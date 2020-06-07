Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B85F21F0EE3
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 21:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727791AbgFGTLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 15:11:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726780AbgFGTLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 15:11:05 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 300A3C061A0E;
        Sun,  7 Jun 2020 12:11:06 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id k2so4834819pjs.2;
        Sun, 07 Jun 2020 12:11:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fx8ZDPbjLqrJ/ye5aLr7B04mOPqMqfhQ6CkJiC2rhAg=;
        b=KU5ygKCSnowH1AJviUI0XGU5GaDvMhRlNCgUKT1heLzjBtixM4v4k10UX3e8hR1zAx
         Jyp2bGWgQ+r3lNixViN11j6vHxZGecV8sPORl+hGbICEA3iB4AEYuetecCGl2RLUN0oU
         RjKSxwNGuzbTrKd51oQ9VMF9Pxdm1zJcJCenchPMcsoXbmQypK2A3/CKzXj51q3z8/xL
         bwMEYHaE10KADmFUAZB5kRuqiGwqBKTPpndIq4kbtytRCCiy0FgOOlkCzofgZ3X7724k
         8Ar8xSpUCAqdBTwatXmCN/V6JbcoHvCYQQsg/4L9T6BjyFfSDEFRzGWmZBI2P6hUJZBH
         fkQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fx8ZDPbjLqrJ/ye5aLr7B04mOPqMqfhQ6CkJiC2rhAg=;
        b=WSYf9CHLQ/bXZMCJ2obqCTMz7uhnb/yWR2hD/5yzylv5wH/Hf1onY5ENU3Lpi8cV2l
         myfOuScUjw0HUA+SPLcTJV8H6SUGQMjK7AYqacw6vq9lq868iMb9himqwpvWLvPNoKmp
         WZ0J8YIdzQxdsz0NG6h8xP9Z7UW/d04q8aCaV1O9EqkxXYLlWWiJXlhO3p66hG//wbv1
         rNKl+PEr8zk1D6eoMxc4jKkysXbiFLPAYIjXVgFOsJcIzlwS4h1NgTCmxbUUC8PNkLlT
         lE8BUUU1OP3SaLRyK0wHoJwjp66jY0M5l9yTat9I+5D8HSKNLJS1f52g8dFDAQCvZ46N
         z2sQ==
X-Gm-Message-State: AOAM5334t8tq5c1KG8U6L82bZ4gqNaM6vSQJUweIK2WmL6KBBbbz04rf
        rjuvJKg9nn2dUrfqubtx6HIfYVUq
X-Google-Smtp-Source: ABdhPJzsJEIFZrU0c5F0lzlp8839oXC7BcdruIb3QnRVKkfjFEJLqd6iAU/LHK18eGZWM4XXjMdZgw==
X-Received: by 2002:a17:902:bc84:: with SMTP id bb4mr5993404plb.55.1591557065013;
        Sun, 07 Jun 2020 12:11:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id 9sm13129803pju.1.2020.06.07.12.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 12:11:04 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 05/10] Documentation: networking:
 ethtool-netlink: Add link extended state
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-6-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <de5a37cd-df07-4912-6928-f1c3effba01b@gmail.com>
Date:   Sun, 7 Jun 2020 12:11:02 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-6-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Add link extended state attributes.
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

If you need to resubmit, I would swap the order of patches #4 and #5
such that the documentation comes first.

[snip]

>  
> +Link extended states:
> +
> +  ============================    =============================================
> +  ``Autoneg failure``             Failure during auto negotiation mechanism
> +
> +  ``Link training failure``       Failure during link training
> +
> +  ``Link logical mismatch``       Logical mismatch in physical coding sublayer
> +                                  or forward error correction sublayer
> +
> +  ``Bad signal integrity``        Signal integrity issues
> +
> +  ``No cable``                    No cable connected
> +
> +  ``Cable issue``                 Failure is related to cable,
> +                                  e.g., unsupported cable
> +
> +  ``EEPROM issue``                Failure is related to EEPROM, e.g., failure
> +                                  during reading or parsing the data
> +
> +  ``Calibration failure``         Failure during calibration algorithm
> +
> +  ``Power budget exceeded``       The hardware is not able to provide the
> +                                  power required from cable or module
> +
> +  ``Overheat``                    The module is overheated
> +  ============================    =============================================
> +
> +Many of the substates are obvious, or terms that someone working in the
> +particular area will be familiar with. The following table summarizes some
> +that are not:

Not sure this comment is helping that much, how about documenting each
of the sub-states currently defined, even if this is just paraphrasing
their own name? Being able to quickly go to the documentation rather
than looking at the header is appreciable.

Thank you!

> +
> +Link extended substates:
> +
> +  ============================    =============================================
> +  ``Unsupported rate``            The system attempted to operate the cable at
> +                                  a rate that is not formally supported, which
> +                                  led to signal integrity issues

Do you have examples? Would you consider a 4-pair copper cable for
Gigabit that has a damaged pair and would downshift somehow fall in that
category?
-- 
Florian
