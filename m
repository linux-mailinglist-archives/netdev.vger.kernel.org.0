Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B745F9C17
	for <lists+netdev@lfdr.de>; Mon, 10 Oct 2022 11:39:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbiJJJja (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 05:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231795AbiJJJjX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 05:39:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA7FD6A486;
        Mon, 10 Oct 2022 02:39:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16E28B80E10;
        Mon, 10 Oct 2022 09:39:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AD1EC433D6;
        Mon, 10 Oct 2022 09:39:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665394751;
        bh=+ntlNPaUu8ZqKEENMV+H9ix1UQJwz1ovCJAvJR+dlzo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=uU2l+K7yp3hFqNw4PUxsf43FpIavUFqgmAJKENNo12SGIJMbYMb6W6teBwZ6L9sMo
         IIGcEUTsEdyN4aLXcpPdUk4BP960ftwLcA2Cb6tGdDb8EkQqiJy6L7y87AxvTJUG0f
         NZUrL1l+5uZPs4LdOuq25ClPekjARBzmwulMI+/vcwPJT+e0aIztZoTeIDsgKdqKZo
         YQEGjaZJJN1VuxnTW7+IRpMipUtF3QX5OGoBfOvMJRK8JqZvYwDqZY6hpk6JXMaAyq
         pdCrX3+LMKbzuwDIhyAdt+tmET+C7wZcZNYLIM4aKZ8Kkxv3pYGzR8wDBNv6DZbt2e
         Eypyqiug2EWFQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: ath11k: Fix spelling mistake "chnange" ->
 "change"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220928143834.35189-1-colin.i.king@gmail.com>
References: <20220928143834.35189-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166539474757.12656.2793687718974660718.kvalo@kernel.org>
Date:   Mon, 10 Oct 2022 09:39:09 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> There is a spelling mistake in an ath11k_dbg debug message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a797f479bf3e wifi: ath11k: Fix spelling mistake "chnange" -> "change"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220928143834.35189-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

