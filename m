Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C547B26B1CA
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:36:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbgIOWgQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:36:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727794AbgIOWf4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 18:35:56 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4C3AC06174A;
        Tue, 15 Sep 2020 15:35:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AE9BD13757C1F;
        Tue, 15 Sep 2020 15:19:07 -0700 (PDT)
Date:   Tue, 15 Sep 2020 15:35:53 -0700 (PDT)
Message-Id: <20200915.153553.450322847326627010.davem@davemloft.net>
To:     oded.gabbay@gmail.com
Cc:     andrew@lunn.ch, kuba@kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, SW_Drivers@habana.ai,
        gregkh@linuxfoundation.org, f.fainelli@gmail.com,
        linux-rdma@vger.kernel.org
Subject: Re: [PATCH v3 00/14] Adding GAUDI NIC code to habanalabs driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAFCwf13RHWmpAXpWLRtsxjvKPK=7ZChDPD9E6KEgbamLbg09OA@mail.gmail.com>
References: <CAFCwf10+_hQOSH4Ot+keE9Tc+ybupvp5JyUhFbvfoy6HseVyZg@mail.gmail.com>
        <20200915213735.GG3526428@lunn.ch>
        <CAFCwf13RHWmpAXpWLRtsxjvKPK=7ZChDPD9E6KEgbamLbg09OA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 15 Sep 2020 15:19:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oded Gabbay <oded.gabbay@gmail.com>
Date: Wed, 16 Sep 2020 00:43:00 +0300

> I honestly don't know and I admit we didn't look at the dates of when
> these drivers were introduced.

Please do research when you make claims in the future, thank you.
