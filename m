Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4A5D80778
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbfHCRmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 13:42:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33488 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfHCRmy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 13:42:54 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CCEAD153F2261;
        Sat,  3 Aug 2019 10:42:53 -0700 (PDT)
Date:   Sat, 03 Aug 2019 10:42:53 -0700 (PDT)
Message-Id: <20190803.104253.136871012331362030.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, dsahern@gmail.com
Subject: Re: [PATCH net-next 00/15] net: Add functional tests for L3 and L4
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801185648.27653-1-dsahern@kernel.org>
References: <20190801185648.27653-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 03 Aug 2019 10:42:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  1 Aug 2019 11:56:33 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> This is a port the functional test cases created during the development
> of the VRF feature. It covers various permutations of icmp, tcp and udp
> for IPv4 and IPv6 including negative tests.

Series applied, thanks David.

Please work with Alexei to make the server/client startup work better in
a CI environment since frankly that's the most important situation where
all of these tests are going to run now that these are in the tree.

Thanks.
