Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E29422B42B
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 19:08:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgGWRIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 13:08:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726650AbgGWRIp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 13:08:45 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E8C7720792;
        Thu, 23 Jul 2020 17:08:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595524125;
        bh=vW/iu7THEy25PLl1MXXPVouITYL6IELwVCJZNIH1sv4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pWXkoTTrecuOSM3HzJdcVqmF2N8TbfIDMDA/7PL3mjZYPoN9D57pW56BqIEk1V7/7
         3opLLbDEW0prhywwK6B9YSvnSdpK7sfjsCGLAHE5R/p5lrAUpFKzfZFX/8Ts2AUioJ
         0hD1FiziE9GR4brwTu8jQt/XY+BieJfz4KbKS/7Q=
Date:   Thu, 23 Jul 2020 10:08:43 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chi Song <chisong@microsoft.com>
Cc:     "K. Y. Srinivasan" <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Wei Liu <wei.liu@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 net-next] net: hyperv: dump TX indirection table to
 ethtool regs
Message-ID: <20200723100843.5c7dc128@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
References: <alpine.LRH.2.23.451.2007222356070.2641@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.inter>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 23:59:09 -0700 (PDT) Chi Song wrote:
> An imbalanced TX indirection table causes netvsc to have low
> performance. This table is created and managed during runtime. To help
> better diagnose performance issues caused by imbalanced tables, it needs
> make TX indirection tables visible.
> 
> Because TX indirection table is driver specified information, so
> display it via ethtool register dump.
> 
> Signed-off-by: Chi Song <chisong@microsoft.com>

The patch looks good to me, but it has been corrupted by your email
client, could you perhaps try git send-email?

> +	memcpy(regs_buff, ndc->tx_table, VRSS_SEND_TAB_SIZE *
> sizeof(u32));
