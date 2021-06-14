Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE84C3A6D8F
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 19:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234131AbhFNRtO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 13:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233975AbhFNRtN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 13:49:13 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75DA4C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 10:46:59 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id e22so9229878pgv.10
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 10:46:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vftzWlyIrExXWJmqBX7OeGsfHVmPSnmnCXq1p5nOPtQ=;
        b=UqTnq3Lr4wnZ52BI0zxf/ZDKRz6xGHW7vrbZ/ranStiYRE0Ysh7aDVhbg2nsK9DYGD
         NN7SDxhwt7lgn9ftvB4gaYt48grvZS9j98qf15fxXkU4z716WvH7YmEyMcL90Z3cInC2
         DpPpvBZuf+Kmzo1cDaTzJbLyppi+P6uA9vFZ3LkccXTws+Mf+9gifk8S/UwfSh/hGg6/
         gzzEKokStnJIXjO5gaLG1TJEARgBLyoXAxH2SYrXxkVkiYaxXJFTdqMFaBWkducNWDMN
         tyQ2yMG2/8jKxgex6WSLo9RUCIU0IerGWHErCjiawWiG9HRefjzaWqjJrra4V2B1QO1f
         FNTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vftzWlyIrExXWJmqBX7OeGsfHVmPSnmnCXq1p5nOPtQ=;
        b=k48aynAhlDPuYDDduWUFNjBpUEG0/WBzDoHdGTRP63AM5toCisXRPZ1QQkUPkGJFiB
         CbOnTV7Ljxn4sJWV84i63urUG/2NzqNw+fN3ETLMU1fIidv25S0vNxDxY0w6TJ5yamvt
         1YcMLYID35UaCNlLfmtFbip/j7ewA0KuVrZeuwU1kc0hqxTwUrQvPu1UvueQ4z6olCnC
         01H5FpMCJ8b+KiI7t3FES95VOBurTtOaa+iRdbsIQ9N5/XYD+n142UcoISZoUfAUlxCT
         sxTPBOYmgjivqT/zdxPMDg4yUvUZqKuUi8Dgneo4+D9ga9FCiiDKmUTACqmTkhpkhfKX
         ipbw==
X-Gm-Message-State: AOAM532rMCMV99Rdxf4HXn6Wyem5OzkwtcnWgQFvOCxJ9ZCndInXp/Nv
        CPyk12Z9oVOFc3Q1xjczyJY=
X-Google-Smtp-Source: ABdhPJynz4762M5WC8efWFrduCmEqk/jhfNAaLm6TsdnSxCpORAElnofaZeq+7TssvithcwdT/j8QA==
X-Received: by 2002:a05:6a00:d65:b029:2ec:2bfa:d0d1 with SMTP id n37-20020a056a000d65b02902ec2bfad0d1mr153876pfv.14.1623692818923;
        Mon, 14 Jun 2021 10:46:58 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g63sm13145384pfb.55.2021.06.14.10.46.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 10:46:58 -0700 (PDT)
Subject: Re: [PATCH net-next] net: dsa: sja1105: constify the sja1105_regs
 structures
To:     Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
References: <20210614135050.500826-1-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <adaecbb4-657b-01d6-0e3b-1c0a7e4023b8@gmail.com>
Date:   Mon, 14 Jun 2021 10:46:56 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210614135050.500826-1-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/14/2021 6:50 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The struct sja1105_regs tables are not modified during the runtime of
> the driver, so they can be made constant. In fact, struct sja1105_info
> already holds a const pointer to these.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
