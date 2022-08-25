Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A38D85A1594
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:26:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241549AbiHYPYp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242108AbiHYPY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:24:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573D6B99E0;
        Thu, 25 Aug 2022 08:24:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B982B827EF;
        Thu, 25 Aug 2022 15:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7406CC433D7;
        Thu, 25 Aug 2022 15:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661441064;
        bh=7mVkVx68ioUNUhlCoLLM6s92sDizXMGDoPLg+RDE40Y=;
        h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
        b=Xl0yAgWWlqmkiThUAgivfCtuTJS5qtn7abo9Fe/gjAggQQlWlOYQiA2wBjdH4HH+7
         TIaX3oDPSCw9JeCrQFViAWYrojZPj3c5uCFW5JEismq2DiQYFOq9hx421bl/9LwCJa
         rOa/1kaytnVxLqAhUbEwByUNBibc77rvGKIeljSCuEgWYlbBNvBNRlxa7O0+Vp8kaB
         D/NGPevgEME/FEnEwtJ2Q5GykFztcTtOxRUIj5GHVn33UH6u0QfOY9xFBczirb5DRZ
         jStMiycve6cdrSNvpCPWdsN3OfrQaRWecASrfHWodywCZnfNyBW8Fzo5y0nJhqng/7
         g4mMmikEd5Ieg==
Message-ID: <2f7045ed-d3da-b32a-6c9d-98ef6fa79b23@kernel.org>
Date:   Thu, 25 Aug 2022 08:24:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] ipv4: Namespaceify route/error_cost knob
Content-Language: en-US
From:   David Ahern <dsahern@kernel.org>
To:     cgel.zte@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn,
        Yunkai Zhang <zhang.yunkai@zte.com.cn>
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
 <20220824020343.213715-1-xu.xin16@zte.com.cn>
 <6c0c312c-5b95-6650-e002-0ba76bbdd854@kernel.org>
In-Reply-To: <6c0c312c-5b95-6650-e002-0ba76bbdd854@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/25/22 8:23 AM, David Ahern wrote:
> Also, why not ip_rt_error_burst as well? part of the same algorithm.
> 

nevermind. that is patch 2.
