Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8325429E3
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 10:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbiFHIvM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 04:51:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231599AbiFHIuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 04:50:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E8B72E68A;
        Wed,  8 Jun 2022 01:07:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32082B82586;
        Wed,  8 Jun 2022 08:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D2CC34116;
        Wed,  8 Jun 2022 08:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654675676;
        bh=xgUnZ05DgSsN3m66jVL3rwkvg0bAunJZ88E9ubfR8DQ=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=VBU9apM/0BsrA2dIoHjVqqTDtcRcczQYLPQk0wXRAzBpR16ob+3K/3VTiWbOKS4sc
         u8SyHlyun5DSW0ei/G1bGysX/I/Axw/er2S7XmDePbpUGKfNBFgS5UcaScJ8JtTdRm
         fCH2UL2Qd+s7ZPtTsIzROFgtU8z33Yh5jet3XLWebv8HPU3jbb0Kb1rK9LvMsIY3dR
         FZMWr/bR3gMjDPYcd81LZcAn564nMrqy0weDmdDubCLTtNUlGexyPJOtm9f4T8W8e4
         5WndBN28e4rUrE50rLegqVBMozlqF0mhFFgTX4/o63saEC5/FqRQfniDI3t/ODYW4Q
         IT9qxiOYp9Bcg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [v1,1/1] wifi: rtw88: use %*ph to print small buffer
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20220603125648.46873-1-andriy.shevchenko@linux.intel.com>
References: <20220603125648.46873-1-andriy.shevchenko@linux.intel.com>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <165467567290.10728.2279936435083170860.kvalo@kernel.org>
Date:   Wed,  8 Jun 2022 08:07:54 +0000 (UTC)
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> Use %*ph format to print small buffer as hex string.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

d38c9df53ad6 wifi: rtw88: use %*ph to print small buffer

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20220603125648.46873-1-andriy.shevchenko@linux.intel.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

