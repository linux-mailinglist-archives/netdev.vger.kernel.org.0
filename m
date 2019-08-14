Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1FE88DC5F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 19:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728890AbfHNRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 13:52:42 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:34988 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728768AbfHNRwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 13:52:42 -0400
Received: by mail-pg1-f196.google.com with SMTP id n4so11724172pgv.2;
        Wed, 14 Aug 2019 10:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=lRCo0N8AtsgFyI3T8EWB9ODOdEqeXdtYXIzkSor+lyQ=;
        b=HsF/WPDtNY7ixk84VAHlxCL3krT/gwSwTL/acmmEV7T4zsjApLlRsh76JHTxzYGS/2
         pV9udmkLyvBDUqEUG9eYrQ7Lb8KlTyFvW5ceqDO8YS+4uOlcoa4ss1OtBzDJ5nKDqagC
         7GSZ+nAQyjKHj+/8XUXcb3HQ4GDmPscWy0EAZSIxZpDfVStx7SvCyS6Fit7U3S4XTSDg
         qnVTHvaGNA+DLILdomzDH7ZTUlB9/ZySBq+juws3GT4G9ko8nmrtB74v8MJxy7y3MaWK
         UUhyhbvOzzbKxJUnObVVQ6Xic0EdJZ7+X65N7ziTBOz9TyIEfZLYawtZVjFF0COMqKdZ
         Lk/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=lRCo0N8AtsgFyI3T8EWB9ODOdEqeXdtYXIzkSor+lyQ=;
        b=XVK8018OSr7o7rLzCSAUyLBPyQrl9xEBNY84YXg+QBZm6UmpzxzZudfEe8CgArE6c7
         GUBkNf8DZYTbSRoArxiOeh4h14Q5nj5ZNqDsBHFlGlIdhDMMJbs26FQ88tfnsYv+KPQa
         lWjTRuCADU6m7kdfMzPduT+7eQwjJ7x80CN3d/GUtkX6FCZ4zu7lGWYDrh/P3kVdMrBg
         rvP+L8FM3pATc2PZEI1XuIhvU/MhDrjUKU7hGHsu7w/NQLRK8HtoBu/Cop1TZUAnwCwP
         WBmvLKi/bRO6j8/NbMtPFW6PJZcOs9SEMvcnZSHyfcml8nKu6pd/Wc7HhBo9teSJdOU5
         YGBQ==
X-Gm-Message-State: APjAAAXLb5zlZyojVCSXozMwhI0NYjj9octsvZIbVZC5uGJNdzNH3Isy
        WYKC096nNDOGYeUxPYviw8Y=
X-Google-Smtp-Source: APXvYqwv4d6CHKJYw/NR185R8CVRIV9LlAFP6ODKWjxN89NPM5qhVJByzvaTXGgNNrKc2ASnQv7GMw==
X-Received: by 2002:a63:8a43:: with SMTP id y64mr351919pgd.104.1565805161542;
        Wed, 14 Aug 2019 10:52:41 -0700 (PDT)
Received: from [10.69.78.41] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s16sm430549pfs.6.2019.08.14.10.52.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 10:52:40 -0700 (PDT)
Subject: Re: [PATCH v4 06/14] net: phy: adin: make RGMII internal delays
 configurable
To:     Alexandru Ardelean <alexandru.ardelean@analog.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, robh+dt@kernel.org, mark.rutland@arm.com,
        hkallweit1@gmail.com, andrew@lunn.ch
References: <20190812112350.15242-1-alexandru.ardelean@analog.com>
 <20190812112350.15242-7-alexandru.ardelean@analog.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <b591cc5b-9511-2223-ae34-088eaec0ba03@gmail.com>
Date:   Wed, 14 Aug 2019 10:52:36 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812112350.15242-7-alexandru.ardelean@analog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/12/2019 4:23 AM, Alexandru Ardelean wrote:
> The internal delays for the RGMII are configurable for both RX & TX. This
> change adds support for configuring them via device-tree (or ACPI).
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
