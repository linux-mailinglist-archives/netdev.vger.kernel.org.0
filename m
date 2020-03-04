Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B41471786CC
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 01:02:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727793AbgCDACI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 19:02:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37502 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727274AbgCDACI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 19:02:08 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3FAAA15AAFC75;
        Tue,  3 Mar 2020 16:02:07 -0800 (PST)
Date:   Tue, 03 Mar 2020 16:02:06 -0800 (PST)
Message-Id: <20200303.160206.1467881674346759532.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     netdev@vger.kernel.org, bruce.w.allan@intel.com,
        jeffrey.e.pieper@intel.com, jeffrey.t.kirsher@intel.com
Subject: Re: [PATCH net 1/1] e1000e: Stop tx/rx setup spinning for upwards
 of 300us.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
References: <6ef1e257642743a786c8ddd39645bba3@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Mar 2020 16:02:07 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 3 Mar 2020 17:06:03 +0000

> Reduce the delay between checks for the ME being idle from 50us
> to uus.
     ^^^

I think you mean '5us' here.

I'll let the Intel folks review and integrate this as it's a
non-trivial change honestly.
