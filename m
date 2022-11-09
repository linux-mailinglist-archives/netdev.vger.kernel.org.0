Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780BF62245E
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 08:05:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbiKIHFE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Nov 2022 02:05:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiKIHFC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Nov 2022 02:05:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79B691DDFF;
        Tue,  8 Nov 2022 23:05:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0E7D2618CF;
        Wed,  9 Nov 2022 07:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556FDC433D6;
        Wed,  9 Nov 2022 07:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667977500;
        bh=XzQzAuHjMD8nBRIb31jLyO9Oa4GaBmvEgA5C2VJmaN4=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=k/ydLQoIbZWatztSOcT/Raq90pz5OsPJrv0HIOEK2jN5S9hBjdpccfehM7U+KCbfH
         yWYMA+UIJhfV7Z4mAj8efIpyQ8gpcEHegbN/LFZf8JWRriRPmXkyIyir2CSbAJdkMJ
         iCZErYNBscSFtlwSqXcvd3rRbXHXtOFf4QOwpPCDDCcC7xciTSvo3BmzY1oc5LD7h4
         3eG5ylw5FCE5FV/ByRK8j0qcJhPrJSXeYdYKCPBK0nfKIvpx/vg0fJpiPkO1g8iHFj
         iC6HmlzOuBrrw2kUCP3YC64y/T1w/CQJpxB4L0puSJRjXm34f/bfMwk+M8/5dcWsn9
         O63NJDqUoVVIg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ath9k: Remove unused variable mismatch
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221104140723.226857-1-colin.i.king@gmail.com>
References: <20221104140723.226857-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166797749534.13342.6777832158964184769.kvalo@kernel.org>
Date:   Wed,  9 Nov 2022 07:04:58 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Variable mismatch is just being incremented and it's never used anywhere
> else. The variable and the increment are redundant so remove it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

dc45398446be wifi: ath9k: Remove unused variable mismatch

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221104140723.226857-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

