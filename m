Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37A986F29
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405333AbfHIBMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:12:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54072 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404550AbfHIBMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:12:40 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAA0614284348;
        Thu,  8 Aug 2019 18:12:39 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:12:39 -0700 (PDT)
Message-Id: <20190808.181239.5792042621243070.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cxgb4: smt: Use normal int for refcount
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806025854.17076-1-hslester96@gmail.com>
References: <20190806025854.17076-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:12:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Tue,  6 Aug 2019 10:58:54 +0800

> All refcount operations are protected by spinlocks now.
> Then the atomic counter can be replaced by a normal int.
> 
> This patch depends on PATCH 1/2.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
