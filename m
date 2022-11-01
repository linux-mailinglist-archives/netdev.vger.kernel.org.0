Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0AC8C6146A0
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 10:28:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230108AbiKAJ2I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Nov 2022 05:28:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbiKAJ2G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Nov 2022 05:28:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 373D9183A8;
        Tue,  1 Nov 2022 02:28:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E88AFB81C1F;
        Tue,  1 Nov 2022 09:28:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EA47C433D6;
        Tue,  1 Nov 2022 09:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667294881;
        bh=b5oMAoKP4AeMRH9vw8x8y5P2nZXivmtvSuBCcrTDKOc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=UCwuHXOJhzGAVLFcvJ/WmfzKpfavZ6thwkEMoCqYd6Y36aiGItxz/dJy2nQbyZ72+
         OBNzH0UgAevuH662dgcV4/dZlw+kVXO+5iJWx7VHA0Xnh2FuEaHauo6iCjwG5HImYb
         BHE8xVMlURaqar33SfsF6qAM3gRfWqR3a6RjET6ltrHZ9fb9knjCpEneNObZC3TaNf
         LYiA9a4IutJDkBTYNT+RWDkXC2trOn0yuD+DsjOwKW8yTu3gz/1+dTZt+I32GN9cX9
         /0GE8UCIClWjxVylxzml1KL/iS7Ey5i/73ak/L1E71eXrER+ga+6Z10FQmSWJIQUKu
         zVU+OG+dN8euA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH][next] wifi: rtw89: 8852b: Fix spelling mistake
 KIP_RESOTRE ->
 KIP_RESTORE
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221020072646.1513307-1-colin.i.king@gmail.com>
References: <20221020072646.1513307-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166729487741.21401.13126570333051605990.kvalo@kernel.org>
Date:   Tue,  1 Nov 2022 09:27:59 +0000 (UTC)
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin Ian King <colin.i.king@gmail.com> wrote:

> Ther is a spelling mistake in a rtw89_debug message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

8fa681703175 wifi: rtw89: 8852b: Fix spelling mistake KIP_RESOTRE -> KIP_RESTORE

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221020072646.1513307-1-colin.i.king@gmail.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

