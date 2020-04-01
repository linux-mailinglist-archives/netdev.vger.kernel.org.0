Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 135B219B545
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 20:19:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732807AbgDASTj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 14:19:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37522 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732331AbgDASTj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Apr 2020 14:19:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A58F311E3C074;
        Wed,  1 Apr 2020 11:19:38 -0700 (PDT)
Date:   Wed, 01 Apr 2020 11:19:38 -0700 (PDT)
Message-Id: <20200401.111938.230963240591609634.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: free MQPRIO resources in shutdown path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585684021-17628-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1585684021-17628-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Apr 2020 11:19:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Wed,  1 Apr 2020 01:17:01 +0530

> Perform missing MQPRIO resource cleanup in PCI shutdown path. Also,
> fix MQPRIO MSIX bitmap leak in resource cleanup.
> 
> Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied and queued up for -stable.
