Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C8DA63C1F7
	for <lists+netdev@lfdr.de>; Tue, 29 Nov 2022 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234088AbiK2OKl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Nov 2022 09:10:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235125AbiK2OKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Nov 2022 09:10:21 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 539E65FBBA;
        Tue, 29 Nov 2022 06:10:20 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 11A6221B30;
        Tue, 29 Nov 2022 14:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1669731019; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bNCCZNV8OGv2lGF4X9G7d9QfW4BFyQYsCaGorsDK6GE=;
        b=iTpJX2ZXzAqixvLgPLBpDZgiVgphQVCQBrkVZsD7M+pTpTdrPDayT998sG9s0EZJmYCfqk
        icumrQr4JDbRupSSWpRw9QDDPqix1jxm28xLivCIJTVsF0zgdj5rnz2jIxHTJj/V7v2/IZ
        k74uwtzQuxl5Cwl9J//uCrXnV4wKDb0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1669731019;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bNCCZNV8OGv2lGF4X9G7d9QfW4BFyQYsCaGorsDK6GE=;
        b=W6QXk1P1i2wXZtJ9BgVFpJ8uupCXZ7EHI6uNLC/BI9zIE2Bs06hHDUkj803+EMcpr2hKWH
        EVufHhpC6zUemlAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E478B13428;
        Tue, 29 Nov 2022 14:10:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4E17N8oShmMcSAAAMHmgww
        (envelope-from <afaerber@suse.de>); Tue, 29 Nov 2022 14:10:18 +0000
Message-ID: <2d9c0d89-15c1-bd10-18ac-2e10d451c20f@suse.de>
Date:   Tue, 29 Nov 2022 15:10:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH v2 1/5] dt-bindings: net: snps, dwmac: add NXP S32CC
 support
Content-Language: en-US
To:     Chester Lin <clin@suse.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     netdev@vger.kernel.org, s32@nxp.com, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matthias Brugger <mbrugger@suse.com>,
        Jan Petrous <jan.petrous@nxp.com>
References: <20221128054920.2113-1-clin@suse.com>
 <20221128054920.2113-2-clin@suse.com>
From:   =?UTF-8?Q?Andreas_F=c3=a4rber?= <afaerber@suse.de>
In-Reply-To: <20221128054920.2113-2-clin@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Chester,

Am 28.11.22 um 06:49 schrieb Chester Lin:
> Add a new compatible string for NXP S32CC DWMAC glue driver. The maxItems
> of clock and clock-names need be increased because S32CC has up to 11
> clocks for its DWMAC.
> 
> Signed-off-by: Chester Lin <clin@suse.com>
> ---
> 
> No change in v2.
> 
>   Documentation/devicetree/bindings/net/snps,dwmac.yaml | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/net/snps,dwmac.yaml b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> index 13b984076af5..c174d173591e 100644
> --- a/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> +++ b/Documentation/devicetree/bindings/net/snps,dwmac.yaml
> @@ -65,6 +65,7 @@ properties:
>           - ingenic,x2000-mac
>           - loongson,ls2k-dwmac
>           - loongson,ls7a-dwmac
> +        - nxp,s32cc-dwmac

As we had discussed offline, please change this to nxp,s32g2-dwmac.
S32G3 and S32R45 can then reuse it if they don't require changes; there 
is no difference here to how i.MX family or other vendors inherit IP 
across SoC models, so Rob's rules apply equally.

Also affects the following patches.

Thanks,
Andreas

>           - renesas,r9a06g032-gmac
>           - renesas,rzn1-gmac
>           - rockchip,px30-gmac
[snip]

-- 
SUSE Software Solutions Germany GmbH
Frankenstraße 146, 90461 Nürnberg, Germany
GF: Ivo Totev, Andrew Myers, Andrew McDonald, Boudien Moerman
HRB 36809 (AG Nürnberg)
