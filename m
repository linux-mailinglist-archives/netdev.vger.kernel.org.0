Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E7B5427A89
	for <lists+netdev@lfdr.de>; Sat,  9 Oct 2021 15:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233401AbhJINYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Oct 2021 09:24:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233191AbhJINYt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Oct 2021 09:24:49 -0400
Received: from fudo.makrotopia.org (fudo.makrotopia.org [IPv6:2a07:2ec0:3002::71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 248E4C061570;
        Sat,  9 Oct 2021 06:22:52 -0700 (PDT)
Received: from local
        by fudo.makrotopia.org with esmtpsa (TLS1.3:TLS_AES_256_GCM_SHA384:256)
         (Exim 4.94.2)
        (envelope-from <daniel@makrotopia.org>)
        id 1mZCJ8-0002SM-M1; Sat, 09 Oct 2021 15:22:35 +0200
Date:   Sat, 9 Oct 2021 14:22:16 +0100
From:   Daniel Golle <daniel@makrotopia.org>
To:     Nick <vincent@systemli.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        davem@davemloft.net, kuba@kernel.org, matthias.bgg@gmail.com,
        sean.wang@mediatek.com, shayne.chen@mediatek.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org,
        Robert Foss <robert.foss@linaro.org>
Subject: Re: [RFC v2] mt76: mt7615: mt7622: fix ibss and meshpoint
Message-ID: <YWGXiExg1uBIFr2c@makrotopia.org>
References: <20211007225725.2615-1-vincent@systemli.org>
 <87czoe61kh.fsf@codeaurora.org>
 <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <274013cd-29e4-9202-423b-bd2b2222d6b8@systemli.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 09, 2021 at 12:37:53PM +0200, Nick wrote:
> On 10/9/21 10:32, Kalle Valo wrote:
> 
> > Nick Hainke <vincent@systemli.org> writes:
> > 
> > > Fixes: d8d59f66d136 ("mt76: mt7615: support 16 interfaces").
> > The fixes tag should be in the end, before Signed-off-by tags. But I can
> > fix that during commit.
> Thanks for feedback. Already changed that locally but I did not want to spam
> you with another RFC v3. :)
> I was able to organize me a BPI-MT7615 PCIE Express Card. With and without
> this patch beacons were sent on the mt7615 pcie, so the patch did not make
> any difference. However, the mt7622 wifi will only work with my patch.

Does Mesh+AP or Ad-Hoc+AP also work on MT7622 and does it still work on
MT7615E card with your patch applied?
