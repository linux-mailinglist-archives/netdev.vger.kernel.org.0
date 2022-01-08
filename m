Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10817488118
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:27:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbiAHD11 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:27:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbiAHD11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:27:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0A36C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:27:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D0EF6205C
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 001A1C36AE0;
        Sat,  8 Jan 2022 03:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641612445;
        bh=UhAu1Vizok90wo6pIFRYr0LQwz9i7l52nSF6d+qdWRM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m/hIOS/O3T1Ms+hAzQMVTKJR81qpKnuhTdM/NJMrOK4mnWvBByYxj15A+vuf8KiJP
         SEoYAiQS8NEvQ3fAD10I+eofmGCezia5+hk66Jd8S1eNiC1E9NvHnOoFjmcxadkunf
         Ct5mz4yVhr4P5E+NK2YpeqskrLpQqCNdLx9ysqA+3XPIY1M5e0AVsSr7MmSHQAzosv
         +BM5rZmUh6mwal6hHc/px6AMg8qSWA1u1lKH4mTdBJUXbVJYK8d4Iowtf7VTyultF8
         Xc52yOHo2mDxU38QLxBNxpyRGjRU4HLC9MCtPa9KKVEOc+7VzfUVorCkVtWWL32nq4
         /c+ibt+3sSU8g==
Date:   Fri, 7 Jan 2022 19:27:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Arthur Kiyanovski <akiyano@amazon.com>
Cc:     David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        "Woodhouse, David" <dwmw@amazon.com>,
        "Machulsky, Zorik" <zorik@amazon.com>,
        "Matushevsky, Alexander" <matua@amazon.com>,
        Saeed Bshara <saeedb@amazon.com>,
        "Wilson, Matt" <msw@amazon.com>,
        "Liguori, Anthony" <aliguori@amazon.com>,
        "Bshara, Nafea" <nafea@amazon.com>,
        "Belgazal, Netanel" <netanel@amazon.com>,
        "Saidi, Ali" <alisaidi@amazon.com>,
        "Herrenschmidt, Benjamin" <benh@amazon.com>,
        "Dagan, Noam" <ndagan@amazon.com>,
        "Agroskin, Shay" <shayagr@amazon.com>,
        "Arinzon, David" <darinzon@amazon.com>,
        Nati Koler <nkoler@amazon.com>
Subject: Re: [PATCH V2 net-next 09/10] net: ena: Change the name of bad_csum
 variable
Message-ID: <20220107192723.66201906@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220107202346.3522-10-akiyano@amazon.com>
References: <20220107202346.3522-1-akiyano@amazon.com>
        <20220107202346.3522-10-akiyano@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 7 Jan 2022 20:23:45 +0000 Arthur Kiyanovski wrote:
> -	ENA_STAT_RX_ENTRY(bad_csum),
> +	ENA_STAT_RX_ENTRY(csum_bad),

If any of your users complains that this broke their scripts you'll
need to revert.
