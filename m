Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CEAF4121AC1
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:18:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727606AbfLPUQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:16:24 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:54730 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727016AbfLPUQW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:16:22 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BE938154FD911;
        Mon, 16 Dec 2019 12:16:21 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:16:19 -0800 (PST)
Message-Id: <20191216.121619.2170160029247719261.davem@davemloft.net>
To:     ptalbert@redhat.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: Use rx_nohandler for unhandled packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAPRrrxVJjKJ0eE_Xd78DNfyixjr=iTSfVQ1FsAssek-+XMWKUQ@mail.gmail.com>
References: <20191211162107.4326-1-ptalbert@redhat.com>
        <20191215.124119.1034274845955800225.davem@davemloft.net>
        <CAPRrrxVJjKJ0eE_Xd78DNfyixjr=iTSfVQ1FsAssek-+XMWKUQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 16 Dec 2019 12:16:21 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Patrick Talbert <ptalbert@redhat.com>
Date: Mon, 16 Dec 2019 15:07:14 +0100

> On Sun, Dec 15, 2019 at 9:41 PM David Miller <davem@davemloft.net> wrote:
>> I'm not applying this patch, sorry.
> 
> If you do not agree with adjusting the purpose of rx_nohandler to
> track these events then would you agree to a new counter?

I guess the people relying on the current rx_dropped behavior don't
matter and we can just change things from underneath them?  No,
actually, we cannot do that.

Educating people to solve this problem has the benefit of not screwing
over the users who understand what the counter means in this situation
already.
