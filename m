Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34218BAFF8
	for <lists+netdev@lfdr.de>; Mon, 23 Sep 2019 10:52:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731900AbfIWIwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Sep 2019 04:52:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38316 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731734AbfIWIwV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Sep 2019 04:52:21 -0400
Received: from localhost (unknown [185.13.106.231])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 90069154461DD;
        Mon, 23 Sep 2019 01:52:19 -0700 (PDT)
Date:   Mon, 23 Sep 2019 10:52:04 +0200 (CEST)
Message-Id: <20190923.105204.1664693492654772909.davem@davemloft.net>
To:     ka-cheong.poon@oracle.com
Cc:     netdev@vger.kernel.org, santosh.shilimkar@oracle.com,
        rds-devel@oss.oracle.com
Subject: Re: [PATCH net] net/rds: Check laddr_check before calling it
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
References: <1568734158-18021-1-git-send-email-ka-cheong.poon@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Sep 2019 01:52:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
Date: Tue, 17 Sep 2019 08:29:18 -0700

> In rds_bind(), laddr_check is called without checking if it is NULL or
> not.  And rs_transport should be reset if rds_add_bound() fails.
> 
> Reported-by: syzbot+fae39afd2101a17ec624@syzkaller.appspotmail.com
> Signed-off-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>

Please resubmit with an appropriate Fixes: tag.

Thank you.
