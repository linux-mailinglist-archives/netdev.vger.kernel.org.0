Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 804E21A3BDE
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 23:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727611AbgDIVW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 17:22:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:34554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726964AbgDIVW5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Apr 2020 17:22:57 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFAF42074F;
        Thu,  9 Apr 2020 21:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586467378;
        bh=Rox0VFzLFrt1E0/yeU18ErAK0JFSnXwf+cLAXADgnQs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ErRhjXvp2vDs8kk8CTQAEFaG0ZFuuBVcLhq3AQ6Nzv7qRAKZZi/7rv72x/ldtQt8D
         ftDQkF79cLTwTDn5e3KkynbillA3WexE76ie5tbb4CbxpvyT1bZd/+xLE7wcxIdHrS
         RMidwuXnMIMlV9LXTvAgibP7/v03w0k9JQu8cy8U=
Date:   Thu, 9 Apr 2020 14:22:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kernel-team@fb.com,
        talgi@mellanox.com, leon@kernel.org, jacob.e.keller@intel.com
Subject: Re: [PATCH net] docs: networking: add full DIM API
Message-ID: <20200409142256.1d52da32@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ee8a06a5-06fd-4d97-193c-51cc3ad41e7e@infradead.org>
References: <20200409175704.305241-1-kuba@kernel.org>
        <fcda6033-a719-adfb-c25d-d562072b5e82@infradead.org>
        <e27192c8-a251-4d72-1102-85d250d50f49@infradead.org>
        <20200409124221.128d6327@kicinski-fedora-PC1C0HJN>
        <0a2f9a52-6abb-b9ca-45c1-cc74f6d276d7@infradead.org>
        <20200409131818.7f4fa0bf@kicinski-fedora-PC1C0HJN>
        <ee8a06a5-06fd-4d97-193c-51cc3ad41e7e@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Apr 2020 13:25:51 -0700 Randy Dunlap wrote:
> > If you have the doc rendered check out what
> > networking/net_dim.html#c.dim takes us to right now.  
> 
> OK, I see that.
> 
> I don't object to those markings, but I would want to see the kernel-doc
> structs etc.

Okay, I sent a v2 of my patch and included yours in the series just for
ease of applying.
