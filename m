Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C49471FA1BE
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 22:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731541AbgFOUiJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 16:38:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728346AbgFOUiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 16:38:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6156C061A0E;
        Mon, 15 Jun 2020 13:38:06 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 10DED120ED49C;
        Mon, 15 Jun 2020 13:38:06 -0700 (PDT)
Date:   Mon, 15 Jun 2020 13:38:05 -0700 (PDT)
Message-Id: <20200615.133805.1327699493804622026.davem@davemloft.net>
To:     pakki001@umn.edu
Cc:     kjlu@umn.edu, wu000273@umn.edu, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rocker: fix incorrect error handling in dma_rings_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200612202755.57418-1-pakki001@umn.edu>
References: <20200612202755.57418-1-pakki001@umn.edu>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 13:38:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aditya Pakki <pakki001@umn.edu>
Date: Fri, 12 Jun 2020 15:27:55 -0500

> In rocker_dma_rings_init, the goto blocks in case of errors
> caused by the functions rocker_dma_cmd_ring_waits_alloc() and
> rocker_dma_ring_create() are incorrect. The patch fixes the
> order consistent with cleanup in rocker_dma_rings_fini().
> 
> Signed-off-by: Aditya Pakki <pakki001@umn.edu>

Applied, thanks.
