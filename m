Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78D3F363518
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 14:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231289AbhDRMUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Apr 2021 08:20:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:59935 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230096AbhDRMUt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Apr 2021 08:20:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1618748404;
        bh=KrJxZ3ktoX8ugMIz09NLW4gbn+NeR1J5vIHhd/Rt0b4=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=YLFIFghVMg8gSivY5How0d537JTJoO5HLC6PznzaBeSUc8wV7L/eFFKedHNvn6RC4
         QhEEtsxc/KCF6jmJRZt8LW4D3P4X/sDCsSBdc3r3RUOoqnk74157UYPv0Gp0qMJA4b
         F+QzZ+QaDxqDaPpm2X0z1CALegKte6Yjo5QMiWS8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.75.88] ([80.245.75.88]) by web-mail.gmx.net
 (3c-app-gmx-bap31.server.lan [172.19.172.101]) (via HTTP); Sun, 18 Apr 2021
 14:20:04 +0200
MIME-Version: 1.0
Message-ID: <trinity-a589052c-229f-4be9-aad5-779246fe2024-1618748404510@3c-app-gmx-bap31>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <frank-w@public-files.de>
Cc:     netdev@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, davem@davemloft.net,
        linux-mediatek@lists.infradead.org,
        Matthias Brugger <matthias.bgg@gmail.com>
Subject: Aw: [PATCH][net-next] net: mediatek: add flow offload for mt7623
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 18 Apr 2021 14:20:04 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20210331133437.75269-1-frank-w@public-files.de>
References: <20210331133437.75269-1-frank-w@public-files.de>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:cTNeHwOY6sX+aBIMeXaS00D/xbai9pT3547kt55/25/7h+ZEHmjF8qW/zxxmaUNt7v0EQ
 hDWe01YzRpJ43L3/b4ec/XgTvsqKEqrwcUnv9+yCLnp/uLNDS6H+y24+2BZ6hQtP/hlw4O7Z60Iv
 8kRSTkh/Ya0ena95pfOgtSQvynZxqpn7187Ta6rmFdP58KkjJ0Elyb1zT45Chlt8BbyGcrSSRbOs
 WIVPSivO8WP4TQoXTEMsvz4HDyQBsULDQ9CIxbqIzY4lAVLTRI+vlx9b17z2djh/LMjiZr+VfgWJ
 lw=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:ZqimDKHl4jk=:ULSNJzrUxiJPjPpzO0DQmj
 v2xeCkV6xxYePHFiYIObreNt3RN3POPJACBsvZvHYD0HmgLgSshRl/9Svuhys+qedSE1Cp66X
 BECkMAFeRL59ppU/P+CQk2N3V/uf5DPs9tcJY7p3enTzzo1UZYrpb2TYh3MpZOvnIIzFSHMaE
 XHLfPPDxfL/t2ptm3iBDKPraj9aERbZZkeQ3brXItBrNHdEAKCwx82Z0cLQ8Ir244Wus0LIp8
 KLc1ElAc91cD+vv7sbQnwD4BFC8xRo6M0CqEotWa7rwYchCjnMM+StwIYotDpW40C4I/PgC2p
 LAGGC5dHx5ZQKEOZBae6hO2Att+c16DqRlkjTxyPWoozA5AR7FI4IPaAfBAVgONshqJ+R0tXT
 /ZpGjab6dscqcWARB5ZTNStXTSKd992bMemY7HYeeeamwxyUdfvqQNjr7FEe3HoYBothSzN5f
 Bl916WZoB3Wm3+Wx7aPTegpVD9cFyQXFD2J/L7OH0cPBZURTKlq0JDIeBdKwlVpu8ulRhdMSt
 ciRqI98sZNeyO2p6ebAT6Mh6eITe4guduYRN/sjQTw28rCUQQ3hw5JDRjHeUo0z9oZJYB9ViO
 xApPwCUYSWLAFhJMiuvdmVTkjtv24sMoSzNWuNvID3EKvr34/Go8FmL1Rzb0vqq6/npJbxn5Q
 bGkFfQ0VXnx9+lgdv9qAWRg8gHc6DUUPruNGTFOTCznD7zHnHfRL3wtJeeEprS3pWM1njt6aM
 A/R5wCXiYYfjm/fJ9uE5XPPAv+B4sawjhkgfK1OJEWuwWgIk8w0xKZhCI56HEOXtSDQHiA1t8
 3K//Zo17K0UCZHIICtwEJ7HBqW4Fa0b9e4CFe7U2NQXGMgVRdXvxoI3VNe/OceMAWxBaNQyIN
 4zHsEDLZtmVVUNGLjXITGoyRDvcfr/+Y5R118RY0+QgD069ZrTclt/3ZCuOONLORYZVRyCbsh
 I712Nh+zvug==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

any comment?

regards Frank


> Gesendet: Mittwoch, 31=2E M=C3=A4rz 2021 um 15:34 Uhr
> Von: "Frank Wunderlich" <frank-w@public-files=2Ede>
> Betreff: [PATCH][net-next] net: mediatek: add flow offload for mt7623
>
> mt7623 uses offload version 2 too
>=20
> tested on Bananapi-R2
