Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D8261668F
	for <lists+netdev@lfdr.de>; Wed,  2 Nov 2022 16:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbiKBPxY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 11:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230480AbiKBPxX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 11:53:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F40965FF;
        Wed,  2 Nov 2022 08:53:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F278361A3C;
        Wed,  2 Nov 2022 15:53:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 318C6C433D7;
        Wed,  2 Nov 2022 15:53:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667404401;
        bh=YIMhsZZSiri86laUeio2ZJ5MI9Auku8tWuRwUZZgrU4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=vCBRfzG2osYYmCwiur2EJub3kpny7uDgdG3oyZFS2/uu2sG2QqoIuqMacbHs9w3Bm
         DLbNgBUeVxcEvKnct2F+UVfLMw62d5nUHqyvijxTINuc1X+nvQ+xvW2CM/Bu6e5ip0
         0EocG+ZCx9QL3sPtXA/ApRuXjeMKfs2M3nHvJt+iCfPPbGrO8+0WWHCVtriaboSlkz
         Ukv6eQmSN8BrJWb8UX4JB8FgOVz339WQpDtdLFfLNHNFzXSM8cMp9rVSuCTieqxaAq
         XhoH/4kI74Z66BxeL4YAGzqi0OXIj+bgZlWbO7yeYQbaFYmvxPm9sm/L9khZOz85pz
         LWXTbSUn+1FNQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: remove variable sent
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221024153954.2168503-1-colin.i.king@gmail.com>
References: <20221024153954.2168503-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166740439390.20386.10524681182247555003.kvalo@kernel.org>
Date:   Wed,  2 Nov 2022 15:53:19 +0000 (UTC)
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Variable sent is just being incremented and it's never used
> anywhere else. The variable and the increment are redundant so
> remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

4f6620cd6bbd wifi: ath9k: remove variable sent

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221024153954.2168503-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

