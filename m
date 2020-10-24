Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF379297A31
	for <lists+netdev@lfdr.de>; Sat, 24 Oct 2020 03:36:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1758530AbgJXBgN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 21:36:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758525AbgJXBgM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 21:36:12 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EED542463D;
        Sat, 24 Oct 2020 01:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603503388;
        bh=uC8ZkbH+CZSWiPKx8EpT8w9Qgvr2TB32ku+16okCZHI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=xz3ODf/5AMlK+9vbyRwvH7v6wwqRsgtKLv1qGB3WF+bNHk5tJPVXoQzBB0dksk5/A
         ZlAgwLHlwxgVz+EdpKKJcKTF9cBf5Ubxmf8pqtsUyf84pQy+s6kXZ9GVCyKge/gmYP
         We/PSQ7x+Q/codLCjcL5KGOoMYfLQAuPgKY4iyGg=
Date:   Fri, 23 Oct 2020 18:36:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net,v2] chelsio/chtls: fix tls record info to user
Message-ID: <20201023183627.70f0e499@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201022190556.21308-1-vinay.yadav@chelsio.com>
References: <20201022190556.21308-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 00:35:57 +0530 Vinay Kumar Yadav wrote:
> chtls_pt_recvmsg() receives a skb with tls header and subsequent
> skb with data, need to finalize the data copy whenever next skb
> with tls header is available. but here current tls header is
> overwritten by next available tls header, ends up corrupting
> user buffer data. fixing it by finalizing current record whenever
> next skb contains tls header.
> 
> v1->v2:
> - Improved commit message.
> 
> Fixes: 17a7d24aa89d ("crypto: chtls - generic handling of data and hdr")
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied.
