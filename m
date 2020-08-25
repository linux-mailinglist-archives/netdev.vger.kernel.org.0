Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5A5C250DC3
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 02:43:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgHYAno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 20:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727968AbgHYAnn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 20:43:43 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD1EAC061574;
        Mon, 24 Aug 2020 17:43:40 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id ds1so330764pjb.1;
        Mon, 24 Aug 2020 17:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=D6KF3YyF8XW7CU02DB+9SDZOobpa8DnWIkfKxSLrha0=;
        b=hbiad5YBHrZmPttPpjGDQ8Nhfv2fKXHVMI4ebQsp4hGaxu5txlSFQSvQcPywedpv6I
         kkoTDf+pnZx5s7CFagLvXkrz0cFi5ddI6neBd8BjgFrANrWgB9KDDyXX49HS/iNNcaPz
         z59U83Q1yuvju0wi/tkoBCrWst8IH0SmUilAgdwhWPIudMgDEjto34hFa3o6AjMunR0g
         zPxCQsxlFvyEk3eXkVw6kMSRueinojdkFmwzA8vXzBhZqCndYS8y+B5qKHZpC8Wn7hEG
         JO23zqscadTllO2TCDsxwX6Le9BPdZvHX0IHwf0FoayBa05NB8j0MEmRdekExT04HQ+9
         VHtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=D6KF3YyF8XW7CU02DB+9SDZOobpa8DnWIkfKxSLrha0=;
        b=fp3NRsfVuekh8FBBtrkgLFisnl26ZKpVSMfwZfUUSpYQH5MoW9uNRau63cQgjRw2tl
         kVVsUlad4x/jhaSFT94bl0YZOigou86pA7Hlx6X2O1mAXFjNIXxghep/4l/m9qUr8w/D
         9AfMXs1pfta0eyvTSbGTF+MGi1eXQGqoITcDLk6tsatX7hoS9eC+tviqphMEOGxgNWPd
         9AjEVbVbqjCz4IWaFR11Fa5c1mENRs2A2Xc6xWC+SRZkimAnubpiGs9LlbLs47MsjY8S
         7SB1UoAd6yqueYKZOKLF8nLj08w74yDV33Fyhh4Qk3R49rO6lMOXLOA/DOWzNqouxjRm
         hElQ==
X-Gm-Message-State: AOAM530/c3t7liHNU+y+39fomLOJ26tN18HQW0sBgIx/Z3vcbfM/bDTy
        Y9oG1yBuxYRBI89zpM3v1vY=
X-Google-Smtp-Source: ABdhPJwayAyLWT/ej7w91nbRscZjR98nq8drWRqMz6g/m45+2aSM4QyOY34I3OqlX7DmMuaIFAfZlA==
X-Received: by 2002:a17:90a:e287:: with SMTP id d7mr1389875pjz.21.1598316219971;
        Mon, 24 Aug 2020 17:43:39 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id d23sm655766pjz.44.2020.08.24.17.43.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Aug 2020 17:43:39 -0700 (PDT)
Subject: Re: [PATCH net-next 0/6] MAINTAINERS: Remove self from PHY LIBRARY
To:     David Miller <davem@davemloft.net>, f.fainelli@gmail.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
References: <20200822201126.8253-1-f.fainelli@gmail.com>
 <20200824.161937.197785505315942083.davem@davemloft.net>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bd8da53d-ebf8-2e2e-124d-f12e614d820a@gmail.com>
Date:   Mon, 24 Aug 2020 17:43:37 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <20200824.161937.197785505315942083.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/24/2020 4:19 PM, David Miller wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> Date: Sat, 22 Aug 2020 13:11:20 -0700
> 
>> Hi David, Heiner, Andrew, Russell,
>>
>> This patch series aims at allowing myself to keep track of the Ethernet
>> PHY and MDIO bus drivers that I authored or contributed to without
>> being listed as a maintainer in the PHY library anymore.
>>
>> Thank you for the fish, I will still be around.
> 
> I applied this to 'net' because I think it's important to MAINTAINERS
> information to be as uptodate as possible.

Humm sure, however some of the paths defined in patches 4 and 5 assume 
that Andrew's series that moves PHY/MDIO/PCS to separate directories. I 
suppose this may be okay for a little while until you merge his patch 
series?
-- 
Florian
