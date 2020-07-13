Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756FB21E334
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726755AbgGMWv7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:51:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726347AbgGMWv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Jul 2020 18:51:58 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35EF120C56;
        Mon, 13 Jul 2020 22:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594680718;
        bh=KGV5rqSEoEwiaauckqdN7x0b0DvJBudnyqrURMHSkOw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OrOPt01GiPaCZ5lQbglRQcVPs0CTS+pt95033WKNnmRWxoNxFosp1fpT7t1vD4BdQ
         Dz0z2NU7ZV5fxmbcMnOf/cetZfcIl6SUwlJ4QPW5S4LdrFQEgk1aSRm38kWROp9CyH
         lxp8CtV0L+QrCqbIOKj0pCxAj3Lzy6LQK9i5hMH4=
Date:   Mon, 13 Jul 2020 15:51:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, secdev@chelsio.com
Subject: Re: [PATCH net-next 0/3] chtls: fix inline tls bugs
Message-ID: <20200713155156.306f7618@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200713183554.11719-1-vinay.yadav@chelsio.com>
References: <20200713183554.11719-1-vinay.yadav@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jul 2020 00:05:51 +0530 Vinay Kumar Yadav wrote:
> This series of patches fix following issues.
> patch1: correct net_device reference count
> patch2: fix tls alert messages corruption

IMO fixes to the tls are fine, they should have a Fixes tag and go to
net, not net-next.

> patch3: Enable tcp window scaling option

But extending your TOE I don't like.
