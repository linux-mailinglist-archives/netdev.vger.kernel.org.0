Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6AB943D176
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 21:12:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240595AbhJ0TOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 15:14:41 -0400
Received: from mout.gmx.net ([212.227.17.22]:46553 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240552AbhJ0TOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Oct 2021 15:14:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635361930;
        bh=uRfxxfp1mgu5lleRgj1EYt2TvALUaRx6S15PsN2Blhk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ERVM2Q6oaahWQ3WOQhAZs1tgAickICWD9d18imbfP3Ia4WXGdo0uU5bxENTUzgXLt
         KWyv3sYtpetv59GXhk4t6ZOqRH9pujdhp1ycKS8gfKCZzt0+KLxvRgjE4jxGFVyNZV
         mnhhCMOggSzM2UDNBlYNgkX2W/CWg3hidnDBiS5E=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [91.64.35.151] ([91.64.35.151]) by web-mail.gmx.net
 (3c-app-gmx-bs12.server.lan [172.19.170.63]) (via HTTP); Wed, 27 Oct 2021
 21:12:10 +0200
MIME-Version: 1.0
Message-ID: <trinity-f081ed33-d810-43a4-bc84-81aba256a52b-1635361930410@3c-app-gmx-bs12>
From:   Robert Schlabbach <robert_s@gmx.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: ixgbe: How to do this without a module parameter?
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 27 Oct 2021 21:12:10 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YXiaG1q6Uw1xUsJx@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk> <YXcdmyONutFH8E6l@lunn.ch>
 <trinity-cc7ee762-b84d-4980-b38c-a8083fd0c1ff-1635292252562@3c-app-gmx-bs06>
 <YXiaG1q6Uw1xUsJx@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:QgZGJShWghvRwls+9UnjRSn4ZYlCWucdCUw+BV1Q5HKGGv0UGS38Efyom/BrSlVofEkIl
 HiaNetBlI49a7SvCNkFkRTX860JZVQ+ms4cLHzCHJFe/0wP2Gi+Z2PHNZOS4awHYOWeA3eZQRpzM
 +cihTk1tygwzRjBHfddXGmAecUe9bYj5SD0rxjRYEZ8DHXE3yCBoeNkTtZoHpYVoJs5YCWqNt6rl
 JqVBejMLN35gy1G2G47MFKfY/EZHx21rinTiHlwLfcn6A6Ycml/Se2lb3oaOfX/Or8MtX5nw0eiy
 lA=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:gWXBYomjrM4=:EWgpUH0unZ/r8VcCnakO8S
 4PP1A23rlsXGzuj93DikTH9R3XAUbY+biV/9n3UCpowOAbFg86LdC4m6aS1s2SUKAyT3sUQMb
 9QQpFBzRO3lZmMPO7DZzRCZqnhFAhmtzKqrAFkwjrbEqd5NUedgy0I10V/BMb0rBFTWWeW/JT
 tuP3NO0hvlEiQLZls02mrlu3Fo+4TcSgo0h0U37uPx1SICgBnegQCi9RV3O9b/c2UjOGaC535
 tHbkNSyfjZwfTLvBoAqEaI7jb7FMo7M9wf0WKXyM6qKT+G9gMq9yiAYQX89CddZ3+tv391I8w
 7ToaP9MxvQRHyK0UT+eyyDZMYcxdYyc4QgOzkOUJqvRTprqqbsSxmVrcW1X+XeiSkkFOv48Jn
 7t7suWoMbL3eXAnth+pChV51Krr02FlxZQ8kjzpQs9sVy+v58ikEinD+zBrZhxHY2sV+pTUdp
 vNSWKuUwadpnFxd9wT95r5UW1SqdRorwXmKKv9bicrbj/kSKO5ylipD+Yt/JMn1lquAdElAIb
 Q2J6LhoV7ngkSTkPAXo3ADfyTfFl2kNxQ61bVrFqOaWunXL2YBAB7Y0XNXIDZUDkj8J3E/UMU
 NgsVKx+CnSRh6AQCVIGI6CLbI+SnUq69TxuIS9yTL/PCROz/CDjUNWJTGeXBY9dD/5qYO0lJ7
 eo3lOwZMGeeYzFQf3FUI/3b+TqQMmwEoL7fv8MPpOigDtVZJWaL4rXlN7arRdxJhESJka1rOH
 A+pbFQFi3uMeJNsJGLoU7nhyFDXoSFgE79FBvf4gDwtXwTX2iLEO4zshYU8nEgMXbXKj2gxbi
 fVVNCqx
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Andrew Lunn" <andrew@lunn.ch> wrote:
> On Wed, Oct 27, 2021 at 01:50:52AM +0200, Robert Schlabbach wrote:
> > The parsing seems to be implemented in the kernel
>
> Actually, it might not be. A kernel that old might not have netlink
> ethtool, just the old ioctl interface. It could be the command line
> parsing is dependent on which API is used to the kernel.
>
> ethtool --debug 255 eno3

I should have mentioned that I also searched the ethtool source code
for link mode name parsing and came up empty. While ethtool contains
link mode names, those are "private" to the dump_link_mode_caps()
function and unavailable for any other access/use.

The ethtool debug option you gave shows that ethtool indeed sends the
link mode name strings down to the kernel for parsing:

sending genetlink packet (100 bytes):
    msg length 100 ethool ETHTOOL_MSG_LINKMODES_SET
    ETHTOOL_MSG_LINKMODES_SET
        ETHTOOL_A_LINKMODES_HEADER
            ETHTOOL_A_HEADER_DEV_NAME =3D "eno3"
        ETHTOOL_A_LINKMODES_OURS
            ETHTOOL_A_BITSET_BITS
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME =3D "2500baseT/Full"
                    ETHTOOL_A_BITSET_BIT_VALUE =3D true
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME =3D "5000baseT/Full"
                    ETHTOOL_A_BITSET_BIT_VALUE =3D true

And trying nonsense names for link modes confirms that ethtool does not
parse them at all, but rather passes them unchecked:

$ ethtool --debug 255 -s eno3 advertise NonSenseModeName off EvenMoreNonSe=
nse on

sending genetlink packet (104 bytes):
    msg length 104 ethool ETHTOOL_MSG_LINKMODES_SET
    ETHTOOL_MSG_LINKMODES_SET
        ETHTOOL_A_LINKMODES_HEADER
            ETHTOOL_A_HEADER_DEV_NAME =3D "eno3"
        ETHTOOL_A_LINKMODES_OURS
            ETHTOOL_A_BITSET_BITS
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME =3D "NonSenseModeName"
                ETHTOOL_A_BITSET_BITS_BIT
                    ETHTOOL_A_BITSET_BIT_NAME =3D "EvenMoreNonSense"
                    ETHTOOL_A_BITSET_BIT_VALUE =3D true

Running these commands on an old 4.15 kernel fails very early, supposedly =
when
ethtool checks whether the kernel supports above messages:

sending genetlink packet (32 bytes):
    msg length 32 genl-ctrl
    CTRL_CMD_GETFAMILY
        CTRL_ATTR_FAMILY_NAME =3D "ethtool"

offending message:
    ETHTOOL_MSG_LINKINFO_SET
        ETHTOOL_A_LINKINFO_PORT =3D 101
ethtool: bad command line argument(s)
For more information run ethtool -h

So a more user-friendly option to specify link modes to advertise is alrea=
dy
implemented, but only in more recent kernel versions.

Best regards,
-Robert Schlabbach
