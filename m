Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DB2EBDD78
	for <lists+netdev@lfdr.de>; Wed, 25 Sep 2019 13:56:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391293AbfIYL4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Sep 2019 07:56:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34832 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727569AbfIYL4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Sep 2019 07:56:21 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F27C1154ECD4B;
        Wed, 25 Sep 2019 04:56:19 -0700 (PDT)
Date:   Wed, 25 Sep 2019 13:56:18 +0200 (CEST)
Message-Id: <20190925.135618.473594014346335536.davem@davemloft.net>
To:     jcfaracco@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: core: dev: replace state xoff flag
 comparison by netif_xmit_stopped method
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190923015729.10273-1-jcfaracco@gmail.com>
References: <20190923015729.10273-1-jcfaracco@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Sep 2019 04:56:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: jcfaracco@gmail.com
Date: Sun, 22 Sep 2019 22:57:29 -0300

> From: Julio Faracco <jcfaracco@gmail.com>
> 
> Function netif_schedule_queue() has a hardcoded comparison between queue
> state and any xoff flag. This comparison does the same thing as method
> netif_xmit_stopped(). In terms of code clarity, it is better. See other
> methods like: generic_xdp_tx() and dev_direct_xmit().
> 
> Signed-off-by: Julio Faracco <jcfaracco@gmail.com>

net-next is closed, please resubmit when the net-next tree opens back up.

Thank you.
