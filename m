Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F303D41554A
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 03:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238846AbhIWB7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Sep 2021 21:59:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238177AbhIWB7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Sep 2021 21:59:38 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 602B4C061574;
        Wed, 22 Sep 2021 18:58:07 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id me1so3367045pjb.4;
        Wed, 22 Sep 2021 18:58:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Pl2pxy47WELrNLzeajbBJTra/umYQRtI3a5QLE8Z/Ec=;
        b=jxOu9CLymVv3YKYzl/FZgHEOkbowHgFYkYY+kUxQNcJaorX9jdQg17D4J7GjoWZpQi
         XnVg3/4f/tXBj9MB0HEUJ3iv7fQ7017FHWsbu1I1jDMCjeF1ucsTz5l2bCOsii593wxQ
         mGcyc8kjmYswRUUxLUT+/qBgp/hywahE3vcO/0a2BbAKTAogb/I8KJ++fXTU54YQ+R7A
         FDHo26fgnfH/tmHtIfM1qc3F6A7R07Pa+0Kk+zHXRjBEsssyWPnY5yXwcP+9U8WPm7S/
         eiHC0f0zRdIpKBuUUeUnId3zHH6JiMmnvvDeS38h0kQ8+psqnvBGQbBoxfjN/sIBleT2
         hb0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Pl2pxy47WELrNLzeajbBJTra/umYQRtI3a5QLE8Z/Ec=;
        b=1uH+AWUbNM31X/CRDA4zACHCUs7crlueXNh1/1khbYABhlPz8lH9flUoAq5T5TBx23
         ozUoMaPCwLbt7Btgqn+vJbO5XFetkHeuYla+v+46KjZlu08sp3MuzlVA+rR/FTVfEuDu
         d7PsbqDIz3lmSbP7djs8vqZx/vLrXAPNykP77KSpkTg3DctEzrwFQ/JN3Q9yZLfiy5Dr
         zGvr4YgWXf/a9BGx2qCGD3xF8atKxtj65sAwtz7DiJ9FqWShF99WyaBQKFfpKWc4J14s
         GGe4JWc+tLXovxOEvPWl/UNnLjbMx0loVKirHytZJ7RJUUwEGmlejR5+M2R8seFgPTgL
         SI3w==
X-Gm-Message-State: AOAM533nyl5/CWR5OBeaxMWwiW4VHVvoU1HlUr/+EnpHxgCWLk4bA+fA
        CFLXKDcA+HqdiHCnC2UWyik=
X-Google-Smtp-Source: ABdhPJwPQpquM0dYyKWSZngXnPdXKr5jNOaxE+rxggYhoHpgHMHxEcu3Nq8BFNaBLWWR/X8GtVKlIQ==
X-Received: by 2002:a17:902:e54f:b0:13c:a004:bc86 with SMTP id n15-20020a170902e54f00b0013ca004bc86mr1694868plf.78.1632362286828;
        Wed, 22 Sep 2021 18:58:06 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v197sm3564265pfc.125.2021.09.22.18.57.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Sep 2021 18:58:06 -0700 (PDT)
Message-ID: <07c3172b-83eb-29a7-3dac-da7fb82f785a@gmail.com>
Date:   Wed, 22 Sep 2021 18:57:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.1
Subject: Re: [PATCH v4 net-next 1/8] net: mscc: ocelot: export struct
 ocelot_mact_entry
Content-Language: en-US
To:     Xiaoliang Yang <xiaoliang.yang_1@nxp.com>, davem@davemloft.net,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc:     allan.nielsen@microchip.com, joergen.andreasen@microchip.com,
        UNGLinuxDriver@microchip.com, vinicius.gomes@intel.com,
        michael.chan@broadcom.com, vishal@chelsio.com, saeedm@mellanox.com,
        jiri@mellanox.com, idosch@mellanox.com,
        alexandre.belloni@bootlin.com, kuba@kernel.org, po.liu@nxp.com,
        vladimir.oltean@nxp.com, leoyang.li@nxp.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, claudiu.manoil@nxp.com
References: <20210922105202.12134-1-xiaoliang.yang_1@nxp.com>
 <20210922105202.12134-2-xiaoliang.yang_1@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210922105202.12134-2-xiaoliang.yang_1@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/22/2021 3:51 AM, Xiaoliang Yang wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Felix DSA needs to use this struct to export MAC table write and lookup
> operations as well, for its stream identification functions, so export
> them in preparation of that.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
