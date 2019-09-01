Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B85A47EB
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:42:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728684AbfIAGmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:42:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33724 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728653AbfIAGmm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:42:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 29D9C14CDC64C;
        Sat, 31 Aug 2019 23:42:42 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:42:41 -0700 (PDT)
Message-Id: <20190831.234241.1305621783967667856.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     ruxandra.radulescu@nxp.com, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com
Subject: Re: [PATCH net-next 0/3] dpaa2-eth: Add new statistics counters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830231219.2363758a@cakuba.netronome.com>
References: <1567160443-31297-1-git-send-email-ruxandra.radulescu@nxp.com>
        <20190830231219.2363758a@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:42:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Fri, 30 Aug 2019 23:12:19 -0700

> On Fri, 30 Aug 2019 13:20:40 +0300, Ioana Radulescu wrote:
>> Recent firmware versions offer access to more DPNI statistics
>> counters. Add the relevant ones to ethtool interface stats.
>> 
>> Also we can now make use of a new counter for in flight egress frames
>> to avoid sleeping an arbitrary amount of time in the ndo_stop routine.
> 
> A little messy there in the comment of patch 2, and IMHO if you're
> expecting particular errors to be ignored it's better to write:
> 
> 	if (err == -EOPNOTSUPP)
> 		/* still fine*/;
> 	else if (err)
> 		/* real err */
> 
> than assume any error is for unsupported and add a extra comment
> explaining that things may be not supported.

Ioana, please address this feedback and respin your patchset.

Thank you.
