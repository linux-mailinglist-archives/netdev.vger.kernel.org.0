Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A78A462B69
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 00:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726358AbfGHWXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 18:23:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59526 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725815AbfGHWXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 18:23:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71B20126B590B;
        Mon,  8 Jul 2019 15:23:53 -0700 (PDT)
Date:   Mon, 08 Jul 2019 15:23:52 -0700 (PDT)
Message-Id: <20190708.152352.710464914281100209.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] forcedeth: recv cache support 
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
References: <1562307568-21549-1-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 15:23:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Fri,  5 Jul 2019 02:19:26 -0400

> This recv cache is to make NIC work steadily when the system memory is
> not enough.

The system is supposed to hold onto enough atomic memory to absorb all
reasonable situations like this.

If anything a solution to this problem belongs generically somewhere,
not in a driver.  And furthermore looping over an allocation attempt
with a delay is strongly discouraged.
