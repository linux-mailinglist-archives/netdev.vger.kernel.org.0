Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7A6F506111
	for <lists+netdev@lfdr.de>; Tue, 19 Apr 2022 02:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242634AbiDSArS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Apr 2022 20:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242594AbiDSAqr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Apr 2022 20:46:47 -0400
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1897631522
        for <netdev@vger.kernel.org>; Mon, 18 Apr 2022 17:43:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1650329001; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=R96Ei4VHoRqv6tnYJx5ts/1uW6+JUQFTm1vIbOryR5Ot0/IApz3lclz2iglRkBWO7yZRloGS7Jl/BFqPp/2voo/n/ZS5G25AKmDCoc1pj4N5Yxesbc+mwN6HDztgz79lIYb/kMgJfai/MyxMgS8cDq50zMwXya1dszs8Nwn67lw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1650329001; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=vH4F6bwEf7yqLS8773Pi6FjnitkGDwf/gSI7isNWcvE=; 
        b=LwvPwS43FYwhwjKOdj+3zALwP65g5j9VNGX9C5qkKzyTfYOknFXL9Hg0XQip+VhOgi/aZ4/7gs9JjklHUZ4T58QHLO23X+HsIxM8VrQ0FuPFhYk5ToyzpsklwuX6xlfV5D19dXisINIxs/rjrba03CYMmAUWNwOMa3UYutvzEi8=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1650329001;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:Date:MIME-Version:Subject:Subject:To:To:Cc:Cc:References:From:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
        bh=vH4F6bwEf7yqLS8773Pi6FjnitkGDwf/gSI7isNWcvE=;
        b=T9LL6Z2h3R1yLgPI1TX2kHFLa1QJOJCllYX2sQgyPD5a5fQ6qKOSQD0vtQgNTVcG
        jCq+ylaId5IWIpYd7pcVH/btOx3qR5INhSkyorq1GoYTC3216rhQz24ixjWZoWuPkKt
        dTRfIiorxPIdKgp31brbIQDH4OU61JtOr+G/krpw=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 165032899879762.26343193331513; Mon, 18 Apr 2022 17:43:18 -0700 (PDT)
Message-ID: <89a87f52-799d-1f02-1726-45c8473962cc@arinc9.com>
Date:   Tue, 19 Apr 2022 03:43:13 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH net v2 2/2] net: dsa: realtek: remove realtek,rtl8367s
 string
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, alsi@bang-olufsen.dk, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        robh+dt@kernel.org, krzk+dt@kernel.org
References: <20220418233558.13541-1-luizluca@gmail.com>
 <20220418233558.13541-2-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220418233558.13541-2-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19/04/2022 02:35, Luiz Angelo Daros de Luca wrote:
> There is no need to add new compatible strings for each new supported
> chip version. The compatible string is used only to select the subdriver
> (rtl8365mb.c or rtl8366rb.c). Once in the subdriver, it will detect the
> chip model by itself, ignoring which compatible string was used.
> 
> Link: https://lore.kernel.org/netdev/20220414014055.m4wbmr7tdz6hsa3m@bang-olufsen.dk/
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> Reviewed-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Acked-by: Arınç ÜNAL <arinc.unal@arinc9.com>

Cheers.
Arınç
