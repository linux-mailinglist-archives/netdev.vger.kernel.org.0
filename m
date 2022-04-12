Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BEC4FE34E
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:58:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356591AbiDLN7F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:59:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356679AbiDLN6m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:58:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458B45C652;
        Tue, 12 Apr 2022 06:56:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA4C3B81E58;
        Tue, 12 Apr 2022 13:56:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6098FC385A1;
        Tue, 12 Apr 2022 13:56:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649771781;
        bh=uHkGd8ictgdU7Kn2Aw8Ljt7AtMOmTrIPNZUTzRWpN8k=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=rqoZtjd9+Ujnpn7EgNjft/K6ScpqMKWlVZrsx32ABAoMEIjdsax+Hbrb4QmBuX63P
         SGRyrRokIhxJdHCZXPJmd0KV1k2tOaakCRFpEuMyu4JEogX0rvHoxm6DoPLhHLVYdR
         QbCfI6pO7y0BwCdDCkhSvFibTpUl8ZLh3Px0jVH76Z0IY/zEat9BeWwLI5PtNmOBdL
         XwEXQySSAzApd25EgrQuVhO2j+MFfZFEV7MdyfCLExHAipJyh4fIYjh2bJo6sKpVva
         PY+9rwX8m5nGwtWKK83GMOS6/lte6vD74b5rQ8GAfpuEBgKLvrPmJ+/jJmpDSauTO7
         MP/pSx5FKq4tw==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix spelling mistake "writting" ->
 "writing"
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220411032458.2517551-1-lv.ruyi@zte.com.cn>
References: <20220411032458.2517551-1-lv.ruyi@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     pkshih@realtek.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, Larry.Finger@lwfinger.net, lv.ruyi@zte.com.cn,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977177737.30373.11474444705361142487.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:56:19 +0000 (UTC)
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

780d9c48a05a rtlwifi: rtl8192cu: Fix spelling mistake "writting" -> "writing"

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220411032458.2517551-1-lv.ruyi@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

