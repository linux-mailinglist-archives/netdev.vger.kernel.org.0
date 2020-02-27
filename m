Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1BB17285E
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 20:12:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729563AbgB0TMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Feb 2020 14:12:22 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43854 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729120AbgB0TMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Feb 2020 14:12:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 819E9120F5DEE;
        Thu, 27 Feb 2020 11:12:21 -0800 (PST)
Date:   Thu, 27 Feb 2020 11:12:21 -0800 (PST)
Message-Id: <20200227.111221.1320473655273081869.davem@davemloft.net>
To:     tklauser@distanz.ch
Cc:     kuba@kernel.org, netdev@vger.kernel.org, ktkhai@virtuozzo.com,
        arnd@arndb.de
Subject: Re: [PATCH] unix: define and set show_fdinfo only if procfs is
 enabled
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200226172953.16471-1-tklauser@distanz.ch>
References: <20200226172953.16471-1-tklauser@distanz.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Feb 2020 11:12:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tobias Klauser <tklauser@distanz.ch>
Date: Wed, 26 Feb 2020 18:29:53 +0100

> Follow the pattern used with other *_show_fdinfo functions and only
> define unix_show_fdinfo and set it in proto_ops if CONFIG_PROCFS
> is set.
> 
> Fixes: 3c32da19a858 ("unix: Show number of pending scm files of receive queue in fdinfo")
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>

Applied, thanks.
