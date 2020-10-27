Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EBA429CD50
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 02:48:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgJ1Bi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 21:38:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:35080 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1833064AbgJ0X4Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:56:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C906207D8;
        Tue, 27 Oct 2020 23:56:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603842975;
        bh=DPgj3zYuKLPjEZ/p/duM7uAOzRSW2Xntsna187+y55k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JpIX27w7Q+vj3Oewxu6i08uysquDDK/6OpC7aFBEEKfzKxLCCakd0347BvTZe5oj4
         p2R2K6p1PjzvDqPxpOSfzIaXaiQM+OSGNi6Zi6UsvLbpVD0/qKxd9WHOURxyqACZLY
         ldBsxdmKEHsMjxcY4gwSLtMyIn/ppnLkyqAG6YoI=
Date:   Tue, 27 Oct 2020 16:56:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net] chelsio/chtls: fix memory leaks in CPL handlers
Message-ID: <20201027165614.564d0941@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201025194228.31271-1-vinay.yadav@chelsio.com>
References: <20201025194228.31271-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 01:12:29 +0530 Vinay Kumar Yadav wrote:
> CPL handler functions chtls_pass_open_rpl() and
> chtls_close_listsrv_rpl() should return CPL_RET_BUF_DONE
> so that caller function will do skb free to avoid leak.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied.
