Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1F0369265
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 14:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242497AbhDWMtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Apr 2021 08:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbhDWMtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Apr 2021 08:49:21 -0400
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CB2AC061574
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:48:44 -0700 (PDT)
Received: by mail-il1-x12d.google.com with SMTP id r5so393646ilb.2
        for <netdev@vger.kernel.org>; Fri, 23 Apr 2021 05:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=mWfAtGdxpFEp4LVoo+rqb8Rn9YokussnKSoryb4RU5M=;
        b=GPM1lSeP//ZNKPiXG9KWBfZNpNlCEb4eR/mfOGUqMRlymkABLJtitF7ZktuD+LYuqF
         Q2w+25DvrTWzTaQVM7ylqyGA4V6T6n8EygMAMpz66XPOMzIiAQJTt9ovnZ4Nx6z2OwtS
         z+IqQAXWHcmZvGsYlknsdjJlsvndBvKI3SKbY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mWfAtGdxpFEp4LVoo+rqb8Rn9YokussnKSoryb4RU5M=;
        b=UHYl3Q2Zln5GMFr+J6/HSSYXqYXa4ubMMm/HSvz+V7Otk0EYLMAlNBbM9+haUhfHEM
         2uVDij+zLQB440VqBzQlrmvaghD+LoHo01djNgcoaHQooTEe5Lq9NJczBwyhvf+Yx8sM
         GZoe50r631P+LTjop8ibMjVj0c3AGOOfIhv03dcrdWWyDNAeczNI/fL6wj6KkfaWtiJe
         +yItv7MOUAVItdXWFdE2TngJrjM7LduHCaLDFaCeI6Vsxj3c+mnAqneatEpi8XHSoKCi
         NxmMNkhNK05PSKdVeK4sSusF/t+3ph0Yxp1Mt44/2xLdQgWZyRwS1is2WqmKtHQh9E+B
         Dk/A==
X-Gm-Message-State: AOAM531/rxa50TIIj0o0egoUOS8CRKcadnOxUn5usLltXFeWfN/TgS8z
        8+q6hD3bhcefIeqFi0NoVqF4roEgHv4Mxw==
X-Google-Smtp-Source: ABdhPJxfCx4yvv+7+tVgXbNOcieXDlNCf7ZH4e8yceqIc1vWC80Y099PWOBobq7IE4QBeObQIjjZlA==
X-Received: by 2002:a92:d143:: with SMTP id t3mr3024278ilg.241.1619182123496;
        Fri, 23 Apr 2021 05:48:43 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q5sm2732695iop.17.2021.04.23.05.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 05:48:42 -0700 (PDT)
Subject: Re: [PATCH net-next v5 0/3] net: qualcomm: rmnet: Enable Mapv5
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>,
        davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <stranche@codeaurora.org linux-doc@vger.kernel.org corbet@lwn.net>
 <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
From:   Alex Elder <elder@ieee.org>
Message-ID: <2c7d9807-0b9c-2334-b059-c3c18f63a341@ieee.org>
Date:   Fri, 23 Apr 2021 07:48:41 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <1619180343-3943-1-git-send-email-sharathv@codeaurora.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/23/21 7:19 AM, Sharath Chandra Vurukala wrote:
> This series introduces the MAPv5 packet format.
> 
>    Patch 0 documents the MAPv4/v5.
>    Patch 1 introduces the MAPv5 and the Inline checksum offload for RX/Ingress.
>    Patch 2 introduces the MAPv5 and the Inline checksum offload for TX/Egress.
> 
>    A new checksum header format is used as part of MAPv5.For RX checksum offload,
>    the checksum is verified by the HW and the validity is marked in the checksum
>    header of MAPv5. For TX, the required metadata is filled up so hardware can
>    compute the checksum.
> 
>    v1->v2:
>    - Fixed the compilation errors, warnings reported by kernel test robot.
>    - Checksum header definition is expanded to support big, little endian
>            formats as mentioned by Jakub.
> 
>    v2->v3:
>    - Fixed compilation errors reported by kernel bot for big endian flavor.
> 
>    v3->v4:
>    - Made changes to use masks instead of C bit-fields as suggested by Jakub/Alex.
>   
>    v4->v5:
>    - Corrected checkpatch errors and warnings reported by patchwork.

Unfortunately our e-mails crossed paths...  I'll reproduce
my comments on v4 here.  I'm sure you're going to grow tired
of this feedback.


I see one thing that I think might be a bug in the third
patch, but maybe I'm mistaken, and you can explain why.

I tested the code you supplied me last week, and with a
bug fix applied I found they worked for:
   IPA v3.5.1, IPv4 in loopback, checksum enabled and not
   IPA v4.2, IPv6 using LTE, checksum enabled and not
Both of the above tested ICMP, UDP, and TCP.  I will retest
with version 5 of this series.

I did not test with IPA v4.5+, which is unfortunately
the main user of this new code.  I will try to do so
with your updated code, and if all testing passes I'll
send a message with "Tested-by" for you to add to your
patches.

					-Alex

> Sharath Chandra Vurukala (3):
>    docs: networking: Add documentation for MAPv5
>    net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
>    net: ethernet: rmnet: Add support for MAPv5 egress packets
> 
>   .../device_drivers/cellular/qualcomm/rmnet.rst     | 126 +++++++++++++++--
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_config.h |   4 +-
>   .../net/ethernet/qualcomm/rmnet/rmnet_handlers.c   |  31 +++--
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_map.h    |  11 +-
>   .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c   | 151 ++++++++++++++++++++-
>   drivers/net/ethernet/qualcomm/rmnet/rmnet_vnd.c    |   3 +-
>   include/linux/if_rmnet.h                           |  27 +++-
>   include/uapi/linux/if_link.h                       |   2 +
>   8 files changed, 320 insertions(+), 35 deletions(-)
> 

