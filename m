Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E58B42853D
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 04:42:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhJKCoW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Oct 2021 22:44:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231560AbhJKCoV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 10 Oct 2021 22:44:21 -0400
Received: from mail-qv1-xf2d.google.com (mail-qv1-xf2d.google.com [IPv6:2607:f8b0:4864:20::f2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AD39C061570;
        Sun, 10 Oct 2021 19:42:21 -0700 (PDT)
Received: by mail-qv1-xf2d.google.com with SMTP id k19so4482312qvm.13;
        Sun, 10 Oct 2021 19:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=yAKGdgRdxijlpNEEly6ajSA0nM9YaEScSkQfHadvQQ8=;
        b=fdQw78PJDdUbQ3YKHND49JSP3mbGJYAOFyiFRbN0GFxryw4xw+vR2zD1VegJ4RVKkQ
         s0RqWHN/JfmTlNVHwQG46FsDmy/CKB/mdyQFX6A//jRy7HumeotIjyevNuHGmFiIiX/X
         eOOOWgN5KgN8Q75TqRHnHBbLCWC7wsYUaKBUmClAwh5rwjb2yEyrBgzCkGRHylgEEKDh
         tPM74lBEZyOS/VLV9NFHQi+bfBI1jmSOHSJ3NR+TJyDihrtKuId4HxzhcaH5fyXOEVd1
         lfke0xK0LessI928B55Wbsmig/gIxtYyQKKl1xrgzI8ERJA0f/mG5/O+IUv7ZOgPy1xE
         bOCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=yAKGdgRdxijlpNEEly6ajSA0nM9YaEScSkQfHadvQQ8=;
        b=r4TIKzPUWBrArika1UXVCYQ/kxFZGLxjfkP0m6aXz7hjS+BXqksg07iNSN5Gv0IY2c
         5IUdY1KPsuYkULdoIt9uCeGiiygvM8PVs37m7bexiUxsE7FJ9xpFKrcN/+f5ISYMta+m
         qJd2HqE5AaPWfI5zLoqNwDeQtG4qfvWD+HIqiVktAf/7p8aBZn+rpLdZ5aAh6bIiUhvH
         mQ5mIKl+rmj0UeQcho/O1QEBn9iDGxT/2mPL27UoJ/G+Rmqllyq61B74VcrvtxKq4HjY
         8UQYJmzMStve1JuQjVqMG8T0Yya2Q9+7iaJ6NQ0kSNG7iNSrO1Z53UJQa/saShiwwJ+8
         faUg==
X-Gm-Message-State: AOAM531kFJk27wr+uOZPPxLg9SiXhVKS2KpxDKGSBaZMDCcQDLCLM113
        oVnY3kZibCVx2mEcG8aTgYI=
X-Google-Smtp-Source: ABdhPJxump/1TE0sa4bjF9NLSX89uFm/F+jA+jOxLE/IJxzR6fFrmBD9HZ8PW9XIUVpOgpfgitsRbg==
X-Received: by 2002:ad4:59d0:: with SMTP id el16mr12916992qvb.60.1633920140298;
        Sun, 10 Oct 2021 19:42:20 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id t64sm3659612qkd.71.2021.10.10.19.42.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Oct 2021 19:42:19 -0700 (PDT)
Message-ID: <e902fed0-cde8-ab81-c0d0-64bd296bbcba@gmail.com>
Date:   Sun, 10 Oct 2021 19:42:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [net-next PATCH v5 12/14] drivers: net: dsa: qca8k: add support
 for QCA8328
Content-Language: en-US
To:     Ansuel Smith <ansuelsmth@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20211011013024.569-1-ansuelsmth@gmail.com>
 <20211011013024.569-13-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211011013024.569-13-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Nit: please remove the "drivers: " prefix from your v6 and do that 
across your entire patch series.

On 10/10/2021 6:30 PM, Ansuel Smith wrote:
> QCA8328 switch is the bigger brother of the qca8327. Same regs different
> chip. Change the function to set the correct pin layout and introduce a
> new match_data to differentiate the 2 switch as they have the same ID
> and their internal PHY have the same ID.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
