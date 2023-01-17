Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBC0666DB53
	for <lists+netdev@lfdr.de>; Tue, 17 Jan 2023 11:40:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236700AbjAQKkr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Jan 2023 05:40:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236358AbjAQKjz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Jan 2023 05:39:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC1C252A8;
        Tue, 17 Jan 2023 02:39:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2DE461261;
        Tue, 17 Jan 2023 10:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B507C433D2;
        Tue, 17 Jan 2023 10:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673951982;
        bh=mdaYoCHieqlR/XZypf3TarTc+QlmTt1KMt/bm1NDAz4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sif5820mhWBTYwW9xX+3U+VHdMetfAu71sahgUqIe0lCZw5Djjtlaw6H/hf3wy/7e
         V2O07oyBdG+5eFeS+dorFRiD3/cXCT5J1MsSDfxXhcYji7YFZ3WYivq5CMFS20cxKD
         vITeLJhacnHBKeEGiNAKTMnjq+avDGhtwVbMpaxXYzLQxF+lH8gzhdV7RusS8EadfK
         2aUv7db2dM2RB0ZbsVUZ7A0kCihKoTTSV7vUap3ejqGExBJjx1IYAAj6g3XOUlflI6
         b6HhcCrljZeGbqo2uhh0v9K3txufTYZBJ+z7KZUpGa2YPff+eQKPQ3V68MdfGqRKEv
         NiJlAlqtrolJw==
Message-ID: <a37c0632-08cf-7083-3776-84bdbb33ccd4@kernel.org>
Date:   Tue, 17 Jan 2023 11:39:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH net-next 1/2] dt-bindings: net: add amlogic gxl mdio
 multiplexer
Content-Language: en-US
To:     Jerome Brunet <jbrunet@baylibre.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Da Xue <da@lessconfused.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230116091637.272923-1-jbrunet@baylibre.com>
 <20230116091637.272923-2-jbrunet@baylibre.com>
 <4be60ea2-cb67-7695-1144-bf39453e9e1f@kernel.org>
 <1jzgah1puj.fsf@starbuckisacylon.baylibre.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <1jzgah1puj.fsf@starbuckisacylon.baylibre.com>
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

On 17/01/2023 10:05, Jerome Brunet wrote:
> 
> On Tue 17 Jan 2023 at 09:31, Krzysztof Kozlowski <krzk@kernel.org> wrote:
> 
>> On 16/01/2023 10:16, Jerome Brunet wrote:
>>> Add documentation for the MDIO bus multiplexer found on the Amlogic GXL
>>> SoC family
>>
>> Please use scripts/get_maintainers.pl to get a list of necessary people
>> and lists to CC.  It might happen, that command when run on an older
>> kernel, gives you outdated entries.  Therefore please be sure you base
>> your patches on recent Linux kernel.
>>
> 
> Hi Krzysztof,
> 
> I do use get_maintainers.pl but I also filter based on past experience
> to avoid spamming to much. It seems I stayed on the pre-2015
> requirement to send only to devicetree list (I was actually making an
> exception specifically for DT) ... and there was no complain so far ;)
> 
> I've read documentation again and it is explicit. This will be fixed for
> v2.
> 
> Thanks for pointing this out.

For regular patchsets not spanning over 10 different subsystems (so
total number of CCs should be 5-10), please Cc all
maintainers/reviewers/supporters/lists pointed by maintainers.pl. Skip
git fallback. How your patch should appear in my mailbox if you skip me?
Not everyone are using Patchwork.

Best regards,
Krzysztof

