Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A23642F9F6
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 19:16:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242173AbhJORS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 13:18:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242176AbhJORSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 13:18:50 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AD8C061767;
        Fri, 15 Oct 2021 10:16:43 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id i5so555477pla.5;
        Fri, 15 Oct 2021 10:16:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=h1OfWNmPxnvZMni+hSGr/aPakXoUDhVv2xUOS4WlYDg=;
        b=kyPHGZmrPOS/mviCT0sz87P/tWmUvHvWTyD0U+V5YZoy+eLX3dOTwgcgrYP/ebIhX6
         koEADONUdH4BLJPtn8C7gYcbgPz5XTOyogtmKNh1Xgm54h0qwlS7fhqPAYZ93oDeOxqg
         TrbShyJoma34MXNXE8WuNuvNqDjGwwgOoENO1JKNZkyAlHMkJhmc3VZK+3wRKVLCSvAo
         AsMqqyoCn1Ybb68clUy6OtA3YUqcCbKXaK4WN6ej3ca2F+gKrfY7+nZsEhqwF2m7N1dB
         jKuxjODzZjst70vMF+ETB4asYF4+2pjULbLZf4kufZfTjaoUCe5rQGPF171sZfOg4fN8
         PFEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=h1OfWNmPxnvZMni+hSGr/aPakXoUDhVv2xUOS4WlYDg=;
        b=xft/gXjatTmgZc5+mrheuZyMGe4dSHZ1NNAK3aLYFkOoqEGxkVAqavKrXsjZojCLWa
         p18MzmAI4KHRTRZ4INxg3GgEhA05ULENwd8e/YbeV9DwBxkzBs8a93DUKM548fV7dmqb
         PrKaKSuKlLN7PzeFrSe+moCxQMt9GXpLWt/IU3W28n7wsQZcZR6pjCGU14nsn++iNglM
         PFVfUZsecHUGTwifjhISxPQiavK0lc+QZPkXRFkd36iJfgPtJKe+sNVWur3tioz/Su/d
         kf3pCZO1M40yGI8SYHFqcRsoHDzdBAqtiW3DGEk5wb0I20DLhSIVlMcriXBFKaa0Tfsb
         OUWQ==
X-Gm-Message-State: AOAM531F9Fia0mCt0RUuCFkUJnDoIVDTjjipM1WQKJ/gOMYxIw8+QSxm
        NKDfQW5lZFzmxPPLE07j4lA=
X-Google-Smtp-Source: ABdhPJxDnJ9gEfsIjDn1Pb1K/slL3blAcdVmn64+NKMFsrbUb4oQ/BHNdP6eXr2WWDYflbz3V9L6aA==
X-Received: by 2002:a17:902:e74a:b0:13f:3538:fca0 with SMTP id p10-20020a170902e74a00b0013f3538fca0mr12160835plf.22.1634318203132;
        Fri, 15 Oct 2021 10:16:43 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s17sm5666597pfs.91.2021.10.15.10.16.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 10:16:42 -0700 (PDT)
Subject: Re: [PATCH net-next 2/6] ARM: dts: ls1021a-tsn: update RGMII delays
 for sja1105 switch
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Prasanna Vengateshan <prasanna.vengateshan@microchip.com>,
        Ansuel Smith <ansuelsmth@gmail.com>,
        =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>
References: <20211013222313.3767605-1-vladimir.oltean@nxp.com>
 <20211013222313.3767605-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <28551a3d-541e-8538-6a2f-110eeacd0500@gmail.com>
Date:   Fri, 15 Oct 2021 10:16:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> In the new behavior, the sja1105 driver expects there to be explicit
> RGMII delays present on the fixed-link ports, otherwise it will complain
> that it falls back to legacy behavior, which is to apply RGMII delays
> incorrectly derived from the phy-mode string.
> 
> In this case, the legacy behavior of the driver is to not apply delays
> in any direction (mostly because the SJA1105T can't do that, so this
> board uses PCB traces). To preserve that but also silence the driver,
> use explicit delays of 0 ns. The delay information from the phy-mode is
> ignored by new kernels (it's still RGMII as long as it's "rgmii*"
> something), and the explicit {rx,tx}-internal-delay-ps properties are
> ignored by old kernels, so the change works both ways.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
