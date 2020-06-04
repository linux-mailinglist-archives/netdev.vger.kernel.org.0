Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 205DB1EEE15
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 01:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728005AbgFDXBU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 19:01:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726221AbgFDXBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 19:01:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 926E7C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 16:01:20 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5249111F5F8D1;
        Thu,  4 Jun 2020 16:01:19 -0700 (PDT)
Date:   Thu, 04 Jun 2020 16:01:18 -0700 (PDT)
Message-Id: <20200604.160118.588933839599445650.davem@davemloft.net>
To:     linville@tuxdriver.com
Cc:     netdev@vger.kernel.org, mkubecek@suse.cz
Subject: Re: ethtool 5.7 released
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200604183539.GC1408312@tuxdriver.com>
References: <20200604183539.GC1408312@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 16:01:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "John W. Linville" <linville@tuxdriver.com>
Date: Thu, 4 Jun 2020 14:35:39 -0400

> ethtool version 5.7 has been released.
> 
> Home page: https://www.kernel.org/pub/software/network/ethtool/
> Download link:
> https://www.kernel.org/pub/software/network/ethtool/ethtool-5.7.tar.xz
> 
> Release notes:
> 
> 	* Feature: ethtool: Add support for Low Latency Reed Solomon
> 	* Fix: ethtool.c: Report transceiver correctly
> 	* Feature: features: accept long legacy flag names when setting features
> 	* Feature: refactor interface between ioctl and netlink code
> 	* Feature: netlink: use genetlink ops information to decide about fallback
> 	* Feature: netlink: show netlink error even without extack
> 	* Feature: ethtool: add support for newer SFF-8024 compliance codes
> 	* Feature: Rewrite printf() due to -Werror=format-security
> 
> This should be my last release as maintainer of ethtool. Michal
> Kubecek has graciously agreed to take-on that responsibility, and I
> have every confidence that he will do a great job in that capacity
> for our community.
> 
> Thanks, Michal!

Thank you John for steering the ethtool ship all of this time and
thanks Michal for helping us with this important networking tool.
