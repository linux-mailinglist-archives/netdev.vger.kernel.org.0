Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD98D44688
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404395AbfFMQw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:52:28 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46880 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730116AbfFMDMs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 23:12:48 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so10838987pfy.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 20:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TjftckyWJKJbw4yRGpSrs0KCYTsUoDM7M/+717BM9fQ=;
        b=WTPkzCFfA/g5ESJae93vyHtK8y53mB321X6I5G0QGqmhD02fCTHPxl6Do9ZLw6mv63
         rXtiRe1dE5TV309Z1YVkpQGIOv/akmh1dgXPfoncCuAjFBXks3j9zll8aPy8b+gEm4g3
         28SeygB+ZtyJIiXoc4o0g02y6IcnDrzN0ASmDN0Dg16IM638o26aY4BfH7rdMZCmho2b
         E7D9v5BBDjfFSmx4q8VCpBzYaIFu2tSu2yn7rWV1VC4VP4swi9ON1KtHFQ7sJscGeJXg
         XvffP7edNz+Ws61NaZLkUjKfeAx2nIad+b3kLntbTEcLScudvpd7ENPekPEOlWaQXeKD
         zEdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TjftckyWJKJbw4yRGpSrs0KCYTsUoDM7M/+717BM9fQ=;
        b=XftFuP4uJHeZTHA5v/LYH1mCS1kkV9IXsLsBGK1xC8ZDq+zkZEkX3LKQ9wlv5f48fc
         MO14IjGPBKQmid9GZF5Er7A6dIGQSiKWezvzslsX+wmLLVz3/m7YhUc95v8OyoulhAAE
         HFnwtI2dHIbEb3QljEMQGJgnYx62W6hMtWQ194LazcqXrf4DosjYUsV43HmNcKOqRFmZ
         vhMphM28/ZKyl0eRoSgirSzzJ6FOCs5L5SPhQ+0dind/1IipYVE445YX8btLrfOPnGxw
         CTPQ9bhlu1H83cA849BoRDxEivYTh2yv5pTJlN4jcpaK8VPgyJMpT0SnDO4oeNAbEc/u
         zVyg==
X-Gm-Message-State: APjAAAVWPKI/AG5Cq30gMInWlSVLtR19yrhwCQbs3G7JgWHRchWocis5
        3Q+VYOCMmPoAwwGiYlJEwXpfOogK
X-Google-Smtp-Source: APXvYqxrqXhmiANg7yKesPEceGVozU0WyvMlzsSEtC1WYnKhVKKNivJAkWlDu+ZcABQxgofdgJwYNQ==
X-Received: by 2002:a65:450b:: with SMTP id n11mr27229415pgq.174.1560395567156;
        Wed, 12 Jun 2019 20:12:47 -0700 (PDT)
Received: from [10.230.1.150] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id d5sm952668pfn.25.2019.06.12.20.12.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 20:12:46 -0700 (PDT)
Subject: Re: [PATCH RFC 0/3] RFC 2863 Testing Oper status
To:     Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>
References: <20190612154438.22703-1-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <fcacb46a-c12c-c0b7-4e21-8aef1da57d57@gmail.com>
Date:   Wed, 12 Jun 2019 20:12:44 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190612154438.22703-1-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/12/2019 8:44 AM, Andrew Lunn wrote:
> This patchset add support for RFC 2863 Oper status testing.  An
> interface is placed into this state when a self test is performed
> using ethtool.

LGTM!

> 
> Andrew Lunn (3):
>   net: Add IF_OPER_TESTING
>   net: Add testing sysfs attribute
>   net: ethtool: self_test: Mark interface in testing operative status
> 
>  Documentation/ABI/testing/sysfs-class-net | 13 +++++++
>  include/linux/netdevice.h                 | 41 +++++++++++++++++++++++
>  include/uapi/linux/if.h                   |  1 +
>  net/core/dev.c                            |  5 +++
>  net/core/ethtool.c                        |  2 ++
>  net/core/link_watch.c                     | 12 +++++--
>  net/core/net-sysfs.c                      | 15 ++++++++-
>  net/core/rtnetlink.c                      |  9 ++++-
>  8 files changed, 94 insertions(+), 4 deletions(-)
> 

-- 
Florian
