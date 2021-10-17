Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2048443063D
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 04:36:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244833AbhJQCi3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Oct 2021 22:38:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhJQCi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Oct 2021 22:38:28 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C10E6C061765;
        Sat, 16 Oct 2021 19:36:18 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so1355260otq.12;
        Sat, 16 Oct 2021 19:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vt2nE+05nEFgW4xYDB3lt8X/MwGWDGhqcK2RI3W6Hoc=;
        b=Ol6bg9uYISr4XILXrDsRKmR+Lewl42+rHGZV0WwSZTcEsVTEaWzh7cNkyNGU5Jfwr4
         r75D/qEGGTuzktMZ6U0/A1C88B3mo5d9XELVy4bld6/xpmNMYtfWMhNQJ6t3WNMJFE0G
         /7wxXlQSAtl9zHxkDoffQ6mBnDAKXxLQNyA2ETbc4avsF9SHCNrHaacvFy681EmzT/+A
         kazwEknRtIT3mZHaob2HW9yyxrOZq5Ouo5cc/MJWAQpmMwtXqmvrBqqoRAzaUb1xFiAh
         stfibIpGZa7Mghgmwn81eLiRxfil+DP1L0/2Qi9rmn/26L7M3SB1ppNP5g0DRQFVmZrt
         rLYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vt2nE+05nEFgW4xYDB3lt8X/MwGWDGhqcK2RI3W6Hoc=;
        b=Ni9IQls3DBRYpBJNIFQxnhyRi/unLIJLpVmV4sgQ0X4SxcHVzfXL0I12qDukwudb/E
         KcDQljZHPQARKqtxlgnDZc014tLwyDcHtsBagz0Q4qlczsKpNnulDPVH7eSqjqotchnF
         uSBAV092B/k2/eFqPawXHHqgAj+2szVxqM+xqHlG6g+ug4wCDQaNmd/NJhK6Er7s5ffv
         bQOro4PI+3mAp7rFBYPIQNnPsp1mVVKTz+mIPwzuSb+5Goc0xyrEkfmvk+xD2rHsHE5V
         QuVPfLsl7cJS2G6w5qghLC218OFjBVGIqmJpr3Kss4eHcrpoaqbBJ/nwDtvQizQ5KNzb
         RsrA==
X-Gm-Message-State: AOAM531HcTnRfWA6ikFEpR1ZNOjxQmhjbG6oHLo7Qt/ESmSeY8t2Vr8O
        OJGwjt7NzWBmMMMDrywdbss=
X-Google-Smtp-Source: ABdhPJwyjQIR9Vz4lTFACirNg9EtFSS20B1jGSPa5ISdqOi/w2j2zcwvJtoXpYFpOL5YVwUg1TQeMA==
X-Received: by 2002:a9d:6483:: with SMTP id g3mr15702924otl.105.1634438177976;
        Sat, 16 Oct 2021 19:36:17 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:71b0:fa9a:856:a7fd? ([2600:1700:dfe0:49f0:71b0:fa9a:856:a7fd])
        by smtp.gmail.com with ESMTPSA id l10sm2166160otj.9.2021.10.16.19.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Oct 2021 19:36:17 -0700 (PDT)
Message-ID: <cd6a03b9-af49-97b4-6869-d51b461bf50a@gmail.com>
Date:   Sat, 16 Oct 2021 19:36:14 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH net] net: dsa: mt7530: correct ds->num_ports
Content-Language: en-US
To:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
References: <20211016062414.783863-1-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211016062414.783863-1-dqfext@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/15/2021 11:24 PM, DENG Qingfang wrote:
> Setting ds->num_ports to DSA_MAX_PORTS made DSA core allocate unnecessary
> dsa_port's and call mt7530_port_disable for non-existent ports.
> 
> Set it to MT7530_NUM_PORTS to fix that, and dsa_is_user_port check in
> port_enable/disable is no longer required.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>

Do you really want to target the net tree for this change?
-- 
Florian
