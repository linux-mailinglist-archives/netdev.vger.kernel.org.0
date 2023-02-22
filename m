Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF00C69F79A
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 16:21:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjBVPVf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Feb 2023 10:21:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231600AbjBVPVd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Feb 2023 10:21:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC70E3D084;
        Wed, 22 Feb 2023 07:21:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B29CFB815B4;
        Wed, 22 Feb 2023 15:21:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 327CEC433EF;
        Wed, 22 Feb 2023 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677079267;
        bh=RBYbeNaC2FBnERJkTwJJnkkuWpVod2+YeopDwG9+LGo=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=ESL90y4gXZApY+mGsSSX1D9Gnf187v+ThhNRqTyg0rJ0X6Xkzg/wiqRCd4pbXFm5Y
         fXGj0aEiuuQn+VBOme4k7CiMnC7YnTIoxKby9BbqSlPmDDB8AJf/RsHCDzR0vQ+21R
         ecrlP6BepLzc/0MabO/b/vyoWT0vVwCpat+nsI9dEE8BhtCc2FwyLQKDzHIqAL2tCw
         dLzp9s1ZirDV2qRjdT/NcAtGTiVwIAqtLPuouV1GrRKn/ke4hIM2lMfbZo/A7NiNp5
         +KDRQtr7H2ivq8lt1RiXPJhwVPvSl0v7nAlqF0lQy2+fSUQ+EGUCvqN0LZQeGZxvNk
         Mih6bovu7BGkA==
Message-ID: <65261e80-1fb5-93e3-8956-8d2a3d382405@kernel.org>
Date:   Wed, 22 Feb 2023 08:21:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [PATCH net,v4,2/2] selftests: fib_tests: Add test cases for
 IPv4/IPv6 in route notify
Content-Language: en-US
To:     Lu Wei <luwei32@huawei.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230222083629.335683-1-luwei32@huawei.com>
 <20230222083629.335683-3-luwei32@huawei.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230222083629.335683-3-luwei32@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/22/23 1:36 AM, Lu Wei wrote:
> Add tests to check whether the total fib info length is calculated
> corretly in route notify process.
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  tools/testing/selftests/net/fib_tests.sh | 96 +++++++++++++++++++++++-
>  1 file changed, 95 insertions(+), 1 deletion(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
