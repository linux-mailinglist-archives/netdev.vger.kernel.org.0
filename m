Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203D7397FF1
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 06:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230312AbhFBEDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 00:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230322AbhFBEDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 00:03:14 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71DC7C06175F;
        Tue,  1 Jun 2021 21:01:31 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 133so1180367pgf.2;
        Tue, 01 Jun 2021 21:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Psg5LZgVxkE0XFjla4qijJ1f+kTs+VjX8IAhvkS1TnU=;
        b=PzEglsbnRKOgy2zmiQZPocEgrcplSj7vy6E3yjFAHp2jSlOuDmSsyi0VJeZ6SREY8j
         b9aoSpkmlve5vyHZXP4NOWe8xEGYOB9FddFgVhcn0hwPiGoG08dYbr43ahwIwG+LcGT2
         CejYHEVx6cJDLEc81g7FA5LeQ+XetLJZf80PPQwHwxlgUBlzwqvDJ3dXyO+9cDVRYSK1
         26KOszqc1Bi4JhB5bJvO7LXt83NvpFtxge0SpSxDoqHUzVmuV/iki2xcZXuF7eeUrMh7
         XriLy2HSXpf3DA5n3PiT+i8mi1zv6TZT40lbR/YZ2X/mrS4rn1s0T7fgXsDX2lIohWpo
         /eJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Psg5LZgVxkE0XFjla4qijJ1f+kTs+VjX8IAhvkS1TnU=;
        b=P9r4wW3ibhG4c/RYw+oo7b/Bk4VgTM/ENfUeOT8CLwVo/RUSAA6hzo/TbEz/wafnp0
         zrKEd0EqOCLsA99zBPJZxVUS54I3SzsPX+TYc0BBfIGlfNuggSy4241ZS79H7bHf5t41
         x9K7ujcaDNt0wgLJqRqTbPmUXbxkT2HQh9WTt4X4KkDeqnfDZYndgsrKSDcJiF0wWaIa
         m7b/5mvwE0PI0h7/RmjEQAZ4f8kAiSfo8JV0mcBFmKSr5XNC8f/gkMI3puloM9c9yntj
         MPWqGeHFa9jc1veEGdE2RNvN23l6LPcjyNxvLD/U9aoqpA1QbSVHUBKDQ4F27tfnk3ZB
         XBRg==
X-Gm-Message-State: AOAM531u0Ir6WGBqdK0f5+MpUdw3dNnQKk2FYkTpz2Ox+kndJUgQ+VTM
        1Dy78HWEHPfLPapjlHDVPJY=
X-Google-Smtp-Source: ABdhPJxKlLfx8fGrjuW4kyOWyd346i+7tCQUK8Q7+rHQRknOzVIZop1GxuD0qUV4+7AkKc3PzRieRw==
X-Received: by 2002:a63:1b04:: with SMTP id b4mr12560718pgb.224.1622606490927;
        Tue, 01 Jun 2021 21:01:30 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id c21sm2955384pfi.44.2021.06.01.21.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Jun 2021 21:01:30 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: mdio: Fix spelling mistakes
To:     Zheng Yongjun <zhengyongjun3@huawei.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        rjui@broadcom.com, sbranden@broadcom.com,
        bcm-kernel-feedback-list@broadcom.com, narmstrong@baylibre.com,
        khilman@baylibre.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-amlogic@lists.infradead.org
Cc:     opendmb@gmail.com, f.fainelli@gmail.com, linux@armlinux.org.uk,
        jbrunet@baylibre.com, martin.blumenstingl@googlemail.com
References: <20210602015151.4135891-1-zhengyongjun3@huawei.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ce8d1b78-47ce-9211-d948-093d316ea647@gmail.com>
Date:   Tue, 1 Jun 2021 21:01:19 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <20210602015151.4135891-1-zhengyongjun3@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/1/2021 6:51 PM, Zheng Yongjun wrote:
> informations  ==> information
> typicaly  ==> typically
> derrive  ==> derive
> eventhough  ==> even though
> hz ==> Hz
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Your v1 was applied already:

https://git.kernel.org/netdev/net-next/c/e65c27938d8e

so you would need to submit an incremental patch thanks!
-- 
Florian
