Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02B13258D0
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 22:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727641AbfEUUYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 16:24:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44768 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbfEUUYK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 16:24:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7EA4414C85813;
        Tue, 21 May 2019 13:24:10 -0700 (PDT)
Date:   Tue, 21 May 2019 13:24:10 -0700 (PDT)
Message-Id: <20190521.132410.376317891388238361.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: Enable hash filter with offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
References: <1558410037-29161-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 May 2019 13:24:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Tue, 21 May 2019 09:10:37 +0530

> This patch enables hash filter along with offload
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

This commit message is too terse.

What is going on here.  Why does this change need to made?  Why did
you implement it this way?

Is this a bug fix?  If so, target 'net' instead of 'net-next'.
