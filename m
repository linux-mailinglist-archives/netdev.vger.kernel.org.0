Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0174F69B1F2
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 18:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjBQRlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 12:41:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbjBQRlS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 12:41:18 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4DE272E26;
        Fri, 17 Feb 2023 09:41:16 -0800 (PST)
Received: from [10.7.7.5] (unknown [182.253.183.176])
        by gnuweeb.org (Postfix) with ESMTPSA id D09A7830FD;
        Fri, 17 Feb 2023 17:41:11 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1676655676;
        bh=GDNVJL/UdiQ+Jr809KR5bMOXYeBOZBt+hfFgU3xHPds=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QDNw/limDd6YRBKmWj4RzL5fiGfaotrFZH816heVZg1a3/Bqs+WaYlszBhRiaNC4e
         bGXOFcSjhbqQnK+ZIam/joD1WddXIs8sByRO06Ip0omHra2tLmm0PpdtWl4lcD4mPL
         UguCAVKGkqk90O6QcQm2nWeteBpmcNyUYrZ3xWk3MJqCyPl5xPik6La36/g1kj0JEP
         2LcTute5DLxJwOwa8Y/B0+UQzX8XEG0Cg7b2ie7y+cl5pGZKvy9UXXDAdXB5/HhL4v
         rQH5try8eiSfCWEf2Ap2dXO5DSYhMox+rmUzIruTaC5ZZTntXXRpRIaxNe3D8UBo5R
         G9kg3xR8/HWCA==
Message-ID: <a939672c-4b3c-fd4a-8fc8-c3b4437f5265@gnuweeb.org>
Date:   Sat, 18 Feb 2023 00:41:08 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 net-next] sfc: fix ia64 builds without CONFIG_RTC_LIB
To:     alejandro.lucero-palau@amd.com, netdev@vger.kernel.org,
        linux-net-drivers@amd.com
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, habetsm.xilinx@gmail.com,
        ecree.xilinx@gmail.com, linux-doc@vger.kernel.org, corbet@lwn.net,
        jiri@nvidia.com
References: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
Content-Language: en-US
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20230217170348.7402-1-alejandro.lucero-palau@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/18/23 12:03 AM, alejandro.lucero-palau@amd.com wrote:
> -		memset(&build_date, 0, sizeof(build_date)
> +		memset(&build_date, 0, sizeof(build_date);

Missing ")" for the memset.

-- 
Ammar Faizi
