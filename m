Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0F1023B026
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:25:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgHCWZK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:25:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgHCWZJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:25:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA591C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:25:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4FE9612771DF5;
        Mon,  3 Aug 2020 15:08:24 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:25:09 -0700 (PDT)
Message-Id: <20200803.152509.966776397269574876.davem@davemloft.net>
To:     florent.fourcot@wifirst.fr
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] ipv6/addrconf: use a boolean to choose
 between UNREGISTER/DOWN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200731133207.26964-2-florent.fourcot@wifirst.fr>
References: <20200731133207.26964-1-florent.fourcot@wifirst.fr>
        <20200731133207.26964-2-florent.fourcot@wifirst.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:08:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florent Fourcot <florent.fourcot@wifirst.fr>
Date: Fri, 31 Jul 2020 15:32:07 +0200

> "how" was used as a boolean. Change the type to bool, and improve
> variable name
> 
> Signed-off-by: Florent Fourcot <florent.fourcot@wifirst.fr>

Applied.
