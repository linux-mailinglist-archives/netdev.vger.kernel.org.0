Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC79F500
	for <lists+netdev@lfdr.de>; Tue, 27 Aug 2019 23:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729696AbfH0VVw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Aug 2019 17:21:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726675AbfH0VVw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Aug 2019 17:21:52 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8F5DE1534D6C1;
        Tue, 27 Aug 2019 14:21:51 -0700 (PDT)
Date:   Tue, 27 Aug 2019 14:21:51 -0700 (PDT)
Message-Id: <20190827.142151.109285425672083572.davem@davemloft.net>
To:     dsahern@gmail.com
Cc:     Joakim.Tjernlund@infinera.com, netdev@vger.kernel.org,
        greg@kroah.com, stable@vger.kernel.org
Subject: Re: [PATCH net] ipv6: Default fib6_type to RTN_UNICAST when not set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b644d367-53a3-c2cc-2a84-28a7caae480c@gmail.com>
References: <20190827170729.GD21369@kroah.com>
        <db87d29f160302789f239cda2074ed35ae67da62.camel@infinera.com>
        <b644d367-53a3-c2cc-2a84-28a7caae480c@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Aug 2019 14:21:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@gmail.com>
Date: Tue, 27 Aug 2019 11:51:32 -0600

> Specific request is for commit c7036d97acd2527cef145b5ef9ad1a37ed21bbe6
> ("ipv6: Default fib6_type to RTN_UNICAST when not set") to be queued for
> stable releases prior to v5.2

Ok, I'll take care of this in my next round.
