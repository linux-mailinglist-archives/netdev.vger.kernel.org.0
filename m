Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40B12BC27B
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 23:43:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728632AbgKUWl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 17:41:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgKUWlz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 21 Nov 2020 17:41:55 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 101BA2151B;
        Sat, 21 Nov 2020 22:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605998515;
        bh=qomVMm2MeRDCKHvedwhIgYBadhiY7UIQ36rqjlMxvkM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BDnmp4j34qJ0g/oajusdvGqiqXHQUgSg7prTt+uOVdh9jJszcS8aZ4ZDFV0ASgDSU
         +1Vee89nbbvUS8i2Oo63pjPA6spHEta2mVl3ChF5Tn0JCQWEAL4dZCWbL85ot4f+QA
         ykFT6zvQsMGa4ixgfE3AbYRa3Bka/WlyHn3AN9rU=
Date:   Sat, 21 Nov 2020 14:41:54 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Roopa Prabhu <roopa@nvidia.com>,
        Nikolay Aleksandrov <nikolay@nvidia.com>,
        David Miller <davem@davemloft.net>,
        bridge@lists.linux-foundation.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] net: bridge: switch to net core statistics
 counters handling
Message-ID: <20201121144154.03696203@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9bad2be2-fd84-7c6e-912f-cee433787018@gmail.com>
References: <9bad2be2-fd84-7c6e-912f-cee433787018@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 12:22:23 +0100 Heiner Kallweit wrote:
> Use netdev->tstats instead of a member of net_bridge for storing
> a pointer to the per-cpu counters. This allows us to use core
> functionality for statistics handling.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
