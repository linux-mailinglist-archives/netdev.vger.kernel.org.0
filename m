Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2830310A12
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 17:31:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbfEAPbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 11:31:17 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34652 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726579AbfEAPbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 11:31:17 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B07821473AE57;
        Wed,  1 May 2019 08:31:16 -0700 (PDT)
Date:   Wed, 01 May 2019 11:31:15 -0400 (EDT)
Message-Id: <20190501.113115.1053814132378789555.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, liuhangbin@gmail.com, dsahern@gmail.com
Subject: Re: [PATCH net] selftests: fib_rule_tests: Fix icmp proto with ipv6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190429173009.8396-1-dsahern@kernel.org>
References: <20190429173009.8396-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 08:31:17 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Mon, 29 Apr 2019 10:30:09 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> A recent commit returns an error if icmp is used as the ip-proto for
> IPv6 fib rules. Update fib_rule_tests to send ipv6-icmp instead of icmp.
> 
> Fixes: 5e1a99eae8499 ("ipv4: Add ICMPv6 support when parse route ipproto")
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.
