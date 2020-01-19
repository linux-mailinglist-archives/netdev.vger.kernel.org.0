Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BD1141EC1
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 16:13:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgASPNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 10:13:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49120 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727007AbgASPNp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 10:13:45 -0500
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCE4114EC31E8;
        Sun, 19 Jan 2020 07:13:43 -0800 (PST)
Date:   Sun, 19 Jan 2020 16:13:42 +0100 (CET)
Message-Id: <20200119.161342.631508284605232315.davem@davemloft.net>
To:     rahul.lakkireddy@chelsio.com
Cc:     netdev@vger.kernel.org, nirranjan@chelsio.com, vishal@chelsio.com,
        dt@chelsio.com
Subject: Re: [PATCH net] cxgb4: reject overlapped queues in TC-MQPRIO
 offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1579265507-7729-1-git-send-email-rahul.lakkireddy@chelsio.com>
References: <1579265507-7729-1-git-send-email-rahul.lakkireddy@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 Jan 2020 07:13:44 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>
Date: Fri, 17 Jan 2020 18:21:47 +0530

> A queue can't belong to multiple traffic classes. So, reject
> any such configuration that results in overlapped queues for a
> traffic class.
> 
> Fixes: b1396c2bd675 ("cxgb4: parse and configure TC-MQPRIO offload")
> Signed-off-by: Rahul Lakkireddy <rahul.lakkireddy@chelsio.com>

Applied.
