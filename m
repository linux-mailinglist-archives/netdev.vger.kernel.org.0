Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1852DEC54
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:22:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726275AbgLSAVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:21:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725862AbgLSAVc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:21:32 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B44C06138C
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:20:52 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 11so2510542pfu.4
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:20:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ewVphHA+3NX6u8gwY7eAoukG2/2BmQ40SB2+909eN7s=;
        b=kG8yf6rEB/AZrjsLlcX43+z7sBn3MS11c0NDTIs63BZVyTBre5+J8ubv64nILVmv5D
         6sJKfxMFqc6HHCs67RKQvp4fbTVqMEasrkaJbVQMkI4ccSAVOfb7/uWGDnXNwt/vbEsF
         lwubuOwKbuyWq2RbQXBVrZqEV/SDh61E6M7f3Lk8GA8keutF0e13NaVrRuI0G3mdU6sX
         hu7BfBL/MflWrQ1gwcBllOcCMXKX63DuWJt6q1A7+mF2/wxgZKTJZjSPrV5QcOOmvGsz
         chYinAEjTcv1xpgj8xoSxfRzreP0RYaqnDUuXA3wODg1nHP0PGo2hCxLM2tLSleg6qo9
         Z03g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ewVphHA+3NX6u8gwY7eAoukG2/2BmQ40SB2+909eN7s=;
        b=jRjKY6h93V2sg83mo9UVafGzeFeOA2vwnMQ2Rq/LcYB441fWAkLjod1Hp1vcv2O6xt
         AN6jSQaA570togMlTXZRSkZmfQXV/oSMByWSgOSxFWC3hz8wfF3ovDbrBD1YHAxU+R3O
         MrrLXXwh5O0iWYtMIUwnzhvLYm39ixmPio9K7JhLIkGtnaGfv+jwCKiiwTQw85Xlz/Ky
         k5IvhxBJOX3TG4ZnGzjHUx1/zs44tUqoH6Kh2XZFRmiiOVvnqriTsfgD081SSyJVgzad
         kNAg7rx8mpb3yy1ljheKmPMOFSMwUtngYrcu4JYyjBB5D58660uHOw8OncdGurRuh08W
         5smg==
X-Gm-Message-State: AOAM531atNP+GIbKowBrQp35sXvvT8AEZ8e8O6qfLxKDhrr5abpoEy2r
        z5grOgTBWuE09YaWXstXS72Sy1bfunY=
X-Google-Smtp-Source: ABdhPJwxG1kJ5lBs9w9vqRUGOTibQqJwpkjzu+z2azHKSVNM4O0dDhfVQQoggpaSZ6g6/9nX+pGAkA==
X-Received: by 2002:a05:6a00:882:b029:19c:5287:4a1e with SMTP id q2-20020a056a000882b029019c52874a1emr6552049pfj.44.1608337251189;
        Fri, 18 Dec 2020 16:20:51 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b10sm10120181pgh.15.2020.12.18.16.20.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 16:20:50 -0800 (PST)
Subject: Re: [RFC PATCH net-next 2/4] net: dsa: export dsa_slave_dev_check
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-3-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ed953614-72a0-2443-329c-7dedd5ab387a@gmail.com>
Date:   Fri, 18 Dec 2020 16:20:48 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218223852.2717102-3-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> Using the NETDEV_CHANGEUPPER notifications, drivers can be aware when
> they are enslaved to e.g. a bridge by calling netif_is_bridge_master().
> 
> Export this helper from DSA to get the equivalent functionality of
> determining whether the upper interface of a CHANGEUPPER notifier is a
> DSA switch interface or not.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
