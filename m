Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C103E53AFA0
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 00:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232248AbiFAWXi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 18:23:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232229AbiFAWXh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 18:23:37 -0400
Received: from mailgw02.mediatek.com (unknown [210.61.82.184])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E2FFC9;
        Wed,  1 Jun 2022 15:23:31 -0700 (PDT)
X-UUID: 3adf2b09e9054a8ebf80d0196da9e7aa-20220602
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:f7e979cc-3c39-4192-b114-63159e78c769,OB:10,L
        OB:0,IP:0,URL:25,TC:0,Content:3,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_Ham,A
        CTION:release,TS:82
X-CID-INFO: VERSION:1.1.5,REQID:f7e979cc-3c39-4192-b114-63159e78c769,OB:10,LOB
        :0,IP:0,URL:25,TC:0,Content:3,EDM:0,RT:0,SF:54,FILE:0,RULE:Spam_GS981B3D,A
        CTION:quarantine,TS:82
X-CID-META: VersionHash:2a19b09,CLOUDID:ad70f514-b515-4766-a72d-4514488fe823,C
        OID:519d15beb0b2,Recheck:0,SF:28|16|19|48,TC:nil,Content:3,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:0,BEC:nil
X-UUID: 3adf2b09e9054a8ebf80d0196da9e7aa-20220602
Received: from mtkcas10.mediatek.inc [(172.21.101.39)] by mailgw02.mediatek.com
        (envelope-from <sean.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-SHA384 256/256)
        with ESMTP id 290362415; Thu, 02 Jun 2022 06:23:25 +0800
Received: from mtkcas10.mediatek.inc (172.21.101.39) by
 mtkmbs11n2.mediatek.inc (172.21.101.187) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.3;
 Thu, 2 Jun 2022 06:23:23 +0800
Received: from mtkswgap22.mediatek.inc (172.21.77.33) by mtkcas10.mediatek.inc
 (172.21.101.73) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 2 Jun 2022 06:23:23 +0800
From:   <sean.wang@mediatek.com>
To:     <dev@pschenker.ch>
CC:     <deren.wu@mediatek.com>, <kvalo@kernel.org>,
        <linux-wireless@vger.kernel.org>, <nbd@nbd.name>,
        <linux@leemhuis.info>, <davem@davemloft.net>, <kuba@kernel.org>,
        <lorenzo.bianconi83@gmail.com>, <matthias.bgg@gmail.com>,
        <pabeni@redhat.com>, <ryder.lee@mediatek.com>,
        <sean.wang@mediatek.com>, <shayne.chen@mediatek.com>,
        <yn.chen@mediatek.com>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>,
        <linux-mediatek@lists.infradead.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
Date:   Thu, 2 Jun 2022 06:23:23 +0800
Message-ID: <1654122203-26090-1-git-send-email-sean.wang@mediatek.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch--annotate>
References: <e93aef5c9f8a97efe23cfb5892f78f919ce328e7.camel@pschenker.ch--annotate>
MIME-Version: 1.0
Content-Type: text/plain
X-MTK:  N
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        T_SCC_BODY_TEXT_LINE,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sean Wang <sean.wang@mediatek.com>

>On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
>> On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
>> > Philippe Schenker <dev@pschenker.ch> writes:
>> >
>> > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
>> > >
>> > > This commit introduces a regression on some systems where the
>> > > kernel is crashing in different locations after a reboot was
>> > > issued.
>> > >
>> > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest
>> > > firmware.
>> > >
>> > > Link:
>> > > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless
>> > > /5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!
>> > > CTRNKA9wMg0ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14
>> > > J4iDycWA9cq36Y$
>> > >
>> > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
>> >
>> > Can I take this to wireless tree? Felix, ack?
>> >
>> > I'll also add:
>> >
>> > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
>> >
>>
>> Hi Kalle,
>>
>> We have a patch for a similar problem. Can you wait for the
>> verification by Philippe?
>> Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
>> after
>> reboot")
>> Link:
>> https://urldefense.com/v3/__https://git.kernel.org/pub/scm/linux/kerne
>> l/git/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76?id=
>> 602cc0c9618a819ab00ea3c9400742a0ca318380__;!!CTRNKA9wMg0ARbw!3N9I3iKwS
>> 3XCNAb4LuhbFqt_el1yiOaJzSdUjaJsTaxRCHiWhXnEgbk3bOqYTy6T$
>>
>> I can reproduce the problem in my v5.16-rc5 desktop. And the issue can
>> be fixed when the patch applied.
>>
>>
>> Hi Philippe,
>>
>> Can you please help to check the patch in your platform?
>
>Hi Kalle and Deren,
>
>I just noticed on my system and mainline v5.18 reboots do now work however Bluetooth is no longer accessible after a reboot.
>
>Reverting commit bf3747ae2e25dda6a9e6c464a717c66118c588c8 on top of
>v5.18 solves this problem for me.
>
>@Deren are you aware of this bug?
>@Kalle Is there a bugtracker somewhere I can submit this?

Hi Philippe,

Could you try the latest firmware to see if it can help with the issue you reported here ?

Please check out https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/mediatek
and replace the following three files in /lib/firmware/mediatek on your target and reboot
1) BT_RAM_CODE_MT7961_1_2_hdr.bin
2) WIFI_MT7961_patch_mcu_1_2_hdr.bin
3) WIFI_RAM_CODE_MT7961_1.bin

	Sean

>
>Thanks,
>Philippe
>
>>
>>
>> Regards,
>> Deren
>>
>
>
>
