Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 38423A7736
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 00:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfICWoA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 18:44:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725977AbfICWoA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Sep 2019 18:44:00 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E37414B7A0C7;
        Tue,  3 Sep 2019 15:43:58 -0700 (PDT)
Date:   Tue, 03 Sep 2019 15:43:56 -0700 (PDT)
Message-Id: <20190903.154356.856345970271500460.davem@davemloft.net>
To:     sirus.shahini@gmail.com
Cc:     eric.dumazet@gmail.com, shiraz.saleem@intel.com, jgg@ziepe.ca,
        arnd@arndb.de, netdev@vger.kernel.org, sirus@cs.utah.edu
Subject: Re: [PATCH] Clock-independent TCP ISN generation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
References: <bf10fbfb-a83f-a8d8-fefc-2a2fd1633ef8@gmail.com>
        <2cbd5a8f-f120-a7df-83a3-923f33ca0a10@gmail.com>
        <e3bf138f-672e-cefa-5fe5-ea25af8d3d61@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Sep 2019 15:43:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cyrus Sh <sirus.shahini@gmail.com>
Date: Tue, 3 Sep 2019 10:06:03 -0600

> On 9/3/19 9:59 AM, Eric Dumazet wrote:
>> 
>> You could add a random delay to all SYN packets, if you believe your host has clock skews.
> 
> In theory yes, but again do you know any practical example with tested
> applications and the list of the rules? I'm interested to see an actual example
> that somebody has carried out and observed its results.

That's ironic that you're asking for specific and "practical" examples
when you submitted a kernel patch that doesn't even compile.
