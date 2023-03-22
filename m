Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B383D6C4F6F
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 16:30:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbjCVPaC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 11:30:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbjCVPaB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 11:30:01 -0400
Received: from out-1.mta0.migadu.com (out-1.mta0.migadu.com [IPv6:2001:41d0:1004:224b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E0AF67805
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 08:30:00 -0700 (PDT)
Message-ID: <761f463f-7e0f-d53b-540d-d1bedd4fc7e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1679498998;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0rxe9dmu0T6UwAphM6KyWHPR0EEhgnJZ6htJV13AY6I=;
        b=Eq/gkaTMaQFe14wnCIhhzXuHeFUlxMqq0rE1TiQJP7kpb3WeJSRkoUhneiNXhYJJDnxYe+
        yCScd4jOHMOEbpegaSPT4BgS9UpWSQ2I6VwBtfCtuH8U+gZC07IvUuFCUhsMsoCZH9hxyT
        +skAVbEsF6QpETOfR04p96oEF0KWZqU=
Date:   Wed, 22 Mar 2023 15:29:48 +0000
MIME-Version: 1.0
Subject: Re: [PATCH net-next v2 0/3] bnxt PTP optimizations
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>,
        michael.chan@broadcom.com, kuba@kernel.org
Cc:     davem@davemloft.net, edumazet@google.com, gospo@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com, richardcochran@gmail.com
References: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Vadim Fedorenko <vadim.fedorenko@linux.dev>
In-Reply-To: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/03/2023 14:44, Pavan Chebbi wrote:
> Patches to
> 1. Enforce software based freq adjustments only on shared PHC NIC
> 
> 2. A prerequisite change to expand capability storage field to
> accommodate more Firmware reported capabilities
> 
> v1-->v2:
>    Addressed comments by vadim.fedorenko@linux.dev
> 
> Pavan Chebbi (3):
>    bnxt: Change fw_cap to u64 to accommodate more capability bits
>    bnxt: Defer PTP initialization to after querying function caps
>    bnxt: Enforce PTP software freq adjustments only when in non-RTC mode
> 
>   drivers/net/ethernet/broadcom/bnxt/bnxt.c     |  4 +-
>   drivers/net/ethernet/broadcom/bnxt/bnxt.h     | 57 ++++++++++---------
>   drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c | 14 +++--
>   3 files changed, 42 insertions(+), 33 deletions(-)
> 

Thanks!

For the series:
Acked-by: Vadim Fedorenko <vadim.fedorenko>
