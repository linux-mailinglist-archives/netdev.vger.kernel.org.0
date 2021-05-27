Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE933938E0
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 01:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236424AbhE0XCf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 May 2021 19:02:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233203AbhE0XCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 May 2021 19:02:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 855C36139A;
        Thu, 27 May 2021 23:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622156460;
        bh=4OLpMF0M592A6ak/M6gWl9OdBVY54xQnLAXmGcPk2QY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWjF6duyj7OQg7THlRc+ewlf9VrUGQjg7sTCR4yU7xtKr8gCxmdzWrx2IHNv4qWBq
         gJ+T8VYN8XjPGx2VswLPyx+Ire3nyoeBiWeJD8Pre80ggGXe2aei0sXeYPWdKf+NVw
         4+q4bofUr4WGSUDnWXzg4zWhrnzlKu6i61bV5WAc+kVWufGO1juCbJ4tD7dfFw5ceV
         TB61MrPKaOxQxfemy6vyBNQZZo+Dj8N9CIGu2I+/B8WbpURlq7RgY/GRNd6bkhWmq8
         XNaTTWDjgqSi99tQLk7NHI0omZzLBpZkYMoci9vLFiBwDCDMwyoB2XM91u+V943s+N
         5LbnACsF0FEeA==
Date:   Thu, 27 May 2021 16:00:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/5] Netfilter/IPVS fixes for net
Message-ID: <20210527160059.6d86c6a0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210527190115.98503-1-pablo@netfilter.org>
References: <20210527190115.98503-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 May 2021 21:01:10 +0200 Pablo Neira Ayuso wrote:
> The following patchset contains Netfilter/IPVS fixes for net:
> 
> 1) Fix incorrect sockopts unregistration from error path,
>    from Florian Westphal.
> 
> 2) A few patches to provide better error reporting when missing kernel
>    netfilter options are missing in .config.
> 
> 3) Fix dormant table flag updates.
> 
> 4) Memleak in IPVS  when adding service with IP_VS_SVC_F_HASHED flag.

Pulled, thanks. Please double check fixes tags in the future, the hash
on patch 1 is too short.
