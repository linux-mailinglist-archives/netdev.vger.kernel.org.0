Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9888AB1B0C
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 11:44:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728479AbfIMJog (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 05:44:36 -0400
Received: from first.geanix.com ([116.203.34.67]:50662 "EHLO first.geanix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbfIMJog (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 05:44:36 -0400
Received: from [192.168.100.95] (unknown [95.138.208.137])
        by first.geanix.com (Postfix) with ESMTPSA id 53BCC6503C;
        Fri, 13 Sep 2019 09:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=geanix.com; s=first;
        t=1568367829; bh=3wWbBizKQzuoPs4Ml3JVzYjHkna3WkG4j9LAsyU+jzM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To;
        b=QQ6SOKjC4LGCjbjgEXrl/5CY9BzowOHa1w6oai65AAgpJl+n7XG8xhub8mSegVl8H
         ZzuR0qGCVIkkAUDojR8++vQrDD0XOGmovazoxbqhjkNzSXwKe+t68WzRR6qNAbj2AQ
         E5fKmIkMPxMNgGBWtZsPX6q7O8gjrJ2PEZO3O4p3AGRiCM4EwqpaVHFE3Slf6kYEeh
         dSrIxS6RwV2/u22fIyP3MMOdNY9EzKZh/yaWy218E69S/xJwepRXrOAQbjtboQATkJ
         LI/aT9xI9dGe+/ODxH4bg7TG6Zq8LRx6XG2qUpXTfVnsPyezzixlFwGCOIQVFi6vGG
         4qvRFbS5cyDtQ==
Subject: Re: [PATCH] can: flexcan: free error skb if enqueueing failed
To:     Marc Kleine-Budde <mkl@pengutronix.de>, linux-can@vger.kernel.org
Cc:     =?UTF-8?Q?Martin_Hundeb=c3=b8ll?= <martin@geanix.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20190715185308.104333-1-martin@geanix.com>
 <d5f8811e-4b85-776a-668f-33f64ec6ef16@geanix.com>
From:   Sean Nyekjaer <sean@geanix.com>
Message-ID: <c40b4b92-8768-6d26-7224-03e5096b4237@geanix.com>
Date:   Fri, 13 Sep 2019 11:44:10 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <d5f8811e-4b85-776a-668f-33f64ec6ef16@geanix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-3.1 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,URIBL_BLOCKED
        autolearn=disabled version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on 77834cc0481d
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 01/08/2019 09.59, Martin Hundebøll wrote:
> On 15/07/2019 20.53, Martin Hundebøll wrote:
>> If the call to can_rx_offload_queue_sorted() fails, the passed skb isn't
>> consumed, so the caller must do so.
>>
>> Fixes: 30164759db1b ("can: flexcan: make use of rx-offload's 
>> irq_offload_fifo")
>> Signed-off-by: Martin Hundebøll <martin@geanix.com>
> 
> Ping.

Hi Marc

Any problems with this? Besides time ;-)

We really need this to be back ported to 4.19, soon...

/Sean
