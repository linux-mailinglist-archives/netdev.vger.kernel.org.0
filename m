Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5B36F05BE
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 14:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243938AbjD0M1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 08:27:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243429AbjD0M1a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 08:27:30 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F2035B93;
        Thu, 27 Apr 2023 05:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=j8pd3+4XWrJ0SsoTVsir25DVL+uxcXLJo87srUeRyUQ=; b=mCqK8M4FfKmKvzWqejsRSaDa33
        wpr/HX9dCnZG8IW6w2nP4KfKPhNN+MNy3sGvHdIbCYp/sY4QsMoWDx0UZfBgnWlOiJFkBBMvDBeJl
        Q9AzyQA7H9YBxbmrqlFfOA1YDdjRRkCMd/nHw/XC+Y9Bz4TklaKV2iWH2MT2kmWi3X0Q=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ps0iT-00BLpJ-SG; Thu, 27 Apr 2023 14:27:17 +0200
Date:   Thu, 27 Apr 2023 14:27:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hayes Wang <hayeswang@realtek.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] r8152: fix 2.5G devices
Message-ID: <a1e306c1-ec0c-40a5-86b2-f31b74dd36ba@lunn.ch>
References: <20230426122805.23301-400-nic_swsd@realtek.com>
 <20230427121057.29155-405-nic_swsd@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427121057.29155-405-nic_swsd@realtek.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 27, 2023 at 08:10:54PM +0800, Hayes Wang wrote:
> v2:
> For patch #1, Remove inline for fc_pause_on_auto() and fc_pause_off_auto(),
> and update the commit message.
> 
> For patch #2, define the magic value for OCP register 0xa424.
> 
> v1:
> These patches are used to fix some issues of RTL8156.

Please always create a new thread. The patch automation bots can get
confused if you append to an existing thread, they assume it is just
comments to the original patchset.

	 Andrew
