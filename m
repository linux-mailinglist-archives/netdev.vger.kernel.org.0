Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318CC43BE26
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbhJZXx0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:53:26 -0400
Received: from mout.gmx.net ([212.227.15.15]:33495 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237337AbhJZXxV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 19:53:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1635292252;
        bh=6RVO3d75zKITgPaZugtDJSzzXG2Q9SzNrj5LsL/hgIk=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=hH8bZF4s6vkNWpPmZpK5ohXO8b5lufEpFiQl+ouYS0lx5+tW56WeduKfGqrc6lABG
         8i9ykqaRR3F1etr2CAjWr8pdYKqKIPGkknlH8UzRt+IEuAUYo6VX1uqAODvDkdUz5N
         TfKFOdeURfBdQnidxelBpaYplC1kDRHg3hn8ETBA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [91.64.35.151] ([91.64.35.151]) by web-mail.gmx.net
 (3c-app-gmx-bs06.server.lan [172.19.170.55]) (via HTTP); Wed, 27 Oct 2021
 01:50:52 +0200
MIME-Version: 1.0
Message-ID: <trinity-cc7ee762-b84d-4980-b38c-a8083fd0c1ff-1635292252562@3c-app-gmx-bs06>
From:   Robert Schlabbach <Robert.Schlabbach@gmx.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org
Subject: Aw: Re: ixgbe: How to do this without a module parameter?
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 27 Oct 2021 01:50:52 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <YXcdmyONutFH8E6l@lunn.ch>
References: <trinity-50d23c05-6cfa-484b-be21-5177fcb07b75-1635193435489@3c-app-gmx-bap58>
 <87k0i0bz2a.fsf@toke.dk> <YXcdmyONutFH8E6l@lunn.ch>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:FmB2jUxtPHmDoSphQNO/xseLGl+Bg5gPNFt1omHtCMGDfTwWqZCwiKEKLDz0/IJeOnpuY
 S2JN3pNaws9HMxEzLtx4qIR39za1isGsZ95u64qUT+YnolAhdPPkKtqYXz7fa0zVBNDajDuiLVv2
 1q5qh829Trm7zU06xAPGHyFKg0LLfVEFLuJtw3GWKSU6NgLaJkSszzNfTU6R2dK80YM828+UTc49
 qTScXWrGecR3NSGRuRUJdh13PnFswO/IHnKD6XCoEaHLZ1fGgifuA/Rfwh9v/w9ihPFvMz+pTGIL
 Dk=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:l+5G0dnBFuA=:6hhujk5zcb3WW7A4XQWi3S
 Cl867yZmvujwaZF9reFNM2xsM0bYWm3pjmWF2egKmqeTWSipYDGcVQ0EbsgVFhczTtk5lSV6T
 37OQZlOmrJiVKEUI5j7bsE/8JFZa8J6RE2S7Te433lpG+xbo0oYpRWDuFfXl7oqSie2THUVLa
 gIRy1AL/h6AQy4gzdbVsybG13wvr+DJx6iVtE+9GcAdSQb2jONsXePB53lsmNGsCWbQ7U23Oy
 UrdFelv5t6K52VQMZ5c6DNRvosUkajtV07y5XqwQxLeYJZGwzvj188LRKy0l89rf76AAOLLui
 De5s8bHItuxe4nenRQnj7GdVyGKYCtuylZq8wC1o67DYH/WLWbK8I34zRCTufp9eMOpwN0QEs
 JaeABM2qB6PZAX9Sr4HBfeoBtVY/zQWa9V0ExK+BC1KqrpWpp76Lbg/idlPSsvQPJk1ntR3ex
 u9egj1/9r2jrhC43ls+gAuIk8I5HogXGolIf6aNNvP450PV/uY10fGMrVi0x1sOsY6sISmr6C
 uja/zcZwDr9yeFaky+NJdy4m5KQIOBjCJANr7S8Y02xgFTPdt95RymFQNiKM35TpcJncotnrC
 dvBzgFT5mj5Qe2+KCvr1cHd7A5/ojyfQIEs2MuxOmz2mUj4Bo0bLYQv5A3Tu2tH4DTKT00hoe
 xCXCMGARYcXN7SUilk0QNwVp1YtQwakaJTWWqX9H1jS0tbnne9Ae2C/UenyUY3x7Bx26BwlB9
 jycQOrJt1hNLaMSxQ7Ohyfa78c4PZ7pE21GUMMXn1jpUd+t+106MQRIm2oQCsf/VIbCf6aSgr
 +zo2r7v
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Andrew Lunn" <andrew@lunn.ch> wrote:
> > Personally I wouldn't mind having this (symbolic names) for all the
> > supported advertised modes; I also think it's a pain to have to go
> > lookup the bit values whenever I need to change this...
>
> Something like this has been talked about before, but nobody ever
> spent the time to do it. ethtool has all the needed strings, so it
> should not be too hard to actually do for link modes.

It appears somebody already did, because I found that my Debian 11.1
server (with kernel version 5.14) actually takes this command:

$ ethtool -s eno3 advertise 2500baseT/Full on 5000baseT/Full on

The parsing seems to be implemented in the kernel, because when I copy
the binary over to my Ubuntu machine (with kernel version 4.15), any
attempt to specify a link mode name only yields:

ethtool: bad command line argument(s)

Best regards,
-Robert Schlabbach
