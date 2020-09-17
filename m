Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C78A26E647
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:10:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgIQUKJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Sep 2020 16:10:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725874AbgIQUKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Sep 2020 16:10:09 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37E1FC06174A
        for <netdev@vger.kernel.org>; Thu, 17 Sep 2020 13:10:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3310D1359F13D;
        Thu, 17 Sep 2020 12:53:21 -0700 (PDT)
Date:   Thu, 17 Sep 2020 13:10:06 -0700 (PDT)
Message-Id: <20200917.131006.516684715772641506.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     snelson@pensando.io, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ionic: add DIMLIB to Kconfig
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200917130231.65770423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a17b550c-1db1-d32e-f69c-d51bb4a1ca2b@pensando.io>
        <20200917130231.65770423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 17 Sep 2020 12:53:21 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 17 Sep 2020 13:02:31 -0700

> On Thu, 17 Sep 2020 12:08:45 -0700 Shannon Nelson wrote:
>> On 9/17/20 12:02 PM, Jakub Kicinski wrote:
>> > On Thu, 17 Sep 2020 11:42:43 -0700 Shannon Nelson wrote:  
>> >>>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation  
>> >>     >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/ionic/ionic_lif.c:52)
>> >>     >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in archive drivers/built-in.a  
>> >> --  
>> > This is going to cut off the commit message when patch is applied.  
>> 
>> Isn't the trigger a three dash string?  It is only two dashes, not 
>> three, and "git am" seems to work correctly for me.  Is there a 
>> different mechanism I need to watch out for?
> 
> I got a verify_signoff failure on this patch:
> 
> Commit a92faed54662 ("ionic: add DIMLIB to Kconfig")
> 	author Signed-off-by missing
> 	author email:    snelson@pensando.io
> 
> And in the tree I can see the commit got cut off. 
> 
> Maybe it's some extra mangling my bot does. In any case, I wanted to
> at least give Dave a heads up.

Thanks I'll watch carefully when applying this :)
