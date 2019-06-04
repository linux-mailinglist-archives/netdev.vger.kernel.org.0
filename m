Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C2F348C5
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 15:32:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbfFDNcg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 09:32:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:53526 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfFDNcg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 09:32:36 -0400
Received: from 1.general.smb.uk.vpn ([10.172.193.28])
        by youngberry.canonical.com with esmtpsa (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <stefan.bader@canonical.com>)
        id 1hY9YD-0001qN-CT; Tue, 04 Jun 2019 13:32:29 +0000
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
Message-ID: <9567b192-f31d-8bd1-298d-5f736ee8d578@canonical.com>
Date:   Tue, 4 Jun 2019 15:32:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190529103731.GB7383@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="9ahW5ZftHhteefVCSayK0QAIAShOjJkWT"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--9ahW5ZftHhteefVCSayK0QAIAShOjJkWT
Content-Type: multipart/mixed; boundary="FJnhAidxZHnQtz8tytKPcZMk04pn5E1Jj";
 protected-headers="v1"
From: Stefan Bader <stefan.bader@canonical.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable <stable@vger.kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
 Sasha Levin <sashal@kernel.org>, Peter Oskolkov <posk@google.com>,
 Ben Hutchings <ben.hutchings@codethink.co.uk>,
 Andy Whitcroft <andy.whitcroft@canonical.com>
Message-ID: <9567b192-f31d-8bd1-298d-5f736ee8d578@canonical.com>
Subject: Re: [PATCH 1/4] ipv4: ipv6: netfilter: Adjust the frag mem limit when
 truesize changes
References: <20190529102542.17742-1-stefan.bader@canonical.com>
 <20190529102542.17742-2-stefan.bader@canonical.com>
 <20190529103731.GB7383@kroah.com>
In-Reply-To: <20190529103731.GB7383@kroah.com>

--FJnhAidxZHnQtz8tytKPcZMk04pn5E1Jj
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

It turns out that I cannot provide patches for 4.9.y because those are no=
t
needed there. Patches #1 and #2 of the list I did do not explicitly appea=
r.
However patch #3 does and it might be possible to implicitly do the chang=
es of
the other two by adjusting the removal of the functions from the old loca=
tions
and doing the additions unmodified.
And the final patch for pulling the skb from the list is included in 4.9.=
y by
backports for using rbtrees in ipv6, too. In 4.9.y however the skb_get() =
still
needs to be dropped. Sasha did not apply it in the end, maybe partially b=
ecause
of my warning that this was not enough in 4.4.y.

So I think there are two options for 4.4.y which I would defer to the net=
-devs
to decide:
- either also backport the patches to use rbtrees in ipv6 to 4.4.y (inclu=
ding
  use of inet_frag_pull_head() in ip6_expire_frag_queue() and dropping th=
e
  skb_get() there.
- or some limited change to ip6_expire_frag_queue(). Probably only doing =
the
  part not related to rbtrees. This would not require patch #3 as pre-req=
=2E
  Patches #1 and #2 might be considered separately. Those would be unrela=
ted
  to the crash in ip6_expire-frag_queue() but could fix other issues (not=

  liking the sound of net namespace teardown possibly getting stuck).

For 4.9.y, please re-consider picking "ip6: fix skb leak in
ip6frag_expire_frag_queue()". Depending on checks down the path of icmpv6=
_send()
it might be a crash, too. In that case it should be enough as
inet_frag_pull_head() takes the skb off the queue, so it won't get double=
 freed
when releasing the whole queue.

-Stefan
>=20
> thanks,
>=20
> greg k-h
>=20



--FJnhAidxZHnQtz8tytKPcZMk04pn5E1Jj--

--9ahW5ZftHhteefVCSayK0QAIAShOjJkWT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEE2118yvOZTjOV2k0+6Gdd7svuzqMFAlz2cuwACgkQ6Gdd7svu
zqPnyw//ZO2puPgIuv0SbyX3l7mZS08vvi+FGrTs4/TKeuVMcAa18SwcmxhbNGS1
SnPhzWjaNLapUqWnIJ4f6R8mL6LP/yugM+v9/Sh6IQ2TEStT0rXtQT3lGhpbZ0UR
qSHrSm0LJMBlzlRbvj1z1vlIG64kKXhAJ2rq4ZpkIttuXo1N8K2kkNkF2ZNp85OU
KMksllstVVSIsxrKgnU2VluAnkBzbLJezMD12vbJUjeszYXSxoAmuRmypCPr0Ved
X4EvVyC2miX3JvgWUOKEWH3n9L8DsBWgKsIvAmlf69gVnp7k8jiTEItz2/+pGA4e
Yxd9rstBpxeOheJud0FcTVY0/80TNtz/+BJMfU1Gpyi6UOqhvrZhS9DeRUenR/Un
ISgoQ4yQYLJvXLp5TLZ/g0gmIb/d0WXnfFgwg6K7Ysf+DUffrW7q+LOb+n9WgkM5
axs4njSfvZ53nxc1KMIFKf87kJsc3LgcFiQdX97CvyrddW1zCyeb5jG17Ju2Vles
u4SpUkGz1v4csmYcp4PBYs2Hp50uURNGb0dXp98r8KJLjO3bsVT+uLvF6ZqA735U
m/ggCX+LsBAspdOsTA9YxF9KO9yM5pDsc1jbOLhxCTQw3YR4cAQajzfZ/m4XJVUy
xEvnSbNiZWFLS3FGcr4T6ZHNKvxhxJy6kjmcHIO3cS6OPdh9hQU=
=VOLU
-----END PGP SIGNATURE-----

--9ahW5ZftHhteefVCSayK0QAIAShOjJkWT--
