Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12A7B88395
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 21:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727275AbfHIT7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 15:59:03 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37252 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726022AbfHIT7C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 15:59:02 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4763C144A3A68;
        Fri,  9 Aug 2019 12:59:02 -0700 (PDT)
Date:   Fri, 09 Aug 2019 12:59:01 -0700 (PDT)
Message-Id: <20190809.125901.428600986132688806.davem@davemloft.net>
To:     johunt@akamai.com
Cc:     netdev@vger.kernel.org, edumazet@google.com, ncardwell@google.com
Subject: Re: [PATCH v2 1/2] tcp: add new tcp_mtu_probe_floor sysctl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1565221950-1376-1-git-send-email-johunt@akamai.com>
References: <1565221950-1376-1-git-send-email-johunt@akamai.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 12:59:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Josh Hunt <johunt@akamai.com>
Date: Wed,  7 Aug 2019 19:52:29 -0400

> The current implementation of TCP MTU probing can considerably
> underestimate the MTU on lossy connections allowing the MSS to get down to
> 48. We have found that in almost all of these cases on our networks these
> paths can handle much larger MTUs meaning the connections are being
> artificially limited. Even though TCP MTU probing can raise the MSS back up
> we have seen this not to be the case causing connections to be "stuck" with
> an MSS of 48 when heavy loss is present.
> 
> Prior to pushing out this change we could not keep TCP MTU probing enabled
> b/c of the above reasons. Now with a reasonble floor set we've had it
> enabled for the past 6 months.
> 
> The new sysctl will still default to TCP_MIN_SND_MSS (48), but gives
> administrators the ability to control the floor of MSS probing.
> 
> Signed-off-by: Josh Hunt <johunt@akamai.com>

Applied.
