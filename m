Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA594FDCC2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:06:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234274AbiDLKjG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:39:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1381910AbiDLKgF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:36:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0537B606C3;
        Tue, 12 Apr 2022 02:38:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A48E60BC8;
        Tue, 12 Apr 2022 09:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282BCC385A1;
        Tue, 12 Apr 2022 09:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649756281;
        bh=Z8H3j7wqi5e1lG2YLJp1rEvzi3mZVYDKfcLpQYqvVss=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=c3zVsyjuMlxbotIc42Vq0cYT4ydjtAY1ae1gbMIYRsylDj/1ckf2B74QKGTczGsD2
         o8EhhejnQbt6nIerFou1kYwlZAdjZKE/1PZr03g41cgtkaPeFwunWunWVjGgH3z0T1
         cWdlS0yGFjY/PPHOYZ9XHLhye+bsqjxh1qGl6wzclsST2k9keMAwwrN6BiSGSABVGw
         9MBoRR2WibvTpeDUj3LeexDgCp9pz1e5IY0gNeOFFBlN1SXaFcThO1ZQSsJbz/Scsg
         PaooJ7TgY814dyHkDzQ7mLRc3MfjhdXfkQgRu7gInh3tlXlZR/D5c0WNG9x/Ti16a+
         SwFhheUZov/gA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Philippe Schenker <dev@pschenker.ch>
Cc:     linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        linux@leemhuis.info, "David S. Miller" <davem@davemloft.net>,
        Deren Wu <deren.wu@mediatek.com>,
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
Subject: Re: [PATCH] Revert "mt76: mt7921: enable aspm by default"
References: <20220412090415.17541-1-dev@pschenker.ch>
Date:   Tue, 12 Apr 2022 12:37:50 +0300
In-Reply-To: <20220412090415.17541-1-dev@pschenker.ch> (Philippe Schenker's
        message of "Tue, 12 Apr 2022 11:04:14 +0200")
Message-ID: <87y20aod5d.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Philippe Schenker <dev@pschenker.ch> writes:

> This reverts commit bf3747ae2e25dda6a9e6c464a717c66118c588c8.
>
> This commit introduces a regression on some systems where the kernel is
> crashing in different locations after a reboot was issued.
>
> This issue was bisected on a Thinkpad P14s Gen2 (AMD) with latest firmware.
>
> Link: https://lore.kernel.org/linux-wireless/5077a953487275837e81bdf1808ded00b9676f9f.camel@pschenker.ch/
> Signed-off-by: Philippe Schenker <dev@pschenker.ch>

Can I take this to wireless tree? Felix, ack?

I'll also add:

Fixes: bf3747ae2e25 ("mt76: mt7921: enable aspm by default")

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
