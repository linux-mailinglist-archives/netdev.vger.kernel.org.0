Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B867A7416A
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 00:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfGXW3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 18:29:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52818 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726486AbfGXW3K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 18:29:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC26F1543BD22;
        Wed, 24 Jul 2019 15:29:09 -0700 (PDT)
Date:   Wed, 24 Jul 2019 15:29:09 -0700 (PDT)
Message-Id: <20190724.152909.630985511198328199.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     cai@lca.pw, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] net/ixgbevf: fix a compilation error of
 skb_frag_t
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8749f22284c5a557fe50a5dcc956c5d2c80037e2.camel@intel.com>
References: <4b5abf35a7b78ceae788ad7c2609d84dd33e5e9e.camel@intel.com>
        <20190724.144143.2055459359936675888.davem@davemloft.net>
        <8749f22284c5a557fe50a5dcc956c5d2c80037e2.camel@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jul 2019 15:29:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Wed, 24 Jul 2019 15:02:15 -0700

> On Wed, 2019-07-24 at 14:41 -0700, David Miller wrote:
>> From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
>> Date: Wed, 24 Jul 2019 09:39:26 -0700
>> 
>> > Dave I will pick this up and add it to my queue.
>> 
>> How soon will you get that to me?  The sooner this build fix is cured
>> the
>> better.
> 
> Go ahead and pick it up, I was able to get it through an initial round
> of testing with no issues.  No need to wait for me to re-send it, I
> will go ahead and ACK Qian's patch.

Ok, done.

Thanks.
