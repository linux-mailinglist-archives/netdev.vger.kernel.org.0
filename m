Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E02C214976
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 03:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728087AbgGEBF6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jul 2020 21:05:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726926AbgGEBF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jul 2020 21:05:58 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83C2AC061794
        for <netdev@vger.kernel.org>; Sat,  4 Jul 2020 18:05:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D9FAE157ADA67;
        Sat,  4 Jul 2020 18:05:57 -0700 (PDT)
Date:   Sat, 04 Jul 2020 18:05:56 -0700 (PDT)
Message-Id: <20200704.180556.1354268815995059017.davem@davemloft.net>
To:     ap420073@gmail.com
Cc:     kuba@kernel.org, subashab@codeaurora.org, stranche@codeaurora.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: rmnet: fix interface leak for rmnet module
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200702170737.10479-1-ap420073@gmail.com>
References: <20200702170737.10479-1-ap420073@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 04 Jul 2020 18:05:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>
Date: Thu,  2 Jul 2020 17:07:37 +0000

> There are two problems in rmnet module that they occur the leak of
> a lower interface.
> The symptom is the same, which is the leak of a lower interface.
> But there are two different real problems.
> This patchset is to fix these real problems.
> 
> 1. Do not allow to have different two modes.
> As a lower interface of rmnet, there are two modes that they are VND
> and BRIDGE.
> One interface can have only one mode.
> But in the current rmnet, there is no code to prevent to have
> two modes in one lower interface.
> So, interface leak occurs.
> 
> 2. Do not allow to add multiple bridge interfaces.
> rmnet can have only two bridge interface.
> If an additional bridge interface is tried to be attached,
> rmnet should deny it.
> But there is no code to do that.
> So, interface leak occurs.

Series applied and queued up for v5.6+ -stable, thanks.
