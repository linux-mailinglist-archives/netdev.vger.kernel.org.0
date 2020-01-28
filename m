Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2912D14AE91
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 05:04:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgA1EEr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 23:04:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:56848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA1EEr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 23:04:47 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 797D52173E;
        Tue, 28 Jan 2020 04:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580184286;
        bh=BVthqpyqOp3qdMjZ8J/rplJXLhtT0jntt9WRiFrsMCg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OFCQ9wwvCNGvtrnXYO/7hCyjLebNAiBoNPYHL6pG+NsuS117nDf9VC+QO6+6wC/Tl
         7WXPXEhuvvFfbex3xLlROfHPI8XTXmnWJ3mfEYzWukMbr3FAB38+3pmV7AY+cZEFQI
         wIPLDHTk8Nk6+BOAI/KNuBdAfr2+ZJuUFONj06Zs=
Date:   Mon, 27 Jan 2020 20:04:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 3/6] netdevsim: fix stack-out-of-bounds in
 nsim_dev_debugfs_init()
Message-ID: <20200127200445.760e34ee@cakuba>
In-Reply-To: <20200127143034.1367-1-ap420073@gmail.com>
References: <20200127143034.1367-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:30:34 +0000, Taehee Yoo wrote:
> When netdevsim dev is being created, a debugfs directory is created.
> The variable "dev_ddir_name" is 16bytes device name pointer and device
> name is "netdevsim<dev id>".
> The maximum dev id length is 10.
> So, 16bytes for device name isn't enough.

> Fixes: ab1d0cc004d7 ("netdevsim: change debugfs tree topology")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
