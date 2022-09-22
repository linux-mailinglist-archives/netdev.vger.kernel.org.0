Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF05D5E7032
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 01:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230131AbiIVXVb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 19:21:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231250AbiIVXV3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 19:21:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2232F113B66
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 16:21:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D35CB81D06
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 23:21:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 482AEC433C1;
        Thu, 22 Sep 2022 23:21:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663888885;
        bh=QPn1ECMi4qN5gXW215RoKcQ7Hir4AgaRYy/xVcI/xYU=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=fprcjiQCrPjoZeMqJ1Zgc36NgC4OV9EXISkINig8rQ6ssCQZz/NFDM9XegAKoB+GX
         ST28Hkt3HZ44ugO6vTggrTH3GUvMs8j5z/5rkI82CH5y7oZFFc10T8SZzmZOupxFqJ
         hAdZINuWbWLftb2g8+2zKkW9RMM9ZV3YRl0qLOTZyTTxmlp3jQEeuoPlxZ4XQOzlWn
         fIdpB2TliDJbwGtvPrvjmcEK4U+uanrj3KY8jZBtkASHYiyjhLWK648dEHLKdxChNI
         bgW+WDih8nQZwz7EtjoryjTjdOYP8+ZFWksiqM5nLVM23L0ZOmmdxUOZw49+ii5/KG
         b/rRL06+iCNQw==
Message-ID: <37d1bcdb-9310-da9e-c962-7c65364e698a@kernel.org>
Date:   Thu, 22 Sep 2022 16:21:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next] link: display 'allmulti' counter
Content-Language: en-US
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
References: <20220919083136.23043-1-nicolas.dichtel@6wind.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220919083136.23043-1-nicolas.dichtel@6wind.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/22 2:31 AM, Nicolas Dichtel wrote:
> This counter is based on the same principle that the 'promiscuity' counter:
> the flag ALLMULTI is displayed only when it is explicitly requested by the
> userland. This counter enables to know if 'allmulti' is configured on an
> interface.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
> ---
>  include/uapi/linux/if_link.h | 1 +
>  ip/ipaddress.c               | 6 ++++++
>  2 files changed, 7 insertions(+)
> 

applied to iproute2-next. Thanks


