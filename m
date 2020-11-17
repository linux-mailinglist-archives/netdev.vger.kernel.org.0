Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2602B55E1
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 01:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgKQA4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 19:56:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726321AbgKQA4F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 19:56:05 -0500
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 783F8C0613CF
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 16:56:05 -0800 (PST)
Received: by mail-io1-xd44.google.com with SMTP id u21so19397115iol.12
        for <netdev@vger.kernel.org>; Mon, 16 Nov 2020 16:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=pZ0suG+ilwYfkoEUsrzWSyUQQjFEywQRFVN8Vw7ud1g=;
        b=r5AQRNPDtjcKWdTkDZq5IEId2v68Jm8DaTpphp0JNvw9bQtk1jDrGJ7SAFPgYxAHmR
         OfzMPHkYeBVYmmJp7YSdOvxl4ll2OAfiTHwQLaHogTOUW7qiRfSBqKUC5hyaFePxNEyK
         mG9uapbMRxClidlLG/iuZ5fkfm66gwY6+4Bi/BGq2cQQKCpXEUy2gPlh1AKDID3gFqQF
         RdgeX1Bf21g89JPNvPlv0hSTGQeYU45Lp2/5nSYJgLyq+cJqaI0URjtrZBzRQnzkB06m
         Yl9O+ILuliFX+9F1wtjmGPuZy9V/u5dJjq4Efm7KDpkG8XnDxv4XlmxXuRmW9Rut/55j
         Vjcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZ0suG+ilwYfkoEUsrzWSyUQQjFEywQRFVN8Vw7ud1g=;
        b=Ch14nBQIsSVRe8FZjlqOseaUOTngWKy74m3Urf3eV7PTxkbb6nmLRL5kEBVqIzrIpR
         0kX2vwSFcOPbB4zN5NnQRsf6PFWOs0nqsoBK12nL0v+EXQeTZs2Aw3vzv9t77vU1jsXU
         3oPkGjlC0wGT/7Fa5y7i5nAchRI9TMO2DjpkPRU9a77qQ0760APWdhF2O7YG401o0PqM
         DGU/x85aKkZlq+9/NRR7nRAjqmYDN8ThCRlmnEjs7xr9iZpmxeIedL4VeWZZGO4ioq0v
         jHDacPYLQbh/+XNxMkk8f/4dsnAYcFvulgGTumUV6Qj8g4z4IWkFx6ePVAxU2Bpx2PVw
         ewvA==
X-Gm-Message-State: AOAM530G0dTeR3lu0mCv2dn4Pw0iOvgk0/Z7Hi+7np6SHDlhHixX8uvO
        nf7mCoYnI9zXwsc7E7SE4o1F+mrgdzw=
X-Google-Smtp-Source: ABdhPJyKZ5kVq5DwNK/r4f+b9rbq58euICHonmglwbPkT3/zGP+npblU3uFxphezXVhnrbv/Oi+04Q==
X-Received: by 2002:a05:6602:2d09:: with SMTP id c9mr10133180iow.55.1605574564785;
        Mon, 16 Nov 2020 16:56:04 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([2601:282:800:dc80:c472:ae53:db1e:5dd0])
        by smtp.googlemail.com with ESMTPSA id f18sm10271790ill.22.2020.11.16.16.56.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Nov 2020 16:56:03 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/7] Convert a number of use-cases to
 parse_on_off(), print_on_off()
To:     Petr Machata <me@pmachata.org>, netdev@vger.kernel.org,
        stephen@networkplumber.org,
        Nikolay Aleksandrov <nikolay@nvidia.com>
References: <cover.1605393324.git.me@pmachata.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <dcbc0c8b-feb8-634c-4eec-80afa0809c06@gmail.com>
Date:   Mon, 16 Nov 2020 17:56:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <cover.1605393324.git.me@pmachata.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/14/20 3:53 PM, Petr Machata wrote:
> Two helpers, parse_on_off() and print_on_off(), have been recently added to
> lib/utils.c. Convert a number of instances of the same effective behavior
> to calls to these helpers.
> 
> Petr Machata (7):
>   bridge: link: Port over to parse_on_off()
>   bridge: link: Convert to use print_on_off()
>   ip: iplink: Convert to use parse_on_off()
>   ip: iplink_bridge_slave: Port over to parse_on_off()
>   ip: iplink_bridge_slave: Convert to use print_on_off()
>   ip: ipnetconf: Convert to use print_on_off()
>   ip: iptuntap: Convert to use print_on_off()
> 
>  bridge/link.c            | 135 ++++++++++++++++++---------------------
>  ip/iplink.c              |  47 +++++---------
>  ip/iplink_bridge_slave.c |  46 +++++--------
>  ip/ipnetconf.c           |  28 ++++----
>  ip/iptuntap.c            |  18 ++----
>  5 files changed, 112 insertions(+), 162 deletions(-)
> 

looks fine to me. Added Nik for a second set of eyes on the bridge changes.
