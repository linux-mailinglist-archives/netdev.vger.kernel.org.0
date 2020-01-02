Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD4E812E999
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 18:57:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgABR5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 12:57:06 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37731 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727829AbgABR5F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 12:57:05 -0500
Received: by mail-pj1-f66.google.com with SMTP id m13so3650858pjb.2
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 09:57:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fOf5j/p39rK8z8FH9Ye5UgPeBdGVwciaj00YmLZzQH0=;
        b=bIrWKTieKCpT3jHQRGkf/uUiXcfNuUC5Z51dZBlXh9i88YaxBcqlLlQWrDxpAg//Kz
         /sH2akLfWbT7bgBFVUphDtibMCEjCIjtSignoOma25tKq+q+3B9vH+A1dQRrkXTjcLoW
         4Flse/ZTy5kALwA4a+Pc2MTd2AoImCVCUyPXsGvNTs6q8R5bfbZKe/f6kB20tj0/7Io1
         g/zoFA2pWb2hM8lj/+FF2OcNC+KRyT9zHlFX073LgiJQtI1SGvfOg2PN9Ko/gjvF6ZN5
         rSp/cWOCZRYGB1MEDV6qX6BoSDpyMVFcPv04bvPZNjan2BidDFNQipMfV3zH1p1J2whb
         UkBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fOf5j/p39rK8z8FH9Ye5UgPeBdGVwciaj00YmLZzQH0=;
        b=NZlGfzaHy2l782Hw0hgDp+/x1mmFGg/n0XZmmzAD80U6eVRYcXUppHPh9HcreNsC/F
         /v7hwN3c1Cv1Q1+2cAUPQfm5qHOfmNjvFgM4stLwdOq5NiYYngXxOVzsBymm6cDumc/E
         Ds51n26ywKZYRaMMFXK3ppxArER9w7ZS0XkGUVQaYf3mZ/5cQairnTZSKg7IJUyvZluv
         ZbcmMQztRTaiEBC6zf9GOyc5efgUB0jtwHyjL0KLUw+2bDvgM3it06uxSYI5bvMgTVcB
         DHTiB1gZCLo2CWzqDJV6Bsrfu5Ik7Srbm5VyEj7wgmjy9UdmYq7KMgYNW727HbMgUKnr
         ZLjg==
X-Gm-Message-State: APjAAAXiPBph7RzfhgvkRPYKVP02d8aV2IKObBNWq1Mj+1IItG5vRbPg
        RWD0DjtdJnX0P+9mm56Kb2I=
X-Google-Smtp-Source: APXvYqxPQ30/m6u8mvHmTNC74KelLmR1bkvg9HMN4diaiHc2q09NQH1oQELgO65D8SCyVevV3QminA==
X-Received: by 2002:a17:90a:1785:: with SMTP id q5mr21324385pja.143.1577987825301;
        Thu, 02 Jan 2020 09:57:05 -0800 (PST)
Received: from ?IPv6:2601:282:800:7a:3d3f:fd31:c108:442d? ([2601:282:800:7a:3d3f:fd31:c108:442d])
        by smtp.googlemail.com with ESMTPSA id f8sm64395983pfn.2.2020.01.02.09.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jan 2020 09:57:04 -0800 (PST)
Subject: Re: [PATCH iproute2-next v3 2/2] iplink: bond: print lacp
 actor/partner oper states as strings
To:     Andy Roulin <aroulin@cumulusnetworks.com>, netdev@vger.kernel.org
Cc:     nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
References: <1577794502-8063-1-git-send-email-aroulin@cumulusnetworks.com>
 <1577794502-8063-3-git-send-email-aroulin@cumulusnetworks.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <ec9976a8-7084-687d-a7eb-7df07bd85196@gmail.com>
Date:   Thu, 2 Jan 2020 10:56:57 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.1
MIME-Version: 1.0
In-Reply-To: <1577794502-8063-3-git-send-email-aroulin@cumulusnetworks.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/31/19 5:15 AM, Andy Roulin wrote:
> The 802.3ad/LACP actor/partner operating states are only printed as
> numbers, e.g,
> 
> ad_actor_oper_port_state 15
> 
> Add an additional output in ip link show that prints a string describing
> the individual 3ad bit meanings in the following way:
> 
> ad_actor_oper_port_state_str <active,short_timeout,aggregating,in_sync>
> 
> JSON output is also supported, the field becomes a json array:
> 
> "ad_actor_oper_port_state_str":
> 	["active","short_timeout","aggregating","in_sync"]
> 
> Signed-off-by: Andy Roulin <aroulin@cumulusnetworks.com>
> ---
>  ip/iplink_bond_slave.c | 36 ++++++++++++++++++++++++++++++++----
>  1 file changed, 32 insertions(+), 4 deletions(-)
> 

Fixed up a space before tabs in the macro and applied to iproute2-next.
Please run checkpatch on patches.

