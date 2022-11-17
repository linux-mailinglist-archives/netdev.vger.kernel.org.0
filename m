Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA2262DC17
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 13:57:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239273AbiKQM5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 07:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbiKQM5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 07:57:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A80312497E;
        Thu, 17 Nov 2022 04:57:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 539E3B82047;
        Thu, 17 Nov 2022 12:57:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE637C433D6;
        Thu, 17 Nov 2022 12:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668689831;
        bh=ZOv2xrVLw6KOC97u6Z3qAeavQOyOIGJMgx0UM0hKo/E=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=sGOk610N3CduGTmOdPfuOT4PNjLz8I5lU6nN2aUENTa4ejgyLccsO3fLtFYjBRdpf
         T2irFWVv7K6q4+bhEShd+i1QU3gpog6quSWq7XiHhS9WqcgQXCA/UuSaUIHLjHsKRQ
         BR+CeJRqNkvGfPxPsXnXARlsIMFvoWtd/uqlxeg7EVuU017+GEeVK+m57IiGPRMqn0
         XcwQtg5O69/i8A6mO4mianTfLiImbGmvTe+8B9LLGjJgVUlIMzkELU8WU8aVlGLLN7
         ZtWbwOmN1b5y91nNEop79i3wu82uFjJSd/eYRXn2/wmG+0D+NOtqo01ZdjC9xb2Zgw
         HUTp5YgmlG4ng==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH RESEND v2] wifi: ath10k: Fix return value in
 ath10k_pci_init()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221110061926.18163-1-xiujianfeng@huawei.com>
References: <20221110061926.18163-1-xiujianfeng@huawei.com>
To:     Xiu Jianfeng <xiujianfeng@huawei.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <kuba@kernel.org>,
        <pabeni@redhat.com>, <rmani@qti.qualcomm.com>,
        <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166868982720.22046.2839005153989061348.kvalo@kernel.org>
Date:   Thu, 17 Nov 2022 12:57:08 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Xiu Jianfeng <xiujianfeng@huawei.com> wrote:

> This driver is attempting to register to support two different buses.
> if either of these is successful then ath10k_pci_init() should return 0
> so that hardware attached to the successful bus can be probed and
> supported. only if both of these are unsuccessful should ath10k_pci_init()
> return an errno.
> 
> Fixes: 0b523ced9a3c ("ath10k: add basic skeleton to support ahb")
> Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
> Reviewed-by: Jeff Johnson <quic_jjohnson@quicinc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

2af7749047d8 wifi: ath10k: Fix return value in ath10k_pci_init()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221110061926.18163-1-xiujianfeng@huawei.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

