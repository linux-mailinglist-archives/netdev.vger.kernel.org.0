Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF60217B427
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 03:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgCFCI0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 21:08:26 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:58762 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbgCFCI0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 21:08:26 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FCE11581B2D3;
        Thu,  5 Mar 2020 18:08:25 -0800 (PST)
Date:   Thu, 05 Mar 2020 18:08:23 -0800 (PST)
Message-Id: <20200305.180823.1274906337509861200.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     sameo@linux.intel.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        johannes@sipsolutions.net
Subject: Re: linux-next: the nfc-next tree seems to be old
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200306104825.068268eb@canb.auug.org.au>
References: <20200130105538.7b07b150@canb.auug.org.au>
        <20200306104825.068268eb@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 05 Mar 2020 18:08:25 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Fri, 6 Mar 2020 10:48:25 +1100

> On Thu, 30 Jan 2020 10:55:38 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> Hi Samuel,
>> 
>> I noticed that the nfc-next tree has not changed since June 2018 and
>> has been orphaned in May 2019, so am wondering if the commits in it are
>> still relevant or should I just remove the tree from linux-next.
> 
> Since I have had no response, I will remove it tomorrow.

We've been integrating NFC patches directly into my networking tree for
a while now, so this is indeed the thing to do.

Thanks.
