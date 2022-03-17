Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21AFD4DC23C
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 10:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231668AbiCQJDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 05:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231665AbiCQJDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 05:03:02 -0400
Received: from mail-ed1-x530.google.com (mail-ed1-x530.google.com [IPv6:2a00:1450:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 407CF1D12C2
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:47 -0700 (PDT)
Received: by mail-ed1-x530.google.com with SMTP id a17so4656534edm.9
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 02:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=HtMS2+9V7qd6zUhJqmshIHceW7JGRRmz5hCKeup/FwU=;
        b=v1E7SzBfSt8587wvWB/smgDMZ9JEHt+ZoQNwOn2uA49pYqLeUsEf7felGz0ynrFCTS
         Ti6vYpZHB2JzO6+pYzVwPVQffy63WI+ZOLfXgGKBUkBeAALAOVtAOpDhKmoZYipOcbIU
         CtPpPvHUhDP81OKvzPH7kVJQ+uhR6M92XhPfqT/vIM5IrWl+QFCfYZ0v8TDfx/gMLTUj
         1tV8l9+DZRyAmp1s+HCBoTXinca+zvnDhe+4NiXFOUpx4Py90gI8tXCgFeF+DpVeyfqC
         /KqwuVs7uVIc9JUwSDFpYEYaCUTh3L1YqKugIfg0TiAlYaPH9MIMh076qLIpRJVjyXQ4
         w1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=HtMS2+9V7qd6zUhJqmshIHceW7JGRRmz5hCKeup/FwU=;
        b=ZtO3MIie7t9l9tBiyfQ8i5e08JfqZvoBqJWGhyoKZpN5iahwA2mwQPXkl9TjvIIF2p
         IiP/yV2dgE4LExoaWs3Y6QSbtVmAuRctpavb8SmNp1m5Br4qduAkVVXA76loWW8jlQkV
         2h2LSEA6zYx+Zvfvjnt/MaTgJ/lZ6wDgDLISYriHCeEp9y0iMZXQvaUeheYtDNBdKwRn
         764XX/4G1aPbAIG8Tfn/P6yZWONm6DTI2MrVdmpMTTS0S8HHezXf+DaKHzsVW7Hj4zqB
         nogDnw74gYmZrvxCdj1amoAUYEKWn91QEYKNQHC3ohS455GXUoWeN890lJKFRetVrMAn
         2aKg==
X-Gm-Message-State: AOAM533D0QfAOjsbuMciUnK68EjSGHMdW1eSGOKwxhfQZ9RfAu20eImU
        ZO2/qAaOaWFkMEgMFdoJzsC1zw==
X-Google-Smtp-Source: ABdhPJyYIemM2BHyxfpYahkpXaN8TCf2fBTFDf2vdU/5njxqv1A5ML+sYwcBMhfT45A1gK26heBQtg==
X-Received: by 2002:a05:6402:28b2:b0:416:2b00:532 with SMTP id eg50-20020a05640228b200b004162b000532mr3305663edb.396.1647507705736;
        Thu, 17 Mar 2022 02:01:45 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id d4-20020a1709067a0400b006d6e3ca9f71sm2081763ejo.198.2022.03.17.02.01.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Mar 2022 02:01:45 -0700 (PDT)
Message-ID: <0005fbf1-0c14-2ffe-617b-a770dcc1240c@blackwall.org>
Date:   Thu, 17 Mar 2022 11:01:43 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v5 net-next 09/15] net: bridge: mst: Add helper to query a
 port's MST state
Content-Language: en-US
To:     Tobias Waldekranz <tobias@waldekranz.com>, davem@davemloft.net,
        kuba@kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Russell King <linux@armlinux.org.uk>,
        Petr Machata <petrm@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Matt Johnston <matt@codeconstruct.com.au>,
        Cooper Lees <me@cooperlees.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20220316150857.2442916-1-tobias@waldekranz.com>
 <20220316150857.2442916-10-tobias@waldekranz.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220316150857.2442916-10-tobias@waldekranz.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2022 17:08, Tobias Waldekranz wrote:
> This is useful for switchdev drivers who are offloading MST states
> into hardware. As an example, a driver may wish to flush the FDB for a
> port when it transitions from forwarding to blocking - which means
> that the previous state must be discoverable.
> 
> Signed-off-by: Tobias Waldekranz <tobias@waldekranz.com>
> ---
>  include/linux/if_bridge.h |  6 ++++++
>  net/bridge/br_mst.c       | 25 +++++++++++++++++++++++++
>  2 files changed, 31 insertions(+)
> 

Acked-by: Nikolay Aleksandrov <razor@blackwall.org>

