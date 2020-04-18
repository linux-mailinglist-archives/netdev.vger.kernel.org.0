Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 174CF1AEB10
	for <lists+netdev@lfdr.de>; Sat, 18 Apr 2020 11:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725960AbgDRJBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Apr 2020 05:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725862AbgDRJBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Apr 2020 05:01:08 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C5EC061A0C
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 02:01:07 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id w145so3764039lff.3
        for <netdev@vger.kernel.org>; Sat, 18 Apr 2020 02:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=v2r1LNfcfZSMQjP8dr2xBneKdKcMoniQ02EHOw8mPkg=;
        b=Qehbzq/lwAQz4mxTlNzPxp6RB0mgqSy6uthfto33Yze71yukx+lvwUC0wtejhWPCrB
         ZR61llSdswVXVylEAI0rCx9MSdy836jyhFHESLcLn/3O6xufpGPw8Q3mEhjvTON1BAQn
         OWcR3LP0XXCqINT2trWlumMb9ADMtQLqZnEfk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v2r1LNfcfZSMQjP8dr2xBneKdKcMoniQ02EHOw8mPkg=;
        b=tjenI9RzoU+O13D3OzyLzrzjlaqhvRZJhlOAwED843GYiFqsA25ns8e9ynU3LHkTsT
         MVCRFFAwSIpd2ZYoRlLjGBtE8BkPBpE0KbsLLlg9rTl7T8KdCfpjAWL+jMUICfzrPVCa
         Vbmf3rU3nhgsNL6wUMA7OLC9vgjMf0TGBP4inJOPs3KokuXECqW2jMYi91W01TIvFKo8
         mnx1pTzTStuBLJ5FWXFbExDNjbZ/H2KXeWm2FmFRE5LDSMxO9O6ozJ2B2GYbcAzZYOqX
         kTc+vI00kWDbRC6Ygl/BqzSFq+5v6ftCpr4/FViiDCQQXNyztIOstUbXGNgSj0tL/X30
         ek2Q==
X-Gm-Message-State: AGi0PuYVIuDWlvgytI6NrGJI+aIz096155zbr+oMHZEGvf4cg1LqjzbF
        0X1Qma1r6xuAaMky45mSya4B0A==
X-Google-Smtp-Source: APiQypJB7StCrR9XTUXa/d7LPRLIwRuUYoumhbZUVEivdD5SyjUZLN5f+omoQA5zGMpiIA17F4dZcw==
X-Received: by 2002:a19:4014:: with SMTP id n20mr4332985lfa.6.1587200465617;
        Sat, 18 Apr 2020 02:01:05 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id q16sm6063952ljj.23.2020.04.18.02.01.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Apr 2020 02:01:04 -0700 (PDT)
Subject: Re: [RFC net-next v5 0/9] net: bridge: mrp: Add support for Media
 Redundancy Protocol(MRP)
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, davem@davemloft.net,
        jiri@resnulli.us, ivecera@redhat.com, kuba@kernel.org,
        roopa@cumulusnetworks.com, olteanv@gmail.com, andrew@lunn.ch,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, UNGLinuxDriver@microchip.com
References: <20200414112618.3644-1-horatiu.vultur@microchip.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <59ccd697-3c97-207e-a89d-f73e594ec7eb@cumulusnetworks.com>
Date:   Sat, 18 Apr 2020 12:01:03 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200414112618.3644-1-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14/04/2020 14:26, Horatiu Vultur wrote:
> Media Redundancy Protocol is a data network protocol standardized by
> International Electrotechnical Commission as IEC 62439-2. It allows rings of
> Ethernet switches to overcome any single failure with recovery time faster than
> STP. It is primarily used in Industrial Ethernet applications.
> 
> Based on the previous RFC[1][2][3][4], the MRP state machine and all the timers
> were moved to userspace, except for the timers used to generate MRP Test frames.
> In this way the userspace doesn't know and should not know if the HW or the
> kernel will generate the MRP Test frames. The following changes were added to
> the bridge to support the MRP:
> - the existing netlink interface was extended with MRP support,
> - allow to detect when a MRP frame was received on a MRP ring port
> - allow MRP instance to forward/terminate MRP frames
> - generate MRP Test frames in case the HW doesn't have support for this
> 
> To be able to offload MRP support to HW, the switchdev API  was extend.
> 

Hi Horatiu,
The set still has a few blocker issues (bisectability, sysfs error return, use of extack)
and a few other cleanup tasks as I've noted in my replies to the respective patches.
I think with those out of the way you can submit it for inclusion.

Cheers,
 Nik




