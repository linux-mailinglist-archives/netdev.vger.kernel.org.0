Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54FDA105CF4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 00:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfKUXDF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 18:03:05 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726329AbfKUXDF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 18:03:05 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CDC37150ABF36;
        Thu, 21 Nov 2019 15:03:04 -0800 (PST)
Date:   Thu, 21 Nov 2019 15:03:04 -0800 (PST)
Message-Id: <20191121.150304.1123396062175478961.davem@davemloft.net>
To:     hoang.h.le@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com,
        tipc-discussion@lists.sourceforge.net, ying.xue@windriver.com,
        netdev@vger.kernel.org
Subject: Re: [net-next] tipc: update replicast capability for broadcast
 send link
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121030109.4754-1-hoang.h.le@dektech.com.au>
References: <20191121030109.4754-1-hoang.h.le@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 15:03:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>
Date: Thu, 21 Nov 2019 10:01:09 +0700

> When setting up a cluster with non-replicast/replicast capability
> supported. This capability will be disabled for broadcast send link
> in order to be backwards compatible.
> 
> However, when these non-support nodes left and be removed out the cluster.
> We don't update this capability on broadcast send link. Then, some of
> features that based on this capability will also disabling as unexpected.
> 
> In this commit, we make sure the broadcast send link capabilities will
> be re-calculated as soon as a node removed/rejoined a cluster.
> 
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>

Applied, thank you.
