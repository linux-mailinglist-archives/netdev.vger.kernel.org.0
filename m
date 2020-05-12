Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A25661CEE8B
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 09:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728911AbgELHuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 03:50:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725813AbgELHuQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 03:50:16 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29F56C061A0E
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 00:50:15 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id u4so9721207lfm.7
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 00:50:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0WcvL1fwWHBcoJrzzXl8Y9z1jSMK5TQ31/Tsh0Md1tM=;
        b=lNCp3F2Ygx600BVUbC8Dg65qCe8TRx2s/0qFe+EqHdwdxv8YFEdJi6IcfbzWVt2HMY
         MalNqPo0hm6pS+0/z3OeeB9uZfVhY09wz6Di5PMa/AW14vJUx72Kf52Zbt0ijbNPSCFW
         jxBe1qKSLXTDwcfPqRa14svgGfsA4qQ4zAdmGPrrCVk42hnFa6qnDI+WmBD2TU3kx1CX
         1yXMOF/tFh6ipOPxz/o0vqXDO0wD+mraXvv02dfmalJ78h04Lw+15lAQtS24wuJvb2gr
         RkZ0SAcnyQgKHD+Rn2r8MZE0HzLSK3hhMf/tZuc2DoDnA+EDkvHt5TBXt94hi3IV5Oxt
         0HiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0WcvL1fwWHBcoJrzzXl8Y9z1jSMK5TQ31/Tsh0Md1tM=;
        b=Wl8M1kgf0Esu1YmdviLT1D35PkicRUAjNfs+miU60hepCLc3beOAmljDoRPxeL0I8Z
         wnHrGMK8ob+Nghn+ET1vkcyMeikZimDeFyypKmSitik5bJaQEqv8MsavR/KJ3jvjWQr0
         01Yt6/L1pq5mhoMrwN+Fg6W3J51U6XjVfFieSlY0Ql8ETE5zxja+Bg8MiRS9wXSSgxpQ
         7E7v4RJJQ9auWc+AwDkFen9xu29VcON1oDvHS/wZEPPaWlzZHxtGeVJ/1kIdK0Mb6E7b
         2lrMF1ULPToHnZVHG8nQN1b5CVMlSST55unjSO2lmbmob1nbzTs90NWu4szYSNCQKvqP
         Lsmw==
X-Gm-Message-State: AOAM531ofd8/mZq4Ey02u9JY5JhzVUYm0BRFTVeG6taEyljPD1vnW9Eb
        RU9wCIBjUNd0cRjOiDwGWVrEgg==
X-Google-Smtp-Source: ABdhPJz1U/AKQVEmTfopcIhAFk7bSfKlU8QA5XuMgd57DBQmKEFzrpOVHrwsLbl+e3E3ff+YR113KA==
X-Received: by 2002:ac2:5199:: with SMTP id u25mr13532900lfi.80.1589269813516;
        Tue, 12 May 2020 00:50:13 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:61b:c4fe:68d6:9937:777b:c884? ([2a00:1fa0:61b:c4fe:68d6:9937:777b:c884])
        by smtp.gmail.com with ESMTPSA id y129sm13395002lfc.23.2020.05.12.00.50.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 00:50:12 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: sh_eth: Sort compatible string in increasing
 number of the SoC
To:     Rob Herring <robh@kernel.org>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Lad Prabhakar <prabhakar.csengg@gmail.com>,
        linux-kernel@vger.kernel.org,
        Simon Horman <horms+renesas@verge.net.au>,
        linux-renesas-soc@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
References: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <20200511212204.GA1071@bogus>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Message-ID: <bba5ab6f-d077-544a-5085-4f7cdc9aa0ca@cogentembedded.com>
Date:   Tue, 12 May 2020 10:50:06 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200511212204.GA1071@bogus>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 12.05.2020 0:22, Rob Herring wrote:

>> Sort the items in the compatible string list in increasing number of SoC.
>>
>> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
>> ---
>>   Documentation/devicetree/bindings/net/renesas,ether.yaml | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
> 
> Applied, thanks!

    Mhm, there was v2 with a corrected subject?

MBR, Sergei
