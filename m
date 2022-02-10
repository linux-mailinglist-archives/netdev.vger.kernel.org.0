Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DE984B0D3B
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 13:11:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241444AbiBJMLX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 07:11:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiBJMLW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 07:11:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 802A31098;
        Thu, 10 Feb 2022 04:11:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 34C01B82427;
        Thu, 10 Feb 2022 12:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA75CC004E1;
        Thu, 10 Feb 2022 12:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644495080;
        bh=m9xsRSfcgzaB9d1+P3z4hWiz8XuCiyXDg3LvpoZGVYE=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=AvHiWF2o1W2Tmfgjz0t98jT7zhVN49BIVgpu3JVEguUcZyPuh85LU+xIwZ7cDlMZD
         oJi+jbbPfaiTTyFndUkZ8fD5FJPV9YgLcKCFhIblT43IA8OqwPcsb6e2W9uUR367vr
         nVVfiQrxQhyXP/JRgNFegnDvE8OWNoiMuFpdWm0JCPg83/Na0JRNOnhg/l4JOOhWTN
         FkzEQwL3YBCwCmiVo+X4i4lQpZbTbNsLI7GomosobracP53NERhjMpkUuIq8cTHb1b
         rKIUaGcHzGBAFeDj0e4CldB0n17/TW4oYDwE6o9hwbEwuhHothcBHvKqGcFQOE4GTv
         Wl7NYCX3SXEeQ==
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
Message-ID: <164449505175.11894.18378600637942439052.kvalo@kernel.org>
Date:   Thu, 10 Feb 2022 12:11:18 +0000 (UTC)
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

> From: "Minghao Chi (CGEL ZTE)" <chi.minghao@zte.com.cn>
> 
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

What are the changes from v1?

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220208015606.1514022-1-chi.minghao@zte.com.cn/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

