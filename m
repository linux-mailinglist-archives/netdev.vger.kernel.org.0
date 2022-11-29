Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F72C63C4F8
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 17:18:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiK2QSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 11:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235972AbiK2QSE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 11:18:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8877F2019F;
        Tue, 29 Nov 2022 08:17:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A7A6B816AA;
        Tue, 29 Nov 2022 16:17:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B4A4C433D6;
        Tue, 29 Nov 2022 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669738674;
        bh=DRfn+TpVRUL6CMr5CTIyEdnUfSabuFcgLkGOasdBnL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KvE7T2slbH5Il8SHhWyHYebElxnFHn47Y/mzxnpVTmdq1w6xY0W9iXXkSr8msjyWb
         c/8hSckKO9JBNOZ4+NicridH8+p1BnauSfEewGsi7Gk1I0YH1wEAJL+90yZFTiGwUA
         EjMP5XMX0ZU5zwJ2tizWh0CFBmuLKPVEK/71KCbis4pk8acTvN16YqZqyc3hpFHZNd
         M/DqhFDR2SVsr+x+wImVRQJkDjaUONQpvaFOBN+S7uNpvQQQEFcWVShUr5D27a/EOr
         XmLttSXUO4pULtEL4B8aZ8Gg2dq7zLVFuvkWC/xsYy4gl19F5xI3wbJTUIJFnVU8+t
         gIRQrjaLiuWxA==
Date:   Tue, 29 Nov 2022 08:17:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sascha Hauer <s.hauer@pengutronix.de>
Cc:     linux-wireless@vger.kernel.org, Neo Jou <neojou@gmail.com>,
        Hans Ulli Kroll <linux@ulli-kroll.de>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        kernel@pengutronix.de, Johannes Berg <johannes@sipsolutions.net>,
        Alexander Hochbaum <alex@appudo.com>,
        Da Xue <da@libre.computer>, Po-Hao Huang <phhuang@realtek.com>,
        Viktor Petrenko <g0000ga@gmail.com>
Subject: Re: [PATCH v4 08/11] wifi: rtw88: Add rtw8821cu chipset support
Message-ID: <20221129081753.087b7a35@kernel.org>
In-Reply-To: <20221129100754.2753237-9-s.hauer@pengutronix.de>
References: <20221129100754.2753237-1-s.hauer@pengutronix.de>
        <20221129100754.2753237-9-s.hauer@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 29 Nov 2022 11:07:51 +0100 Sascha Hauer wrote:
> +config RTW88_8821CU
> +	tristate "Realtek 8821CU USB wireless network adapter"
> +	depends on USB
> +	select RTW88_CORE
> +	select RTW88_USB
> +	select RTW88_8821C
> +	help
> +	  Select this option will enable support for 8821CU chipset
> +
> +	  802.11ac USB wireless network adapter

Those kconfig knobs add so little code, why not combine them all into
one? No point bothering the user with 4 different questions with amount
to almost nothing.
