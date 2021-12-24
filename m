Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD83147F167
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 00:02:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231340AbhLXXCr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 18:02:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhLXXCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 18:02:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC53C061401;
        Fri, 24 Dec 2021 15:02:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB91E62100;
        Fri, 24 Dec 2021 23:02:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EACB8C36AE8;
        Fri, 24 Dec 2021 23:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640386966;
        bh=DKPso7JDkPBu19dQQYe6eovRa4v1MAvKwa1FFEw7fi0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IV/XT0T4skHp5zp7c9GKppybIj+ROW4dqs0eLkJrMeEU+Af6RTWSJHTYwl0jFXsXn
         D/rnDrj4b9Qv8oo8x7fXhqACKWl0SGTRM7PSa3vpusV862akXoVoBUqONh6H4wuGwq
         5o3uipDhh3ZVCxZ9NgZRHfFiMe42tX8I+e8+pIRpmKStvRONj437NAJc/EPJegfPWs
         /kbw/ZLdU8qlatGliFKCzlDhHLyL8SkpHq3FY1ULNirM8Kz1gbrkeDS7c9MpOLd2Uw
         g3QaKgi5XyoNEBjehlAU6Mhe6cZlXF/xLOhrrxrypjeDrz5eJWd2IytO/DBAXUJ652
         dtL2kOugCoi+Q==
Date:   Fri, 24 Dec 2021 15:02:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, thunder.leizhen@huawei.com,
        yangyingliang@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fjes: Fix wrong check for irq
Message-ID: <20211224150245.7df31c0a@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224035539.1564861-1-jiasheng@iscas.ac.cn>
References: <20211224035539.1564861-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 11:55:39 +0800 Jiasheng Jiang wrote:
> Because hw->hw_res.irq is unsigned

It is not.
