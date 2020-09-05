Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 067FC25EB9A
	for <lists+netdev@lfdr.de>; Sun,  6 Sep 2020 00:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgIEWxB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Sep 2020 18:53:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:55154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728491AbgIEWxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Sep 2020 18:53:00 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3FFF20760;
        Sat,  5 Sep 2020 22:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599346380;
        bh=eGbIb1mWoL2+kkOgl/ysxvJuQARHeOfN34x1mzzvKOY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WXtqVChv9kr1U8LdqOxUarwFbD0sIl16pR1goWX+2Pslzqa436M9H/g8inFFcabCR
         Zke8ecsBISHL5mXIdiC9StLt18J98RbIM7IUFh3ofbBjZ6U62US4qYfYR+TDrrxPli
         wGmrA2GDy7usaNBikZXaoAzfupyui3Ey15w/jmBc=
Date:   Sat, 5 Sep 2020 15:52:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ganji Aravind <ganji.aravind@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, vishal@chelsio.com,
        rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net] cxgb4: Fix offset when clearing filter byte
 counters
Message-ID: <20200905155258.1abc967c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200904102818.2001982-1-ganji.aravind@chelsio.com>
References: <20200904102818.2001982-1-ganji.aravind@chelsio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Sep 2020 15:58:18 +0530 Ganji Aravind wrote:
> Pass the correct offset to clear the stale filter hit
> bytes counter. Otherwise, the counter starts incrementing
> from the stale information, instead of 0.
> 
> Fixes: 12b276fbf6e0 ("cxgb4: add support to create hash filters")
> Signed-off-by: Ganji Aravind <ganji.aravind@chelsio.com>

Applied, thank you.
