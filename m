Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0AB6C2DE4
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 10:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230165AbjCUJb0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 05:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229786AbjCUJbZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 05:31:25 -0400
Received: from mail-0201.mail-europe.com (mail-0201.mail-europe.com [51.77.79.158])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDD6FDBEB;
        Tue, 21 Mar 2023 02:31:22 -0700 (PDT)
Date:   Tue, 21 Mar 2023 09:31:03 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail3; t=1679391078; x=1679650278;
        bh=QgoRYW5BI5JeW2NPiEMwKAciyoBFm3U02q6YbW1yxIc=;
        h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
         Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
         Message-ID:BIMI-Selector;
        b=JKzkaUcCBTp/yk5zXk9iPMq45aKBdTi0mgH+ZXbs7Sq+5hNws3851AisB1TzoD9mW
         VsF622j5LEyJwSPPVw3h25MWTbITnnXRcSx6tljLMdbLilablf0jIDQV9c0/ILCK1O
         Cr1BEVDUu2S9Zg3+fcqoEdf2INzRS3WZK/ezvM0uwxMBw+DoUR7DtkOOzL3nW/O9Us
         v5xGA/a7h35CgeqZeLIwsbfTuhKVN14kkY2m+A1ej4saIjXH9XCAmRLmaZiw2hUXqo
         WwOC6mmMsHNiWs196yuAGA3VzeAHBhcoWBAUi5ufGtzKcFGbaNpucXe14JmZHctipq
         +AS50LI3pdcNg==
To:     Bagas Sanjaya <bagasdotme@gmail.com>
From:   Turritopsis Dohrnii Teo En Ming <teo.en.ming@protonmail.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ceo@teo-en-ming-corp.com" <ceo@teo-en-ming-corp.com>,
        Linux Networking <netdev@vger.kernel.org>
Subject: Re: My TP-Link EX510 AX3000 Dual-Band Gigabit Wi-Fi 6 Router has a paper notice on GNU General Public License
Message-ID: <lUgi660lymiMAtgctBw6-8963Cz3PC68rsTgFMYpOVtxIiffk3F7ixUpNUW_h4Eo_FP1lJMer3_HMCaMT5Ob82nMnlTvBsRjE1in9DI3X6w=@protonmail.com>
In-Reply-To: <ZBlq0/DbBIPwZK9s@debian.me>
References: <1D-_qNweCAFnkwL_AEoQeM4SEahOqRb9pOD9W5kE3tFzosEIgcNt8qCC8c48lirfo-J3BGXu7QcnZJOtxY8QFPY3RjYLSWwcAEEZedYot7Y=@protonmail.com> <ZBlq0/DbBIPwZK9s@debian.me>
Feedback-ID: 39510961:user:proton
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


------- Original Message -------
On Tuesday, March 21st, 2023 at 4:29 PM, Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:


> On Sun, Mar 19, 2023 at 02:43:14PM +0000, Turritopsis Dohrnii Teo En Ming=
 wrote:
>=20
> > Good day from Singapore,
> >=20
> > I have terminated my M1 ISP fiber home broadband with effect from 11 Ma=
r 2023 Saturday because I need to pay about SGD$42 per month. My M1 fiber b=
roadband contract ends on 11 Mar 2023.
> >=20
> > Instead I have subscribed to Infocomm Media Development Authority (IMDA=
) Home Access program. This program is for EXTREMELY POOR FAMILIES in Singa=
pore who are living in HDB PUBLIC RENTAL HOUSING PROGRAM. People who live i=
n HDB Public Rental Flats (like myself) have very little money in their ban=
k accounts and cannot afford to buy even the smallest HDB BTO 2-room apartm=
ent in Singapore. Because even the monies in our Central Provident Fund (CP=
F) accounts are mediocre/super low.
> >=20
> > The participating ISP in the IMDA Home Access Program is MyRepublic. Un=
der the IMDA Home Access program, I only need to pay SGD$14 per month for m=
y fiber home broadband.
> >=20
> > MyRepublic ISP has also given me a FREE TP-Link EX510 AX3000 Dual-Band =
Gigabit Wi-Fi 6 Router on 10 Mar 2023 Friday. MyRepublic fiber broadband li=
ne was also activated on the same day. Inside the packaging box there is a =
paper notice on GNU General Public License.
> >=20
> > I believe my tp-link Wi-Fi 6 wireless router is most likely running on =
an open source Linux operating system.
> >=20
> > How can I find out what version of the Linux Kernel it is running on? I=
 think only Linux kernel 6.x support Wi-Fi 6. Am I right?
> >=20
> > By the way, I live in a HDB 2-room RENTAL apartment in Ang Mo Kio Singa=
pore.
>=20
>=20
> Hi and welcome to LKML!
>=20
> Looks like this is general Linux support, so you need to refer to support
> channels for whatever the distro you're using. LKML, on the other hand,
> is highly technical mailing list about Linux kernel development.
>=20
> If you have kernel problems (like buggy driver), see Documentation/admin-=
guide/reporting-issues.rst in the kernel sources for how to properly report=
 the issue.
>=20
> Thanks.
>=20
> --
> An old man doll... just what I always wanted! - Clara

Noted with thanks.

Regards,

Mr. Turritopsis Dohrnii Teo En Ming
Targeted Individual in Singapore
GIMP also stands for Government-Induced Medical Problems
