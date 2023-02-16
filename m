Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BFCB698C90
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 07:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbjBPGGV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 01:06:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229782AbjBPGGT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 01:06:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553D437B6E;
        Wed, 15 Feb 2023 22:06:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC33E61EA0;
        Thu, 16 Feb 2023 06:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1792C433D2;
        Thu, 16 Feb 2023 06:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676527573;
        bh=CCfKulX1qMjWRPYQHoEuNu2jHwQvCBGUX2X7aTHWcXQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gEkYBlxFb8i7O7q0KwsaNyFBm2BHFOLj/qJmCbQTUoc0VqMEEThmTygc9H7gAa9fK
         oNQXIRvUIDgaWxTEianN0axPnvKm4O3l3bHKYlOI13IPGqbnuah+O1yU9owJKJ5QNQ
         7fGIW5RRit4tSi/zCZdmaHV/xZnRI+T8SKtfcLHCmRTRVKw80IbISHIdUuXAHp8tOi
         vEYQiTjY9EjCKfCu7Mn0S19Ccgwy0/Zf1BGyJt0uIjChEuOvCBse7ml86Din8b/SNj
         du1OZ3itAPrzC+4sCm/Cw6cpqeTpE6yoUrlKUxNWPwacpPDK+3O8vS/XjtH4KPVPG5
         4IbnSsQIfzkQw==
Message-ID: <748ce7b4-d4e9-ef2a-3d05-6cbfb4085e2b@kernel.org>
Date:   Wed, 15 Feb 2023 23:06:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.7.2
Subject: Re: [net-next 1/3] seg6: factor out End lookup nexthop processing to
 a dedicated function
Content-Language: en-US
To:     Andrea Mayer <andrea.mayer@uniroma2.it>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Cc:     Stefano Salsano <stefano.salsano@uniroma2.it>,
        Paolo Lungaroni <paolo.lungaroni@uniroma2.it>,
        Ahmed Abdelsalam <ahabdels.dev@gmail.com>
References: <20230215134659.7613-1-andrea.mayer@uniroma2.it>
 <20230215134659.7613-2-andrea.mayer@uniroma2.it>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <20230215134659.7613-2-andrea.mayer@uniroma2.it>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/15/23 6:46 AM, Andrea Mayer wrote:
> The End nexthop lookup/input operations are moved into a new helper
> function named input_action_end_finish(). This avoids duplicating the
> code needed to compute the nexthop in the different flavors of the End
> behavior.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>
> ---
>  net/ipv6/seg6_local.c | 16 ++++++++++------
>  1 file changed, 10 insertions(+), 6 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


