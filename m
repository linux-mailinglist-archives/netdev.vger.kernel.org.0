Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7788C22F8F0
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 21:21:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgG0TVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 15:21:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728358AbgG0TVW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 15:21:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF93FC061794;
        Mon, 27 Jul 2020 12:21:21 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A2E512763AE2;
        Mon, 27 Jul 2020 12:04:36 -0700 (PDT)
Date:   Mon, 27 Jul 2020 12:21:20 -0700 (PDT)
Message-Id: <20200727.122120.336438917999066726.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com
Subject: Re: [net-next v5 PATCH 0/7] Add PRP driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200722144022.15746-1-m-karicheri2@ti.com>
References: <20200722144022.15746-1-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jul 2020 12:04:36 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Wed, 22 Jul 2020 10:40:15 -0400

> This series is dependent on the following patches sent out to
> netdev list. All (1-3) are already merged to net/master as of
> sending this, but not on the net-next master branch. So need
> to apply them to net-next before applying this series. v3 of
> the iproute2 patches can be merged to work with this series
> as there are no updates since then.
> 
> [1] https://marc.info/?l=linux-netdev&m=159526378131542&w=2
> [2] https://marc.info/?l=linux-netdev&m=159499772225350&w=2
> [3] https://marc.info/?l=linux-netdev&m=159499772425352&w=2
> 
> This series adds support for Parallel Redundancy Protocol (PRP)
> in the Linux HSR driver as defined in IEC-62439-3. PRP Uses a
> Redundancy Control Trailer (RCT) the format of which is
> similar to HSR Tag. This is used for implementing redundancy.
 ...

Series applied to net-next, thank you.
