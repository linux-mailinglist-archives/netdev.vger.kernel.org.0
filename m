Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F57D20C51D
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 03:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726678AbgF1BIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jun 2020 21:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726101AbgF1BI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jun 2020 21:08:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC0CC061794
        for <netdev@vger.kernel.org>; Sat, 27 Jun 2020 18:08:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D17114322D53;
        Sat, 27 Jun 2020 18:08:29 -0700 (PDT)
Date:   Sat, 27 Jun 2020 18:08:28 -0700 (PDT)
Message-Id: <20200627.180828.233747922813040718.davem@davemloft.net>
To:     oliver.peter.herms@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: IPv4: Why are sysctl settings of abandoned route cache / GC
 still around?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <dadfe9fd-a585-09d1-cb08-54d742d295fe@gmail.com>
References: <dadfe9fd-a585-09d1-cb08-54d742d295fe@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 27 Jun 2020 18:08:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Herms <oliver.peter.herms@gmail.com>
Date: Sat, 27 Jun 2020 14:33:30 +0200

> is there a reason sysctl settings like net/ipv4/route/
> - max_size
> - gc_thresh
> - gc_min_interval
> - gc_min_interval_ms
> - gc_elasticity
> are still around in current kernels? 

Because otherwise scripts would break.

Sysctl is a user facing API.
