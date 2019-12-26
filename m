Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD8A612AA15
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 04:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfLZDtc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Dec 2019 22:49:32 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37324 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726741AbfLZDtc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Dec 2019 22:49:32 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3A5215413546;
        Wed, 25 Dec 2019 19:49:31 -0800 (PST)
Date:   Wed, 25 Dec 2019 19:49:29 -0800 (PST)
Message-Id: <20191225.194929.1465672299217213413.davem@davemloft.net>
To:     dalias@libc.org
Cc:     AWilcox@Wilcox-Tech.com, netdev@vger.kernel.org,
        linux-api@vger.kernel.org, musl@lists.openwall.com
Subject: Re: [musl] Re: [PATCH] uapi: Prevent redefinition of struct iphdr
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191226010515.GD30412@brightrain.aerifal.cx>
References: <20191222060227.7089-1-AWilcox@Wilcox-Tech.com>
        <20191225.163411.1590483851343305623.davem@davemloft.net>
        <20191226010515.GD30412@brightrain.aerifal.cx>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Dec 2019 19:49:31 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rich Felker <dalias@libc.org>
Date: Wed, 25 Dec 2019 20:05:15 -0500

> On Wed, Dec 25, 2019 at 04:34:11PM -0800, David Miller wrote:
>> I find it really strange that this, therefore, only happens for musl
>> and we haven't had thousands of reports of this conflict with glibc
>> over the years.
> 
> It's possible that there's software that's including just one of the
> headers conditional on __GLIBC__, and including both otherwise, or
> something like that. Arguably this should be considered unsupported
> usage; there are plenty of headers where that doesn't work and
> shouldn't be expected to.

I don't buy that, this is waaaaaay too common a header to use.

Please investigate.
