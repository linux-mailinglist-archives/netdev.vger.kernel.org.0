Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75ED74DDD1E
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 16:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238228AbiCRPju (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 11:39:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238218AbiCRPjq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 11:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C263655A3;
        Fri, 18 Mar 2022 08:38:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E5C760DF3;
        Fri, 18 Mar 2022 15:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB10AC340E8;
        Fri, 18 Mar 2022 15:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647617905;
        bh=WlXccs9jxy8tdltrMaJyKSPB6CfDpAaOnqmUkn7LHQ4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NeCCtIWo/8rtQypgjUDlS6ZxzzgXOx3mDfe44mWgChWdQa+UgsQFcMXwpjSWMZXfG
         gg15+UNVexeK0vjp7VN/snGlxrLnbOCDBgy0GitKV3gEyV9dD9cDAgbWn/mO0pH7K0
         xIGtKEFBeHiI26MgucN8GYMxYiW2b+jB1vHQC5rFqHvjvM66EbkeqAlDwPzWCGNoIt
         FEBXXIVOLrD7Il2rXVBKuzhGmovfOVZZklFA/7wcdMYBSefZxyxbAPAdbWu2GUTz66
         c5WeQTgp/PgbLqpVjMe+bdOsTXlMlfo9RJZQZtjNAgKcRfdcioskF5mCslEC4LePwz
         MpzoazIf4NrOA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] ath9k: Use platform_get_irq() to get the interrupt
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220314064501.2114002-1-chi.minghao@zte.com.cn>
References: <20220314064501.2114002-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     toke@toke.dk, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164761790166.655.9681762898112864772.kvalo@kernel.org>
Date:   Fri, 18 Mar 2022 15:38:23 +0000 (UTC)
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> It is not recommened to use platform_get_resource(pdev, IORESOURCE_IRQ)
> for requesting IRQ's resources any more, as they can be not ready yet in
> case of DT-booting.
> 
> platform_get_irq() instead is a recommended way for getting IRQ even if
> it was not retrieved earlier.
> 
> It also makes code simpler because we're getting "int" value right away
> and no conversion from resource to int is required.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

9503a1fc123d ath9k: Use platform_get_irq() to get the interrupt

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220314064501.2114002-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

