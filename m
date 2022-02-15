Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 709DF4B76D2
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 21:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243384AbiBOTK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 14:10:57 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234523AbiBOTK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 14:10:56 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28540C24AE;
        Tue, 15 Feb 2022 11:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=h0p8O9gXSl2oatpZsX3v3JE9N4rU455HYsfn15c1I5U=; b=qisigwdnkwldKdXiLCYJ7ua469
        BL6e/2sA7gbC9hhykcuxQg8TwqlNgJPogvDA7EgzYoWNPef8WJZCib/aaOqC5H3WsNUrHx1FI8pUN
        WDlcNl6MuPH0rIz/wpj+4KJ+4VWDs2hNGuTWZw154YOE+uCAoMUoO0YLHRa1ZJP6HCmSRhNB8FKC9
        bXJRCxrHaQyNPfxnIwEzgSPsM0xToyZYMIiZvTeF9ZgfEYxnUJTfs7xHQDs5Ac9wPumVi2XRosdd9
        N3YjFQttbSuDO+luIBJT16wcj6zfriJ4h4UHoCsXcneyvtaknvFJdlSG7QbCYX08RY1/VsfpYreqz
        GNdgxAaQ==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by casper.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nK3DK-00E6VJ-LC; Tue, 15 Feb 2022 19:10:14 +0000
Message-ID: <038caecf-b367-23db-1f9c-8d84d46d3924@infradead.org>
Date:   Tue, 15 Feb 2022 11:10:07 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH] net: ethernet: xilinx: cleanup comments
Content-Language: en-US
To:     trix@redhat.com, davem@davemloft.net, kuba@kernel.org,
        michal.simek@xilinx.com, radhey.shyam.pandey@xilinx.com,
        gary@garyguo.net, esben@geanix.com, huangguangbin2@huawei.com,
        michael@walle.cc, moyufeng@huawei.com, arnd@arndb.de,
        chenhao288@hisilicon.com, andrew@lunn.ch,
        prabhakar.mahadev-lad.rj@bp.renesas.com, yuehaibing@huawei.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <20220215190447.3030710-1-trix@redhat.com>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20220215190447.3030710-1-trix@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/15/22 11:04, trix@redhat.com wrote:
> From: Tom Rix <trix@redhat.com>
> 
> Remove the second 'the'.
> Replacements:
> endiannes to endianness
> areconnected to are connected
> Mamagement to Management
> undoccumented to undocumented
> Xilink to Xilinx
> strucutre to structure
> 
> Signed-off-by: Tom Rix <trix@redhat.com>

Reviewed-by: Randy Dunlap <rdunlap@infradead.org>

thanks.

> ---
>  drivers/net/ethernet/xilinx/Kconfig               | 2 +-
>  drivers/net/ethernet/xilinx/ll_temac.h            | 4 ++--
>  drivers/net/ethernet/xilinx/ll_temac_main.c       | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_axienet_main.c | 2 +-
>  drivers/net/ethernet/xilinx/xilinx_emaclite.c     | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)


-- 
~Randy
