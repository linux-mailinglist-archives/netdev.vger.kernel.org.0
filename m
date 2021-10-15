Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF37242F8BE
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 18:52:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241691AbhJOQyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 12:54:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241657AbhJOQyD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 12:54:03 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EEC1C061570;
        Fri, 15 Oct 2021 09:51:56 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id q10-20020a17090a1b0a00b001a076a59640so7626706pjq.0;
        Fri, 15 Oct 2021 09:51:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3o5yVUkAQxi7EAG4z+qLtJfsfGY9iQ3yN3rUtTSBlMs=;
        b=Ei+YeCOrAxu8aqVNs0CM/9/iDKLQ5Onex3oMjoF66B1/hA49W3TEcgbwM10WVTYtgm
         GIXlPGvEo7NKvdWQFnTwT7Hhb/vR8u812yzkVREDs2mx73z9LYDYkFq/9enoOw+n4Roa
         WhBLJStQDSVGBdnqbdFjUie/FAk5jzQfnJfBjphV+AQtyggNukcgZj6mqjJNwvty/G5v
         RXV63e2kawah5zACmpqT801JGeOdLD/3Gab1a9nHMbxFBm4l2FmFbPa9a+ik1jjxeoXb
         bnEmerpX1ra5WlmbjvvRZyLLa7BUxzAjfekABwv2Mb9XPB0YWxPHE5X+sEe875kbsM2y
         YkDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3o5yVUkAQxi7EAG4z+qLtJfsfGY9iQ3yN3rUtTSBlMs=;
        b=PqZ2BhxdTfUBYsSJLhytkqVBPdB7HyXUVf9hix7i0zfQ5puZ4SYcUgfM362lRM2SZ1
         2MwCytu96se9ioKOnPUXNeeLvqta+cWj7k2Ov74RTlBE/XsQWx2nMuDU56GPFtc726QN
         mAFTZvMmM9otFrEXNUmtIpohSfJUZu/EA+fMacf6fTEyKJe8twMb3rwpa8Mslojf9K5i
         JqKMscDwxPrzAqOwm74xOG1+YPgsmJ+BB3sXi/MxzzsjxEk9KnrX2/aqeCcPZSQYoM3u
         /5TYUpOlw9wuGj2F/P5UKwJojBPVlgdPi3eKUeUZe21SQYFO21el8QpjLesJE6e+m3Z9
         yKww==
X-Gm-Message-State: AOAM530Vo0OU36Ibs93KNfan2j8YQbvpRACTU82Iq/2A5AgiMGhzhsyl
        sd8YU+fXdyUSYWTlr0duFnA=
X-Google-Smtp-Source: ABdhPJz3Pbs/ZZog6QwTndMIPRmzItBjlEEpgz1atY4WV9jY0jgnA2HEi5hDfbe/0zn8I1wueVHFVg==
X-Received: by 2002:a17:90a:fb87:: with SMTP id cp7mr29151027pjb.114.1634316715788;
        Fri, 15 Oct 2021 09:51:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t13sm5266201pjg.25.2021.10.15.09.51.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 09:51:55 -0700 (PDT)
Subject: Re: [PATCH net-next 4/6] dt-bindings: net: dsa: inherit the
 ethernet-controller DT schema
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
 <20211013222313.3767605-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3c794866-6319-4f5f-25cd-e2980d1fc211@gmail.com>
Date:   Fri, 15 Oct 2021 09:51:51 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211013222313.3767605-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/13/21 3:23 PM, Vladimir Oltean wrote:
> Since a switch is basically a bunch of Ethernet controllers, just
> inherit the common schema for one to get stronger type validation of the
> properties of a port.
> 
> For example, before this change it was valid to have a phy-mode = "xfi"
> even if "xfi" is not part of ethernet-controller.yaml, now it is not.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
