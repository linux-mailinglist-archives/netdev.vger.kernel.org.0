Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED41333DEDE
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 21:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbhCPUfL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 16:35:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231247AbhCPUex (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 16:34:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0BBBD64F80;
        Tue, 16 Mar 2021 20:34:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615926893;
        bh=okRMItYdKasGgTRYd7gy0EpX6yF0Jgr0clwpOBDEkcc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZqoeJGGV9lud2AQhRJAgyemOws0smvXmgWPVFr0SuSHJqUfxOldFhGU4fDP/sl8iE
         sRFD/5OxGLJYeBT31PhFYIlR22qDa2BdP2egRTflCnxcHO0liyz0D4VRod+Ymj6s+1
         GO/JgBrT2mh/qtUv7ekSL+6JM8Z+U789lqnDas+Jkzj7seNHedILQF7jYmBoI+/yXs
         cmaq7syNqOKinqqU8Tcqpt3bWN6+1GeUT4dBsQ20w03A+y2ohy7Em+SW6kH25YLE+4
         TZYSqoSu1xn0+d76s3pLiyxTcL//gzszrE2UlA7znsIdq5E0LODte7rg2JKEL1X0yJ
         tIf3oX2YqZd2Q==
Date:   Tue, 16 Mar 2021 13:34:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yejune Deng <yejune.deng@gmail.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ipv4: route.c: simplify procfs code
Message-ID: <20210316133452.2e64eeaa@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316025736.37254-1-yejune.deng@gmail.com>
References: <20210316025736.37254-1-yejune.deng@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 10:57:36 +0800 Yejune Deng wrote:
> proc_creat_seq() that directly take a struct seq_operations,
> and deal with network namespaces in ->open.
> 
> Signed-off-by: Yejune Deng <yejune.deng@gmail.com>

Looks equivalent to me:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
