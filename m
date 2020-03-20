Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1B3918C681
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:30:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCTEaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 00:30:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46842 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727197AbgCTEav (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:30:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4DC721590C665;
        Thu, 19 Mar 2020 21:30:51 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:30:50 -0700 (PDT)
Message-Id: <20200319.213050.1103025966630815592.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: fix Txq restart check during backpressure
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1584639490-27208-2-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1584639490-27208-1-git-send-email-rahul.lakkireddy@chelsio.com>
        <1584639490-27208-2-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:30:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Thu, 19 Mar 2020 23:08:10 +0530

> Driver reclaims descriptors in much smaller batches, even if hardware
> indicates more to reclaim, during backpressure. So, fix the check to
> restart the Txq during backpressure, by looking at how many
> descriptors hardware had indicated to reclaim, and not on how many
> descriptors that driver had actually reclaimed. Once the Txq is
> restarted, driver will reclaim even more descriptors when Tx path
> is entered again.
> 
> Fixes: d429005fdf2c ("cxgb4/cxgb4vf: Add support for SGE doorbell queue timer")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied, thanks.
