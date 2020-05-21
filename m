Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A96961DD5A0
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 20:07:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729301AbgEUSG1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 14:06:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728885AbgEUSG0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 14:06:26 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87B26C061A0E;
        Thu, 21 May 2020 11:06:26 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id j21so3534280pgb.7;
        Thu, 21 May 2020 11:06:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=YcuxEZQUpOQDQ5Lr0xl9z9r81E55lsgED1E3qnSscDk=;
        b=eW6v38ZRp+Glo1cdTZumTfkrEClDxGIGVQPUmVnS3h2bbdkhB2hZydHePX9NH5h1WJ
         57JjQzpjr7Rvf30dSJISe8wjDElqD8mdf5NF/ma+HS8eVRio7mqNIoty+w+x26mZ2wgW
         plEeZSv+UOcBad23gyytHzH5bYQLYi3uTMdSPubu6JyoxOXWfmNQQ+HtaXJxDuai6ObI
         7zS0UO/REoAWWzt5XuERqrg0uPzqtUPLi4w4HvBkWzpe4/i39HYb15wITV+hCH7XFXab
         HDWQ92eOQIkbgvNn345fJ8VetC1Mxabbt/pp4Ib6lQLqbtR3hJ32fVdh/ED7udF8mma6
         yYMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YcuxEZQUpOQDQ5Lr0xl9z9r81E55lsgED1E3qnSscDk=;
        b=Z6acBqBJaje/4lu0rl2r0Ewas6v7on76ABMOpagdWCj5xOMYmvjkS4ATW/QDpHzPee
         ragObhdrj1qrpiWLaZuBdo3IGd9sBu/Rdwg2pvcugdJPeKpkJvVEOm8I7RBqZZxbLfr3
         J0lmUtLrO4WVhk5kBQPts0SGxfzrGv/lPFiD6URlw8r5gKysbdQHEVuP3YunhVaF+fMZ
         6iiMLZZWIEvuFEsnuvXNKioPOFfbqq/Rxa1+Iz+6KyigVfwFwXBYFFjsvK8o91bzHiDJ
         MAvOanXnThOF13FVgjo1UL96jf8DFK2ZVs0eMmyEFWg58kR/eryRQb+amyQZYXtoM9/P
         qBew==
X-Gm-Message-State: AOAM533eWfxwDzz4HWyx9u5gpsen5W8cyMHa27Pu+4tzjIss7gLL25sC
        6h3UhszKsuIzDQ9HgVyMGfao65Qo
X-Google-Smtp-Source: ABdhPJznGe2UNZ5jAmqKiPtGqZfklEpUjBlndvAcPOFCKX2xEIJyAGsymq18z1F10/gOSMmTbJvXjQ==
X-Received: by 2002:a63:d918:: with SMTP id r24mr10175031pgg.119.1590084385623;
        Thu, 21 May 2020 11:06:25 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x13sm4910062pjr.20.2020.05.21.11.06.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 11:06:24 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 1/4] dt-bindings: net: Add tx and rx internal
 delays
To:     Dan Murphy <dmurphy@ti.com>, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, robh@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20200521174834.3234-1-dmurphy@ti.com>
 <20200521174834.3234-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <a293624e-bbab-4f9e-3e59-470bff5a90f9@gmail.com>
Date:   Thu, 21 May 2020 11:06:23 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200521174834.3234-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/21/2020 10:48 AM, Dan Murphy wrote:
> tx-internal-delays and rx-internal-delays are a common setting for RGMII
> capable devices.
> 
> These properties are used when the phy-mode or phy-controller is set to
> rgmii-id, rgmii-rxid or rgmii-txid.  These modes indicate to the
> controller that the PHY will add the internal delay for the connection.
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../bindings/net/ethernet-controller.yaml          | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b60ed6a..3f25066c339c 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -143,6 +143,20 @@ properties:
>        Specifies the PHY management type. If auto is set and fixed-link
>        is not specified, it uses MDIO for management.
>  
> +  rx-internal-delay:

Please name this 'rx-internal-delay-ps'

> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Receive PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable RX internal delays.  This property is only
> +      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-rxid.
> +
> +  tx-internal-delay:

Likewise

> +    $ref: /schemas/types.yaml#definitions/uint32
> +    description: |
> +      RGMII Transmit PHY Clock Delay defined in pico seconds.  This is used for
> +      PHY's that have configurable TX internal delays.  This property is only
> +      used when the phy-mode or phy-connection-type is rgmii-id or rgmii-txid.
> +
>    fixed-link:
>      allOf:
>        - if:
> 

-- 
Florian
