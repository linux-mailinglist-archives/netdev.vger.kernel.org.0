Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7866525313F
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 16:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727924AbgHZO1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 10:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726950AbgHZO1K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 10:27:10 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA1BC061574;
        Wed, 26 Aug 2020 07:27:09 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6B3A713588513;
        Wed, 26 Aug 2020 07:10:19 -0700 (PDT)
Date:   Wed, 26 Aug 2020 07:27:02 -0700 (PDT)
Message-Id: <20200826.072702.41986607066578195.davem@davemloft.net>
To:     yili@winhong.com
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        yilikernel@gmail.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, kuba@kernel.org, libing@winhong.com
Subject: Re: [PATCH] net: hns3: Fix for geneve tx checksum bug
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200826051150.2646128-1-yili@winhong.com>
References: <20200826051150.2646128-1-yili@winhong.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Aug 2020 07:10:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yi Li <yili@winhong.com>
Date: Wed, 26 Aug 2020 13:11:50 +0800

> when skb->encapsulation is 0, skb->ip_summed is CHECKSUM_PARTIAL
> and it is udp packet, which has a dest port as the IANA assigned.
> the hardware is expected to do the checksum offload, but the
> hardware will not do the checksum offload when udp dest port is
> 6081.
> 
> This patch fixes it by doing the checksum in software.
> 
> Reported-by: Li Bing <libing@winhong.com>
> Signed-off-by: Yi Li <yili@winhong.com>

Applied, thank you.
