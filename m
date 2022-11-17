Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0C9462DC2C
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 14:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239475AbiKQNBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 08:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234724AbiKQNA5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 08:00:57 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A655916D;
        Thu, 17 Nov 2022 05:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Znj/zN2SyjWqIbqwFb6gAvBXmx3ZvTt/Rr7JUuD+cp0=; b=ibMvFW/DbQabpQK9XmnHg3CC5V
        gR5XWZWWAhzpGHocBkJMdXNQYdp8rnkLtregkjQtKEicGCdplsqGxmJPcSNUzjpuHdxOF8Zxbq84m
        53B4wwdaDE0rFqnHzj7wEbZH5aJwSmdJ+BLNfMskz5JW9ylYkL+sR/gGjTeD6vKLgixI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1oveUE-002gbS-QO; Thu, 17 Nov 2022 13:59:22 +0100
Date:   Thu, 17 Nov 2022 13:59:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Hao Chen <chenhao288@hisilicon.com>,
        Guangbin Huang <huangguangbin2@huawei.com>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Marco Bonelli <marco@mebeim.net>, Tom Rix <trix@redhat.com>,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, yc-core@yandex-team.ru
Subject: Re: [PATCH v1] net/ethtool/ioctl: ensure that we have phy ops before
 using them
Message-ID: <Y3YwKrgrZ9Aci7m1@lunn.ch>
References: <20221114081532.3475625-1-d-tatianin@yandex-team.ru>
 <20221114210705.216996a9@kernel.org>
 <Y3Oy14CNVEttEI7T@lunn.ch>
 <Y3VqUBUXdMrt4iAC@x130.lan>
 <d220e5b6-70d8-e64f-0544-d3dfaf905a6d@yandex-team.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d220e5b6-70d8-e64f-0544-d3dfaf905a6d@yandex-team.ru>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Strange, pretty sure it CCed the netdev ML. Unless there's something else
> you must do for it to get through?

HTML might get it rejected. But so long as you used git send-email, it
normally works.

Anyway, please resend.

	Andrew
