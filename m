Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E80111E32BD
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391180AbgEZWgd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389755AbgEZWgc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 18:36:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF39C061A0F;
        Tue, 26 May 2020 15:36:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E8A691210A40D;
        Tue, 26 May 2020 15:36:31 -0700 (PDT)
Date:   Tue, 26 May 2020 15:36:31 -0700 (PDT)
Message-Id: <20200526.153631.1486651154492951372.davem@davemloft.net>
To:     David.Laight@ACULAB.COM
Cc:     vyasevich@gmail.com, nhorman@tuxdriver.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org, hch@lst.de,
        marcelo.leitner@gmail.com
Subject: Re: [PATCH v3 net-next 1/8] sctp: setsockopt, expand some #defines
From:   David Miller <davem@davemloft.net>
In-Reply-To: <8bb56a30edfb4ff696d44cf9af909d82@AcuMS.aculab.com>
References: <bab9a624ee2d4e05b1198c3f7344a200@AcuMS.aculab.com>
        <8bb56a30edfb4ff696d44cf9af909d82@AcuMS.aculab.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 May 2020 15:36:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Laight <David.Laight@ACULAB.COM>
Date: Tue, 26 May 2020 16:44:07 +0000

> This should be 3/8.

David just respin this at some point and with this fixed and also the
header posting saying "0/8" properly instead of "0/1", this is really
messy.

Thanks.
