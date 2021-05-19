Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 788663884D1
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 04:37:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235467AbhESCiW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 May 2021 22:38:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:49456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231964AbhESCiW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 May 2021 22:38:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 08BEC61364;
        Wed, 19 May 2021 02:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621391823;
        bh=EviYGZiiNV8nh1TntdawEEtwlB9Rx9HaS6XEd76rHMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kuDbAePyOnYgRUX4rsz2z50j9SshKqDM6yaQa2uiwGXW2Qb6UynYEscPxyDJ8EygE
         CNM8+YyNIgKZ7gwVr7RyqhlwASnmpncyomSUjJRgRyv2EpY1Mwu7U07f6gihJtEaUa
         PYVproFMOrM4sPpGtWvbMMIe5f9p0/ICf+gAP6WUZQl602OvQKkRMfXxpUKZIFQCjv
         IzR5cpyL15TP+OI1lFpAX2ddoD+LPMegy9Km6DrknKuelUc/AtwsyIFi3XULzdvfVC
         kIvzVDhEy5k1hLv8MiCSRzF6/Q1IeLYRvW7QpsvnHIewXLGNGh48sK1vmtzmdpYAp5
         VYVKzrFUGmStQ==
Date:   Tue, 18 May 2021 19:37:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] ethtool: stats: Fix a copy-paste error
Message-ID: <20210518193701.6255212b@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20210519021038.25928-1-yuehaibing@huawei.com>
References: <20210519021038.25928-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 May 2021 10:10:38 +0800 YueHaibing wrote:
> data->ctrl_stats should be memset with correct size.
> 
> Fixes: bfad2b979ddc ("ethtool: add interface to read standard MAC Ctrl stats")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
