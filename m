Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1C20C3C7C
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:52:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733304AbfJAQw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:52:28 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49792 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727572AbfJAQw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:52:28 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F0E9154ECD6D;
        Tue,  1 Oct 2019 09:52:27 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:52:27 -0700 (PDT)
Message-Id: <20191001.095227.1125113002999915056.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     vinicius.gomes@intel.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH net] net: sched: cbs: Avoid division by zero when
 calculating the port rate
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190928233948.15866-1-olteanv@gmail.com>
References: <20190928233948.15866-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:52:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Sun, 29 Sep 2019 02:39:48 +0300

> As explained in the "net: sched: taprio: Avoid division by zero on
> invalid link speed" commit, it is legal for the ethtool API to return
> zero as a link speed. So guard against it to ensure we don't perform a
> division by zero in kernel.
> 
> Fixes: e0a7683d30e9 ("net/sched: cbs: fix port_rate miscalculation")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied and queued up for -stable.
