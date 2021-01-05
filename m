Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2D052EA718
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:13:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727374AbhAEJNQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:13:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbhAEJNN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:13:13 -0500
Received: from ozlabs.org (ozlabs.org [IPv6:2401:3900:2:1::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EF9C061574;
        Tue,  5 Jan 2021 01:12:33 -0800 (PST)
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4D96G46wxFz9sVv;
        Tue,  5 Jan 2021 20:12:25 +1100 (AEDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1609837949;
        bh=yIBmNFY7IIvoYm6vloU8xR4+rOYHg+/39Nso3nw/G/Q=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=QJ4XIMcNpUoJzuoLThPU+S4kvNMOQ0JvXD2FvV7JBizappV2V81lztYDSaaWc0wxx
         sO6nyx6xdkOItuNnYiaiTPTFfA9U0pVjjLcpdcXrNwMgyIkmKa+WiW2eC06NgIytj1
         82IZMpTp/X8XdxCWmUSruiSHlTN5O80eA0yTgHnMnMkB8nvzyVNqW3m5XfzHRA/wQb
         QJ99m/4s1CLJUSuRcwV9z5oMq+lW7zDxsVtCu9grXdkmpEgnNN7q/5BbaTs3Q5irMq
         SkYUXf2ksR4jMHHYVR7JsY578JXhi0wrpnY/6w+OqRmyU1DUhNOmCD1MWqeelicQOS
         n7J7OF+aLF9Ng==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        pantelis.antoniou@gmail.com, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] net: ethernet: fs_enet: Add missing MODULE_LICENSE
In-Reply-To: <X/PRX+RziaU3IJGi@lunn.ch>
References: <20210105022229.54601-1-mpe@ellerman.id.au> <X/PRX+RziaU3IJGi@lunn.ch>
Date:   Tue, 05 Jan 2021 20:12:21 +1100
Message-ID: <87zh1ng32i.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:
> On Tue, Jan 05, 2021 at 01:22:29PM +1100, Michael Ellerman wrote:
>> Since commit 1d6cd3929360 ("modpost: turn missing MODULE_LICENSE()
>> into error") the ppc32_allmodconfig build fails with:
>> 
>>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-fec.o
>>   ERROR: modpost: missing MODULE_LICENSE() in drivers/net/ethernet/freescale/fs_enet/mii-bitbang.o
>> 
>> Add the missing MODULE_LICENSEs to fix the build. Both files include a
>> copyright header indicating they are GPL v2.
>> 
>> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
>> ---
>>  drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c | 1 +
>>  drivers/net/ethernet/freescale/fs_enet/mii-fec.c     | 1 +
>>  2 files changed, 2 insertions(+)
>> 
>> diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
>> index c8e5d889bd81..76ac1a9eab58 100644
>> --- a/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
>> +++ b/drivers/net/ethernet/freescale/fs_enet/mii-bitbang.c
>> @@ -223,3 +223,4 @@ static struct platform_driver fs_enet_bb_mdio_driver = {
>>  };
>>  
>>  module_platform_driver(fs_enet_bb_mdio_driver);
>> +MODULE_LICENSE("GPL v2");
>> diff --git a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
>> index 8b51ee142fa3..407c330b432f 100644
>> --- a/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
>> +++ b/drivers/net/ethernet/freescale/fs_enet/mii-fec.c
>> @@ -224,3 +224,4 @@ static struct platform_driver fs_enet_fec_mdio_driver = {
>>  };
>>  
>>  module_platform_driver(fs_enet_fec_mdio_driver);
>> +MODULE_LICENSE("GPL v2");
>
> Hi Michael
>
> The use of "GPL v2" has been deprecated. Please use just "GPL". There
> is a discussion about this here:
>
> https://lore.kernel.org/patchwork/patch/1036331/
>
> https://www.kernel.org/doc/html/latest/process/license-rules.html#id1

Ah sorry, I just grepped for "GPL v2" and saw lots of examples so copied
that. Will post a new version using "GPL".

cheers
