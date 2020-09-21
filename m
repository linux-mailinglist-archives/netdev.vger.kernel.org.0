Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3958427346C
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 22:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727743AbgIUU47 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 16:56:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726796AbgIUU47 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 16:56:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3254C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 13:56:58 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5970411E49F60;
        Mon, 21 Sep 2020 13:40:11 -0700 (PDT)
Date:   Mon, 21 Sep 2020 13:56:58 -0700 (PDT)
Message-Id: <20200921.135658.1923772977648321686.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mtosatti@redhat.com
Subject: Re: [PATCH net-next] net-sysfs: add backlog len and CPU id to
 softnet data
From:   David Miller <davem@davemloft.net>
In-Reply-To: <5e503da366e0261632ab87559a72db2fff0e78a4.1600444637.git.pabeni@redhat.com>
References: <5e503da366e0261632ab87559a72db2fff0e78a4.1600444637.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 21 Sep 2020 13:40:11 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Fri, 18 Sep 2020 18:00:46 +0200

> Currently the backlog status in not exposed to user-space.
> Since long backlogs (or simply not empty ones) can be a
> source of noticeable latency, -RT deployments need some way
> to inspect it.
> 
> Additionally, there isn't a direct match between 'softnet_stat'
> lines and the related CPU - sd for offline CPUs are not dumped -
> so this patch also includes the CPU id into such entry.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Looks good, applied, thanks.
