Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 937428A239
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 17:25:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfHLPZh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 11:25:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfHLPZh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 11:25:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4EABF154480AB;
        Mon, 12 Aug 2019 08:25:36 -0700 (PDT)
Date:   Mon, 12 Aug 2019 08:25:31 -0700 (PDT)
Message-Id: <20190812.082531.1505685049405253771.davem@davemloft.net>
To:     ying.xue@windriver.com
Cc:     netdev@vger.kernel.org, jon.maloy@ericsson.com, hdanton@sina.com,
        tipc-discussion@lists.sourceforge.net,
        syzkaller-bugs@googlegroups.com, jakub.kicinski@netronome.com
Subject: Re: [PATCH v2 0/3] Fix three issues found by syzbot
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
References: <1565595162-1383-1-git-send-email-ying.xue@windriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 Aug 2019 08:25:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ying Xue <ying.xue@windriver.com>
Date: Mon, 12 Aug 2019 15:32:39 +0800

> Ying Xue (3):
>   tipc: fix memory leak issue
>   tipc: fix memory leak issue

Please make the subject lines for these two patches unique.  Perhaps
mention what part of the tipc code has the memory leak you are fixing.

Thanks.
