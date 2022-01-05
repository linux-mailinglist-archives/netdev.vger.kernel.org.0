Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1848485894
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:39:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243113AbiAESjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:39:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243098AbiAESjG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:39:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E502C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:39:06 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id n16so284677plc.2
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:39:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WF6W7HvfgSnJtLamRHxmmuS1/5W2U1J5aEv6Rw9KNYU=;
        b=qNWnkAsnRz6ZgSnU4CYuRgE42+hQ8anu1bDXXfenuKBCZY7TXZd51MLTYdabzB6Rxk
         kPB5GgsYazHcPTJr5FzQIyNq4Ep/7kbSm+8R1MaDhLp4uMjqp9VHZIOPbI4i7Z71pu59
         d50sBa7iUGBW2HMr+BehqofrcaxOtMZYmsTONQ6Jn1GS3hJGSyIsrlLb3AkDhGVJNGen
         rgc4nhDRzglRRx5m3oNeFxA9TC1vOlqdn1/QxxFo+jKHQH5PZgDdo/SvFuQpDDMqttaY
         9tInScKExq6q9BRF4yUK2Ja9ciI5uCtFCmPFVh1Y79ZIJVB79i2JnGK05mojdTj0TML4
         FoDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WF6W7HvfgSnJtLamRHxmmuS1/5W2U1J5aEv6Rw9KNYU=;
        b=bwvvHUnYbPRD1273uQ5p3ghtpY6QCMx/N2Swlam0XaAnSmLukZYOS4MkcTn9c5/I83
         43Ra/N2v/30F1evUxsVtEDlEB3LVGNAxv8wWY/0jqJk/rIqSRlsSv8XNs89nQRjvoRMX
         p9DD8AFv5UlhuVHtdZcQThjwrdwkWhKevGIXbjYFX0/0fImiScMHt7QlYxsl8t79zn0q
         WYGHrm3PJRsh0nSiMFdzi+K5lEdyCrBaEXPD6wvcsU1fwumRcFhXm7tPlnFS6bgK4P1L
         lLV4rRbFPXmBSFsbS47WMw8+RXJfLOWzoHogLkr6PvYbsJNzZVxTwrm6XQ6ragRSY8V1
         dlGA==
X-Gm-Message-State: AOAM533V8hHF4+vxHoCKkx0SztyUqqtfd3NM0vPYqEKZOywRE8uhY/4M
        uzsX/Y4YrovQ8cdGcJUUI+E=
X-Google-Smtp-Source: ABdhPJxk1Bj8LFnze5hxDyMrzwHSasxNbB0J9f3Fm7Ux9KEeCfDSyKjmDmYdyAqGUOg/USYeDMETtA==
X-Received: by 2002:a17:903:246:b0:149:e881:9e36 with SMTP id j6-20020a170903024600b00149e8819e36mr1315320plh.26.1641407945942;
        Wed, 05 Jan 2022 10:39:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h13sm27220461pgq.63.2022.01.05.10.39.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Jan 2022 10:39:05 -0800 (PST)
Subject: Re: [PATCH v2 net-next 0/7] Cleanup to main DSA structures
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <f6d50994-6022-be0f-4df2-1dc3c8199c09@gmail.com>
Date:   Wed, 5 Jan 2022 10:39:04 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220105132141.2648876-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/22 5:21 AM, Vladimir Oltean wrote:
> This series contains changes that do the following:
> 
> - struct dsa_port reduced from 576 to 544 bytes, and first cache line a
>   bit better organized
> - struct dsa_switch from 160 to 136 bytes, and first cache line a bit
>   better organized
> - struct dsa_switch_tree from 112 to 104 bytes, and first cache line a
>   bit better organized
> 
> No changes compared to v1, just split into a separate patch set.

This is all looking good to me. I suppose we could possibly swap the
'nh' and 'tag_ops' member since dst->tag_ops is used in
dsa_tag_generic_flow_dissect() which is a fast path, what do you think?
-- 
Florian
