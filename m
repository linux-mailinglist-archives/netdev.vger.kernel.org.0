Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0389C4FE155
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 14:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354802AbiDLM7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 08:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351056AbiDLM4y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 08:56:54 -0400
Received: from mxout014.mail.hostpoint.ch (mxout014.mail.hostpoint.ch [IPv6:2a00:d70:0:e::314])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EED694C42F;
        Tue, 12 Apr 2022 05:30:42 -0700 (PDT)
Received: from [10.0.2.46] (helo=asmtp013.mail.hostpoint.ch)
        by mxout014.mail.hostpoint.ch with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2 (FreeBSD))
        (envelope-from <dev@pschenker.ch>)
        id 1neFfG-000Bu6-U9; Tue, 12 Apr 2022 14:30:34 +0200
Received: from 31-10-206-124.static.upc.ch ([31.10.206.124] helo=[10.0.0.134])
        by asmtp013.mail.hostpoint.ch with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.95 (FreeBSD))
        (envelope-from <dev@pschenker.ch>)
        id 1neFfG-000LWw-O9;
        Tue, 12 Apr 2022 14:30:34 +0200
X-Authenticated-Sender-Id: dev@pschenker.ch
Message-ID: <420241bdd4fdbd1379f59e38571ec04c580eba41.camel@pschenker.ch>
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
From:   Philippe Schenker <dev@pschenker.ch>
Reply-To: dev@pschenker.ch
To:     Deren Wu <deren.wu@mediatek.com>, Kalle Valo <kvalo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux@leemhuis.info, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        YN Chen <YN.Chen@mediatek.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mediatek@lists.infradead.org, netdev@vger.kernel.org
Date:   Tue, 12 Apr 2022 14:30:34 +0200
In-Reply-To: <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
References: <20220412090415.17541-1-dev@pschenker.ch>
         <87y20aod5d.fsf@kernel.org>
         <668f1310cc78b17c24ce7be10f5f907d5578e280.camel@mediatek.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2022-04-12 at 19:06 +0800, Deren Wu wrote:
> On Tue, 2022-04-12 at 12:37 +0300, Kalle Valo wrote:
> > Philippe Schenker <dev@pschenker.ch> writes:
> > 
> > > This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
> > > 
> > > This commit introduces a regression on some systems where the
> > > kernel is
> > > crashing in different locations after a reboot was issued.
> > > 
> > > This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest
> > > firmware.
> > > 
> > > Link: 
> > > https://urldefense.com/v3/__https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/__;!!CTRNKA9wMg0ARbw!09tjyaQlMci3fVI3yiNiDJKUW_qwNA_CbVhoAraeIX96B99Q14J4iDycWA9cq36Y$
> > >  
> > > Signed-off-by: Philippe Schenker <dev@pschenker.ch>
> > 
> > Can I take this to wireless tree? Felix, ack?
> > 
> > I'll also add:
> > 
> > Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")
> > 
> 
> Hi Kalle,
> 
> We have a patch for a similar problem. Can you wait for the
> verification by Philippe?
> Commit 602cc0c9618a81 ("mt76: mt7921e: fix possible probe failure
> after
> reboot")
> Link: 
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/drivers/net/wireless/mediatek/mt76?id=602cc0c9618a819ab00ea3c9400742a0ca318380
> 
> I can reproduce the problem in my v5.16-rc5 desktop. And the issue can
> be fixed when the patch applied.
> 
> 
> Hi Philippe,
> 
> Can you please help to check the patch in your platform?

Aah, so I have been a bit late with my painful bisecting. Should have
checked -next before... Whatever, your patch works just fine. I cherry
picked your patch on top mainline v5.17 and it works just fine with that
one.

Thank you very much Deren!

Sorry Kalle for the overlapping revert, please do not apply it.

Best Regards,
Philippe

> 
> 
> Regards,
> Deren
> 

