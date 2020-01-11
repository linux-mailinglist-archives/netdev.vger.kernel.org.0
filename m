Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE1F1137AC3
	for <lists+netdev@lfdr.de>; Sat, 11 Jan 2020 01:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727768AbgAKAtS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 19:49:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42688 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727732AbgAKAtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 19:49:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E368A15858B95;
        Fri, 10 Jan 2020 16:49:16 -0800 (PST)
Date:   Fri, 10 Jan 2020 16:49:16 -0800 (PST)
Message-Id: <20200110.164916.1492091203901906907.davem@davemloft.net>
To:     jacob.e.keller@intel.com
Cc:     netdev@vger.kernel.org, valex@mellanox.com, jiri@resnulli.us
Subject: Re: [PATCH 1/2] devlink: correct misspelling of snapshot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109190821.1335579-1-jacob.e.keller@intel.com>
References: <20200109190821.1335579-1-jacob.e.keller@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 16:49:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>
Date: Thu,  9 Jan 2020 11:08:20 -0800

> The function to obtain a unique snapshot id was mistakenly typo'd as
> devlink_region_shapshot_id_get. Fix this typo by renaming the function
> and all of its users.
> 
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Applied.
