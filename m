Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3DAECD04D2
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 02:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729942AbfJIAiK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 20:38:10 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:42664 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727051AbfJIAiK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 20:38:10 -0400
Received: by mail-io1-f66.google.com with SMTP id n197so1048608iod.9;
        Tue, 08 Oct 2019 17:38:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3Xf/GFIKYoOdVh68AnbPaEIIVn/hMGh9iJb/+ai1QK8=;
        b=jtgB8a9RWkm5zmaO9y/tbFwrFnudl5vEGLeA3UiVbRJ8Rr5LGjZyu/6+Yie0ONXUHm
         Iu/FnR/vVPrcLITJiB9f2kvKmZ3+3wXmp2zY+uLdqZ3eDOKAQmX567UaM9ap+nZAkkSk
         tdj/FVoQDFQe8oiTJFBy6F40OkqUAnCqDwe0VijzFdzBOJzFgMC9TpEodDT7FiNBMIXQ
         Yn6LFR7gEvvhgn9um4IWhDxNffuyHQdZz2gbq+aTUoTrKGA4Ux271Ql50QaPdDQF8dFl
         SROrMt8cv1ZnD9Ng3CgHyKdXR3zK9up5O7DOEsppjXPZ5RJ8o4IewAD+Ngll1EB1uJzS
         LLdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3Xf/GFIKYoOdVh68AnbPaEIIVn/hMGh9iJb/+ai1QK8=;
        b=HolluDwZYZ4kFcVpBuWTvDghEzwO8OTiEdmbrza8KQfPIW9xsVbOnVgJE7jYvN40EP
         PgI2Ey4sre1aLCZRynS8lT6XcPir6tqrtASz+9g7wudnIzNdP0yuX2GgpwSX1pswhpgg
         b3bEHrcnU/87BM9e84lHaMMoSfv/jpL0xgv9vL05LArwr1LbiDCPorEwPJe3EHgc8HOw
         qhgkZzG3YgBtDvQ2YD8jXf+YFPmEOOy1zUF85cjnbeHryfFioLZoy+znjBtAxQiQFnXb
         ZOfsY8exB5l0orAUlc/PeC6cP3THU5ePjbJ7F2fh5WCqmn+Fb8/5g5kPyq/TN9SRAP8S
         VzXw==
X-Gm-Message-State: APjAAAWDJGTCSMzkAPIP7gKvtn+263wBb1kEWIFx4vcQp0Q2UPxiid6f
        1XoT1wvKeeYkdBJL4bO60v2O/S2e
X-Google-Smtp-Source: APXvYqxmypy4pEKgt/DUa4XJDz0ybkdFALxv3Xsd7qwVBXMyeM7mUctV2Vhhia+OSnAtqNlhMLpk+Q==
X-Received: by 2002:a05:6638:68b:: with SMTP id i11mr843994jab.63.1570581488905;
        Tue, 08 Oct 2019 17:38:08 -0700 (PDT)
Received: from [10.230.24.186] ([192.19.224.250])
        by smtp.gmail.com with ESMTPSA id q17sm322619ile.5.2019.10.08.17.38.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 17:38:08 -0700 (PDT)
Subject: Re: [PATCH 0/3] net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
To:     Andrew Jeffery <andrew@aj.id.au>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        joel@jms.id.au, benh@kernel.crashing.org
References: <20191008115143.14149-1-andrew@aj.id.au>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <938706da-d329-c4aa-fcce-2d390a4e98f7@gmail.com>
Date:   Tue, 8 Oct 2019 17:38:05 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191008115143.14149-1-andrew@aj.id.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/8/2019 4:51 AM, Andrew Jeffery wrote:
> Hello,
> 
> This series slightly extends the devicetree binding and driver for the
> FTGMAC100 to describe an optional RMII RCLK gate in the clocks property.
> Currently it's necessary for the kernel to ungate RCLK on the AST2600 in NCSI
> configurations as u-boot does not yet support NCSI (which uses the RMII).

RMII as in Reduced MII or Reverse MII in that context?

> 
> Please review!
> 
> Andrew
> 
> Andrew Jeffery (3):
>   dt-bindings: net: ftgmac100: Document AST2600 compatible
>   dt-bindings: net: ftgmac100: Describe clock properties
>   net: ftgmac100: Ungate RCLK for RMII on ASPEED MACs
> 
>  .../devicetree/bindings/net/ftgmac100.txt     |  7 ++++
>  drivers/net/ethernet/faraday/ftgmac100.c      | 35 +++++++++++++++----
>  2 files changed, 35 insertions(+), 7 deletions(-)
> 

-- 
Florian
