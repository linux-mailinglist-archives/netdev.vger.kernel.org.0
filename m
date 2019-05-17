Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD22321A73
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 17:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbfEQPU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 11:20:59 -0400
Received: from mail-pl1-f172.google.com ([209.85.214.172]:40786 "EHLO
        mail-pl1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728749AbfEQPU7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 11:20:59 -0400
Received: by mail-pl1-f172.google.com with SMTP id g69so3495794plb.7
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 08:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8PJgrsi7mXw+GNRwKnEf+V+7tXYpja9lhxlXD/raQ0M=;
        b=bw9AbL4NL5CjJMxORRB46xB6sgxkeVX9JDkyZ0/s7wvxdvQusQ4+B+t6D8YvMa6pop
         GzdONThKaMQMIAjPd9hjDsuAEm50fIY1O2gl3KVaaj4mYNwKkbyaCN+mTFBY9Dp3ZOC9
         zyhcQ+/D6/SryIfFsCsarIWpjUBofFO25xStAXIuQ3Wy7LmIZVk/wQoH1Hflg+3QHKNN
         2GY51LHSfTIrgnZZn3KQ/nz/ztG6P1BC4xMc0Xx6MuhzA4RMaY0TEgTSB/CvLTV2e7Y9
         A6QDBto2aDjtDZ0JVyv7yKgckkB2GXkzZusPj9eZSjXlErHR3YFhUHsqYDgxG+21pfXp
         k4Nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8PJgrsi7mXw+GNRwKnEf+V+7tXYpja9lhxlXD/raQ0M=;
        b=tiPphXdrsv8NGIAVmKQfH8rEtQvF/fbCPOYoW0g78iX4KVY0+h+yGdxSPxvVH4RHsc
         zCQ5tQkcFtQC97DwOh/1+4ZVM546of/Xq3hygwGmt7pvPhgJZO4TIFqlR0FJmw2vR1wX
         SUmzah+khu4RVNBWoM2qkqmLXRARUVWaeCj/UEKA4uH9m07Ojv5S1DygJm9O+67owvIU
         d5b6SF/O34n91aWzs9k504/N5HWi5aF+XwQ87RfSqrszQChqXpOwkidxCr5l8RUokr0Q
         pWO9gjK+Z8AU1sXhE1yoSBsIkS6Q1yDgxEUuofgdzXTE8z8u5T1si/lZ82jVxKb5RlIk
         wYYQ==
X-Gm-Message-State: APjAAAUYn5XSIsLN2mTJlhuAr/0gJB5UsjQ2hfFsSVV+gynGEhIsIMfW
        4gphA/XC41vwHbctn/cICPc=
X-Google-Smtp-Source: APXvYqzePvHMAXboW5Zvj8+bNzJIsJw+2LEUIzOTwHNpRc2vHXkU/IWQonKRV/H1U7DR79KyOwTn9g==
X-Received: by 2002:a17:902:6a4:: with SMTP id 33mr15554281plh.338.1558106458884;
        Fri, 17 May 2019 08:20:58 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:743c:f418:8a94:7ec7? ([2601:282:800:fd80:743c:f418:8a94:7ec7])
        by smtp.googlemail.com with ESMTPSA id p81sm11992309pfa.26.2019.05.17.08.20.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 17 May 2019 08:20:57 -0700 (PDT)
Subject: Re: 5.1 `ip route get addr/cidr` regression
To:     Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        emersonbernier@tutanota.com,
        Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        David Miller <davem@davemloft.net>, piraty1@inbox.ru
References: <LaeckvP--3-1@tutanota.com>
 <CAHmME9pwgfN5J=k-2-H0cLWrHSMO2+LHk=Lnfe7qcsewue2Kxw@mail.gmail.com>
 <20190517141709.GA25473@unicorn.suse.cz>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <cb462836-a8d3-b8d8-fe3f-42186ade769e@gmail.com>
Date:   Fri, 17 May 2019 09:20:56 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190517141709.GA25473@unicorn.suse.cz>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/19 8:17 AM, Michal Kubecek wrote:
> AFAIK the purpose of 'ip route get' always was to let the user check
> the result of a route lookup, i.e. "what route would be used if I sent
> a packet to an address". To be honest I would have to check how exactly
> was "ip route get <addr>/<prefixlen>" implemented before.
> 

The prefixlen was always silently ignored. We are trying to clean up
this 'silent ignoring' just hitting a few speed bumps.
