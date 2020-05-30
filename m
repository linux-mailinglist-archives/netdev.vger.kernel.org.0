Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74DB71E93E8
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 23:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729290AbgE3VSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 17:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3VSs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 17:18:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2357C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:18:47 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l11so7709313wru.0
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 14:18:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AabL76Y4QDDsMfyVYR8teh02odh5wnypuhutl+YATbM=;
        b=HU8/fQCWnm6X3bnaFOLTBoMq1bLP+XYj7jLMVc3bU/zR+lCIr05kPYJFmxvrygLXPM
         3i+H5tpB4eQY95eHoDhWZsf7chQj1748TnF0TwWsNoXMizHWu5ZyK/iTIGH23FsTQsz6
         Ahj3ubjrS+HfhvmhLU4Jxgph8k/m9fvmrPyi4SdqUVpWo2ilDLSLWewHxSxljA1zXB6G
         2wVbSzb/WBzNdEzQ2t/QiYOV1f2EZEmAWSCok1uFe9jPz6ypK6AaRI9nc7sTXmVoZwpM
         rtW9EYPAkg9f5r5lk4d/B9P81H0juvZzVp3XBYSZ1IiX3s3+xRYMBNOrMpee6LG25kVq
         Nckg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AabL76Y4QDDsMfyVYR8teh02odh5wnypuhutl+YATbM=;
        b=MyFEtjkEbiyVYuLO7Gtcc1ox0UvZuWqKItvQ7nJCSGauhTIN9+W0ee1hqQtegX2Xf6
         tWx1UwlmOSkwEKOW9tWtxRXPssCXetzmVSY1ZLKfF9SKdA9sfzb69O0RLjS/w/mZW43e
         GhvXvocuYIIEBawAc4d+Pdnju8xd0vkewaCWOFRr+EefiFeXi7oVcyUs18Ek5buJvtX3
         q6/NUiBWZaDTAa8D+R+uPRbpk7etnO3VhBm/JwqBAncEGbt4ULa2fW42oBRpaykYY9ad
         jdOPKVCdpsoEqdiNYFtxblY5jhOUwNRQ5W9pbLpEkn9G5qNScLhAKYPMh7opPNnCuVRf
         qLRg==
X-Gm-Message-State: AOAM532gRxKQBDyAdupYDzUR/yN0cZ7sInrvPyfEgrIPt+hBsn+jATTJ
        rpVPkJiTnu/FFQko8udIaB8=
X-Google-Smtp-Source: ABdhPJwkYPWn2Hmm8D6CdJpEHwJD0QBHHVRVj10Z+3p/+v7Ok6XF78dlgFxZp9/BeHiU8DIeYUzDLw==
X-Received: by 2002:a5d:4b47:: with SMTP id w7mr14063098wrs.234.1590873526356;
        Sat, 30 May 2020 14:18:46 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id z9sm3939545wmi.41.2020.05.30.14.18.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 14:18:45 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 05/13] net: mscc: ocelot: convert
 QSYS_SWITCH_PORT_MODE and SYS_PORT_MODE to regfields
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-6-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <88be2af0-b68d-4eea-bfb4-9a7dd5276df8@gmail.com>
Date:   Sat, 30 May 2020 14:18:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-6-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Currently Felix and Ocelot share the same bit layout in these per-port
> registers, but Seville does not. So we need reg_fields for that.
> 
> Actually since these are per-port registers, we need to also specify the
> number of ports, and register size per port, and use the regmap API for
> multiple ports.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> None.

[snip]


>  	/* Core: Enable port for frame transfer */
> -	ocelot_write_rix(ocelot, QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE |
> -			 QSYS_SWITCH_PORT_MODE_SCH_NEXT_CFG(1) |
> -			 QSYS_SWITCH_PORT_MODE_PORT_ENA,
> -			 QSYS_SWITCH_PORT_MODE, port);
> +	ocelot_fields_write(ocelot, port,
> +			    QSYS_SWITCH_PORT_MODE_INGRESS_DROP_MODE, 1);
> +	ocelot_fields_write(ocelot, port,
> +			    QSYS_SWITCH_PORT_MODE_PORT_ENA, 1);

I am a bit confused throughout this patch sometimes SCH_NEXT_CFG is set
to 1, sometimes not, this makes it a bit harder to review the
conversion, assuming this is fine:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
