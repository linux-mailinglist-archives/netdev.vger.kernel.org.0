Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA6F136582
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 03:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgAJCoD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 21:44:03 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:60890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730764AbgAJCoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 21:44:02 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 45A731573FF06;
        Thu,  9 Jan 2020 18:44:02 -0800 (PST)
Date:   Thu, 09 Jan 2020 18:44:01 -0800 (PST)
Message-Id: <20200109.184401.74056974361053845.davem@davemloft.net>
To:     mathew.j.martineau@linux.intel.com
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH net-next v7 00/11] Multipath TCP: Prerequisites
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
References: <20200109155924.30122-1-mathew.j.martineau@linux.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 18:44:02 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mat Martineau <mathew.j.martineau@linux.intel.com>
Date: Thu,  9 Jan 2020 07:59:13 -0800

 ...
> The MPTCP upstreaming community has been collaborating on an
> upstreamable MPTCP implementation that complies with RFC 8684. A minimal
> set of features to comply with the specification involves a sizeable set
> of code changes, so David requested that we split this work in to
> multiple, smaller patch sets to build up MPTCP infrastructure.
> 
> The minimal MPTCP feature set we are proposing for review in the v5.6
> timeframe begins with these three parts:
> 
> Part 1 (this patch set): MPTCP prerequisites. Introduce some MPTCP
> definitions, additional ULP and skb extension features, TCP option space
> checking, and a few exported symbols.
> 
> Part 2: Single subflow implementation and self tests.
> 
> Part 3: Switch from MPTCP v0 (RFC 6824) to MPTCP v1 (new RFC 8684,
> publication expected in the next few days).
> 
> Additional patches for multiple subflow support, path management, active
> backup, and other features are in the pipeline for submission after
> making progress with the above reviews.
 ...

Series applied to net-next.
