Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1D8D4FE33A
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356459AbiDLN4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356476AbiDLN4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:56:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1A662DD47;
        Tue, 12 Apr 2022 06:54:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 519CC61AEC;
        Tue, 12 Apr 2022 13:54:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4C0C385A9;
        Tue, 12 Apr 2022 13:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649771653;
        bh=1xCfFE2oXWz+O/UH/WskpkBvcYnuHxTm3IgRI2Z7Se8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=p45gt84Qezp4EsEarhBJ/t/c9pSx9E0oGrMC/otq0wUcOIyfKzbpsCwQsvQ9k7+Rn
         8YkuC+/BJoEER989ZXH325yCQ6A8AiQqBksiIBvtRTAnZwxBpUNBQfk3kSoLbIwuPh
         66fLRZ2a1gP9uDD78za/JzFv8EW+A1Wh9NBif8dYNOymS4jvqLWyO0MDtXlKqB/I2F
         5njuytQoNXf/wSU1qt5HCy5s9QBAYTMZ2XaTZx1X6dkAmokCjd9dF4Q8WFUkVs1aMZ
         v88ovsUtsCbaKGvQZkodx4PtMaBzfT0DHIwpenbnAYLpdIyXuC3S/UNSQCpE1NVzw7
         8Ppjfu/4fl1yg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: rtlwifi: Fix spelling mistake "cacluated" -> "calculated"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220408095803.2495336-1-lv.ruyi@zte.com.cn>
References: <20220408095803.2495336-1-lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, lv.ruyi@zte.com.cn,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977164950.6629.9995418227435964900.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:54:11 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> From: Lv Ruyi <lv.ruyi@zte.com.cn>
> 
> There are some spelling mistakes in the comments. Fix it.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Lv Ruyi <lv.ruyi@zte.com.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

e8c241d4a7fa rtlwifi: Fix spelling mistake "cacluated" -> "calculated"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220408095803.2495336-1-lv.ruyi@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

