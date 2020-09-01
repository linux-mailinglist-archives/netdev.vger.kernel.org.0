Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E5422586C4
	for <lists+netdev@lfdr.de>; Tue,  1 Sep 2020 06:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726124AbgIAEWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 00:22:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgIAEWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 00:22:01 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07C8C0612FE
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:22:00 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l191so1968903pgd.5
        for <netdev@vger.kernel.org>; Mon, 31 Aug 2020 21:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-transfer-encoding:content-language;
        bh=TO64331+vsFCdCCHoeGucrLfxTFFH7dWfmt7uKYqT24=;
        b=bK5MLsUTANRf3upSHUSARLV9uhLKhmQ9bQuxSn8a93R+AAZvEI1+HgP0qgwFFTf3FM
         UYIN5QLeOoY9aVVz3WfZzeDsWlH4t5yIOV7tVkKMucXt0VEJNM+qZFH5fGv2nuGhD50R
         NzVS3476oRl9NB9erkQQp+Ceo7uA7POKthaz5PKvnZfxOVAfsEp/XlD9bt1pUHSqzvF6
         CGVpAFk9kULAvmh+xn51ziNh3XbGv2dVqWARLx3EfGdPeesC4/I6c3bcw/UPeenU5w6+
         2dr5n6qDNy80lJbuFHp+RdNEXvvK+V5IEeoGhAx+iZakBcdFOe9HiCHdrx6BpOe+gMl/
         o0GA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=TO64331+vsFCdCCHoeGucrLfxTFFH7dWfmt7uKYqT24=;
        b=ka+4HIfcdX4/5keAH4jEmpzUp4TImSRxHgPG0yp3mUbHUvyiQ7coN+OEWk8qkNfrDv
         MnXsG00yyImePwFDhnUBJP3vyb9wnc55KtrpAh14MzqBlsukcD0ZPqjCbZXBLc0iiBOT
         0zUVDXpZuAogh8O/XxvLriTdTBDEXAj5PlEdVbNlM6lb9DtdBlmoauUyzjBATrAwp0w0
         Lr0yHTcgyPhLWOLI6y00ek5u1G6ttvsvT+7c5Q/VwKDJXzMVPkouHKXFOMwMeLF8xATM
         xosd89gUnzG0d9y1OklNMYrnWEEDkw5mKueMlfqHaqMrFpqSAwvdVqlbe7M9g0iRJ8aI
         UYqA==
X-Gm-Message-State: AOAM5329L331vjPQnJ4pD3MvQKXzV0AX2GDLTqxvPxOaDdHcqFWSnRgo
        kNs5dKZZK5aIrxdB4hPfrIqDMQ==
X-Google-Smtp-Source: ABdhPJwc3+7vvGSLSrR9kx+zjFw69PCdUGB/9Oook5G9lFSQuaEqSpUK3ThV4ZwYPbwVk8iXrYtV2Q==
X-Received: by 2002:a63:f70e:: with SMTP id x14mr3870335pgh.407.1598934120466;
        Mon, 31 Aug 2020 21:22:00 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id b5sm139509pgi.83.2020.08.31.21.21.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 31 Aug 2020 21:21:59 -0700 (PDT)
Subject: Re: [PATCH net-next 0/5] ionic: struct cleanups
To:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        davem@davemloft.net
References: <20200831233558.71417-1-snelson@pensando.io>
 <49f1ff16-c3e2-8bbf-e05c-8dc9328b2be1@gmail.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <7493cb9b-be02-a0c5-a4b4-2d7cdb62b337@pensando.io>
Date:   Mon, 31 Aug 2020 21:21:59 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <49f1ff16-c3e2-8bbf-e05c-8dc9328b2be1@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/31/20 5:47 PM, Florian Fainelli wrote:
>
> On 8/31/2020 4:35 PM, Shannon Nelson wrote:
>> This patchset has a few changes for better cacheline use,
>> to cleanup a page handling API, and to streamline the
>> Adminq/Notifyq queue handling.
>
> Some other non technical changes, the changes that Neel in the 
> Signed-off-by should also have a From that matches his Signed-off-by, 
> or you should use Co-developped-by, or some variant of it.

Thanks.  For now, I'll go back to using co-developed.
sln


