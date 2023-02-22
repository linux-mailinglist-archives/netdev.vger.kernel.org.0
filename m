Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F073569ED1B
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 03:53:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232498AbjBVCxl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 21:53:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232455AbjBVCxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 21:53:34 -0500
Received: from gate2.alliedtelesis.co.nz (gate2.alliedtelesis.co.nz [IPv6:2001:df5:b000:5::4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE6A4728A
        for <netdev@vger.kernel.org>; Tue, 21 Feb 2023 18:53:21 -0800 (PST)
Received: from svr-chch-seg1.atlnz.lc (mmarshal3.atlnz.lc [10.32.18.43])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        by gate2.alliedtelesis.co.nz (Postfix) with ESMTPS id C946C2C019A
        for <netdev@vger.kernel.org>; Wed, 22 Feb 2023 15:53:17 +1300 (NZDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alliedtelesis.co.nz;
        s=mail181024; t=1677034397;
        bh=3wAznE1YiN07O6meffNdT44yj56ZcH+epIWdSIxJP4k=;
        h=From:To:Subject:Date:From;
        b=R8SrDGFeHp8TT9TeSnxoInGssSDkWvPnd2m1NpOBo0Y4mCmFBNfe8t83e7Dy378cS
         yjG+C74o6gMaC3j353/wEjR9DGgpLhtZ9fPEntIes6iACcxkZgYt7w7Ngo+/FzReu2
         pcc3Ri5sydp0wclM6o0vtCfd2uDBq7he5hfn2MuD6Jt5VF3Pgf4owfzSBnHF+sKgDC
         zhqu4+3hNardMvF98c2W96TzaAdxI6uWMpM4Z/7jjTdfnCiNq4ClIMYvixnqv8fT+j
         El9C2APr+F1BWtXaPuJ0Z50pcY6GlHG4xfepdi/mEhbrRRe0wjKQpKaLpbe92VWIMX
         +Tp0HOBbZ63qA==
Received: from svr-chch-ex1.atlnz.lc (Not Verified[2001:df5:b000:bc8::77]) by svr-chch-seg1.atlnz.lc with Trustwave SEG (v8,2,6,11305)
        id <B63f5839d0000>; Wed, 22 Feb 2023 15:53:17 +1300
Received: from svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) by
 svr-chch-ex1.atlnz.lc (2001:df5:b000:bc8::77) with Microsoft SMTP Server
 (TLS) id 15.0.1497.47; Wed, 22 Feb 2023 15:53:17 +1300
Received: from svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8]) by
 svr-chch-ex1.atlnz.lc ([fe80::409d:36f5:8899:92e8%12]) with mapi id
 15.00.1497.047; Wed, 22 Feb 2023 15:53:17 +1300
From:   Aryan Srivastava <Aryan.Srivastava@alliedtelesis.co.nz>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: EEE support for 2.5G/5G
Thread-Topic: EEE support for 2.5G/5G
Thread-Index: AQHZRl/DhnYddRUIzEyrO8lbw/nMGw==
Date:   Wed, 22 Feb 2023 02:53:17 +0000
Message-ID: <1677034396395.39388@alliedtelesis.co.nz>
Accept-Language: en-US, en-NZ
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.32.1.11]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-SEG-SpamProfiler-Analysis: v=2.3 cv=GdlpYjfL c=1 sm=1 tr=0 a=Xf/6aR1Nyvzi7BryhOrcLQ==:117 a=xqWC_Br6kY4A:10 a=oKJsc7D3gJEA:10 a=8nJEP1OIZ-IA:10 a=m04uMKEZRckA:10 a=p8WaH4ZBh0pPKxQZ4KcA:9 a=wPNLvfGTeEIA:10
X-SEG-SpamProfiler-Score: 0
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,=0A=
=0A=
I am currently in the process of implementing EEE (energy-efficient etherne=
t) ethtool get/set on my PHY driver. There are generic functions to achieve=
 this, but they do not currently have the capability to set or check for 2.=
5G and 5G EEE LPI. =0A=
=0A=
I had begun to add these additional modes when I realised this was not poss=
ible as the EEE ethtool command struct, only has 32-bit fields, and the eth=
tool bit mask for the 2.5G and 5G modes is 47 and 48 respectively.=0A=
=0A=
I could of course use custom functions to achieve my objective, but I would=
 like to ask if my understanding of the situation is correct. =0A=
=0A=
To my knowledge, there is no framework currently in place to set 2.5G/5G EE=
 through generic phy functions, and it cannot be implemented currently due =
to the size of the bit fields in the ethtool command. Are there any other p=
laces I should be looking at for this functionality? Further from this, is =
it time to create a new ethtool command for EEE (similar to set/get setting=
s) that can account for these new speeds?=0A=
=0A=
Thank you, =0A=
I look forward to your reply,=0A=
=0A=
Aryan Srivastava,=0A=
Allied Telesis NZ=0A=
=0A=
=0A=
