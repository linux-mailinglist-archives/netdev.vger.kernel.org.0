Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DD4DAF757
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 09:57:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfIKH5y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 03:57:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39802 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbfIKH5y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 03:57:54 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BDB8815564A13;
        Wed, 11 Sep 2019 00:57:52 -0700 (PDT)
Date:   Wed, 11 Sep 2019 09:57:48 +0200 (CEST)
Message-Id: <20190911.095748.664798056318278687.davem@davemloft.net>
To:     enkechen@cisco.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH] net: Remove the source address setting in connect()
 for UDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <324B00C3-4526-4026-809B-299634E49368@cisco.com>
References: <20190906.091350.2133455010162259391.davem@davemloft.net>
        <1DCD31CA-E94F-4127-876F-8DD355E6CF9A@cisco.com>
        <324B00C3-4526-4026-809B-299634E49368@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Sep 2019 00:57:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Enke Chen (enkechen)" <enkechen@cisco.com>
Date: Tue, 10 Sep 2019 23:55:59 +0000

> Do you still have concerns about backward compatibility of the fix?

I'm not convinced by your arguments and I am also completely swamped at
LPC2019 running the networking track this week.
