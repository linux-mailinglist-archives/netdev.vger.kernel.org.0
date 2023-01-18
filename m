Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9D3C6714A4
	for <lists+netdev@lfdr.de>; Wed, 18 Jan 2023 08:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230045AbjARHJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 02:09:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbjARHIz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 02:08:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6DDF6C571;
        Tue, 17 Jan 2023 22:35:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65BD2B81B43;
        Wed, 18 Jan 2023 06:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A980BC433EF;
        Wed, 18 Jan 2023 06:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674023722;
        bh=UsZhg3e/FoLkTU5R3hvEWS8a+d3s1oq7ddrZA6/R5ZE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rkbSW35Tf5XzQltEqJK1XK2bgCeGOIyt0k25tAaDauGymr2QAEfDKzjLEafnEjg+m
         6E6ixXFJP/Y9sgiaTtGf2DqLLGJvJFj9/1i0m0cjW/wco172djAyy4Ov+NqBuKxiWO
         3y3GLZwo09QopS8eFVfnls35rdFuHELzhIEiDBmYLZhMHzZkFXxFyWqWS9RavSE1O/
         vseCn2qrZgium/eGEvupTLm9c3qnLKVKNl9SKV28uDZzYhQWBQTyxYlEsDFRWZE2ZF
         bCoCim3jlVYAqNW1Z+2eZil5DZqMu0Zg5Iaf/v2cX0+NbguVqGFS15L4/ze4n2WPgN
         czNXfcZZ5tRKg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] wifi: ath11k: Fix memory leak in
 ath11k_peer_rx_frag_setup
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20230102081142.3937570-1-linmq006@gmail.com>
References: <20230102081142.3937570-1-linmq006@gmail.com>
To:     Miaoqian Lin <linmq006@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linmq006@gmail.com
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167402371642.24104.14787775190477327666.kvalo@kernel.org>
Date:   Wed, 18 Jan 2023 06:35:19 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Miaoqian Lin <linmq006@gmail.com> wrote:

> crypto_alloc_shash() allocates resources, which should be released by
> crypto_free_shash(). When ath11k_peer_find() fails, there has memory
> leak. Add missing crypto_free_shash() to fix this.
> 
> Fixes: 243874c64c81 ("ath11k: handle RX fragments")
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

ed3f83b3459a wifi: ath11k: Fix memory leak in ath11k_peer_rx_frag_setup

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20230102081142.3937570-1-linmq006@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

