Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC34925B71D
	for <lists+netdev@lfdr.de>; Thu,  3 Sep 2020 01:09:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgIBXIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Sep 2020 19:08:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726586AbgIBXIe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Sep 2020 19:08:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E18C061244
        for <netdev@vger.kernel.org>; Wed,  2 Sep 2020 16:08:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A77D15746469;
        Wed,  2 Sep 2020 15:51:45 -0700 (PDT)
Date:   Wed, 02 Sep 2020 16:08:31 -0700 (PDT)
Message-Id: <20200902.160831.2194160080454145229.davem@davemloft.net>
To:     awogbemila@google.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, csully@google.com,
        yangchun@google.com
Subject: Re: [PATCH net-next v2 4/9] gve: Add support for dma_mask register
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAL9ddJciz2MD8CYqdbFLhYCKFk=ouHzzEndQwmcfQ-UqNNgJxQ@mail.gmail.com>
References: <20200901215149.2685117-5-awogbemila@google.com>
        <20200901173410.5ce6a087@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL9ddJciz2MD8CYqdbFLhYCKFk=ouHzzEndQwmcfQ-UqNNgJxQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 02 Sep 2020 15:51:45 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Awogbemila <awogbemila@google.com>
Date: Wed, 2 Sep 2020 11:42:37 -0700

> I don't think there is a specific 24-bit device in mind here, only
> that we have seen 32-bit addressing use cases where the guest ran out
> of SWIOTLB space and restricting to GFP_DMA32 helped.. so we thought
> it would be natural for the driver to handle the 24 bit case in case
> it ever came along.

You should add such support when the situation presents itself, rather
than prematurely like this.

Thank you.
