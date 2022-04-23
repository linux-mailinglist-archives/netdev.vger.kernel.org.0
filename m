Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E2750CA04
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 14:43:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiDWMqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 08:46:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiDWMqg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 08:46:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A1DF2394A3;
        Sat, 23 Apr 2022 05:43:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 34951610AB;
        Sat, 23 Apr 2022 12:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAE7C385A5;
        Sat, 23 Apr 2022 12:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650717818;
        bh=EbsNIYHYE0xnpuSz31FoL9YdysA8KByDyIT+1kXWH74=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=oNkt/h/Km41MiHt8bGmyGqlSK2YejbvbNAsyMnam/5rQbC3nH6SiTXouTB5VNPLZP
         wRi7U5xTVtJ1IqDawoNBjmxRQZm/g7WtT3IMicxmOjPPmb6OcG7lWyowOQ+X0/prUR
         tfF/F91A26k3d3OjNkKrGHCZ0Ms5Uql1qwSB6U5xq52FEr/sHFsqQQFmxQNkPNN0/o
         2ADpEGt2zpc8ZCfE/iOnFyywKUD/c21F6AXfpHM13RWLa4ZGWDjayIcXOK6DCF4YZc
         ZHmWb+AQJsxq7E4JS1bEkxj6kcV3UmGZp6gGADVwm7luFlOpticD29I+QaZ7toAV2J
         IjGBNG4wM3sww==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wl18xx: debugfs: use pm_runtime_resume_and_get() instead of
 pm_runtime_get_sync()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220413093356.2538192-1-chi.minghao@zte.com.cn>
References: <20220413093356.2538192-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165071781385.1434.10114084270097308406.kvalo@kernel.org>
Date:   Sat, 23 Apr 2022 12:43:36 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

Patch applied to wireless-next.git, thanks.

8e95061b5b9c wl18xx: debugfs: use pm_runtime_resume_and_get() instead of pm_runtime_get_sync()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220413093356.2538192-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

