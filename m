Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E22CF5A9A
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728124AbfKHWKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:10:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:10:43 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F3816153B4B1A;
        Fri,  8 Nov 2019 14:10:42 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:10:42 -0800 (PST)
Message-Id: <20191108.141042.348034237649301057.davem@davemloft.net>
To:     jiri@resnulli.us
Cc:     netdev@vger.kernel.org, mlxsw@mellanox.com
Subject: Re: [patch net-next] selftest: net: add alternative names test
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191108142633.18041-1-jiri@resnulli.us>
References: <20191108142633.18041-1-jiri@resnulli.us>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:10:43 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jiri Pirko <jiri@resnulli.us>
Date: Fri,  8 Nov 2019 15:26:33 +0100

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add a simple test for recently added netdevice alternative names.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

Applied, thanks Jiri.
