Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1824FDCCD
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 13:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243020AbiDLKlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355827AbiDLKdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 06:33:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7355BD11;
        Tue, 12 Apr 2022 02:34:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A6AD760BC8;
        Tue, 12 Apr 2022 09:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4722DC385A5;
        Tue, 12 Apr 2022 09:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649756095;
        bh=oAkd2HMCyRHzsEbQYwM6YJGQ2zXVP3kaN1iufD17kAg=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=POJL7IvsbItT44cf4muVPhcT0u+5PP82kbHbjmmH0O+J8cQ05OE34aPylnfdGUi1s
         n9K666b2EWpQAXTV+M8BCreZjhD18bBfNDZxSjZdESvnje3k5MtvegQ/bhqPhoefBQ
         I2TDCsMKyEuc8QvdLDkoRf5nmUm+O3FnhOwb3m/SIA+LlOdYuvumI3sWL/pIpzhXvg
         AAv5baZ+7IJ2Tgsl/nWWWcyNTe+9oAfidwA+Y4+4Q8qBL2wwlBI7bFmh585ZnliN0g
         x648MpuIQzra/X/XuTgFk+Mbh5Hzu7Uh40XOMU43zlJJEK38NFVYghjssl+5kNddeR
         131Ka7IYu7uiA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wlcore: using pm_runtime_resume_and_get instead of
 pm_runtime_get_sync
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408081205.2494512-1-chi.minghao@zte.com.cn>
References: <20220408081205.2494512-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164975609097.5724.17794967869431754911.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 09:34:53 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get is more appropriate
> for simplifing code
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>

I'll rename this to:

wlcore: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408081205.2494512-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

