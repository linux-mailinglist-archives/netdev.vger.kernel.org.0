Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD4A3228C6F
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731386AbgGUXCW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgGUXCW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:02:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04346C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:02:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8FD2911E45906;
        Tue, 21 Jul 2020 15:45:36 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:02:20 -0700 (PDT)
Message-Id: <20200721.160220.640021451646628787.davem@davemloft.net>
To:     vishal@chelsio.com
Cc:     andrew@lunn.ch, netdev@vger.kernel.org, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721133754.GB20312@chelsio.com>
References: <20200720062837.GA22415@chelsio.com>
        <20200720133554.GQ1383417@lunn.ch>
        <20200721133754.GB20312@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:45:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vishal Kulkarni <vishal@chelsio.com>
Date: Tue, 21 Jul 2020 19:08:35 +0530

> Our requirement is to get overall adapter health from single tool and command.
> Using devlink and ip will require multiple tools and commands.

This is an invalid argument.

We have multiple facilities, each of which handles a specific task that it
was designed for.  You shall use such facilities, as appropriate, to fulfill
your needs.
