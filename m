Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58772B0E2E
	for <lists+netdev@lfdr.de>; Thu, 12 Sep 2019 13:44:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731403AbfILLoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Sep 2019 07:44:02 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56550 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730268AbfILLoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Sep 2019 07:44:02 -0400
Received: from localhost (unknown [148.69.85.38])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 12988142D4201;
        Thu, 12 Sep 2019 04:44:00 -0700 (PDT)
Date:   Thu, 12 Sep 2019 13:43:59 +0200 (CEST)
Message-Id: <20190912.134359.345289288863944180.davem@davemloft.net>
To:     steffen.klassert@secunet.com
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        michael@michaelmarley.com, snelson@pensando.io,
        netdev@vger.kernel.org
Subject: Re: [PATCH] ixgbe: Fix secpath usage for IPsec TX offload.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190912110144.GS2879@gauss3.secunet.de>
References: <20190912110144.GS2879@gauss3.secunet.de>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Sep 2019 04:44:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Steffen Klassert <steffen.klassert@secunet.com>
Date: Thu, 12 Sep 2019 13:01:44 +0200

> The ixgbe driver currently does IPsec TX offloading
> based on an existing secpath. However, the secpath
> can also come from the RX side, in this case it is
> misinterpreted for TX offload and the packets are
> dropped with a "bad sa_idx" error. Fix this by using
> the xfrm_offload() function to test for TX offload.
> 
> Fixes: 592594704761 ("ixgbe: process the Tx ipsec offload")
> Reported-by: Michael Marley <michael@michaelmarley.com>
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

I'll apply this directly and queue it up for -stable, thanks.
