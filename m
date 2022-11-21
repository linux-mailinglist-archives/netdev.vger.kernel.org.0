Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20DE632D89
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 20:58:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbiKUT6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 14:58:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiKUT6Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 14:58:25 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305E4175BD
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:58:24 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id l2so7961658qtq.11
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 11:58:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=roY5NqG2PEC4pyN9dyCkwAclUI/eka46qDrHywcvw2g=;
        b=SDwoR2FB5X0l05NZxBm4m41zx2L08rGOd5hv2q/HBxYWFu4ZzhyAZ7gvzDxzPRoYgO
         jkQR98vFZgJdhkn+Nc8fKvcaAjCyveF9w77CrCLA/fglEe5IYWWj4gkb5JePqraMhpwZ
         hcUvjBrqifUY6GdK4sMPSJanuAAUtOVGWiReyrd/CT/W0mZVJQqbeCaapuhzKrrd7DO6
         rxwjVssKa4J/oRryVUXDjDY9mPiNYG9pBLccEu+swC9nhAojiG9o8MmklrSrS4yejx+I
         t2FKRGo//GhlOMDYHYjxxhEEzwq22qfm7x+qiLe8c4l/VzQ1blVguWV8reGrqI29pGYJ
         UdCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=roY5NqG2PEC4pyN9dyCkwAclUI/eka46qDrHywcvw2g=;
        b=uG2RWZYTyDlQhSCE1PjEAjlzDfalE46X32BW+PUgXMgNc+R7gxSCiCU18WEbe89KVI
         bRQRX5h+hi7mXYj2HRz86HdOHVJ++icXRMfP6xXCPOuqFjkISlbGxvZSf3n327RPnmkV
         hJUIRCvzoUVtQzpYYOfmeiuAmLn3alXGkZdE1KGTNVLw439Mikgfquo1HZt1U5ojWIQH
         Di5vXeGMmvwhKtoWwDZZp2K51xd5sCnCG3SVJWvCUNiCstBO8hf6HBKrfAq+9ohnAIIu
         duNN5pmlZOokEThXxsMh8gLH1PwWgeD3HW2RyPh/v4GtJiBQG5FbXfD01Z0/CWf1CErf
         j4qA==
X-Gm-Message-State: ANoB5pm20yBfbgV/UASjB3xV9cuomfgPlNgz6aJH19Y4BxiTILVIR7jb
        IdyIqYoZByl//aUTdjKKOhOc5BQVjXM=
X-Google-Smtp-Source: AA0mqf4Dhh/WuX2fuH4TIWGRUn6x3QWR1niHOp7wyr/oBPHQYMFkiJ0iZykLRvmjDn5QI5c3X3lZlA==
X-Received: by 2002:ac8:775b:0:b0:3a5:8182:cce0 with SMTP id g27-20020ac8775b000000b003a58182cce0mr18348402qtu.446.1669060703308;
        Mon, 21 Nov 2022 11:58:23 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o22-20020a05620a2a1600b006eeb3165554sm8956419qkp.19.2022.11.21.11.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Nov 2022 11:58:22 -0800 (PST)
Message-ID: <298ccdc6-a0b3-ea0b-a38c-27903ab4c993@gmail.com>
Date:   Mon, 21 Nov 2022 11:58:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next 04/17] net: dsa: if ds->setup is true,
 ds->devlink is always non-NULL
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
References: <20221121135555.1227271-1-vladimir.oltean@nxp.com>
 <20221121135555.1227271-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221121135555.1227271-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/21/22 05:55, Vladimir Oltean wrote:
> Simplify dsa_switch_teardown() to remove the NULL checking for
> ds->devlink.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

