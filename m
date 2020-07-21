Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F46228C70
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731407AbgGUXCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:02:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgGUXCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:02:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 671ADC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:02:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 30D1B11E45904;
        Tue, 21 Jul 2020 15:45:46 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:02:30 -0700 (PDT)
Message-Id: <20200721.160230.172092089582745299.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     vishal@chelsio.com, netdev@vger.kernel.org, nirranjan@chelsio.com
Subject: Re: [PATCH net-next 0/4] cxgb4: add ethtool self_test support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721134145.GB1472201@lunn.ch>
References: <20200720133554.GQ1383417@lunn.ch>
        <20200721133754.GB20312@chelsio.com>
        <20200721134145.GB1472201@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 15:45:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Tue, 21 Jul 2020 15:41:45 +0200

>> Hi Andrew,
>> 
>> Our requirement is to get overall adapter health from single tool and command.
>> Using devlink and ip will require multiple tools and commands.
> 
> That is not a good reason to abuse the Kernel norms and do odd things.

+1
