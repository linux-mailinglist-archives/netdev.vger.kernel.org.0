Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 894A62DD21
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 14:31:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbfE2MbY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 08:31:24 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44840 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726828AbfE2MbY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 May 2019 08:31:24 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hVxjf-0008JN-AL; Wed, 29 May 2019 12:31:15 +0000
Subject: Re: [PATCH 1/4] ipv4: ipv6: netfilter: Adjust the frag mem limit when
 truesize changes
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Sasha Levin <sashal@kernel.org>,
        Peter Oskolkov <posk@google.com>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        Andy Whitcroft <andy.whitcroft@canonical.com>
References: <20190529102542.17742-1-stefan.bader@canonical.com>
 <20190529102542.17742-2-stefan.bader@canonical.com>
 <20190529103731.GB7383@kroah.com>
From:   Stefan Bader <stefan.bader@canonical.com>
Openpgp: preference=signencrypt
Autocrypt: addr=stefan.bader@canonical.com; prefer-encrypt=mutual; keydata=
 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
 a/xox1VK9s1EK3Ny6Pj9DekR+8E=
Message-ID: <e8417673-8d22-416b-ee3e-b9892d266921@canonical.com>
Date:   Wed, 29 May 2019 14:31:08 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529103731.GB7383@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="Xv156RXHATY72O65K5zrHrKybj0lt0N0f"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Xv156RXHATY72O65K5zrHrKybj0lt0N0f
Content-Type: multipart/mixed; boundary="UWpcRdIt7LsQqzVKiI2p7a0vdd66YaJw2";
 protected-headers="v1"
From: Stefan Bader <stefan.bader@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Sasha Levin <sashal@kernel.org>, Peter Oskolkov <posk@google.com>,
 Ben Hutchings <ben.hutchings@codethink.co.uk>,
 Andy Whitcroft <andy.whitcroft@canonical.com>
Message-ID: <e8417673-8d22-416b-ee3e-b9892d266921@canonical.com>
Subject: Re: [PATCH 1/4] ipv4: ipv6: netfilter: Adjust the frag mem limit when
 truesize changes
References: <20190529102542.17742-1-stefan.bader@canonical.com>
 <20190529102542.17742-2-stefan.bader@canonical.com>
 <20190529103731.GB7383@kroah.com>
In-Reply-To: <20190529103731.GB7383@kroah.com>

--UWpcRdIt7LsQqzVKiI2p7a0vdd66YaJw2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 29.05.19 12:37, Greg KH wrote:
> On Wed, May 29, 2019 at 12:25:39PM +0200, Stefan Bader wrote:
>> From: Jiri Wiesner <jwiesner@suse.com>
>>
>> The *_frag_reasm() functions are susceptible to miscalculating the byt=
e
>> count of packet fragments in case the truesize of a head buffer change=
s.
>> The truesize member may be changed by the call to skb_unclone(), leavi=
ng
>> the fragment memory limit counter unbalanced even if all fragments are=

>> processed. This miscalculation goes unnoticed as long as the network
>> namespace which holds the counter is not destroyed.
>>
>> Should an attempt be made to destroy a network namespace that holds an=

>> unbalanced fragment memory limit counter the cleanup of the namespace
>> never finishes. The thread handling the cleanup gets stuck in
>> inet_frags_exit_net() waiting for the percpu counter to reach zero. Th=
e
>> thread is usually in running state with a stacktrace similar to:
>>
>>  PID: 1073   TASK: ffff880626711440  CPU: 1   COMMAND: "kworker/u48:4"=

>>   #5 [ffff880621563d48] _raw_spin_lock at ffffffff815f5480
>>   #6 [ffff880621563d48] inet_evict_bucket at ffffffff8158020b
>>   #7 [ffff880621563d80] inet_frags_exit_net at ffffffff8158051c
>>   #8 [ffff880621563db0] ops_exit_list at ffffffff814f5856
>>   #9 [ffff880621563dd8] cleanup_net at ffffffff814f67c0
>>  #10 [ffff880621563e38] process_one_work at ffffffff81096f14
>>
>> It is not possible to create new network namespaces, and processes
>> that call unshare() end up being stuck in uninterruptible sleep state
>> waiting to acquire the net_mutex.
>>
>> The bug was observed in the IPv6 netfilter code by Per Sundstrom.
>> I thank him for his analysis of the problem. The parts of this patch
>> that apply to IPv4 and IPv6 fragment reassembly are preemptive measure=
s.
>>
>> Signed-off-by: Jiri Wiesner <jwiesner@suse.com>
>> Reported-by: Per Sundstrom <per.sundstrom@redqube.se>
>> Acked-by: Peter Oskolkov <posk@google.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>>
>> (backported from commit ebaf39e6032faf77218220707fc3fa22487784e0)
>> [smb: context adjustments in net/ipv6/netfilter/nf_conntrack_reasm.c]
>> Signed-off-by: Stefan Bader <stefan.bader@canonical.com>
>=20
> I can't take a patch for 4.4.y that is not in 4.9.y as anyone upgrading=

> kernel versions would have a regression :(
>=20
> Can you also provide a backport of the needed patches for 4.9.y for thi=
s
> issue so I can take these?

I will, once it is clear that a) the backport looks alright and b) is ok =
to be
done. Alternatively it might be decided that only the parts necessary for=

pulling out a frag head should be picked.

Or the net-devs might decide they want to send things out. The problem
potentially exists in anything that has some stable support up to v5.1
and I have no complete overview where this was backported to.

So this is more a start of discussion that a request to apply it. stable =
was
just included to make stable maintainers aware.

-Stefan
>=20
> thanks,
>=20
> greg k-h
>=20



--UWpcRdIt7LsQqzVKiI2p7a0vdd66YaJw2--

--Xv156RXHATY72O65K5zrHrKybj0lt0N0f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAlzue4wACgkQ6Gdd7svu
zqPYhRAAomNzF2QJMy/Xz13ir2EnLtjAg9sG6DOVG2r+xCrlUlbZ2xk9txXwI9Q0
QcszclDjDh3o/2gV593Nyv+bFtBLjhYgH3iKA6AvekxyAF5ZeHg4V0T0SK1t2KBx
AIkzR4i3GI0ek/JniQPVuLqb513thGLa/bMaug5eR65yrN+8ULnLwEz5mXR5y+Ew
gaxiyObvBS/9Wg/anQiMbdv4G3xvlzAll1XQkjw6qDw9hJsVpWMKnrlU4Ddz2Ez9
NzdRzMTnTbtgE8OA4UWOOO+DlZ1kUCt3R+lxjw0Lk3Pp/ZPUju/PoS7UIUez4BRB
ubKXxFiXiacnd+/3dzfo+qKpqz0LcU6fyDbgAOeHVfKtOqrD2CqvIWTsdHulN9t0
19yJJrqZRyajcI/kbaCY+TugQ43U5EXE50NxP75vtzEQPml6gCQ+yycx53VXOa5k
z+Rg592n9yWT+ffueBwDjQWexpFRB6YEFVBKloPEkbB+KOXurcJ/i5pNP1TCdKV0
0IC6b/lAMkUDYXOLj70cNOdznzgPHeJbXszhBdzme7UirvfVMqM2/YT/VfnHR/Vw
CFKV1/gROXZ7gRzxjDXZW4FvYImMiu5f52KXWM/8/S+Mz41RcwD/khaPsR7JPa7z
551nMwpjxRdcVsvsUpVHcA/119VYk+LB9qr5ejBND6xWKRYspr0=
=vDuW
-----END PGP SIGNATURE-----

--Xv156RXHATY72O65K5zrHrKybj0lt0N0f--
