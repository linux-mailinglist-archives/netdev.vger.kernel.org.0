Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21E10618E9B
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 04:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229511AbiKDDP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 23:15:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbiKDDPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 23:15:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D05471C40E
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 20:15:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6428B61F2A
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 03:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0F6C433D6;
        Fri,  4 Nov 2022 03:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667531753;
        bh=cTu9DYfGoT1tJq+HuX1P1A7qwxa8FflXU4jwe6PsbOg=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=i9DCuSbTHYLpkGP/ndJEFAVvGOotxO+kbd8fDTdQEBcfqVHHVkSqH9+DdYiWUUEA2
         EP3o2Eu8CEMnGyBLrzIHJEOao++S0HA1FwCAJ9GdBVShRIG65csb3BWYiKAEgxLz/o
         JiNIpghnT+WccYGYSdkAHAdjPeeQNaxmqgdMiQWtfhZo+TdOrgbBk7wUYNXIoahzGW
         H4J/eitqRCvwxlXxSVkneXPmWrqo8aQTKQWv0H1e2OWZ//11BuMbgoPKzlOlwU95Fu
         yFrDWXIx1hCAidjl6m/PZY1F4MUtuUZkO7rjnZZ2zr8Y9NYDqvCkGAT7GPRGiTLgMq
         oVM80+qNWn8vw==
Message-ID: <227cb15b-40ca-e674-6dca-a05699a64d8a@kernel.org>
Date:   Thu, 3 Nov 2022 21:15:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH net-next] net: remove redundant check in
 ip_metrics_convert()
Content-Language: en-US
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        davem@davemloft.net, yoshfuji@linux-ipv6.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
Cc:     weiyongjun1@huawei.com, yuehaibing@huawei.com
References: <20221104022513.168868-1-shaozhengchao@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20221104022513.168868-1-shaozhengchao@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/3/22 8:25 PM, Zhengchao Shao wrote:
> Now ip_metrics_convert() is only called by ip_fib_metrics_init(). Before
> ip_fib_metrics_init() invokes ip_metrics_convert(), it checks whether
> input parameter fc_mx is NULL. Therefore, ip_metrics_convert() doesn't
> need to check fc_mx.
> 
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> ---
>  net/ipv4/metrics.c | 3 ---
>  1 file changed, 3 deletions(-)
> 


Reviewed-by: David Ahern <dsahern@kernel.org>
