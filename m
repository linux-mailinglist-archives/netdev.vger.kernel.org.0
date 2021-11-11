Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB56B44D5E9
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 12:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232570AbhKKLiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 06:38:46 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:54208 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbhKKLiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Nov 2021 06:38:46 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 26B8321B37;
        Thu, 11 Nov 2021 11:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1636630556; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rt8/aMa5Kry7fqouFBixTE9VuPZ3pHAbttQhw0tgJc4=;
        b=tYGz6h/KDA+Q/zJgrUumoUPd7y2S0wD7gXgB8Dlj2FqGCJJxZhq5/5HA1qzKR7H6wbDnas
        1WCfDAhM+uo3mxBihzZHjHCIn0mY+ApqAVvLGq/7ANy1SJx87ErxkEwzCC0UE0A7FAF71I
        /ey+7UqTTJv4VygIHujfmclXPSyl+7M=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1636630556;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rt8/aMa5Kry7fqouFBixTE9VuPZ3pHAbttQhw0tgJc4=;
        b=qLh9JQx9hbbITghv5K0PLtUppefmmFDFNejE4ijyqP/vBAR62yFPrbtNmpT2aWpj8BQEwl
        Sd8oGasviazh+cDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C969313358;
        Thu, 11 Nov 2021 11:35:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lD43LBoAjWFMUAAAMHmgww
        (envelope-from <dkirjanov@suse.de>); Thu, 11 Nov 2021 11:35:54 +0000
Subject: Re: [PATCH v2 0/5] MediaTek Ethernet Patches on MT8195
To:     Biao Huang <biao.huang@mediatek.com>, davem@davemloft.net,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org,
        linux-stm32@st-md-mailman.stormreply.com,
        srv_heupstream@mediatek.com, macpaul.lin@mediatek.com
References: <20211111071214.21027-1-biao.huang@mediatek.com>
From:   Denis Kirjanov <dkirjanov@suse.de>
Message-ID: <c2d3c746-ab32-eb99-0408-1409f43248cd@suse.de>
Date:   Thu, 11 Nov 2021 14:35:53 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211111071214.21027-1-biao.huang@mediatek.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: ru
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



11/11/21 10:12 AM, Biao Huang пишет:
> Changes in v2:
> 1. fix errors/warnings in mediatek-dwmac.yaml with upgraded dtschema tools
> 
> This series include 5 patches:
> 1. add platform level clocks management for dwmac-mediatek
> 2. resue more common features defined in stmmac_platform.c
> 3. add ethernet entry for mt8195
> 4. convert mediatek-dwmac.txt to mediatek-dwmac.yaml
> 5. add ethernet device node for mt8195
all new feature should be sent prefixed with net-next
> 
> Biao Huang (5):
>    net: stmmac: dwmac-mediatek: add platform level clocks management
>    net: stmmac: dwmac-mediatek: Reuse more common features
>    net: stmmac: dwmac-mediatek: add support for mt8195
>    dt-bindings: net: dwmac: Convert mediatek-dwmac to DT schema
>    arm64: dts: mt8195: add ethernet device node
> 
>   .../bindings/net/mediatek-dwmac.txt           |  91 -----
>   .../bindings/net/mediatek-dwmac.yaml          | 211 ++++++++++++
>   arch/arm64/boot/dts/mediatek/mt8195-evb.dts   |  92 +++++
>   arch/arm64/boot/dts/mediatek/mt8195.dtsi      |  70 ++++
>   .../ethernet/stmicro/stmmac/dwmac-mediatek.c  | 313 ++++++++++++++++--
>   5 files changed, 664 insertions(+), 113 deletions(-)
>   delete mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.txt
>   create mode 100644 Documentation/devicetree/bindings/net/mediatek-dwmac.yaml
> 
> --
> 2.18.0
> 
> 
