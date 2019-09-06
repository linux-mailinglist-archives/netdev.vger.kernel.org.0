Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75567AB312
	for <lists+netdev@lfdr.de>; Fri,  6 Sep 2019 09:14:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390779AbfIFHN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Sep 2019 03:13:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56458 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfIFHN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Sep 2019 03:13:58 -0400
Received: from localhost (unknown [88.214.187.128])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E584E15163DE2;
        Fri,  6 Sep 2019 00:13:56 -0700 (PDT)
Date:   Fri, 06 Sep 2019 09:13:50 +0200 (CEST)
Message-Id: <20190906.091350.2133455010162259391.davem@davemloft.net>
To:     enkechen@cisco.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xe-linux-external@cisco.com
Subject: Re: [PATCH] net: Remove the source address setting in connect()
 for UDP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190906025437.613-1-enkechen@cisco.com>
References: <20190906025437.613-1-enkechen@cisco.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 06 Sep 2019 00:13:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Enke Chen <enkechen@cisco.com>
Date: Thu,  5 Sep 2019 19:54:37 -0700

> The connect() system call for a UDP socket is for setting the destination
> address and port. But the current code mistakenly sets the source address
> for the socket as well. Remove the source address setting in connect() for
> UDP in this patch.

Do you have any idea how many decades of precedence this behavior has and
therefore how much you potentially will break userspace?

This boat has sailed a long time ago I'm afraid.
