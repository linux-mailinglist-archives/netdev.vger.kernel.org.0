Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C43B6D18E4
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 09:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231157AbjCaHq3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 03:46:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231134AbjCaHqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 03:46:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA4F71A96A;
        Fri, 31 Mar 2023 00:46:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 658FCB82A70;
        Fri, 31 Mar 2023 07:46:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC88EC4339B;
        Fri, 31 Mar 2023 07:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680248776;
        bh=sQoLMSdeOiOr1UZIYJbkm7f56W+4+zGiW2fKD1SjjJs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=tO+vNbhIKZEFpk5mRi6rnUyYrTq3G9PsI9FQNsDqiY0WBteQ8a7Cr3gHpY0QZ0366
         U8XG+vvMqyc3EJNgboUUDLdglQFaY1I0JMzaHvX+/ZJaJbRz3iKyR19pmIbF9IBtCi
         blz6zm6sekSXStzm6YlK8cmxt/7nI1ipG8Dsa78GdEysC6eXXh6VkqREMiYTq+uQq3
         os20OUf65MV70yeahTy+cFSV5maoewfO2m/++UBJ0OJkAbQJGuofdrYR+aWlxYLsGY
         s870Z1P4ItewBXEGXX5YObxNP5nVOP0lAuB3EZWzykwA3EOrF5PaOUggBYccmfyHj/
         NMDue0MmdTOSA==
Message-ID: <a787a9a3-2bb6-555d-2764-643d61cee7f8@kernel.org>
Date:   Fri, 31 Mar 2023 10:46:11 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH net-next 0/2] Add support for J784S4 CPSW9G
Content-Language: en-US
To:     Siddharth Vadapalli <s-vadapalli@ti.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, linux@armlinux.org.uk,
        pabeni@redhat.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, srk@ti.com
References: <20230331065110.604516-1-s-vadapalli@ti.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230331065110.604516-1-s-vadapalli@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 31/03/2023 09:51, Siddharth Vadapalli wrote:
> Hello,
> 
> This series adds a new compatible to am65-cpsw driver for the CPSW9G
> instance of the CPSW Ethernet Switch on TI's J784S4 SoC which has 8
> external ports and 1 internal host port.
> 
> The CPSW9G instance supports QSGMII and USXGMII modes for which driver
> support is added.
> 
> Regards,
> Siddharth.
> 
> Siddharth Vadapalli (2):
>   net: ethernet: ti: am65-cpsw: Enable QSGMII for J784S4 CPSW9G
>   net: ethernet: ti: am65-cpsw: Enable USXGMII mode for J784S4 CPSW9G
> 
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 

For this series,

Reviewed-by: Roger Quadros <rogerq@kernel.org>
