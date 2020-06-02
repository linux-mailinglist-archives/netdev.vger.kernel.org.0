Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2361EC539
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 00:42:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgFBWmw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 18:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726373AbgFBWmw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 18:42:52 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8ABC08C5C0
        for <netdev@vger.kernel.org>; Tue,  2 Jun 2020 15:42:52 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ADC551277F15C;
        Tue,  2 Jun 2020 15:42:51 -0700 (PDT)
Date:   Tue, 02 Jun 2020 15:42:50 -0700 (PDT)
Message-Id: <20200602.154250.587910468519570682.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V1 net 0/2] Fix xdp in ena driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200602132151.366-1-sameehj@amazon.com>
References: <20200602132151.366-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 15:42:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Tue, 2 Jun 2020 13:21:49 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 2 XDP related bug fixes.

Series applied and queued up for v5.6 -stable, thanks.
