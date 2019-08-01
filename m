Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B03A7D6D3
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 10:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730593AbfHAH7w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:59:52 -0400
Received: from first.geanix.com ([116.203.34.67]:33310 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728528AbfHAH7v (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 03:59:51 -0400
Received: from [192.168.8.20] (unknown [85.184.140.241])
        by first.geanix.com (Postfix) with ESMTPSA id 179B8B82;
        Thu,  1 Aug 2019 07:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1564646377; bh=bqSW8N5/HhtbhEB5rZZbOlI+x9iOGq4D7clal5rL8S4=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=layg9ZS6arHsJUH4dF4n3AG6I3f/qB6sAyvaOVQucygZAIMD716xf5qey/pzzz3ya
         xrylqquvvqKeXoAZPc7IDvyUtYDKgMwbTbyvNQ0Pwy83Yf9AdZU3xMZXaP+CEnpQFs
         iZoYFBczcDYALjZQHQSSX9TmgaFDECSWhBClwcm0GBZ+ynQ+FOYad/i8UdgFI0oBgh
         Knnfr+t46ajz1rkzq0/JUYgsY6RewAB55Rx7nDqTkiyPrR9qnlbFjyLOSdgZtGNjA6
         vRvFR0/iNmymeNrl32GW6qoreeasP+edlo5C66P4ZBIYQFF2pteKgloxdnFo5Ac6LQ
         jaZ0VPNseqcxA==
Subject: Re: [PATCH] can: flexcan: free error skb if enqueueing failed
To:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-can@vger.kernel.org
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sean Nyekjaer <sean@geanix.com>
References: <20190715185308.104333-1-martin@geanix.com>
From:   =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>
Message-ID: <d5f8811e-4b85-776a-668f-33f64ec6ef16@geanix.com>
Date:   Thu, 1 Aug 2019 09:59:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190715185308.104333-1-martin@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=3.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 1ffa6606a633
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 15/07/2019 20.53, Martin Hundebøll wrote:
> If the call to can_rx_offload_queue_sorted() fails, the passed skb isn't
> consumed, so the caller must do so.
> 
> Fixes: 30164759db1b ("can: flexcan: make use of rx-offload's irq_offload_fifo")
> Signed-off-by: Martin Hundebøll <martin@geanix.com>

Ping.
