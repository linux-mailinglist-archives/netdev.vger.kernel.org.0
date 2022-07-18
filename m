Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A26D0577F52
	for <lists+netdev@lfdr.de>; Mon, 18 Jul 2022 12:06:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233730AbiGRKGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jul 2022 06:06:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233313AbiGRKGE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jul 2022 06:06:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88F091C123;
        Mon, 18 Jul 2022 03:06:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 37B5EB80EC1;
        Mon, 18 Jul 2022 10:06:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE0AC341C0;
        Mon, 18 Jul 2022 10:05:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658138760;
        bh=0lsumpUDTOMSTkvAmap9tn917b65eoT8ofrawwjhGRQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=MQUWTpjQxH5RKJvQAezAIbcNNVjW3U8Ov+/wmUuCn7bcE8DzohBPXHQ8Huk6d437D
         n1t3Wvw8vbocZIKxt19nHYiOLNlIZ7JXNwn9kqIwAbghcmPnF83RkgNp14HZNnKOWY
         CzexhWTH/mVa+PYcNgy5sC6TxRHz811FGcEJ+v6whKklD9hHH+WzaUkAmYSopt9vBt
         IhqilutQPAPr0ZIVtHmh+zM3tA4crpeb+E87U3L5ANFX2SH6vOIXDMDouM4F8U6ihS
         Z7YBKsVf0dVHVWPsWHpgtv8xtmfgCgNMRkBQ/ohsrXyncNhJjLxgHRA+2r+PMFERrt
         maROf8+5cwI8Q==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] wifi: wcn36xx: fix repeated words in comments
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220709124356.52543-1-yuanjilin@cdjrlc.com>
References: <20220709124356.52543-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jilin Yuan <yuanjilin@cdjrlc.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165813874770.12812.3009375369162457082.kvalo@kernel.org>
Date:   Mon, 18 Jul 2022 10:05:58 +0000 (UTC)
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
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

ec65e0e9acf7 wifi: wcn36xx: fix repeated words in comments

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220709124356.52543-1-yuanjilin@cdjrlc.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

