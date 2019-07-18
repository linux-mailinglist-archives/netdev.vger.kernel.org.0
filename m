Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 664F36D441
	for <lists+netdev@lfdr.de>; Thu, 18 Jul 2019 20:56:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391028AbfGRSz6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jul 2019 14:55:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54178 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727762AbfGRSz6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jul 2019 14:55:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 35E8F1527D810;
        Thu, 18 Jul 2019 11:55:58 -0700 (PDT)
Date:   Thu, 18 Jul 2019 11:55:57 -0700 (PDT)
Message-Id: <20190718.115557.1387889272907500684.davem@davemloft.net>
To:     hslester96@gmail.com
Cc:     dchickles@marvell.com, sburla@marvell.com, fmanlunas@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] liquidio: Replace vmalloc + memset with vzalloc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190718074542.16329-1-hslester96@gmail.com>
References: <20190718074542.16329-1-hslester96@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jul 2019 11:55:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Chuhong Yuan <hslester96@gmail.com>
Date: Thu, 18 Jul 2019 15:45:42 +0800

> Use vzalloc and vzalloc_node instead of using vmalloc and
> vmalloc_node and then zeroing the allocated memory by
> memset 0.
> This simplifies the code.
> 
> Signed-off-by: Chuhong Yuan <hslester96@gmail.com>

Applied.
