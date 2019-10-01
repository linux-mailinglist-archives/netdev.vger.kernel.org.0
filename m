Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24DF2C3A6E
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:26:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729744AbfJAQ0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:26:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729188AbfJAQ0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:26:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F77A154B4BA3;
        Tue,  1 Oct 2019 09:26:50 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:26:49 -0700 (PDT)
Message-Id: <20191001.092649.1794389127329635974.davem@davemloft.net>
To:     jcfaracco@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: core: dev: replace state xoff flag comparison
 by netif_xmit_stopped method
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001143904.6549-1-jcfaracco@gmail.com>
References: <20191001143904.6549-1-jcfaracco@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:26:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jcfaracco@gmail.com
Date: Tue,  1 Oct 2019 11:39:04 -0300

> From: Julio Faracco <jcfaracco@gmail.com>
> 
> Function netif_schedule_queue() has a hardcoded comparison between queue
> state and any xoff flag. This comparison does the same thing as method
> netif_xmit_stopped(). In terms of code clarity, it is better. See other
> methods like: generic_xdp_tx() and dev_direct_xmit().
> 
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>

Applied to net-next.

Please explicitly put "[PATCH net-next v2]" 'net-next' in your Subject lines in
the future.
