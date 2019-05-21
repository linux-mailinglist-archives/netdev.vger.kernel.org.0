Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B473824503
	for <lists+netdev@lfdr.de>; Tue, 21 May 2019 02:20:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfEUAUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 20:20:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726677AbfEUAUk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 20:20:40 -0400
Received: from localhost (50-78-161-185-static.hfc.comcastbusiness.net [50.78.161.185])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BFEF113FD234F;
        Mon, 20 May 2019 17:20:39 -0700 (PDT)
Date:   Mon, 20 May 2019 20:20:39 -0400 (EDT)
Message-Id: <20190520.202039.334525401412211794.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        roopa@cumulusnetworks.com
Subject: Re: [PATCH net 0/2] kselftests: fib_rule_tests: fix "from $SRC_IP
 iif $DEV" match testing
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190520043655.13095-1-liuhangbin@gmail.com>
References: <20190520043655.13095-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 May 2019 17:20:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Mon, 20 May 2019 12:36:53 +0800

> As all the IPv4 testing addresses are in the same subnet and egress
> device == ingress device, to pass "from $SRC_IP iif $DEV" match
> test, we need enable forwarding to get the route entry.

Series applied, thanks.
