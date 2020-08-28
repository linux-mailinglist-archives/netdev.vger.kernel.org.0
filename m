Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3421625635C
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 01:14:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgH1XOC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 19:14:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726536AbgH1XOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Aug 2020 19:14:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB1C5C061264;
        Fri, 28 Aug 2020 16:14:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 91F6D11E44284;
        Fri, 28 Aug 2020 15:57:14 -0700 (PDT)
Date:   Fri, 28 Aug 2020 16:14:00 -0700 (PDT)
Message-Id: <20200828.161400.1745757163764326397.davem@davemloft.net>
To:     stephen@networkplumber.org
Cc:     avi@bartavi.nl, linux-kernel@vger.kernel.org, kuba@kernel.org,
        corbet@lwn.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH v3] net: Use standardized (IANA) local port range
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200828145203.65395ad8@hermes.lan>
References: <20200828203959.32010-1-avi@bartavi.nl>
        <20200828204447.32838-1-avi@bartavi.nl>
        <20200828145203.65395ad8@hermes.lan>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 28 Aug 2020 15:57:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Hemminger <stephen@networkplumber.org>
Date: Fri, 28 Aug 2020 14:52:03 -0700

> Changing the default range impacts existing users. Since Linux has been doing
> this for so long, I don't think just because a standards body decided to reserve
> some space is sufficient justification to do this.

Agreed, there is no way we can change this after decades of
precedence.  We will definitely break things for people.
