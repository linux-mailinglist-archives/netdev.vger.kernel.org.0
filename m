Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56C686B9EFA
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 19:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCNSqs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 14:46:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjCNSqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 14:46:44 -0400
Received: from out-44.mta0.migadu.com (out-44.mta0.migadu.com [IPv6:2001:41d0:1004:224b::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DF27B79C0
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 11:46:12 -0700 (PDT)
Message-ID: <73e4028a-b6f0-6978-01b9-bea2cbc32394@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678819550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+7yMsMktjioUsMH13xBR9DL51SE7PiABPArryiRhJ9g=;
        b=cry9TNMfCl/2V9Q0hPDaFYdkKbA/t12DezbXoYre6nLn1aHyTRZY5tvT6G8GhwJnSpLvqL
        Jpz7MHduXh3R93qhKAm+MYQDD6HIH/Dg59gIN3tFqO7RIaMxTMTSyHLSlqsVlUu35891lx
        d5fWmNSXJflnrZmHLRokmzvJdyq64b8=
Date:   Tue, 14 Mar 2023 11:45:43 -0700
MIME-Version: 1.0
Subject: Re: [PATCH net-next 0/2] ipv6: optimize rt6_score_route()
Content-Language: en-US
To:     Eric Dumazet <edumazet@google.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20230313201732.887488-1-edumazet@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Martin KaFai Lau <martin.lau@linux.dev>
In-Reply-To: <20230313201732.887488-1-edumazet@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/13/23 1:17 PM, Eric Dumazet wrote:
> This patch series remove an expensive rwlock acquisition
> in rt6_check_neigh()/rt6_score_route().
> 
> First patch adds missing annotations, and second patch implements
> the optimization.

Reviewed-by: Martin KaFai Lau <martin.lau@kernel.org>

