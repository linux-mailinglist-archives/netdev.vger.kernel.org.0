Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6C353AB62
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 18:56:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353979AbiFAQzw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 12:55:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiFAQzt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 12:55:49 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA969E9DF;
        Wed,  1 Jun 2022 09:55:41 -0700 (PDT)
X-UUID: 170dd9d948264c66b172e68656e21f4b-20220602
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:6fa3c549-2e88-441f-bdf7-7aeed1eadcdb,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,RULE:Release_Ham,ACTI
        ON:release,TS:0
X-CID-META: VersionHash:2a19b09,CLOUDID:82baf014-b515-4766-a72d-4514488fe823,C
        OID:IGNORED,Recheck:0,SF:nil,TC:nil,Content:0,EDM:-3,IP:nil,URL:1,File:nil
        ,QS:0,BEC:nil
X-UUID: 170dd9d948264c66b172e68656e21f4b-20220602
Received: from mtkmbs10n2.mediatek.inc [(172.21.101.183)] by mailgw02.mediatek.com
        (envelope-from <deren.wu@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 713503531; Thu, 02 Jun 2022 00:55:39 +0800
Received: from mtkmbs11n1.mediatek.inc (172.21.101.185) by
 mtkmbs11n1.mediatek.inc (172.21.101.185) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.3;
 Thu, 2 Jun 2022 00:55:38 +0800
Received: from mtksdccf07 (172.21.84.99) by mtkmbs11n1.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.2.792.3 via Frontend
 Transport; Thu, 2 Jun 2022 00:55:38 +0800
Message-ID: <da79fa2a94c435a308ea763efc557fc352d0245c.camel@mediatek.com>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Deren Wu <deren.wu@mediatek.com>
To:     Kalle Valo <kvalo@kernel.org>, Philippe Schenker <dev@pschenker.ch>
CC:     <linux-wireless@vger.kernel.org>, Felix Fietkau <nbd@nbd.name>,
        <linux@leemhuis.info>, "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        "Sean Wang" <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        "YN Chen" <YN.Chen@mediatek.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>,
        <regressions@lists.linux.dev>
Date:   Thu, 2 Jun 2022 00:55:38 +0800
In-Reply-To: <87mtewoj4e.fsf@kernel.org>
References: <20220412090415.17541-1-dev@pschenker.ch>
         <87y20aod5d.fsf@kernel.org>
         <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
         <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch>
         <87mtewoj4e.fsf@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-01 at 11:58 +0300, Kalle Valo wrote:
> Philippe Schenker <dev@pschenker.ch> writes:
> 
> > On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
> > > On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> > > > Philippe Schenker <dev@pschenker.ch> writes:
> > > > 
> > > > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > > > > 
> > > > > This commit introduces a regression on some systems where the
> > > > > kernel is
> > > > > crashing in different locations after a reboot was issued.
> > > > > 
> > > > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with
> > > > > latest
> > > > > firmware.
> > > > > 
> > > > > Link: 
> > > > > 
https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
> > > > >  
> > > > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> > > > 
> > > > Can I take this to wireless tree? Felix, ack?
> > > > 
> > > > I'll also add:
> > > > 
> > > > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> > > > 
> > > 
> > > Hi Kalle,
> > > 
> > > We have a patch for a similar problem. Can you wait for the
> > > verification by Philippe?
> > > Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
> > > after
> > > reboot")
> > > Link: 
> > > 
https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76?id=602cc0c9618a819ab00ea3c9400742a0ca318380__;!!CTRNKA9wMg0ARbw!zCYyDcufJ-OLqQV6leCegA5SkNOOVjAIo-jzTHTk6HUWT9Gjt-bvSz8lr81Zv95u$
> > >  
> > > 
> > > I can reproduce the problem in my v5.16-rc5 desktop. And the
> > > issue can
> > > be fixed when the patch applied.
> > > 
> > > 
> > > Hi Philippe,
> > > 
> > > Can you please help to check the patch in your platform?
> > 
> > Hi Kalle and Deren,
> > 
> > I just noticed on my system and mainline v5.18 reboots do now work
> > however Bluetooth is no longer accessible after a reboot.
> > 
> > Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top of
> > v5.18 solves this problem for me.
> > 
> > @Deren are you aware of this bug?
> > @Kalle Is there a bugtracker somewhere I can submit this?
> 
> For regressions the best is to submit it to the regressions list,
> CCed
> it now.
> 
Hi Philippe,

Tried your test with v5.18.0 on my desktop and both wifi/bt are still
avaible after reboot. The only problem is I need to insert btusb module
by command "modprobe btusb" to make BT workable.

I will check the issue on different platforms. If there are any
finding, I will let you know.

Regards,
Deren

