Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8DE1895EB
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 06:08:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725822AbfHLEIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 00:08:22 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725648AbfHLEIW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Aug 2019 00:08:22 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 71AC0144B37EE;
        Sun, 11 Aug 2019 21:08:21 -0700 (PDT)
Date:   Sun, 11 Aug 2019 21:08:20 -0700 (PDT)
Message-Id: <20190811.210820.1168889173898610979.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, joe@perches.com, tlfalcon@linux.ibm.com
Subject: Re: [PATCHv2 net 0/2] Add netdev_level_ratelimited to avoid netdev
 msg flush
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190809002941.15341-1-liuhangbin@gmail.com>
References: <20190801090347.8258-1-liuhangbin@gmail.com>
        <20190809002941.15341-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 21:08:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri,  9 Aug 2019 08:29:39 +0800

> ibmveth 30000003 env3: h_multicast_ctrl rc=4 when adding an entry to the filter table

You need to root cause and fix the reason this message appears so much.

Once I let you rate limit the message you will have zero incentive to
fix the real problem and fix it.
