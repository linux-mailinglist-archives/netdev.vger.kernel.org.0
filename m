Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A5D96A67AB
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 07:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjCAGik (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 01:38:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjCAGij (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 01:38:39 -0500
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4A881422C
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=public-files.de;
        s=s31663417; t=1677652696; i=frank-w@public-files.de;
        bh=kRvw/ZdyCWLk2Wqzk8821rUKMMv3J9MQpwyqgqkrfno=;
        h=X-UI-Sender-Class:Date:From:To:CC:Subject:Reply-to:In-Reply-To:
         References;
        b=qiGyF9Dox+hy1Ty+L17Bd+8zE0AqAcpL0+N4ywUfOhsCD+flSQFp1IZrGZVhC8IlT
         oajZajJCn65yGkNt29bVSAXIH3Tg88dMuYqxQcmk1DzhKORT3dV7NHp/qHzFin6k1e
         8U67BKCcBYxjr2J7uwOKyshbgbodnHzs2CTUIHqe2CIcawdFPtVwzHUelvlkb/aDew
         SWW3/qCS+IQ0KMdtGCGTX3PZ5ma017vqA6XhrEddK6yD/NyfmMoiiBgQLbTxLPXZM5
         q2Q3Sxw9Tr9BHH9sXsPvJs43rP6YFo1r05+PeT0/nYC9z/HeP+37den28OfSQexhAB
         Mcx/gSz80dN+Q==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [127.0.0.1] ([80.245.79.250]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MDhhN-1pN3N91CSt-00AkLd; Wed, 01
 Mar 2023 07:38:16 +0100
Date:   Wed, 01 Mar 2023 07:38:10 +0100
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Vladimir Oltean <olteanv@gmail.com>
CC:     =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>,
        Felix Fietkau <nbd@nbd.name>, netdev <netdev@vger.kernel.org>,
        erkin.bozoglu@xeront.com, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        John Crispin <john@phrozen.org>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>
Subject: Re: Choose a default DSA CPU port
User-Agent: K-9 Mail for Android
Reply-to: frank-w@public-files.de
In-Reply-To: <20230228225622.yc42xlkrphx4gbdy@skbuf>
References: <trinity-4ef08653-c2e7-4da8-8572-4081dca0e2f7-1677271483935@3c-app-gmx-bap70> <20230224210852.np3kduoqhrbzuqg3@skbuf> <trinity-5a3fbd85-79ce-4021-957f-aea9617bb320-1677333013552@3c-app-gmx-bap06> <f9fcf74b-7e30-9b51-776b-6a3537236bf6@arinc9.com> <6383a98a-1b00-913d-0db1-fe33685a8410@arinc9.com> <trinity-6ad483d2-5c50-4f38-b386-f4941c85c1fd-1677413524438@3c-app-gmx-bs15> <20230228115846.4r2wuyhsccmrpdfh@skbuf> <CB415113-7581-475E-9BB9-48F6A8707C15@public-files.de> <20230228225622.yc42xlkrphx4gbdy@skbuf>
Message-ID: <0842D2D2-E71C-4DEF-BBCD-2D0C0869046E@public-files.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:C6O0SWzvWO44Xwn3BXYheToXnrChDl99/oehqQdwsIoJ5SWnUN5
 3KxqnhPvTGcAte92ZQCmypsM2hXQupa2+HUEFCuw3FV8+bkCxvVTdHJBdNw9Svtr6jPWQpt
 0hwDl9rtdQYSor+mgB7STKvGIkYrtrUJasgYOrRs5y8RhjLUwy24MYFPFjm3HIYiZyt/19m
 h3WhnBfpKcECTVSXNQtkA==
UI-OutboundReport: notjunk:1;M01:P0:gHt1fLc/pds=;1BQOoWTDF0MRJ4GK9sMC0SP+Dd9
 e825frjPNTiQV5h6IMbnLZ1D4XcMoH3hn8Qzy2+fZFd/FktEiNhSv8tJ8bVkoSO4/ZEASIcS9
 Id8rcDwkHwieIRabSMPybvXIZh7ctNHcAhN+qjmAZiBExWrqxIfMrvmvIAC9jtkMF4bF8EPqo
 SfaA2qZ0s8hmZ7TDTZFK1Agkm7XedvbzBeaGoWICkzhrUALnwkOs/OBFgfTa1dyYCIiND0zmw
 naJY0J8QsxO2X8ak6A9iy+T0yCyCKVP0TMqfuLY6A/4fho3JqcM3yplRUY2luTpF/cjm6mE23
 iySXPt5deIYtwZynQnjgvHOV/vr2agV1TpMOCjxDGMVi4+CeXKqjkkfePyk8TIlit/iZTwMir
 d0kQJ6eNeh/oCxFJbJofMaeb7+hYXO4FRDCsl7WXkobIUw6BMbsaQ5bvsBmNaoJbpjAQGG/M3
 2rUSQvjK6uQ/1jJ9hyuCGW+ZxpHoAKqCFi2iAnoOlAK6iq5lWUJUOvsnCbOQapxLgTWV7s++Q
 iCSRzxhcNCiELdZd0Ofi0jPuhbMfWDlyIFfjApd7HZG6bIkIKXWzqXmSJIPv6NdrHRpoFTT6K
 afPLfMG5DEr3PxK0m/ZLZTgvyy42RaoCLNdZWrB2Ef5KPyaqWxt9+/cLwuqf9CIJ17SaHegRm
 EwsE/rvDZOcBvwaWro/YeNXJTya26xIJXktIOILwa8YVuSeKxb/RCgXxEdR/NdQLh/9KYqcSq
 g1QoWzqdx/vFeTnzyEzZB5RxLl0OB7CXdj+U0QQF+FQhpOZnUDxm8oA4LH5A5LCqbVyQ7XUcd
 EAgLg3JwO7XElzL6FE72asVjNsq/Bdv7isohUaby/4jzRQuY6lZ+FDlwX9RsDLUd3FZTvKVE4
 gygL8lIvmh8b9tHJr4l5LXX6MkMvjyVa7bvKYgehCZzaZvNL1yShvlAcNp+G22LNzq5e2VeHE
 FKjdN7aDDCX0wuQcMQeumtmwsNh2BnZnZp8YfJ1bDDIiX6y4VDQHGVJo/YhEnaJxf8O04A==
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 28=2E Februar 2023 23:56:22 MEZ schrieb Vladimir Oltean <olteanv@gmail=
=2Ecom>:
>On Tue, Feb 28, 2023 at 02:48:13PM +0100, Frank Wunderlich wrote:
>> I have only this datasheet from bpi for mt7531
>>=20
>> https://drive=2Egoogle=2Ecom/file/d/1aVdQz3rbKWjkvdga8-LQ-VFXjmHR8yf9/v=
iew
>>=20
>> On page 23 the register is defined but without additional information
>> about setting multiple bits in this range=2E CFC IS CPU_FORWARD_CONTROL
>> register and CPU_PMAP is a 8bit part of it which have a bit for
>> selecting each port as cpu-port (0-7)=2E I found no information about
>> packets sent over both cpu-ports, round-robin or something else=2E
>>=20
>> For mt7530 i have no such document=2E
>
>I did have the document you shared and did read that description=2E
>I was asking for the results of some experiments because the description
>isn't clear, and characterizing the impact it has seems like a more
>practical way to find out=2E
>
>> The way i got from mtk some time ago was using a vlan_aware bridge for
>> selecting a "cpu-port" for a specific user-port=2E At this point port5
>> was no cpu-port and traffic is directly routed to this port bypassing
>> dsa and the cpu-port define in driver=2E=2E=2Eafaik this way port5 was
>> handled as userport too=2E
>
>Sorry, I understood nothing from this=2E Can you rephrase?

It was a userspace way to use the second ethernet lane p5-mac1 without def=
ining p5 as cpu-port (and so avoiding this cpu-port handling)=2E I know it =
is completely different,but maybe using multiple cpu-ports require some vla=
n assignment inside the switch to not always flood both cpu-ports with same=
 packets=2E So p5 could only accept tagged packets which has to been tagged=
 by userport=2E

How can i check if same packets processed by linux  on gmacs (in case i dr=
op the break for testing)? Looking if rx increases the same way for both ma=
cs looks not like a reliable test=2E

regards Frank
