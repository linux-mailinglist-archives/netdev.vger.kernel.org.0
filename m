Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCFBE185ADA
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 08:07:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgCOHHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 03:07:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgCOHHW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 03:07:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DAB4013CB6A09;
        Sun, 15 Mar 2020 00:07:21 -0700 (PDT)
Date:   Sun, 15 Mar 2020 00:07:21 -0700 (PDT)
Message-Id: <20200315.000721.1436618177431746662.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     ying.xue@windriver.com, netdev@vger.kernel.org, jmaloy@redhat.com,
        maloy@donjonn.com
Subject: Re: [net-next 1/2] tipc: simplify trivial boolean return
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
References: <20200313031803.9588-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 15 Mar 2020 00:07:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: hoang.h.le@dektech.com.au
Date: Fri, 13 Mar 2020 10:18:02 +0700

> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> Checking and returning 'true' boolean is useless as it will be
> returning at end of function
> 
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
> Acked-by: Ying Xue <ying.xue@windriver.com>
> Acked-by: Jon Maloy <jmaloy@redhat.com>

Applied.
