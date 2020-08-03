Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D6EA23B08C
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728967AbgHCW6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:58:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCW6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:58:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF49C06174A;
        Mon,  3 Aug 2020 15:58:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68BD512779166;
        Mon,  3 Aug 2020 15:41:23 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:58:08 -0700 (PDT)
Message-Id: <20200803.155808.537689960383956807.davem@davemloft.net>
To:     tianjia.zhang@linux.alibaba.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        kuba@kernel.org, ricardo.farrington@cavium.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        tianjia.zhang@alibaba.com
Subject: Re: [PATCH] liquidio: Fix wrong return value in cn23xx_get_pf_num()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200802111544.5520-1-tianjia.zhang@linux.alibaba.com>
References: <20200802111544.5520-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:41:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Date: Sun,  2 Aug 2020 19:15:44 +0800

> On an error exit path, a negative error code should be returned
> instead of a positive return value.
> 
> Fixes: 0c45d7fe12c7e ("liquidio: fix use of pf in pass-through mode in a virtual machine")
> Cc: Rick Farrington <ricardo.farrington@cavium.com>
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Applied.
