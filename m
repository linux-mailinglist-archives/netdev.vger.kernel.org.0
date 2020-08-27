Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8820254B0B
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 18:44:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgH0QoQ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 27 Aug 2020 12:44:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgH0QoP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 12:44:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C80C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 09:44:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 73FC91281E8B2;
        Thu, 27 Aug 2020 09:27:28 -0700 (PDT)
Date:   Thu, 27 Aug 2020 09:44:12 -0700 (PDT)
Message-Id: <20200827.094412.1386296048660013556.davem@davemloft.net>
To:     nicolas.dichtel@6wind.com
Cc:     kuba@kernel.org, pablo@netfilter.org, laforge@gnumonks.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        gabriel.ganne@6wind.com
Subject: Re: [PATCH net-next v3] gtp: add notification mechanism
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d0c3b1c8-4275-6b5a-3d93-4c9ac198b1a3@6wind.com>
References: <20200827121923.7302-1-nicolas.dichtel@6wind.com>
        <20200827.080514.1573033574724120328.davem@davemloft.net>
        <d0c3b1c8-4275-6b5a-3d93-4c9ac198b1a3@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 09:27:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Date: Thu, 27 Aug 2020 18:37:32 +0200

> Le 27/08/2020 à 17:05, David Miller a écrit :
>> From: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> Date: Thu, 27 Aug 2020 14:19:23 +0200
>> 
>>> Like all other network functions, let's notify gtp context on creation and
>>> deletion.
>>>
>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>>> Tested-by: Gabriel Ganne <gabriel.ganne@6wind.com>
>>> Acked-by: Harald Welte <laforge@gnumonks.org>
>> 
>> Applied, thanks.
>> 
> I don't see the changes here:
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/log/
> 
> Some build tests? Or just a missing push? ;-)

Was build testing, it's pushed out now.
