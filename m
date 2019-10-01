Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A5A5C3DDC
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 19:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732552AbfJARCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 13:02:36 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50000 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729383AbfJARCf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 13:02:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0E4B1154ECD6A;
        Tue,  1 Oct 2019 10:02:34 -0700 (PDT)
Date:   Tue, 01 Oct 2019 10:02:33 -0700 (PDT)
Message-Id: <20191001.100233.2002881947003652758.davem@davemloft.net>
To:     wenyang@linux.alibaba.com
Cc:     alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        xlpang@linux.alibaba.com, zhiche.yy@alibaba-inc.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: mscc: ocelot: add missing of_node_put after
 calling of_get_child_by_name
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190929065424.2437-1-wenyang@linux.alibaba.com>
References: <20190929065424.2437-1-wenyang@linux.alibaba.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 10:02:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wen Yang <wenyang@linux.alibaba.com>
Date: Sun, 29 Sep 2019 14:54:24 +0800

> of_node_put needs to be called when the device node which is got
> from of_get_child_by_name finished using.
> In both cases of success and failure, we need to release 'ports',
> so clean up the code using goto.
> 
> fixes: a556c76adc05 ("net: mscc: Add initial Ocelot switch support")
> Signed-off-by: Wen Yang <wenyang@linux.alibaba.com>

Applied.
