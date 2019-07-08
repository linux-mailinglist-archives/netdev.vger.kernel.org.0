Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7F962C54
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 01:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726330AbfGHXMl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 19:12:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60028 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725857AbfGHXMl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 19:12:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8704712DE5812;
        Mon,  8 Jul 2019 16:12:40 -0700 (PDT)
Date:   Mon, 08 Jul 2019 16:12:39 -0700 (PDT)
Message-Id: <20190708.161239.1059009680713827908.davem@davemloft.net>
To:     ppenkov@google.com
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        edumazet@google.com
Subject: Re: [net-next] net: fib_rules: do not flow dissect local packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190705184643.249884-1-ppenkov@google.com>
References: <20190705184643.249884-1-ppenkov@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 16:12:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petar Penkov <ppenkov@google.com>
Date: Fri,  5 Jul 2019 11:46:43 -0700

> Rules matching on loopback iif do not need early flow dissection as the
> packet originates from the host. Stop counting such rules in
> fib_rule_requires_fldissect
> 
> Signed-off-by: Petar Penkov <ppenkov@google.com>

Roopa, please review.
