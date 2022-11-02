Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A14B6161DD
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 12:40:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbiKBLk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 07:40:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiKBLk1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 07:40:27 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E0165FC;
        Wed,  2 Nov 2022 04:40:23 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1oqC6I-0002qz-Nw; Wed, 02 Nov 2022 12:40:06 +0100
Date:   Wed, 2 Nov 2022 11:40:01 +0000
From:   Daniel Golle <daniel@makrotopia.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: ethernet: mediatek: ppe: add support for flow
 accounting
Message-ID: <Y2JXEfRDZO2oPoMT@makrotopia.org>
References: <Y2HAmYYPd77dz+K5@makrotopia.org>
 <20221101204945.35edb8e6@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221101204945.35edb8e6@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

On Tue, Nov 01, 2022 at 08:49:45PM -0700, Jakub Kicinski wrote:
> On Wed, 2 Nov 2022 00:58:01 +0000 Daniel Golle wrote:
> > The PPE units found in MT7622 and newer support packet and byte
> > accounting of hw-offloaded flows. Add support for reading those
> > counters as found in MediaTek's SDK[1].
> > 
> > [1]: https://git01.mediatek.com/plugins/gitiles/openwrt/feeds/mtk-openwrt-feeds/+/bc6a6a375c800dc2b80e1a325a2c732d1737df92
> > Signed-off-by: Daniel Golle <daniel@makrotopia.org>
> > ---
> > v4: declare function mtk_mib_entry_read as static
> > v3: don't bother to set 'false' values in any zero-initialized struct
> >     use mtk_foe_entry_ib2
> >     both changes were requested by Felix Fietkau
> > 
> > v2: fix wrong variable name in return value check spotted by Denis Kirjanov
> 
> Please read the FAQ:
> 
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#tl-dr

I'm sorry for re-submitting the fixes to frequently. I'll give it more
time in future.

> 
> https://www.kernel.org/doc/html/next/process/maintainer-netdev.html#running-all-the-builds-and-checks-locally-is-a-pain-can-i-post-my-patches-and-have-the-patchwork-bot-validate-them
> 

It wasn't my intention to out-source testing to the patchwork bot.
I do run checks as recommended locally, which includes checkpatch.pl,
build and run-time testing. And though in this case an unneeded export
of a function was also indicated by my local compiler, I must have
missed it in the output of the kernel build. I will try to improve my
workflow in such a way that it will be less likely to miss new compiler
warnings.
