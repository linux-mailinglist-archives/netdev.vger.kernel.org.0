Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072951F00C7
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 22:11:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728126AbgFEULk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jun 2020 16:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgFEULj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Jun 2020 16:11:39 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBFE2C08C5C2;
        Fri,  5 Jun 2020 13:11:39 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12C7C127A7014;
        Fri,  5 Jun 2020 13:11:39 -0700 (PDT)
Date:   Fri, 05 Jun 2020 13:11:38 -0700 (PDT)
Message-Id: <20200605.131138.784441206945490177.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     kuba@kernel.org, mkubecek@suse.cz, f.fainelli@gmail.com,
        andrew@lunn.ch, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] ethtool: linkinfo: remove an unnecessary NULL check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200605110413.GF978434@mwanda>
References: <20200605110413.GF978434@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Jun 2020 13:11:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 5 Jun 2020 14:04:13 +0300

> This code generates a Smatch warning:
> 
>     net/ethtool/linkinfo.c:143 ethnl_set_linkinfo()
>     warn: variable dereferenced before check 'info' (see line 119)
> 
> Fortunately, the "info" pointer is never NULL so the check can be
> removed.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
