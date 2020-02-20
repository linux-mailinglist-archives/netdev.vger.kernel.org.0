Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 549C916537E
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 01:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgBTAYS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 19:24:18 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBTAYS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 19:24:18 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4946115BD7A45;
        Wed, 19 Feb 2020 16:24:17 -0800 (PST)
Date:   Wed, 19 Feb 2020 16:24:16 -0800 (PST)
Message-Id: <20200219.162416.1910523123736311797.davem@davemloft.net>
To:     christian.brauner@ubuntu.com
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next v3 0/9] net: fix sysfs permssions when device
 changes network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
References: <20200218162943.2488012-1-christian.brauner@ubuntu.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Feb 2020 16:24:17 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Tue, 18 Feb 2020 17:29:34 +0100

> This is v3 with explicit uid and gid parameters added to functions that
> change sysfs object ownership as Greg requested.

Greg, please review.

Thank you.
