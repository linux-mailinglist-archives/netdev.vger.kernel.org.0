Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A8166112
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 23:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbfGKVXM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 17:23:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47066 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726446AbfGKVXM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 17:23:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C768314DA76F6;
        Thu, 11 Jul 2019 14:23:11 -0700 (PDT)
Date:   Thu, 11 Jul 2019 14:23:09 -0700 (PDT)
Message-Id: <20190711.142309.1968330616213266538.davem@davemloft.net>
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
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Jul 2019 14:23:11 -0700 (PDT)
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

Applied, thank you.
