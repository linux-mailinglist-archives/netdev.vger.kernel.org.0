Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7452F30141
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 19:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbfE3Rwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 13:52:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:42300 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfE3Rwc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 13:52:32 -0400
Received: by mail-pg1-f194.google.com with SMTP id e6so1183496pgd.9
        for <netdev@vger.kernel.org>; Thu, 30 May 2019 10:52:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=26hPTiKOnKRy60yRrIATXKYkTmEvDalVnJK3pHQpR90=;
        b=TLXHGb81nWZFzND5q5MFJsD+mrk1jCOWnHIsyppiAj/TVim1J2KwMYGIzBfQHkLRrw
         DiYdIN+VneRQhFi0zKYHJYV+CJ9GoFLx/oO1QXSzGBHZl8DswyxLZhey6VOJMZ1KppFN
         E/LNEodp0wlRevBLmV048JrNlI/NW0owTtXwkTLXNYgWhfo6ISCgxfJQ0+Pf2/KQ7z/n
         QmM0cgqiRTWf60Hkhqq2gYXOnTW2/6CYDyVJh+JJpS9FgPpaEGIfMh7CM4ppHyL/O1Ox
         3MI3l9NCHtS2CY8NODcfPyPrq57bQnCL4tifLoUnE0QxdOV2DhSL15IClOxsZC0uIU9M
         H4mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=26hPTiKOnKRy60yRrIATXKYkTmEvDalVnJK3pHQpR90=;
        b=QR5YZx/ZioGIcJOuhXconyr+WHxYCgQELlJW+cbJabLs+aAxQcRQotKQMTC0TCfQ2Z
         2RQb+RzZ2GlJ8O24266JgT3ijX82U5xG22FNdoW3sStPzQFDslSnuiG9oAii78wTpqEJ
         OlUs6Jta2+CCVg6kTD6h/QCL3KwptH9Ah9RWrMSCD43RuB4B5sOM144+0DaaIAtnFWsE
         NUnTLMYOKDCAbl7EN93tsdg8J8tdRYsdhb8e814bIeqvgry/hlaP6mi0KkAHeZnMwTDT
         U8Dea2gqqJl4xQOhUBIB0Koc5IyT/SvGUrY5tLMw8Lb5j5vTs78W7UgT1o06JjVmE3w/
         ayBA==
X-Gm-Message-State: APjAAAXjm3j2SFClrsar7fp1+QqJ47B5spiWg2jhbHzfSVTnbSX2pqSo
        q+rHYPwoMPj7ZHTH6UOneyRHWHuiKEE=
X-Google-Smtp-Source: APXvYqzZ2kMMaU/FlkVfzPITkCB4WUnPuubsVZiD7wLedDGngiu47h0k3cY2oV1haExC1Cz7hfteig==
X-Received: by 2002:a17:90a:de14:: with SMTP id m20mr4757153pjv.36.1559238751263;
        Thu, 30 May 2019 10:52:31 -0700 (PDT)
Received: from [172.27.227.250] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id t10sm4762286pgk.17.2019.05.30.10.52.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 30 May 2019 10:52:30 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 7/9] Add support for nexthop objects
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20190530031746.2040-1-dsahern@kernel.org>
 <20190530031746.2040-8-dsahern@kernel.org>
 <20190530104521.3600201f@hermes.lan>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <eb5fc621-b6b0-f8fb-ebb8-30c16748bb1a@gmail.com>
Date:   Thu, 30 May 2019 11:52:29 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190530104521.3600201f@hermes.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/30/19 11:45 AM, Stephen Hemminger wrote:
> On Wed, 29 May 2019 20:17:44 -0700
> David Ahern <dsahern@kernel.org> wrote:
> 
>> +static struct
>> +{
> 
> kernel style is:
> 
> static struct {
> ...
> 

The style I used is consistent with existing code -- e.g., ip/iproute.c.
If you want the above, I can do that.
