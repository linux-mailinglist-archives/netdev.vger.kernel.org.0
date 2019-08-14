Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 674A58D87F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 18:53:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfHNQxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 12:53:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56128 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfHNQxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 12:53:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::202])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C1615154CD346;
        Wed, 14 Aug 2019 09:53:30 -0700 (PDT)
Date:   Wed, 14 Aug 2019 12:53:30 -0400 (EDT)
Message-Id: <20190814.125330.1934256694306164517.davem@davemloft.net>
To:     pablo@netfilter.org
CC:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: fallout from net-next netfilter changes
From:   David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Aug 2019 09:53:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


This started happening after Jakub's pull of your net-next changes
yesterday:

./include/uapi/linux/netfilter_ipv6/ip6t_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
 #warning "Please update iptables, this file will be removed soon!"
  ^~~~~~~
In file included from <command-line>:
./include/uapi/linux/netfilter_ipv4/ipt_LOG.h:5:2: warning: #warning "Please update iptables, this file will be removed soon!" [-Wcpp]
 #warning "Please update iptables, this file will be removed soon!"
  ^~~~~~~

It's probaly from the standard kernel build UAPI header checks.

Please fix this.
