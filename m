Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71553342F87
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 21:37:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229870AbhCTUfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 16:35:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhCTUfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 16:35:22 -0400
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2584C061574
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 13:35:21 -0700 (PDT)
Received: by mail-ot1-x32b.google.com with SMTP id h6-20020a0568300346b02901b71a850ab4so11959186ote.6
        for <netdev@vger.kernel.org>; Sat, 20 Mar 2021 13:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/SsrPAj4nblmUyJmmUBSPqkp6Qu+FiUJV9dt0qH1/ws=;
        b=KS5BZAYu+RInOE4rLzXoeVQZtVUN63m+T2TsjjPJTjYd04W0dO/DcQ0N8K4TR4VqVs
         RWwH5viEKRWSjZZFCoVboX46JNcvZ6TNOLKzqVc8Il0TyHgW6Uz3zoxGDGzYsbrUpAqj
         2Caje2T9wAs+1QZTMFYcAeg2HHelCdBouxz8+W6iNGDIOxBR+VfqrFSE0TNZvTztQt1B
         xeQSAAKNtMCX1IU+ToRfa5YkVolUAMnUnHhmaFfiGS7UxlCrRZDFPToKTkQjyP2OgTiu
         BilOrit+O0OM61PZ2JY9yJtgOWOdK6exWfr+9RDv+Ku2XaCZ8ksK6qEfm16TdkOOBNLZ
         ZwMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/SsrPAj4nblmUyJmmUBSPqkp6Qu+FiUJV9dt0qH1/ws=;
        b=Ucw93Pgm5pjtJftl5zAf5N78S45tSogmxaZq2dJVFu5sMxElSM2m77p5wFkfQwX0/G
         NgPnYcVe0NpK/X0GD3PLucwto0KCvpTn/Q7XpQV31EK+LpPxwtgCzhUzaM2ukmwmZt8U
         Sla/F5czfTpjlACARLSXaFnPFv/yYjmcMquTmVUM1WZrxfYjPxkoAX5nsU5sWWMpG0Vg
         gIPfnk8A4jOt1o/W7T79zmqeJEaoJHIujfFPiW/91JrDXTNgIaa8zzp7MvZDbLclX0OS
         S6L8VQRmQ1E02vH7nvLI/kbW3RbYE0cZRxGzVxqmT4/P0JL8clansavqZxsZt97cJ+7t
         dVMg==
X-Gm-Message-State: AOAM5303h3N0HrSzGPi+bvJFpUNOMP94Bs8cKZzZNBHADNR0ercBkHhJ
        DUtVuxw1X8/HSMH0aR2lgneQT2lzTc8=
X-Google-Smtp-Source: ABdhPJwlpRR99NFlZoTM4jzfUicWXZO7hUykwgP6t7NG+YQm1AebpXXOssd57fI+zZJZnBUFnAK8VQ==
X-Received: by 2002:a05:6830:1c6e:: with SMTP id s14mr5934916otg.17.1616272521051;
        Sat, 20 Mar 2021 13:35:21 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:15d7:4991:5c5e:8e9d])
        by smtp.googlemail.com with ESMTPSA id e12sm2107733oou.33.2021.03.20.13.35.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Mar 2021 13:35:20 -0700 (PDT)
Subject:  rfc5837 and rfc8335
From:   David Ahern <dsahern@gmail.com>
To:     Ishaan Gandhi <ishaangandhi@gmail.com>,
        Andreas Roeseler <andreas.a.roeseler@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>
References: <20210317221959.4410-1-ishaangandhi@gmail.com>
 <f65cb281-c6d5-d1c9-a90d-3281cdb75620@gmail.com>
 <5E97397E-7028-46E8-BC0D-44A3E30C41A4@gmail.com>
 <45eff141-30fb-e8af-5ca5-034a86398ac9@gmail.com>
 <CA+FuTSd9kEnU3wysOVE21xQeC_M3c7Rm80Y72Ep8kvHaoyox+w@mail.gmail.com>
 <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
Message-ID: <a41352e8-6845-1031-98ab-6a8c62e44884@gmail.com>
Date:   Sat, 20 Mar 2021 14:35:18 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <6a7f33a5-13ca-e009-24ac-fde59fb1c080@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/19/21 10:24 PM, David Ahern wrote:
> At the end of the day, what is the value of this feature vs the other
> ICMP probing set?

Merging the conversations about both of these RFCs since my comments and
questions are the same for both.

What is the motivation for adding support for these RFCs? Is the push
from a company or academia (e.g., a CS project)?

Realistically, who is expected to use this feature and why given the
information it leaks about the networking configuration of the node. Why
is this tool expected to be more useful than a network operator using
existing protocols like lldp, collecting that data across nodes and
analyzing, or using tools like suzieq[1]?

RFC 5837 has been out for 11 years. Do any operating systems support it
— e.g., networking vendors like Cisco, Juniper, etc.? If not, why not?
This one seems to me the most dubious at this point in time.

Similarly for RFC 8335, what is the current support for it?

Linux does not need to support an RFC just because it exists. I am
really questioning the value of both of them

[1] https://github.com/netenglabs/suzieq
