Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF29E5BB8D4
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229652AbiIQOpi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 10:45:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiIQOph (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 10:45:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCCD2DA82;
        Sat, 17 Sep 2022 07:45:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9EB2EB80C75;
        Sat, 17 Sep 2022 14:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E843EC433C1;
        Sat, 17 Sep 2022 14:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663425933;
        bh=/OQZbiyBlKEnscXaDM1BFamg10VDkDfQyL9LzR2MrDE=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=q7tgWx3mwIqEeCbVBLcYfjczNQyfQ4pGDIGo+2ykkwNXqY204wcg9pJOC8/o/i7uH
         3/Fdn0h3ziW7nW4WYHN6c7cvKWRUw5eTLBX4E93U+agShYS1T2AeLTWh5usFIHsV2l
         FJMXRXRDaVEexfUvzqLOAQeEM1VZGf7dl9s3qj0mnW2+4YtzxdbyzgngMGzWMssrrM
         zaw8KabGhtCQyVyHU8sx+OBUYdIP36sR4nAwbwItRTVDtDtep7f1MWMbkrMMxuy+d8
         qDQCInwHUjN+ZzijxipteDIQbQ6Zaoxb34JjL43DDVorUVagfwSuXbJxH47Jxes7CN
         /BrDnoD3/lx5A==
Message-ID: <a297b958-b066-67bc-79ff-1b7d91553dbe@kernel.org>
Date:   Sat, 17 Sep 2022 08:45:31 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH -next] nexthop: simplify code in nh_valid_get_bucket_req
Content-Language: en-US
To:     williamsukatube@163.com, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220917063031.2172-1-williamsukatube@163.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220917063031.2172-1-williamsukatube@163.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/17/22 12:30 AM, williamsukatube@163.com wrote:
> From: William Dean <williamsukatube@163.com>
> 
> It could directly return 'nh_valid_get_bucket_req_res_bucket' to simplify code.
> 
> Signed-off-by: William Dean <williamsukatube@163.com>
> ---
>  net/ipv4/nexthop.c | 6 +-----
>  1 file changed, 1 insertion(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


