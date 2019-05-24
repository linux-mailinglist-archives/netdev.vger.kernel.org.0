Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A272029FAE
	for <lists+netdev@lfdr.de>; Fri, 24 May 2019 22:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403871AbfEXUSX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 16:18:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403773AbfEXUSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 16:18:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ECFCE14E266A0;
        Fri, 24 May 2019 13:18:22 -0700 (PDT)
Date:   Fri, 24 May 2019 13:18:22 -0700 (PDT)
Message-Id: <20190524.131822.1584287376523103414.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com,
        indranil@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: Revert "cxgb4: Remove SGE_HOST_PAGE_SIZE
 dependency on page size"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1558579041-23465-1-git-send-email-vishal@chelsio.com>
References: <1558579041-23465-1-git-send-email-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 24 May 2019 13:18:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Thu, 23 May 2019 08:07:21 +0530

> This reverts commit 2391b0030e241386d710df10e53e2cfc3c5d4fc1 which has
> introduced regression. Now SGE's BAR2 Doorbell/GTS Page Size is
> interpreted correctly in the firmware itself by using actual host
> page size. Hence previous commit needs to be reverted.
> 
> Signed-off-by: Vishal Kulkarni <vishal@chelsio.com>

Applied and queued up for -stable.
