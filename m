Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 166C64FE332
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:56:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356479AbiDLN6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:58:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356516AbiDLN57 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:57:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 882F8F51;
        Tue, 12 Apr 2022 06:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F252361AF8;
        Tue, 12 Apr 2022 13:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E449C385A1;
        Tue, 12 Apr 2022 13:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649771741;
        bh=9nB9btp7CggAjhl+lMpMoIhd72xBiqUVJqFe1BoEDNo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=F4o+8xh8x9IasDQcuT65ggd6IbezxA/1VXWH34mTgZycmR1b4l7qOvIx3MFaHj3KU
         byjmUcaMbc6D7h6VnrLdmEFPFrFn8sjSXBfhL61g0NjDtZfg3Ka+t3Wd5A8T4h0aBM
         L9Rol7iJBqgASCDxwOv/iUtazdP3yYmJnrRq6g5KT1sPNRAm5rWwgvA/F4SXeYRwBn
         dhe4igjU19t39gncWhpQbKPwQO3oiXUR90ikOMCvYVCwXlXw9jVLMcFB7QaI0jVZox
         kNJ5hvJuQa10Sn9w70/RDyk0BKS8MRl8ygVZzgWFfGOb5At8HIMlQ6THlSVN95cAw9
         pcmM5TvLsCrFQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless: ipw2x00: Refine the error handling of
 ipw2100_pci_init_one()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220409062449.3752252-1-zheyuma97@gmail.com>
References: <20220409062449.3752252-1-zheyuma97@gmail.com>
To:     Zheyu Ma <zheyuma97@gmail.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zheyu Ma <zheyuma97@gmail.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977173724.30373.497076954212523434.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:55:39 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zheyu Ma <zheyuma97@gmail.com> wrote:

> The driver should release resources in reverse order, i.e., the
> resources requested first should be released last, and the driver
> should adjust the order of error handling code by this rule.
> 
> Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>

Can someone review this, please?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220409062449.3752252-1-zheyuma97@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

