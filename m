Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA6F01BE71D
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 21:16:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgD2TQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 15:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726423AbgD2TQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 15:16:15 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF462C03C1AE
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 12:16:15 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B8211210A3EF;
        Wed, 29 Apr 2020 12:16:15 -0700 (PDT)
Date:   Wed, 29 Apr 2020 12:16:14 -0700 (PDT)
Message-Id: <20200429.121614.1404618498953905270.davem@davemloft.net>
To:     andrew@lunn.ch
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org, cphealy@gmail.com,
        leonard.crestez@nxp.com
Subject: Re: [EXT] Re: [PATCH net-next] net: ethernet: fec: Prevent MII
 event after MII_SPEED write
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429141102.GK30459@lunn.ch>
References: <20200428.203439.49635882087657701.davem@davemloft.net>
        <HE1PR0402MB2745963E2B675BAC95A61E55FFAD0@HE1PR0402MB2745.eurprd04.prod.outlook.com>
        <20200429141102.GK30459@lunn.ch>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 29 Apr 2020 12:16:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Wed, 29 Apr 2020 16:11:02 +0200

>> > >> Applied to net-next, thanks.
>> > >
>> > > David, it is too early to apply the patch, it will introduce another
>> > > break issue as I explain in previous mail for the patch.
>> > 
>> > So what should I do, revert?
>> 
>> If you can revert the patch, please do it. 
>> Thanks, David.
> 
> Hi David
> 
> Please do revert. I will send a new version of the patch
> soon. Probably RFC this time!

Ok, done.
