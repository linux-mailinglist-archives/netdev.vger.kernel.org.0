Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E46F62A0F44
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 21:13:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbgJ3UNZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:13:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:45180 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726061AbgJ3UMl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:12:41 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD86520706;
        Fri, 30 Oct 2020 20:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604088761;
        bh=4MSq+kA3xHz1+rNfANi6IYmdRtmgvieCSPxsSr4PZMQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VqwABozgGEgbqB/ozHqLIdgtViI9WzySgvYVtAnibjsEdgHIcMfiw9Fp4VAy3ZEJC
         BUm+kIUO4zJg+RzHQ9FGPRPpQKTjpVaLpPFfj9ecLEhXDiHOKkELA9b4ZoEIL1Eot6
         x7pPB77utzGQnqSsC4Awedce2ygehX+hAQgKyBuI=
Date:   Fri, 30 Oct 2020 13:12:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>
Cc:     netdev@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>
Subject: Re: [net-next] tipc: remove dead code in tipc_net and relatives
Message-ID: <20201030131239.676e6e54@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028032712.31009-1-hoang.h.le@dektech.com.au>
References: <20201028032712.31009-1-hoang.h.le@dektech.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 10:27:12 +0700 Hoang Huu Le wrote:
> dist_queue is no longer used since commit 37922ea4a310
> ("tipc: permit overlapping service ranges in name table")
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>

Applied, thanks!
