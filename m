Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F35951F6D75
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 20:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728020AbgFKS1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 14:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726673AbgFKS1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jun 2020 14:27:11 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06169C08C5C1
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:27:10 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id b27so6534250qka.4
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+fwTo02qhgLWFma2zX6FvAm16SaYYSvtId+uYImuO1k=;
        b=bP8AfqOFtoCo8AXOCb9t7NaSBLTeXk6KekyiJYYGxnLzqQ9te32ALinKYEb5GRD9XL
         aBQHqw7fQHDQqcvcj3U/65Wab9Ljun2o3k1YaBZ8Ui6XlcJToD3VEJ7Gc0vw6basBm4P
         jNvYwRqzqB+JE1EFlOJDJhO9Wdzcr5t2tpO1HNI65ftcME8A9PCjUPVwkY25d4pWGz8U
         2OwXdwLJvu8FkNnLNBmVHjhQcx4ARCgxSR2AElaLMrPWH8lI1fIAhTN4G7TLA/1s2VM5
         b6sVa4jR4zd4Ihhzx4tcKXPSxnXLtjTSksDqdfL2qNdnAE11myyn97xPx/8gB2ZjzDIS
         KoSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fwTo02qhgLWFma2zX6FvAm16SaYYSvtId+uYImuO1k=;
        b=XlmmYwkW6PvmRZhOwh0YJvrLpeOhQz8iPQ63gDPwuCKWrLamdumvDGAa1L73/xzy4Y
         q1wNqcs6vuwKKQFxc3lt2REb+8U8kQWVLzRPvEKM9KFr9N4DsWBi1EEXFHKalVwqlVx1
         cMZNEoRPTfJmHGohdwNVG+N3T1KJqvUl0J3a0ik9V7NYlehGGn7ZHjk1XBjc/brgiO5X
         Ovz20Vf9UXApaWC+5DDBfXNKmMCOVRBkDiWrvurVsrw4Go1UNFlH4xhje6OlWtJAhZxo
         L1h1lOfkA10umnThvj3Ygd//YQ+MSLcQZ/H5iROeHW78+VXRejkpbJwleVohKlbTz0+H
         h5MQ==
X-Gm-Message-State: AOAM531b8mYrjbmtLA7J2LcNDmZuG51C5U+qf4ZLgK9nzyOVlh5SLO17
        JboCp1ko8msr+Y8+30vtiu0=
X-Google-Smtp-Source: ABdhPJwi7ZGC/YpsHCanDEVf/zoFj4IyJp9ACb5n2I8xppdxAvF1UiJ4KsaS4rgA2Rbw5rLsMStT/Q==
X-Received: by 2002:a37:b95:: with SMTP id 143mr8547899qkl.99.1591900028992;
        Thu, 11 Jun 2020 11:27:08 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:1179:8d76:2c34:5284? ([2601:282:803:7700:1179:8d76:2c34:5284])
        by smtp.googlemail.com with ESMTPSA id v3sm2548362qkh.130.2020.06.11.11.27.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 11 Jun 2020 11:27:08 -0700 (PDT)
Subject: Re: [PATCH] can current ECMP implementation support consistent
 hashing for next hop?
To:     =?UTF-8?B?WWkgWWFuZyAo5p2o54eaKS3kupHmnI3liqHpm4blm6I=?= 
        <yangyi01@inspur.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>
References: <6f0bf0c31d634134a0bf4ed4dbf17f9c@inspur.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8ff0c684-7d33-c785-94d7-c0e6f8b79d64@gmail.com>
Date:   Thu, 11 Jun 2020 12:27:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <6f0bf0c31d634134a0bf4ed4dbf17f9c@inspur.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/20 8:56 AM, Yi Yang (杨燚)-云服务集团 wrote:
> Hi, folks
> 
> We need to use Linux ECMP to do active-active load balancer, but consistent hash is necessary because load balance node may be added or removed dynamically, so number of hash bucket is changeable, but we have to distribute flow to load balance node which is handling this flow and has current session state, I’m not sure if current Linux has implemented the algorithm in  https://tools.ietf.org/html/rfc2992, anybody can confirm yes or no?
> 
> I checked source code in https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/tree/net/ipv4/fib_semantics.c#n2176, every next hop in fib has a upper_bound, fib_select_multipath just checks if hash value is greater than upper_bound of next hop and decide if it is selected next hop, so I don't think current linux has implemented consistent hash, please correct me if I'm wrong.
> 
> Thank you all so much in advance and sincerely appreciate your help.
> 

The kernel does not do resilient hashing, but I believe you can do it
from userspace by updating route entries - replacing nexthop entries as
LB's come and go.

Cumulus docs have a good description:
https://docs.cumulusnetworks.com/cumulus-linux/Layer-3/Equal-Cost-Multipath-Load-Sharing-Hardware-ECMP/#resilient-hashing
