Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C8DC218CFD
	for <lists+netdev@lfdr.de>; Wed,  8 Jul 2020 18:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730630AbgGHQaq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jul 2020 12:30:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730093AbgGHQaq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 8 Jul 2020 12:30:46 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D82A6206C3;
        Wed,  8 Jul 2020 16:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594225846;
        bh=T5mLvuAr8vEI8gBZXo5pfinar2VRPd49tJLZBzk+4pM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jLsej5yfqcuzpva/josOmPWrUtmxvpuaIHwH2aTKN0zqsyeiuEdVvNbL1Z0/yIlfd
         OwtaFHx9SAWm6qGd4tV5DlLiPt50DjC6a8nN5dL3fsLjHgoAo7z71OHQnakppqUQkv
         t3qxxWgBKd1tTgwBgQDOQoiI7lBjuLdXLwSdYZzc=
Date:   Wed, 8 Jul 2020 09:30:44 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christoph Paasch <cpaasch@apple.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH net] tcp: Initialize ca_priv when inheriting from
 listener
Message-ID: <20200708093044.123d858d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200708041030.24375-1-cpaasch@apple.com>
References: <20200708041030.24375-1-cpaasch@apple.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 07 Jul 2020 21:10:30 -0700 Christoph Paasch wrote:
> Wei Wang fixed a part of these CDG-malloc issues with commit c12014440750
> ("tcp: memset ca_priv data to 0 properly").
> 
> This patch here fixes the listener-scenario by memsetting ca_priv to 0
> after its content has been inherited by the listener.
> 
> (The issue can be reproduced at least down to v4.4.x.)
> 
> Cc: Wei Wang <weiwan@google.com>
> Cc: Eric Dumazet <edumazet@google.com>
> Fixes: 2b0a8c9ee ("tcp: add CDG congestion control")
> Signed-off-by: Christoph Paasch <cpaasch@apple.com>

Also:

Fixes tag: Fixes: 2b0a8c9ee ("tcp: add CDG congestion control")
Has these problem(s):
	- SHA1 should be at least 12 digits long
	  Can be fixed by setting core.abbrev to 12 (or more) or (for git v2.11
	  or later) just making sure it is not set (or set to "auto").
