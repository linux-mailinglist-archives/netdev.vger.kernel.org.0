Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F58D1EC731
	for <lists+netdev@lfdr.de>; Wed,  3 Jun 2020 04:14:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbgFCCON (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jun 2020 22:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgFCCOM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jun 2020 22:14:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8179AC08C5C0;
        Tue,  2 Jun 2020 19:14:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CAB581279F069;
        Tue,  2 Jun 2020 19:14:09 -0700 (PDT)
Date:   Tue, 02 Jun 2020 19:14:06 -0700 (PDT)
Message-Id: <20200602.191406.2100746209535884762.davem@davemloft.net>
To:     kerneljasonxing@gmail.com
Cc:     edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liweishi@kuaishou.com, lishujin@kuaishou.com
Subject: Re: [PATCH] tcp: fix TCP socks unreleased in BBR mode
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
References: <20200602080425.93712-1-kerneljasonxing@gmail.com>
        <CANn89iLNCDuXAhj4By0PDKbuFvneVfwmwkLbRCEKLBF+pmNEPg@mail.gmail.com>
        <CAL+tcoBjjwrkE5QbXDFADRGJfPoniLL1rMFNUkAKBN9L57UGHA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 02 Jun 2020 19:14:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Xing <kerneljasonxing@gmail.com>
Date: Wed, 3 Jun 2020 09:53:10 +0800

> I'm sorry that I didn't write enough clearly. We're running the
> pristine 4.19.125 linux kernel (the latest LTS version) and have been
> haunted by such an issue. This patch is high-important, I think. So
> I'm going to resend this email with the [patch 4.19] on the headline
> and cc Greg.

That's not the appropriate thing to do.
