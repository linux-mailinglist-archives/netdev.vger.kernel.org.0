Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC241FA0D2
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 21:55:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730596AbgFOTzZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 15:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728771AbgFOTzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 15:55:25 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52343C061A0E
        for <netdev@vger.kernel.org>; Mon, 15 Jun 2020 12:55:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF016120ED49A;
        Mon, 15 Jun 2020 12:55:24 -0700 (PDT)
Date:   Mon, 15 Jun 2020 12:55:24 -0700 (PDT)
Message-Id: <20200615.125524.1811736198326106801.davem@davemloft.net>
To:     martinvarghesenokia@gmail.com
Cc:     netdev@vger.kernel.org, martin.varghese@nokia.com
Subject: Re: [PATCH net] bareudp: Fixed multiproto mode configuration
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1592199569-5243-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1592199569-5243-1-git-send-email-martinvarghesenokia@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Jun 2020 12:55:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Martin Varghese <martinvarghesenokia@gmail.com>
Date: Mon, 15 Jun 2020 11:09:29 +0530

> From: Martin <martin.varghese@nokia.com>
> 
> Code to handle multiproto configuration is missing.
> 
> Fixes: 4b5f67232d95 ("net: Special handling for IP & MPLS")
> Signed-off-by: Martin <martin.varghese@nokia.com>

There are two bugs here.

'conf' is not initialized and can contain garbage, for all fields
not just the multiproto mode configuration.

And also the multiproto mode configuration is not looked at.

So there should be two patches, one for each bug.
