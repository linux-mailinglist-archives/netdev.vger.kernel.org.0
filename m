Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50B814B5919
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 18:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357252AbiBNRvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 12:51:15 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:39504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346837AbiBNRvO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 12:51:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2F765435;
        Mon, 14 Feb 2022 09:51:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CF216159F;
        Mon, 14 Feb 2022 17:51:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3154C340FD;
        Mon, 14 Feb 2022 17:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644861065;
        bh=E1fsyjxKOo6eUswTTQIheKg+D7Wu36faXZ8v2Mp0QAY=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=fnRHp1SDoiGaz950pAvCga0KFRBWDRQKJlrwuFNhnCNWPH1hl17X8tC5/cjIMsmed
         h35N35Ap0wJedOWMgq+sEu7BWJIirrxmvG+QblRh0SBQQA2ACZBN5KdlxlHT8ij2xk
         Alu+BrjI4GOJBDZIHYxXukivBKK9aJZTVzoeRkjYZcOObJ0MN/SavShoQCyFkauJH1
         M3U/xCZky3wW14K89d9c7z7bWqE1H3F88dSfux8apLq6o6YF+MPEaEUdE0naH/eAF5
         SNrPUMyxP+HlDc8jOhSuFH6xGq+DupO87IbYHd3tj443iTgNpWNdIa2br7tHFY4r9E
         8Yh4GRrsU2bfQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH V2] wcn36xx: use struct_size over open coded arithmetic
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220208015606.1514022-1-chi.minghao@zte.com.cn>
References: <20220208015606.1514022-1-chi.minghao@zte.com.cn>
To:     cgel.zte@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, wcn36xx@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164486106193.4355.17554368439155667103.kvalo@kernel.org>
Date:   Mon, 14 Feb 2022 17:51:03 +0000 (UTC)
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

cgel.zte@gmail.com wrote:

> Replace zero-length array with flexible-array member and make use
> of the struct_size() helper in kmalloc(). For example:
> 
> struct wcn36xx_hal_ind_msg {
>     struct list_head list;
>     size_t msg_len;
>     u8 msg[];
> };
> 
> Make use of the struct_size() helper instead of an open-coded version
> in order to avoid any potential type mistakes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi (CGEL ZTE) <chi.minghao@zte.com.cn>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

be24835f8323 wcn36xx: use struct_size over open coded arithmetic

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220208015606.1514022-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

