Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC3106D5F36
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 13:38:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234075AbjDDLig (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 07:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbjDDLig (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 07:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C77230EB;
        Tue,  4 Apr 2023 04:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD28E6327B;
        Tue,  4 Apr 2023 11:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D15D3C433D2;
        Tue,  4 Apr 2023 11:38:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680608292;
        bh=/G8hbWN3k5QsLNgcbUdajkrtEujjF/p390oc4k6zWlo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=U7w8ttORfTp9Pxccl4Es82Wh+Imf5QBP2hKRcXUIVxu7Hpe5T3sgKBliIi6WQdhrq
         tDSvzajnZXillYKQM6I0tBW8SFoRhFUAdQ1A35iNO07O09mwjpVr8R6Lq2CpJz+tYD
         U5t8sWk3XK6kWEyzM0lxi9WaquNStq3QGdxfVm9SOflGO6xDQXr5IkxK/rR5w+rXt2
         sE9XjYeIzW41xwpN+IU9UErwAXOusKLBU96pSb1iBhmopQoNp6aH8sYt/iHiJiil1x
         fISiZyhiC9rFsKp2ObhXshrGX7NQcTLjF3zlttVdzowOuHe/od7a8o752kI2GAyT+n
         /Rass44t45gLg==
Message-ID: <2912dd64-44f7-953b-b1c9-ff79222e9462@kernel.org>
Date:   Tue, 4 Apr 2023 14:38:06 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next v3 2/3] net: ethernet: ti: am65-cpsw: Enable
 QSGMII for J784S4 CPSW9G
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230404061459.1100519-1-s-vadapalli@ti.com>
 <20230404061459.1100519-3-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230404061459.1100519-3-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 04/04/2023 09:14, Siddharth Vadapalli wrote:
> TI's J784S4 SoC supports QSGMII mode with the CPSW9G instance of the
> CPSW Ethernet Switch. Add a new compatible for J784S4 SoC and enable
> QSGMII support for it by adding QSGMII mode to the extra_modes member of
> the "j784s4_cpswxg_pdata" SoC data.
> 
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
