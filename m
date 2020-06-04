Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCEF61EEDE2
	for <lists+netdev@lfdr.de>; Fri,  5 Jun 2020 00:44:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726890AbgFDWn7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Jun 2020 18:43:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgFDWn7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Jun 2020 18:43:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0B9C08C5C0
        for <netdev@vger.kernel.org>; Thu,  4 Jun 2020 15:43:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E31511F5F8D1;
        Thu,  4 Jun 2020 15:43:58 -0700 (PDT)
Date:   Thu, 04 Jun 2020 15:43:57 -0700 (PDT)
Message-Id: <20200604.154357.1163284380349439510.davem@davemloft.net>
To:     sameehj@amazon.com
Cc:     netdev@vger.kernel.org, dwmw@amazon.com, zorik@amazon.com,
        matua@amazon.com, saeedb@amazon.com, msw@amazon.com,
        aliguori@amazon.com, nafea@amazon.com, gtzalik@amazon.com,
        netanel@amazon.com, alisaidi@amazon.com, benh@amazon.com,
        akiyano@amazon.com, ndagan@amazon.com
Subject: Re: [PATCH V2 net 0/2] Fix xdp in ena driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200603085023.24221-1-sameehj@amazon.com>
References: <20200603085023.24221-1-sameehj@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 04 Jun 2020 15:43:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: <sameehj@amazon.com>
Date: Wed, 3 Jun 2020 08:50:21 +0000

> From: Sameeh Jubran <sameehj@amazon.com>
> 
> This patchset includes 2 XDP related bug fixes
> 
> Difference from v1:
> * Fixed "Fixes" tag

Series applied, thanks.
