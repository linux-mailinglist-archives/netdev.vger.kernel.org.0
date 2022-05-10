Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633F152215D
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 18:34:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244884AbiEJQib (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 May 2022 12:38:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347479AbiEJQi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 May 2022 12:38:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B64452A4A0A;
        Tue, 10 May 2022 09:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BBA2B81E1F;
        Tue, 10 May 2022 16:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7204C385C2;
        Tue, 10 May 2022 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652200467;
        bh=VODkbTVf3Dt1eFAC0XK/q51ZYmsgxWsx2okbVq533/I=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FMONo6rKpM/kM/FTdTbOVzHXvhfPaCSQuBlJA6PJDkdaTs5h3XnyCI+NkpUOL5Bcf
         6vqZbmrkamiTOK2a+wLItHL4hdgi34UVt8c7bxF07yVlQe73/VZJFHq3nYCdf3Ju5J
         5LC6RZ5TcfWOu5qonumaSY+ck3IYMAClNwk6WOSgjjVDcZFCtnE1IMB1vn0Xd319kv
         Dzl9BdvB8Ix8x70doQsw4iwzE25cfc0Ryh6fqclmmTXCvHLzLwM6Yn7xwusH41eZSx
         wbHpHgWkZ8pQxys3c+v7ecTUqDzx4Nhevx3x9Qu7esxtmxW+zOV932j/ciFsM5aIAb
         fBbUbrKzCu7rw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath11k: remove redundant assignment to variables vht_mcs
 and
 he_mcs
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220507184155.26939-1-colin.i.king@gmail.com>
References: <20220507184155.26939-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165220046267.6768.5493678781221358887.kvalo@kernel.org>
Date:   Tue, 10 May 2022 16:34:24 +0000 (UTC)
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> The variables vht_mcs and he_mcs are being initialized in the
> start of for-loops however they are re-assigned new values in
> the loop and not used outside the loop. The initializations
> are redundant and can be removed.
> 
> Cleans up clang scan warnings:
> 
> warning: Although the value stored to 'vht_mcs' is used in the
> enclosing expression, the value is never actually read from
> 'vht_mcs' [deadcode.DeadStores]
> 
> warning: Although the value stored to 'he_mcs' is used in the
> enclosing expression, the value is never actually read from
> 'he_mcs' [deadcode.DeadStores]
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

25c321e8534e ath11k: remove redundant assignment to variables vht_mcs and he_mcs

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220507184155.26939-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

