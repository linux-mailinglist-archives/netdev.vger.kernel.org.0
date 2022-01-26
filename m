Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40E049C213
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 04:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237152AbiAZD2f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 22:28:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237143AbiAZD2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 22:28:33 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C938C06161C;
        Tue, 25 Jan 2022 19:28:32 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id s61-20020a17090a69c300b001b4d0427ea2so3525688pjj.4;
        Tue, 25 Jan 2022 19:28:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=eZCPCMPd3mt57EyhCZ62iVdlHE4UKPJRZU4e5HBqWHA=;
        b=DKuaM0vlqb43TGRkH/ny+XUXa1k1TUJ2mufyxWVlhnfxQz+6QQ84zliis9bj87p08O
         kAFn3Yq/GyBduIeMspBM5+3rq/8IRDu9G24NxCxdHdnlj+wu54Iid97mxkToMMDjd3vK
         n9F6h8vDaMPICOgnOVW5eijEO2NzFfRraYHvNoTMXXRKS2Z8NWX0CyeOtrq/2kv1C7NL
         Sdq92N2MD/RINPkwgceUuBTDYew2BLD4Ku5z+Pa62/po/dqC6JOsIJsjrVMgroYAy5Xd
         cgX7DNCmisNTMKtHNGVJwq/YRLogCfY0MK3dt1Y56Ihb8BWT2hFmciEMgtro2wGQeuRS
         zMYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=eZCPCMPd3mt57EyhCZ62iVdlHE4UKPJRZU4e5HBqWHA=;
        b=ZkP6LTG6kVe2YEVhzdDbGUAxxUxhmht5eTIKpqEnfDA+hZyltpMDRSs0bMM/eOaCpI
         dFWOKemmVAcFoZKrAcX8Id6d8lzlobnvMAHbWQOJ5DVd9eO1hpa1Y5eP9mFVyJGc7VNn
         LZqpx7hf12262r3neOZex4EVtleQoom0h891OLaKuy2FGVKXOSQAbZRWerLbmkbfxGNk
         7UK52FbIvpczq9V+1rCnHpvIcBwUwSljowIslLoPmSmuX2yhcCKiqZ64Z/OWVbFAfA2g
         a0fb4pihfmIck8GjdyqFCTUVyXEr5ikUsLCTf/QIg9zJMwCOTxA96c4INvevsQ10HMFC
         vHjw==
X-Gm-Message-State: AOAM5326PNH30GKsNQHYVLaq6OFR5ZdWbOvecZX2wXgj6jAEYS5gbzFV
        7ii2/DXuCsWq7EgoL/9jI10=
X-Google-Smtp-Source: ABdhPJwjbM71sxlpCt6Xf7FgupXigB9yHdggEDOtVYF2wFLRmB38q8EsHngF8+EuYWBLdUSdXqE8bg==
X-Received: by 2002:a17:903:2342:b0:14b:449:d517 with SMTP id c2-20020a170903234200b0014b0449d517mr21617134plh.104.1643167711919;
        Tue, 25 Jan 2022 19:28:31 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id w19sm420047pfu.47.2022.01.25.19.28.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Jan 2022 19:28:31 -0800 (PST)
Message-ID: <08ea3f8d-53df-2fd3-a03f-165840f85b47@gmail.com>
Date:   Tue, 25 Jan 2022 19:28:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [RFC PATCH v7 04/16] net: dsa: tag_qca: move define to include
 linux/dsa
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <20220123013337.20945-1-ansuelsmth@gmail.com>
 <20220123013337.20945-5-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220123013337.20945-5-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/22/2022 5:33 PM, Ansuel Smith wrote:
> Move tag_qca define to include dir linux/dsa as the qca8k require access
> to the tagger define to support in-band mdio read/write using ethernet
> packet.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
