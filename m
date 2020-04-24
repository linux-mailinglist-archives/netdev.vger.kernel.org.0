Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A641B737F
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 13:59:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726882AbgDXL7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 07:59:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgDXL7J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 07:59:09 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E8A6C09B045
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 04:59:09 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id f18so9616403lja.13
        for <netdev@vger.kernel.org>; Fri, 24 Apr 2020 04:59:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=S+yBMYNVRFyvJW4JlBM9svUKJeMIKoXS31YVPYoI3wk=;
        b=umkc6zh1mpHsMuqE0JCi52u7o05OF2fe71Dt8DSMWSYuDhTZNIeSU8KSpWCAR+4HYN
         W+cuBXKcBRS6BIy3ays0tX4EG5dMu1TDGHQhPmpaBRrtUH1632ksAT+l8zpfFv/LefeL
         Mle/sbGDhs3vF85TXJE1q/w73QNqOrQ3NWkGfGwRpdgRfgwOP6stpUD6ldfZz5arqZJQ
         n6ZihBAAGwmkD94DjecbGoWnA1YLozas39ny66F1etm25yxZ/h69wmKfbfBOOV+INzgX
         DkKHUGL6wsDH5sXWXrk7dZp8VZVM6wJtrWUz6P+kUvrRSlcFy2BeYX1SvLPsec6jRXHG
         7mTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=S+yBMYNVRFyvJW4JlBM9svUKJeMIKoXS31YVPYoI3wk=;
        b=YdeN3J11dKJhdaUJtMEDTKW0u7DyYbBEpp168OkOyY3fWOCtM8ceroftPD8rH8xv6e
         wwLG5W3WKH8dMI1JJtxl/LcBEKES57OCxGRVFyekiir3maxBqzwQsaluTrHyumZ3ulVb
         JDH6Xp4tnvpdm/HNc3BOqDf0yG+Vc0SvzHeehRFAe8t5MQI/lWSPkKcBMt93yif/WAT5
         xIC9g3qZSHdZ1vhhwhXpOafFCyRMKw2+MLjWQkC6DIXZlRoMnZf0vMHZkNmKz6Wn5Bfy
         EyVN8+VDlNo8tOLQYrpbSfGVum3DeOJUOkVZ9QWV7HlCL7xuGOZJcVkBVNYLQH/NB+1+
         rEbQ==
X-Gm-Message-State: AGi0PuZH7mhOgFpBgvgLTk4sBRU/qXQStF+WBu5kSPWAxP81xqGmJ2c1
        upWooYIuV9evkyIcgfl1sfor4g==
X-Google-Smtp-Source: APiQypJA/Jj8k1RyumTDUcNNFRefy4LnrX/jcN1Gi5Qg6/1DPcTzIQMuZNAY7jj0ZHr6hpxhuzdBVw==
X-Received: by 2002:a2e:8603:: with SMTP id a3mr5794332lji.153.1587729547414;
        Fri, 24 Apr 2020 04:59:07 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:6b0:1584:1a81:c430:c3eb:7993])
        by smtp.gmail.com with ESMTPSA id u2sm4390222lfk.67.2020.04.24.04.59.06
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 24 Apr 2020 04:59:06 -0700 (PDT)
Subject: Re: [PATCH] dt-bindings: sh_eth: Sort compatible string in increasing
 number of the SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        "David S. Miller" <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rob Herring <robh+dt@kernel.org>,
        Simon Horman <horms+renesas@verge.net.au>
Cc:     Lad Prabhakar <prabhakar.csengg@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
Message-ID: <c3e5be67-4e6e-e6c9-8de2-9cab13848dbb@cogentembedded.com>
Date:   Fri, 24 Apr 2020 14:59:05 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <1587724695-27295-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

   The bindings file is no longer called sh_eth, please adapt the subject to
the new DT reality...

On 04/24/2020 01:38 PM, Lad Prabhakar wrote:

> Sort the items in the compatible string list in increasing number of SoC.
> 
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

MBR, Sergei
