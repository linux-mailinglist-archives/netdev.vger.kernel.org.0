Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A46DA24C859
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:15:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728597AbgHTXPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:15:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTXPR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:15:17 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB63C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 16:15:17 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 95E9A128719F3;
        Thu, 20 Aug 2020 15:58:30 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:15:15 -0700 (PDT)
Message-Id: <20200820.161515.658978104551151821.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, soheil@google.com,
        arjunroy@google.com
Subject: Re: [PATCH net-next 0/3] tcp_mmap: optmizations
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820171118.1822853-1-edumazet@google.com>
References: <20200820171118.1822853-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 15:58:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Thu, 20 Aug 2020 10:11:15 -0700

> This series updates tcp_mmap reference tool to use best pratices.
> 
> First patch is using madvise(MADV_DONTNEED) to decrease pressure
> on the socket lock.
> 
> Last patches try to use huge pages when available.

Series applied, thanks Eric.
