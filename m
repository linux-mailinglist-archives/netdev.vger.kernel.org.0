Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 002462B2AD0
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:23:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726174AbgKNCW6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:22:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:59644 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725981AbgKNCW6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 21:22:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E85D02225D;
        Sat, 14 Nov 2020 02:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605320578;
        bh=k61aVNK15oeAweVgGw21L1znnMpAT+RwJkTmnTyo+oY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LNH1vNYNZrKb2E+qhG4azVpc6qjfGINZKAo0znoxEuEawT8/VI5//AcjvemVZ8Ff5
         KyPzq4HlXM/B6lulrEOZQTrGj+aOgbFYVS+Ry/391cYGV1XsspBQBFAYpr9vxjpZVC
         mHDA96DH4zLNHwyt2bMoF6/7Uv4dd3YNMwP8ExBE=
Date:   Fri, 13 Nov 2020 18:22:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Zhang Qilong <zhangqilong3@huawei.com>
Cc:     <davem@davemloft.net>, <kuznet@ms2.inr.ac.ru>,
        <yoshfuji@linux-ipv6.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] ipv6: Fix error path to cancel the meseage
Message-ID: <20201113182257.4b6dabfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112080950.1476302-1-zhangqilong3@huawei.com>
References: <20201112080950.1476302-1-zhangqilong3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:09:50 +0800 Zhang Qilong wrote:
> genlmsg_cancel() needs to be called in the error path of
> inet6_fill_ifmcaddr and inet6_fill_ifacaddr to cancel
> the message.
> 
> Fixes: 203651b665f72 ("ipv6: add inet6_fill_args")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>

This is the correct fixes tag:

Fixes: 6ecf4c37eb3e ("ipv6: enable IFA_TARGET_NETNSID for RTM_GETADDR") 

Applied.
