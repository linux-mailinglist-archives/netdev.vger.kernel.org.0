Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B139B1CEBA9
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 05:43:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbgELDng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 23:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727942AbgELDnf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 23:43:35 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BBBCC061A0C;
        Mon, 11 May 2020 20:43:35 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id u22so4782978plq.12;
        Mon, 11 May 2020 20:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WoKP7JWepTMT9IDBkj9nuCsfAUjh4k5Chj90kMbEKsM=;
        b=Sf4OewM7HYB2gv4CUMmA8zslnJ67YWeYJMa8DJ2pMNOiFSIX0nFlJwhFZJvGWOX/Vt
         421yfatKc0q/qciUFCi9oFSLWKOycbLwp/N71Xm3PiAsD8iMrgujVYt7vCFJ98Xc/nE8
         KOurWp0GtYlemPaoDQOTFZPvFpq1C/R98QtUttFvQ/j2gKEBSPbb6Hovf0sl1+0US5uy
         5e7/I9iDfFgh77B0NuUVtDTaFOFAKs2AI/swhkMYKH20LbL47sNU5g1Utd4SEoGY4t+0
         3jDr8i9bVC3atm3S6pCJzVFk0lZmsMmCWQT9XJc4XtX7p96AFVOaG5cLT4XKS1PPgeTB
         zdCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WoKP7JWepTMT9IDBkj9nuCsfAUjh4k5Chj90kMbEKsM=;
        b=Sw9+aefaQSx7Wa/1zoTGZXoR8JmcakJuaa1v7wb8BUnL5cSKDlyCph0vaKZ/ptoIYT
         Rc4qfaKIzMd4pFYhPUKHEa+uYlzzX46O4OCDBQqCNkCasJ/5vtL+TWaFJ6ZVPaWLE3Hs
         vm9xzFQp9kyArs1367ZRu3ysiHS9vwWGrBrEaAt4QXLZdfs6kAS8GItq+rmOm11y4Kk4
         ThgQ07vClZbONaFLgwufFOFnixIgDQFBz7lCdPlHQ45NCy7lrpJlzRH6J/RReN0HPLg9
         +oZI6q0uU/Fq3iwB75NLlW9aYe+1wloNlBX+Gc/1nSkvn2ZRb0ZPvM2D2rwnBMpF6v+O
         AdVw==
X-Gm-Message-State: AGi0PubACyd1tak8zXRDeUJu8JltbXBRFOw5e2sP4d2HFezje+dptjtX
        D437Dgt5ipHro4vUjWNxfzGtljWt
X-Google-Smtp-Source: APiQypL9Kd8UKw8AZKRLX0LdS5ahl++zEQ6/LVAGdwrmLTq00PNxMInoKID7OdXM9e6v3KovqLR/Dw==
X-Received: by 2002:a17:90b:374f:: with SMTP id ne15mr25739118pjb.181.1589255013593;
        Mon, 11 May 2020 20:43:33 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 25sm10684476pjk.50.2020.05.11.20.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 May 2020 20:43:32 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 15/15] docs: net: dsa: sja1105: document the
 best_effort_vlan_filtering option
To:     Vladimir Oltean <olteanv@gmail.com>, andrew@lunn.ch,
        vivien.didelot@gmail.com
Cc:     davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        idosch@idosch.org, rmk+kernel@armlinux.org.uk,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200511135338.20263-1-olteanv@gmail.com>
 <20200511135338.20263-16-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <0465e3f6-88b2-1371-da66-530d3d67ddb1@gmail.com>
Date:   Mon, 11 May 2020 20:43:30 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511135338.20263-16-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/11/2020 6:53 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
