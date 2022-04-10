Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EFED4FAF81
	for <lists+netdev@lfdr.de>; Sun, 10 Apr 2022 20:00:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232884AbiDJSC4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Apr 2022 14:02:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240531AbiDJSCc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Apr 2022 14:02:32 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B55C260DB7
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 11:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DD029CE1113
        for <netdev@vger.kernel.org>; Sun, 10 Apr 2022 18:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94FB6C385A1;
        Sun, 10 Apr 2022 18:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649613618;
        bh=flbQm9pdz61k2OfLsM8fnlztg37RQ54NFC0JRcUaj6E=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qzLd6SHPwXuD2dA+W2vLyhofYNe+kDt+kVrH93OxJY1EkqpQ9dFCbqsL4FKmejlpH
         ub5hm5ydqfR0x2RlepqSIMRsJAs3f3ddFAhRPz5GHRaIMqGObH0PbBbGIqKz0vcy0t
         yYzvC0mvSqhB9WqBOSBWXmap9dXX+FMy5ouAQLiFIiFcw9TRAWn0PbClOjYoyGzo5I
         vi/YWXi3gAl6UNoEqozA1z8plVIMCN8vVRN90YYU3JNPT1xKGV9YJLmsVp3R6IQUuA
         n7J8V23AB2JTCX5ZKCQHlK+dM3tBYN6ApLKe91iS8b2PFfx8A5ZqgIbMgUSuLLuUvL
         kM1alWwqSG0Eg==
Message-ID: <96ce3beb-7772-5027-5629-80932dc1aa5c@kernel.org>
Date:   Sun, 10 Apr 2022 12:00:16 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: [PATCH net-next 3/5] netdevsim: Use dscp_t in struct nsim_fib4_rt
Content-Language: en-US
To:     Guillaume Nault <gnault@redhat.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, Taras Chornyi <tchornyi@marvell.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Petr Machata <petrm@nvidia.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>
References: <cover.1649445279.git.gnault@redhat.com>
 <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <1f643c547fc22298afe21953492112de9b9df872.1649445279.git.gnault@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/8/22 2:08 PM, Guillaume Nault wrote:
> Use the new dscp_t type to replace the tos field of struct
> nsim_fib4_rt. This ensures ECN bits are ignored and makes it compatible
> with the dscp fields of struct fib_entry_notifier_info and struct
> fib_rt_info.
> 
> This also allows sparse to flag potential incorrect uses of DSCP and
> ECN bits.
> 
> Signed-off-by: Guillaume Nault <gnault@redhat.com>
> ---
>  drivers/net/netdevsim/fib.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

