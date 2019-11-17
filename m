Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7BE5FFB5B
	for <lists+netdev@lfdr.de>; Sun, 17 Nov 2019 19:29:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfKQS3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Nov 2019 13:29:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726047AbfKQS3u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Nov 2019 13:29:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1B03153E103E;
        Sun, 17 Nov 2019 10:29:49 -0800 (PST)
Date:   Sun, 17 Nov 2019 10:29:49 -0800 (PST)
Message-Id: <20191117.102949.1712366954266607838.davem@davemloft.net>
To:     tariqt@mellanox.com
Cc:     lrizzo@google.com, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/mlx4_en: fix mlx4 ethtool -N insertion
From:   David Miller <davem@davemloft.net>
In-Reply-To: <59ebfae8-ac93-75a1-7a60-2bb3820a9a79@mellanox.com>
References: <20191115201225.92888-1-lrizzo@google.com>
        <20191116.131058.1856199123293908506.davem@davemloft.net>
        <59ebfae8-ac93-75a1-7a60-2bb3820a9a79@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 17 Nov 2019 10:29:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@mellanox.com>
Date: Sun, 17 Nov 2019 14:46:50 +0000

> 
> 
> On 11/16/2019 11:10 PM, David Miller wrote:
>> From: Luigi Rizzo <lrizzo@google.com>
>> Date: Fri, 15 Nov 2019 12:12:25 -0800
>> 
>>> ethtool expects ETHTOOL_GRXCLSRLALL to set ethtool_rxnfc->data with the
>>> total number of entries in the rx classifier table.  Surprisingly, mlx4
>>> is missing this part (in principle ethtool could still move forward and
>>> try the insert).
>>>
>>> Tested: compiled and run command:
>>> 	phh13:~# ethtool -N eth1 flow-type udp4  queue 4
>>> 	Added rule with ID 255
>>>
>>> Signed-off-by: Luigi Rizzo <lrizzo@google.com>
>>> Change-Id: I18a72f08dfcfb6b9f6aa80fbc12d58553e1fda76
>> 
>> Luigi, _always_ CC: the appropriate maintainer when making changes to the
>> kernel, as per the top-level MAINTAINERS file.
>> 
>> Tariq et al., please review.
>> 
> 
> Reviewed-by: Tariq Toukan <tariqt@mellanox.com>

Applied and queued up for -stable, with Change-Id: removed.
