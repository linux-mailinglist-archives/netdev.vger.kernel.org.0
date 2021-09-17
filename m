Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D596740FF0F
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 20:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344158AbhIQSRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 14:17:02 -0400
Received: from relay.sw.ru ([185.231.240.75]:55748 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233022AbhIQSRB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 17 Sep 2021 14:17:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:MIME-Version:Date:Message-ID:From:
        Subject; bh=LWsESo8YQJ4hC/QH9xlLPjllNBm94GOzCSD9ZHmOKNE=; b=ws+g6mRJd4TdwWyNt
        2E1PuG3r99ENSF+3FAaGWlBhWRwe1xzxU1b8o5tcsOckHtxfBh8LgZNdwCkckCAONvIPVoqbiEaub
        Zlhty/k5kdnkHnOaV9LMmaDmJzzj/GPIGxXZ2mbmzd7ayuyCUBbKrHYd0OMTstH6be6+eoXpXI534
        =;
Received: from [10.93.0.56]
        by relay.sw.ru with esmtp (Exim 4.94.2)
        (envelope-from <vvs@virtuozzo.com>)
        id 1mRIOf-002MHj-Hb; Fri, 17 Sep 2021 21:15:37 +0300
Subject: Re: [RFC net v7] net: skb_expand_head() adjust skb->truesize
 incorrectly
To:     Jakub Kicinski <kuba@kernel.org>, eric.dumazet@gmail.com
Cc:     netdev@vger.kernel.org,
        Christoph Paasch <christoph.paasch@gmail.com>,
        Hao Sun <sunhao.th@gmail.com>
References: <20210917162418.1437772-1-kuba@kernel.org>
From:   Vasily Averin <vvs@virtuozzo.com>
Message-ID: <950534aa-2a47-2331-bc20-fb41b7f6fa6c@virtuozzo.com>
Date:   Fri, 17 Sep 2021 21:15:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210917162418.1437772-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/21 7:24 PM, Jakub Kicinski wrote:
> From: Vasily Averin <vvs@virtuozzo.com>
> ---
> v7: - shift more magic into helpers
>     - follow Eric's advice and don't inherit non-wmem sks for now
> 
> Looks like we stalled here, let me try to push this forward.
> This builds, is it possible to repro without syzcaller?
> Anyone willing to test?

I'm going to review and test this on this weekend.

Thank you,
	Vasily Averin
