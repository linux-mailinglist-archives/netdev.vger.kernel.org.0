Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4C3E77352
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:20:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfGZVUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:20:43 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55286 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:20:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD6D912B8C6D1;
        Fri, 26 Jul 2019 14:20:42 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:20:42 -0700 (PDT)
Message-Id: <20190726.142042.1445031989458540873.davem@davemloft.net>
To:     subashab@codeaurora.org
Cc:     netdev@vger.kernel.org, stranche@codeaurora.org
Subject: Re: [PATCH net] net: qualcomm: rmnet: Fix incorrect UL checksum
 offload logic
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564078032-8754-1-git-send-email-subashab@codeaurora.org>
References: <1564078032-8754-1-git-send-email-subashab@codeaurora.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:20:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Date: Thu, 25 Jul 2019 12:07:12 -0600

> The udp_ip4_ind bit is set only for IPv4 UDP non-fragmented packets
> so that the hardware can flip the checksum to 0xFFFF if the computed
> checksum is 0 per RFC768.
> 
> However, this bit had to be set for IPv6 UDP non fragmented packets
> as well per hardware requirements. Otherwise, IPv6 UDP packets
> with computed checksum as 0 were transmitted by hardware and were
> dropped in the network.
> 
> In addition to setting this bit for IPv6 UDP, the field is also
> appropriately renamed to udp_ind as part of this change.
> 
> Fixes: 5eb5f8608ef1 ("net: qualcomm: rmnet: Add support for TX checksum offload")
> Cc: Sean Tranchetti <stranche@codeaurora.org>
> Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>

Applied and queued up for -stable.
