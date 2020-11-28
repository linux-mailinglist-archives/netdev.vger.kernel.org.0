Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC8B72C6E6B
	for <lists+netdev@lfdr.de>; Sat, 28 Nov 2020 03:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731749AbgK1CST (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Nov 2020 21:18:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:36682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbgK1CAd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Nov 2020 21:00:33 -0500
Received: from kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D6BD20679;
        Sat, 28 Nov 2020 02:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606528833;
        bh=6x8qjXtPlKfV3YWl5DLKv16p7Yd+gitssUjQBzFNegs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Dn1KImjiUeTFpDYCYJvcDbdCpqXNhi5bJEaLH13flJcBFQOOvZkV0tVFsHGOwnJcB
         6THFRRhh1Zvgsymroe5aID5ttYeZ+x2gNmZ+YQpPSgPpGlq6vQN5cJOoGnV8RwFblR
         GMtTwNPuv9ce0JzJ4zP2vFovg4hY64V2gtsfVd2g=
Date:   Fri, 27 Nov 2020 18:00:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     netdev@vger.kernel.org, wenxu@ucloud.cn, paulb@nvidia.com,
        ozsh@nvidia.com, ahleihel@nvidia.com,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net-next] net/sched: act_ct: enable stats for HW
 offloaded entries
Message-ID: <20201127180032.52b320a5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
References: <481a65741261fd81b0a0813e698af163477467ec.1606415787.git.marcelo.leitner@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Nov 2020 15:40:49 -0300 Marcelo Ricardo Leitner wrote:
> By setting NF_FLOWTABLE_COUNTER. Otherwise, the updates added by
> commit ef803b3cf96a ("netfilter: flowtable: add counter support in HW
> offload") are not effective when using act_ct.
> 
> While at it, now that we have the flag set, protect the call to
> nf_ct_acct_update() by commit beb97d3a3192 ("net/sched: act_ct: update
> nf_conn_acct for act_ct SW offload in flowtable") with the check on
> NF_FLOWTABLE_COUNTER, as also done on other places.
> 
> Note that this shouldn't impact performance as these stats are only
> enabled when net.netfilter.nf_conntrack_acct is enabled.
> 
> Signed-off-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>

Why no Fixes tag and not targeting net here?
