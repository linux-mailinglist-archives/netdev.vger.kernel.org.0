Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA43577F41
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbiGRKDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:03:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233314AbiGRKDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:03:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AA7FF7;
        Mon, 18 Jul 2022 03:03:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 37B5260B65;
        Mon, 18 Jul 2022 10:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17B75C341C0;
        Mon, 18 Jul 2022 10:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658138631;
        bh=QmgEjAMbWfsZe0w3A+yz7hK2g3FVLYIKHAFc1hxDeWY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=qCj0VvGXetX0D5GGd7Uyfu43KpH5gTyxPRVZxah5IUfWu2zT7D0RDgEwUfQ/mNSkC
         DCivJ///Q6r/iZWivDe5pcooytM2gT374aAa/z499VhbwWTc/Gp7t2wH9o3IpST/Sg
         w08qP6G0JS9RI+of6GCIlIN8wu9yGQcwLqq0XyQefOhQxllNxqtdJ6VZqbmMW0Suj2
         M+AiseFpKE0bbGcVjuJXZ0L2js56ZN+JkZKAP1msAwEPfILVvLfAPiTCyTjH6VBHW1
         jlUMV2J5nphJmx6aJZCTHJ1cju0IY23gOQ/DVveXegagaymRImeNuErM2naBRk5HHI
         AX0cvv8eDSfbQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wireless/ath: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220708154929.19199-1-yuanjilin@cdjrlc.com>
References: <20220708154929.19199-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     jirislaby@kernel.org, mickflemm@gmail.com, mcgrof@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165813862677.12812.17950003102947742156.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 10:03:48 +0000 (UTC)
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jilin Yuan <yuanjilin@cdjrlc.com> wrote:

> Delete the redundant word 'don't' and 'but'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

eaedf62f7aaa wifi: ath5k: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220708154929.19199-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

