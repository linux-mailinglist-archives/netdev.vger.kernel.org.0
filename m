Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6282000F2
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgFSDuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726278AbgFSDuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:50:11 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1FF2C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:50:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B08AD120ED49C;
        Thu, 18 Jun 2020 20:50:10 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:50:10 -0700 (PDT)
Message-Id: <20200618.205010.1700876876955951981.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, dt@chelsio.com
Subject: Re: [PATCH net-next v2 0/5] cxgb4: add support to read/write flash
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200618060556.14410-1-vishal@chelsio.com>
References: <20200618060556.14410-1-vishal@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:50:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Thu, 18 Jun 2020 11:35:51 +0530

> This series of patches adds support to read/write different binary images
> of serial flash present in Chelsio terminator.
> 
> V2 changes:
> Patch 1: No change
> Patch 2: No change
> Patch 3: Fix 4 compilation warnings reported by C=1, W=1 flags
> Patch 4: No change
> Patch 5: No change

Series applied, thank you.
