Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 071D863BA7
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 21:04:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729049AbfGITDm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 15:03:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44050 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727942AbfGITDm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 15:03:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B3E55140163B1;
        Tue,  9 Jul 2019 12:03:41 -0700 (PDT)
Date:   Tue, 09 Jul 2019 12:03:36 -0700 (PDT)
Message-Id: <20190709.120336.1987683013901804676.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     jiri@resnulli.us, parav@mellanox.com, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com
Subject: Re: [PATCH net-next v6 0/5] devlink: Introduce PCI PF, VF ports
 and attributes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190709112058.7ffe61d3@cakuba.netronome.com>
References: <20190708224012.0280846c@cakuba.netronome.com>
        <20190709061711.GH2282@nanopsycho.orion>
        <20190709112058.7ffe61d3@cakuba.netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Jul 2019 12:03:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Tue, 9 Jul 2019 11:20:58 -0700

> On Tue, 9 Jul 2019 08:17:11 +0200, Jiri Pirko wrote:
>> >But I'll leave it to Jiri and Dave to decide if its worth a respin :)
>> >Functionally I think this is okay.
>> 
>> I'm happy with the set as it is right now. 
> 
> To be clear, I am happy enough as well. Hence the review tag.

Series applied, thanks everyone.

>> Anyway, if you want your concerns to be addresses, you should write
>> them to the appropriate code. This list is hard to follow.
> 
> Sorry, I was trying to be concise.

Jiri et al., if Jakub put forth the time and effort to make the list
and give you feedback you can put forth the effort to go through the
list and address his feedback with follow-up patches.  You cannot
dictate how people give feedback to your changes, thank you.

