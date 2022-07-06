Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80701567B7A
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 03:28:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbiGFB2C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jul 2022 21:28:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiGFB2B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jul 2022 21:28:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8BA41835B;
        Tue,  5 Jul 2022 18:28:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51B9E617CA;
        Wed,  6 Jul 2022 01:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CDA3C341C7;
        Wed,  6 Jul 2022 01:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657070878;
        bh=ATRCDBvOjpOFwrL7YvCe2tnd0LQ7mA/Pdq4cfITumbs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PVrlbGBnXuPb+zbUG7C7mHY9Eywwc7A1L1pR+S8Bn5u7i1aejUjf/FnLS5VmW0F3X
         wTtTKJpQtVj03WcYFxIWnErcJYw0dcWyfhExiGODMFBkC/ncXbS+ga8kUw9ziOsmDk
         wTi3xpytLTsYoiEscustcU94Rs4fruE3z7ofSD5PJKSwXKYS6jvnI22pK7+O3XpDUP
         UO2/yX9PD4o+kDr8sYYwXw4JALFMkzzN4KmYZJo1Fy2f0Z9EGzOx1ShC7aMxhyOKHw
         ZgsxvBLFf7OnNrxjFcYRwHn8BGEWZShWUL+MGTZQKZZ1dSmVbzX97Weosgt4KQyw0l
         yM5q3CQi7xKXQ==
Date:   Tue, 5 Jul 2022 18:27:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Divya Koppera <Divya.Koppera@microchip.com>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>, <linux@armlinux.org.uk>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <UNGLinuxDriver@microchip.com>, <Madhuri.Sripada@microchip.com>
Subject: Re: [PATCH net-next] net: phy: micrel: Fix latency issues in
 LAN8814 PHY
Message-ID: <20220705182757.2289c7bb@kernel.org>
In-Reply-To: <20220705110554.5574-1-Divya.Koppera@microchip.com>
References: <20220705110554.5574-1-Divya.Koppera@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Jul 2022 16:35:54 +0530 Divya Koppera wrote:
> +void lan8814_link_change_notify(struct phy_device *phydev)

static

Please make sure you build-test your changes with W=1.
