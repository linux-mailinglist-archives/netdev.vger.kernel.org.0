Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83509267659
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 01:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgIKXHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 19:07:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:38778 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgIKXH2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Sep 2020 19:07:28 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4D8FB221F0;
        Fri, 11 Sep 2020 23:07:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599865648;
        bh=Gz1TMU4yhLhZhyd/qyDuwtloxtiKTwdnXWWfMbXb+3k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zxPacsohBf33/rePOQjJ5FyxYCW7ykG/9DPuLJcTHtSSuKYezwLCdtU6PKshah67d
         +2RqHRd19fvX1hczZQaSzoTJFujEgfsBY1VP8jA/ppSgTJPY/AeXLvGCsK3tBgzluI
         lv69STywSinGpAYaqoLA0B5Z+tepTgecSKSZf+Uw=
Date:   Fri, 11 Sep 2020 16:07:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH v2 net-next 0/7] sfc: encap offloads on EF10
Message-ID: <20200911160726.42c974c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
References: <27a1329b-fe09-d8e0-1d43-2e53e2793748@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 11 Sep 2020 23:37:10 +0100 Edward Cree wrote:
> EF10 NICs from the 8000 series onwards support TX offloads (checksumming,
>  TSO) on VXLAN- and NVGRE-encapsulated packets.  This series adds driver
>  support for these offloads.
> 
> Changes from v1:
>  * Fix 'no TXQ of type' error handling in patch #1 (and clear up the
>    misleading comment that inspired the wrong version)
>  * Add comment in patch #5 explaining what the deal with TSOv3 is

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
