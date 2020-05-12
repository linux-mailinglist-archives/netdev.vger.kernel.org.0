Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A43521CFCD8
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgELSIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:08:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELSIf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:08:35 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BCCFC061A0C
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:08:34 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id b8so6495971pgi.11
        for <netdev@vger.kernel.org>; Tue, 12 May 2020 11:08:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=VNDI8PZ9jaHj5l65S7vRac++L+yiVV8ZDFdPgQEq14A=;
        b=iu0c5jH0ku1CXuChRC6s3IdnhVJpud4O4UdsqvCtQ7HlPNVYoPqYd3X93/QYTSmzFP
         EKOPEqESvZyPrwQT83gIyIXZYPWoRm4yGrImDVZnUxxsb8tOaEwFMeaGZKBy97Bp6wsZ
         h1hGiXFYK+8sLFrM0CU+bOXrqs9PNXACDuaHMnjdDrWuVdQ8C2uup4bDX8Bng5489hHu
         PBx37z74zcnz8RCjymzE2kVg40/cdG2NSdHUvQZ9Wv5XSNjZp4zmlaZ0tEyjzzZG89mP
         /PmXWdQ2Yh6ig3mmBwGycUs8kKpUwiMLxJLJeN0PR7k42CYkPhbnrEjrRM0hW6kMOMXK
         Gz3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VNDI8PZ9jaHj5l65S7vRac++L+yiVV8ZDFdPgQEq14A=;
        b=C2kIuP4kyJdMmIqwXH7Ta63wll+0dVVUR+Kw7uBlWmThl1gpLEq7fE/Ckluq20puOz
         FbYnE9dce/aDZjpiRgUkyhMRlwsAbQxKZ9g0PFfMHHPklhuzoXUIv9gyR7XrqOv3qDii
         NMLdeo/mybjU6fKlZIXtoJZG+iHONPUewrBydT2b0Rf293y14eJDQl79yQsnQYIQOvDo
         YCOfePFLTnoscpyHaVCpDbcAg25YeOkWtHisxNlBJL4HyULQ8hfF7rZNh6h8EkxK7YwB
         i+7QJ28Sw6k2XkFOGGdura9Z2a0MCbOV6BEnW4eyHtQxcwW1ttJTj31zKRIV6uGLWEj1
         u5RA==
X-Gm-Message-State: AGi0PuaWeNy5vjn3Zthel6gLWxZeYIZUFv+F+Vt+XYYYAAyw+DBfNZhU
        g2LR4SAsxNmOVJZLRVbp+2n+Aw==
X-Google-Smtp-Source: APiQypJAxfUPb0uPphDAF+bKGOucKrApQO4clWguB2mDhx1el1fJC/8QocC0hked2jVaSafF/VwIEw==
X-Received: by 2002:a62:1bd0:: with SMTP id b199mr21875008pfb.283.1589306913615;
        Tue, 12 May 2020 11:08:33 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id c1sm12564733pfc.94.2020.05.12.11.08.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 11:08:32 -0700 (PDT)
Subject: Re: [PATCH net-next 00/10] ionic updates
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
References: <20200512005936.14490-1-snelson@pensando.io>
 <20200512101321.164ffa20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <3de5322b-ff15-11fa-9181-7c8408522540@pensando.io>
Date:   Tue, 12 May 2020 11:08:31 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512101321.164ffa20@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/12/20 10:13 AM, Jakub Kicinski wrote:
> On Mon, 11 May 2020 17:59:26 -0700 Shannon Nelson wrote:
>> This set of patches is a bunch of code cleanup, a little
>> documentation, longer tx sg lists, more ethtool stats,
>> and a couple more transceiver types.
> I wish patch 3 was handled by the core, but no great ideas on that so:

I thought about sticking that into the core calling spots, but I suspect 
that there are other devices that allow some configuration activity 
while the PF is unavailable and I'd rather not break them.

>
> Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks.
sln

