Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E71E1EC522
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728638AbgFBWgz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:36:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbgFBWgz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:36:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F87DC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 15:36:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B52261277F130;
        Tue,  2 Jun 2020 15:36:54 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:36:53 -0700 (PDT)
Message-Id: <20200602.153653.1084023936502781522.davem@davemloft.net>
To:     vvs@virtuozzo.com
Cc:     netdev@vger.kernel.org, sridhar.samudrala@intel.com,
        kuba@kernel.org
Subject: Re: [PATCH] net_failover: fixed rollback in net_failover_open()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <df2d392b-0713-20b8-0deb-1a9f93f7a9c2@virtuozzo.com>
References: <df2d392b-0713-20b8-0deb-1a9f93f7a9c2@virtuozzo.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:36:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasily Averin <vvs@virtuozzo.com>
Date: Tue, 2 Jun 2020 15:55:26 +0300

> found by smatch:
> drivers/net/net_failover.c:65 net_failover_open() error:
>  we previously assumed 'primary_dev' could be null (see line 43)
> 
> cc: stable@vger.kernel.org
> Fixes: cfc80d9a1163 ("net: Introduce net_failover driver")
> Signed-off-by: Vasily Averin <vvs@virtuozzo.com>

Do not CC: stable for networking patches in the future please.

Applied, and queued up for -stable, thanks.
