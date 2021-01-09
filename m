Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C123D2F03F1
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 22:56:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726253AbhAIV43 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 16:56:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:39452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726005AbhAIV43 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 16:56:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 917B123AC1;
        Sat,  9 Jan 2021 21:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610229348;
        bh=eSEVYKlJZDRbP94LcaI0ZvzUvpdyptXN2y65vMluhZ4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bnQ7NXe7kW3/nj3WGHGurkiEx1cGPKqlTUGIiPC8xNqY7T+UDyHChJvinc26NOAJc
         TgjqavvIVc6pEo7dlTbvmeN27xgoBkPdEJUSEJJ3hR5wYhupx32H5AJgW/5U+y14/g
         Sodyk6dFLk0PrtVp+cSOIHcwLKqiV/HebNGPPIk+3TTbiKa2bd/xCPBrlUjkQ9obNs
         g4mX+8pvmgWwzaDMgc0K1wkC3+MHribIRDt69zJnEuRb42bVObK3zffE2vUqXvjpTJ
         4pPxxPd3/f3xRI57kY9Nwcc4nhEqnkUS15/fY1imL8VW/h2KCXLeEhob+NZxDfevOp
         rU2QK/qPdlfOg==
Date:   Sat, 9 Jan 2021 13:55:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>, menglong8.dong@gmail.com
Cc:     roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH net-next] net/bridge: fix misspellings using codespell
 tool
Message-ID: <20210109135547.24ab25ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <295b1d84-a49c-cdaa-e7fa-bbe492aa1496@infradead.org>
References: <20210108025332.52480-1-dong.menglong@zte.com.cn>
        <295b1d84-a49c-cdaa-e7fa-bbe492aa1496@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 20:03:49 -0800 Randy Dunlap wrote:
> On 1/7/21 6:53 PM, menglong8.dong@gmail.com wrote:
> > From: Menglong Dong <dong.menglong@zte.com.cn>
> > 
> > Some typos are found out by codespell tool:
> > 
> > $ codespell ./net/bridge/
> > ./net/bridge/br_stp.c:604: permanant  ==> permanent
> > ./net/bridge/br_stp.c:605: persistance  ==> persistence
> > ./net/bridge/br.c:125: underlaying  ==> underlying
> > ./net/bridge/br_input.c:43: modue  ==> mode
> > ./net/bridge/br_mrp.c:828: Determin  ==> Determine
> > ./net/bridge/br_mrp.c:848: Determin  ==> Determine
> > ./net/bridge/br_mrp.c:897: Determin  ==> Determine
> > 
> > Fix typos found by codespell.
> > 
> > Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>  
> 
> LGTM. Thanks.
> 
> Acked-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks!
