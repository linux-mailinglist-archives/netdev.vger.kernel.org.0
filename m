Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8126175E
	for <lists+netdev@lfdr.de>; Sun,  7 Jul 2019 21:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727696AbfGGTvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jul 2019 15:51:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41774 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727052AbfGGTvu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jul 2019 15:51:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1DCB9151BFFA2;
        Sun,  7 Jul 2019 12:51:50 -0700 (PDT)
Date:   Sun, 07 Jul 2019 12:51:49 -0700 (PDT)
Message-Id: <20190707.125149.1162742277762067187.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     viro@zeniv.linux.org.uk, netdev@vger.kernel.org,
        Per.Hallsmark@windriver.com
Subject: Re: [PATCH 1/2] proc: revalidate directories created with
 proc_net_mkdir()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190707080351.GA6236@avx2>
References: <20190706165201.GA10550@avx2>
        <20190707010317.GR17978@ZenIV.linux.org.uk>
        <20190707080351.GA6236@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 07 Jul 2019 12:51:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Sun, 7 Jul 2019 11:03:51 +0300

> On Sun, Jul 07, 2019 at 02:03:20AM +0100, Al Viro wrote:
>> On Sat, Jul 06, 2019 at 07:52:02PM +0300, Alexey Dobriyan wrote:
>> > +struct proc_dir_entry *_proc_mkdir(const char *name, umode_t mode,
>> > +				   struct proc_dir_entry **parent, void *data)
>> 
>> 	Two underscores, please...
> 
> Second underscore is more typing, I never understood it.

Canonicalness is not about understanding, it's about being consistent
with the rest of the tree.

Just do it please...
