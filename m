Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74C2A6A152C
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 04:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjBXDF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Feb 2023 22:05:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjBXDF5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Feb 2023 22:05:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59814158BA;
        Thu, 23 Feb 2023 19:05:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F29D861812;
        Fri, 24 Feb 2023 03:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBAA2C433D2;
        Fri, 24 Feb 2023 03:05:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677207956;
        bh=pR+6ILJdWDTbqbbESyt6naGr/QUbCKrxY2mZ3m4SG6Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=c3a7cPoI+SzoOX9kDImrdrnpjyIMOW1JF5sTohoXj0BrGOCxzuu3txo5ponmfE47n
         hWX+n1WgMg0i1JGbpNJiYV9EvtOiU/EDm4Rt3yFijymEhLKFwM89ApcY0ceJraJHnc
         wXKzaHK8yj7rLY92EhMBJ94V7rve+u0sF1wBMg6MSafwlwcBsmgz4rE7lLK0zU6f9d
         fQR4UdKSn8kw3a2o7HyjXXUV6xcY2eiZ5oY2pElNXT92UhX21NkX/xL6FiKCwAz8lV
         HrnN2Z7CXdZb5F8nY+LPrP42PuqVTwfUUgghCtK9H38bg0M23sf06dAxMo47aUci9v
         gHcn8A+0Ptjhg==
Date:   Thu, 23 Feb 2023 19:05:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Li Yang <leoyang.li@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Luo Jie <luoj@codeaurora.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] net: phy: at803x: remove set/get wol callbacks
 for AR8032
Message-ID: <20230223190555.61aa0d5c@kernel.org>
In-Reply-To: <20230221231411.7786-2-leoyang.li@nxp.com>
References: <20230221231411.7786-1-leoyang.li@nxp.com>
        <20230221231411.7786-2-leoyang.li@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 21 Feb 2023 17:14:11 -0600 Li Yang wrote:
> Since the AR8032 part does not support wol, remove related callbacks
> from it.
> 
> Fixes: 5800091a2061 ("net: phy: at803x: add support for AR8032 PHY")

Is there a reason you didn't CC David Bauer <mail@david-bauer.net>,
the author of the change under Fixes? If no please repost and add him.
