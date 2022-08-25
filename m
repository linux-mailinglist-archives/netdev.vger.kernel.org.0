Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACC55A15B8
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 17:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242801AbiHYP3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 11:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242785AbiHYP2p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 11:28:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D74677287B;
        Thu, 25 Aug 2022 08:27:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CC92FB829E4;
        Thu, 25 Aug 2022 15:27:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C27EC433D6;
        Thu, 25 Aug 2022 15:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661441225;
        bh=iPoggolhTd2JB2dYAJJlj3S9AAeZwC69mokdlOUIOtA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aqqSasZqBxzFu7GyVW13DMjyKIPdSJNWvyYY9+tCs1W9OcaK0hWQAARRDFTNa1cvJ
         vUYLm/m+2Lq0GF+sxz3iEizo48wMv5g3Ss3Jk6bJpf0kkODOID96BWviV+iLVHReDy
         Skk3CdLE49zWQuiFLs9KQ1EzK6+3Hm9+Lw+lvrjlYkldOuIF1+WzLNEuzSjKiAaH/S
         dyjzZWfuTBC9VUZ5ct9rWERbAPAJE0n+E03w7UCvSKxPQIu4vV3LBLZuaq9aVBZEPh
         Nzzeto3V25C1fZvHxzaWgq9OaF9bfjK2H4pwsRRpZEWvmtiptXMZnSvZ2uh8KvwTEb
         4tAF/76/LTJcw==
Message-ID: <0c540a69-f7a4-dc71-c540-6e0785b2b5c9@kernel.org>
Date:   Thu, 25 Aug 2022 08:27:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.12.0
Subject: Re: [PATCH v2 0/3] Namespaceify two sysctls related with route
Content-Language: en-US
To:     cgel.zte@gmail.com, davem@davemloft.net, kuba@kernel.org,
        yoshfuji@linux-ipv6.org
Cc:     netdev@vger.kernel.org, linl@vger.kernel.org, xu.xin16@zte.com.cn
References: <20220824020051.213658-1-xu.xin16@zte.com.cn>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20220824020051.213658-1-xu.xin16@zte.com.cn>
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

On 8/23/22 7:00 PM, cgel.zte@gmail.com wrote:
> From: xu xin <xu.xin16@zte.com.cn>
> 
> With the rise of cloud native, more and more container applications are
> deployed. The network namespace is one of the foundations of the container.
> The sysctls of error_cost and error_burst are important knobs to control
> the sending frequency of ICMP_DEST_UNREACH packet for ipv4. When different
> containers has requirements on the tuning of error_cost and error_burst,
> for host's security, the sysctls should exist per network namespace.
> 
> Different netns has different requirements on the setting of error_cost
> and error_burst, which are related with limiting the frequency of sending
> ICMP_DEST_UNREACH packets. Enable them to be configured per netns.
> 
> 

you did not respond to the IPv6 question Jakub asked.

I think it is legacy for IPv4 since it pre-dates the move to git and
just never added to IPv6. But, if it is important enough for this to
move to per container then it should be important enough to add for IPv6
too.
