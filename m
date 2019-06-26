Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DCC2B56E48
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbfFZQD6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:03:58 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37064 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbfFZQD6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:03:58 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 822AE14A8CC4B;
        Wed, 26 Jun 2019 09:03:57 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:03:56 -0700 (PDT)
Message-Id: <20190626.090356.252151230739268701.davem@davemloft.net>
To:     rasmus.villemoes@prevas.dk
Cc:     willemdebruijn.kernel@gmail.com, wg@grandegger.com,
        mkl@pengutronix.de, Rasmus.Villemoes@prevas.se,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in
 register_candev()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
        <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
        <ff8160d4-3357-9b4f-1840-bbe46195da5a@prevas.dk>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Jun 2019 09:03:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date: Wed, 26 Jun 2019 09:31:39 +0000

> Perhaps I've misunderstood when to use the net-next prefix - is that
> only for things that should be applied directly to the net-next
> tree?

Yes, it is.

