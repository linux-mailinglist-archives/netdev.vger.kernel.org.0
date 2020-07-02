Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA0E9212E7F
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 23:06:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726029AbgGBVGu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 17:06:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:59194 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725994AbgGBVGu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 17:06:50 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E0C7220772;
        Thu,  2 Jul 2020 21:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593724010;
        bh=DQ/GA5dnHwLmegYjVYBQuEyh7vCnD0yqpiBAjKlr15g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iFeJVIMEqtpu9IeAeo1cCJCNTxBtNL+LEqzglgvMdKQU/waO9J+hYvxWLK2ZqReVH
         sdXZHTzytkPTT2VpgwKxLzpERwRR1QfHnUwNHkORC47aSIBuP36sGksvVE7wcfTKF5
         /xBf7gHfhcbuFQUApCWd8iXHUkkJEyAfoKxiJeZ8=
Date:   Thu, 2 Jul 2020 14:06:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 00/16] sfc: prerequisites for EF100 driver,
 part 3
Message-ID: <20200702140648.10105fd4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
References: <52336e78-8f45-7401-9827-6c1fea38656d@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Jul 2020 17:25:17 +0100 Edward Cree wrote:
> Changes in v2:
> * Patch #1: use efx_mcdi_set_mtu() directly, instead of as a fallback,
>   in the mtu_only case (Jakub)
> * Patch #3: fix symbol collision in non-modular builds by renaming
>   interrupt_mode to efx_interrupt_mode (kernel test robot)
> * Patch #6: check for failure of netif_set_real_num_[tr]x_queues (Jakub)
> * Patch #12: cleaner solution for ethtool drvinfo (Jakub, David)

Thanks, the last two patches with functions with no callers slightly
worrying, but okay:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
