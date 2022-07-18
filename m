Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 005625781B3
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 14:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234858AbiGRMJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 08:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234815AbiGRMJ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 08:09:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01B9024943;
        Mon, 18 Jul 2022 05:09:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 114FE6147E;
        Mon, 18 Jul 2022 12:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D61C341CA;
        Mon, 18 Jul 2022 12:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658146152;
        bh=CiVdIVIcbI09n1eCookNEn+X52Sk/j1fD0MbRklf/8Q=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=PEvG6vZwAlA5opwJLXfv9v1nAPAhsQL04C+vg5YuIJQ17lNkpoHXsihVpXHawExKN
         7qbbMDp9bQPxpj6o73LP1UfD9/P558hhqJMhX/JmSUq2MxZV/0eDqkjFLkeeMVQtxO
         d0ucTKOYu/Y61Ofhs5NOHEft8ESVqpmCudscyAk08MOHAewG8i4GpVDggLY3ZPGKHm
         Msh6P96rjezCrsTwTRSiaLIXZAh1XPT3plQ3vwYQYl/Y0wOnnINtImjDPst2z2syzs
         BanAj11hzZU0nO1uW97xAdJYdh41S/Zm2Tf6p+V/Je6VtBKKtildVXfrM/I/rBYjWs
         ZlmYtHtAChWsQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: qtnfmac: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220710041005.10950-1-yuanjilin@cdjrlc.com>
References: <20220710041005.10950-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     imitsyanko@quantenna.com, geomatsi@gmail.co, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165814614819.32602.13322590884597019763.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 12:09:09 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>

Patch applied to wireless-next.git, thanks.

fb01be6d6836 wifi: qtnfmac: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220710041005.10950-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

