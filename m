Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2535B4336EA
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 15:21:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235911AbhJSNYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 09:24:06 -0400
Received: from dehost.average.org ([88.198.2.197]:57894 "EHLO
        dehost.average.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbhJSNYF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 09:24:05 -0400
X-Greylist: delayed 68308 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Oct 2021 09:24:05 EDT
Received: from [IPV6:2a02:8106:1:6800:1752:a293:a417:72ab] (unknown [IPv6:2a02:8106:1:6800:1752:a293:a417:72ab])
        by dehost.average.org (Postfix) with ESMTPSA id 44C4338F995C;
        Tue, 19 Oct 2021 15:21:51 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=average.org; s=mail;
        t=1634649711; bh=NJKL6L4Z5X/cMy761e6rMhSSlE/e89xKCmer6UKmNz8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=TXenM7Wb7A3fiROAsPj2So+7KUki60yZdX2QY/FDp9r+8Gr2mVqO0LMqxbW9cs7v3
         8x+y65TCoDIwhtJHJrJ+kDXILtPGxDonyFa6xCfBV7kuwuCHYVBjEeOx9r9G0l0+0f
         Uz4OVDg+PvA9eRcXE4t17rcstw7rGpyOfGAlFZUA=
Message-ID: <5d971ae3-18f5-48c5-548e-5c6b835a5fc5@average.org>
Date:   Tue, 19 Oct 2021 15:21:42 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Content-Language: en-GB
To:     Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Lahav Schlesinger <lschlesinger@drivenets.com>,
        David Ahern <dsahern@kernel.org>
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc> <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
 <20211018143430.GB28644@breakpoint.cc>
 <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
 <20211019114939.GD28644@breakpoint.cc>
From:   Eugene Crosser <crosser@average.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
In-Reply-To: <20211019114939.GD28644@breakpoint.cc>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------OBNjI4Vb9kQVeoNHxw87wRa8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------OBNjI4Vb9kQVeoNHxw87wRa8
Content-Type: multipart/mixed; boundary="------------7RmDxJHfu71peGU4o0o2PVSy";
 protected-headers="v1"
From: Eugene Crosser <crosser@average.org>
To: Florian Westphal <fw@strlen.de>, David Ahern <dsahern@gmail.com>
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
 Lahav Schlesinger <lschlesinger@drivenets.com>,
 David Ahern <dsahern@kernel.org>
Message-ID: <5d971ae3-18f5-48c5-548e-5c6b835a5fc5@average.org>
Subject: Re: Commit 09e856d54bda5f288ef8437a90ab2b9b3eab83d1r "vrf: Reset skb
 conntrack connection on VRF rcv" breaks expected netfilter behaviour
References: <bca5dcab-ef6b-8711-7f99-8d86e79d76eb@average.org>
 <20211013092235.GA32450@breakpoint.cc> <20211015210448.GA5069@breakpoint.cc>
 <378ca299-4474-7e9a-3d36-2350c8c98995@gmail.com>
 <20211018143430.GB28644@breakpoint.cc>
 <a5422062-a0a8-a2bf-f4a8-d57eb7ddc4af@gmail.com>
 <20211019114939.GD28644@breakpoint.cc>
In-Reply-To: <20211019114939.GD28644@breakpoint.cc>

--------------7RmDxJHfu71peGU4o0o2PVSy
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 19/10/2021 13:49, Florian Westphal wrote:
> David Ahern <dsahern@gmail.com> wrote:
>> Thanks for the detailed summary and possible solutions.
>>
>> NAT/MASQ rules with VRF were not really thought about during
>> development; it was not a use case (or use cases) Cumulus or other NOS=

>> vendors cared about. Community users were popping up fairly early and
>> patches would get sent, but no real thought about how to handle both
>> sets of rules - VRF device and port devices.
>>
>> What about adding an attribute on the VRF device to declare which side=

>> to take -- rules against the port device or rules against the VRF devi=
ce
>> and control the nf resets based on it?
>=20
> This would need a way to suppress the NF_HOOK invocation from the
> normal IP path.  Any idea on how to do that?  AFAICS there is no way to=

> get to the vrf device at that point, so no way to detect the toggle.
>=20
> Or did you mean to only suppress the 2nd conntrack round?
>=20
> For packets that get forwarded we'd always need to run those in the vrf=

> context, afaics, because doing an nf_reset() may create a new conntrack=

> entry (if flow has DNAT, then incoming address has been reversed
> already, so it won't match existing REPLY entry in the conntrack table =
anymore).
>=20
> For locally generated packets, we could skip conntrack for VRF context
> via 'skb->_nfct =3D UNTRACKED' + nf_reset_ct before xmit to lower devic=
e,
> and for lower device by eliding the reset entirely.

I think that I have SNAT (at least) working fine with VRFs, without the
commit. What I do is I set notrack at vrf prerouting callback. Could it
be the "proper" way to go? I don't know if I am breaking anything else
though. Here is my reproducer script. SNAT works on kernels without the
"reset conntrack" commit.

(Sorry my Thunderbird inserts extra newlines :( )

=3D=3D=3D=3D=3D=3D=3D=3D
#!/bin/sudo /bin/bash



for i in 1 2; do

	ip li sh src$i >/dev/null 2>&1 && ip li set src$i nomaster \
		&& ip li del src$i

	ip li sh sink$i >/dev/null 2>&1 && ip li del sink$i

	ip li sh vrf$i >/dev/null 2>&1 && ip li del vrf$i

	ip r flush table 10$i

	ip netns list | grep -q ns$i && ip netns del ns$i

done

nft list table testnat >/dev/null 2>&1 && nft delete table testnat



case $1 in

        clean)  echo "cleaned up"; exit 0;;

esac



sysctl -w net.ipv4.ip_forward=3D1



for i in 1 2; do

	ip netns add ns$i

	ip netns exec ns$i ip li set lo up



	ip li add vrf$i type vrf table 10$i

	ip r add vrf vrf$i unreachable default metric 4278198272

	ip li add src$i type veth peer wayout netns ns$i

	ip li set src$i master vrf$i

	ip a add 172.31.$i.1/32 dev src$i

	ip li set src$i up

	ip li set vrf$i up

	#/sbin/sysctl -w net.ipv4.conf.src$i.accept_local=3D1

	ip netns exec ns$i ip a add 172.31.$i.2/24 dev wayout

	ip netns exec ns$i ip li set wayout up

	ip netns exec ns$i ip r add default via 172.31.$i.1



	ip li add sink$i type veth peer wayin netns ns$i

	ip netns exec ns$i ip li set wayin up

	ip netns exec ns$i /sbin/sysctl -w net.ipv4.conf.wayin.rp_filter=3D0

	ip li set sink$i up

done



ip r add 172.31.1.0/24 dev sink1 table 102

ip r add 172.31.2.0/24 dev sink2 table 101



ip r add 100.64.0.0/24 dev sink1 table 102



nft -f - <<__END__

table testnat {

        chain rawpre {

                type filter hook prerouting priority raw;

                #iif { src1, src2 } meta nftrace set 1

                iif { src1, src2 } ct zone set 1 return

                notrack

        }

        chain rawout {

                type filter hook output priority raw;

                notrack

        }

	chain natpost {

		type nat hook postrouting priority srcnat;

		oif sink2 snat ip to 100.64.0.2

	}

}

__END__



conntrack -F

ip netns exec ns2 tcpdump -lni wayin arp or icmp &

tdpid=3D$!

sleep 1

ip netns exec ns1 ping -W 1 -c 1 172.31.2.2

conntrack -L

sleep 1

kill $tdpid

wait

--------------7RmDxJHfu71peGU4o0o2PVSy--

--------------OBNjI4Vb9kQVeoNHxw87wRa8
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEnAziRJw3ydIzIkaHfKQHw5GdRYwFAmFuxmYACgkQfKQHw5Gd
RYwV2AgAtg6grL0O/y9swEIdxvqC7tfeGwSNvRTjaw92dwAui0rgeOop0/AZNlnS
z88ajljiFvQ+90NvwNRMSHSRrINvs36kr0tKdzWHj5msUXjCEsgRpQ8PI7AGHAnv
VxhY0F+gnazA12kwbKSnFE2+Ge9ZlJfIRnsIifzhpJHtlMbHiEfS1E4HrwDK9C9i
J9sbrXn+CK/FTUvvGJXIvxVgnu0DkpWSKP2vQgbmw5tl7W9rluafplul879dDa3H
LtwnYCMi/kUnXD7GA4xw50tbPJpL0LO0T4n2vEQ+lIpyNcjpiUWsC0oDQzQTMQ4r
jXKcaRYBRKUb5vMO7hYLE4QDCHZthA==
=qYuk
-----END PGP SIGNATURE-----

--------------OBNjI4Vb9kQVeoNHxw87wRa8--
