Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04B987140
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 07:11:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbfHIFLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 01:11:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbfHIFLv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 01:11:51 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5E24614284359;
        Thu,  8 Aug 2019 22:11:51 -0700 (PDT)
Date:   Thu, 08 Aug 2019 22:11:50 -0700 (PDT)
Message-Id: <20190808.221150.639978383290842870.davem@davemloft.net>
To:     john.rutherford@dektech.com.au
Cc:     netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v3] tipc: add loopback device tracking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190807025229.1599-1-john.rutherford@dektech.com.au>
References: <20190807025229.1599-1-john.rutherford@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 22:11:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: john.rutherford@dektech.com.au
Date: Wed,  7 Aug 2019 12:52:29 +1000

> From: John Rutherford <john.rutherford@dektech.com.au>
> 
> Since node internal messages are passed directly to the socket, it is not
> possible to observe those messages via tcpdump or wireshark.
> 
> We now remedy this by making it possible to clone such messages and send
> the clones to the loopback interface.  The clones are dropped at reception
> and have no functional role except making the traffic visible.
> 
> The feature is enabled if network taps are active for the loopback device.
> pcap filtering restrictions require the messages to be presented to the
> receiving side of the loopback device.
> 
> v3 - Function dev_nit_active used to check for network taps.
>    - Procedure netif_rx_ni used to send cloned messages to loopback device.
> 
> Signed-off-by: John Rutherford <john.rutherford@dektech.com.au>
> Acked-by: Jon Maloy <jon.maloy@ericsson.com>
> Acked-by: Ying Xue <ying.xue@windriver.com>

Applied, thank you.
