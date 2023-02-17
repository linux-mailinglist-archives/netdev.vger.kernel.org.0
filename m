Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 850AD69B029
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 17:04:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbjBQQEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 11:04:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBQQEo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 11:04:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E1436D7A5;
        Fri, 17 Feb 2023 08:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA0D7B82C67;
        Fri, 17 Feb 2023 16:04:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F062C433D2;
        Fri, 17 Feb 2023 16:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676649880;
        bh=MhbECQnoKSy05RSvXladUTSAdb/Mb7zR8TEQqOIMZ6c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=DGJXci3x60y9O+nZEq+OdbAoI6bpewskbhX947OXu7XRLiKbxPjYUgybyEyACvgzr
         /GsI6BHpkS+Qz1jmTqcb0FGh+QYW4iAIe6DqB1cRwPEpWSxqAlOKV8zZkLPrZbQ0Tc
         QHBlht8mYhGpm2WLJiMEWnLM6bkajPudXzudtd78jbwGspVJp/LRTyV2hQi+Q2/Uc9
         WtEsLfsDhrB5BCgneqOM/I6JNphsENDkyES5wlACULuG9UXDCJIpMhmhtB35Rl9QpX
         z6+GzVRxqSjELTLVyiL+wwPmWASwYlnCCinvp4SvNtMKMBJxwDyKjgwHK5cl8506H0
         f2akMTLj3es7A==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: ath12k: Fix spelling mistakes in warning
 messages
 and comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230214092122.265336-1-colin.i.king@gmail.com>
References: <20230214092122.265336-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath12k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167664987616.8263.15640226468725297685.kvalo@kernel.org>
Date:   Fri, 17 Feb 2023 16:04:38 +0000 (UTC)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> There are quite a few spelling mistakes in warning messages and a lot
> of the comments. Fix these.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

480c9df57787 wifi: ath12k: Fix spelling mistakes in warning messages and comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230214092122.265336-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

