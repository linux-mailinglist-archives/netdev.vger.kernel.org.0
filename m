Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02A2715AF91
	for <lists+netdev@lfdr.de>; Wed, 12 Feb 2020 19:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728918AbgBLSQv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Feb 2020 13:16:51 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33926 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbgBLSQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Feb 2020 13:16:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E648A13CCE137;
        Wed, 12 Feb 2020 10:16:49 -0800 (PST)
Date:   Wed, 12 Feb 2020 10:16:47 -0800 (PST)
Message-Id: <20200212.101647.1964597534877583063.davem@davemloft.net>
To:     christian.brauner@ubuntu.com
Cc:     gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, rafael@kernel.org, pavel@ucw.cz,
        kuba@kernel.org, edumazet@google.com, stephen@networkplumber.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH net-next 00/10] net: fix sysfs permssions when device
 changes network
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200212180044.uhxwthf5ljxrrnpe@wittgenstein>
References: <20200212104321.43570-1-christian.brauner@ubuntu.com>
        <20200212.095318.414327505774757849.davem@davemloft.net>
        <20200212180044.uhxwthf5ljxrrnpe@wittgenstein>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Feb 2020 10:16:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christian Brauner <christian.brauner@ubuntu.com>
Date: Wed, 12 Feb 2020 19:00:44 +0100

> On Wed, Feb 12, 2020 at 09:53:18AM -0800, David Miller wrote:
>> 
>> net-next is closed
> 
> I just assumed it was open since rc1 has been out for a few days now.

Then why do I bother maintaining:

	http://vger.kernel.org/~davem/net-next.html

which is also mentioned in the netdev FAQ
Documentation/networking/netdev-FAQ.rst:

====================
If you aren't subscribed to netdev and/or are simply unsure if
``net-next`` has re-opened yet, simply check the ``net-next`` git
repository link above for any new networking-related commits.  You may
also check the following website for the current status:

  http://vger.kernel.org/~davem/net-next.html
====================
