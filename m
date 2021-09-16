Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80E6E40ECD8
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 23:44:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236320AbhIPVqP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 17:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234064AbhIPVqO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 17:46:14 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6E1C061574
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:53 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id dw14so5526600pjb.1
        for <netdev@vger.kernel.org>; Thu, 16 Sep 2021 14:44:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eGIz2vsC9LIX7e6x3f2ChL2pCNuAjexGZ/OmEuKbDUU=;
        b=PAs9eJxfysLFeUoCNK0cFXsVccoc8aKmkoYeILGXcDh+wVYVmQ8jeXgMShVvkWiWQt
         2EyvYinJdamQVg/feQ76THAhjgF+7l06ZuIXeHXBHc5cXI4ot2DZQgoGHu3Hxrqk9vcA
         B1ZdtrQU6mG4bEBwIJ1idpb9mKx2nS4pzKsNLqP/a2E9F65pzSxTJmJD/oxi1mRiAGeq
         uwLPNZXvCJH8TFMz0Ga3kAm0aUsI5SH2dt3lajd1D/vimsqCdpFGAXNDsTCPJU4dNMoV
         XtSkkknzFLJyBn/rSJyBNJHmqS67RxJ9WGqfhNS/Ity9O3qrmj719QL78eEq/PMu9LuQ
         4j1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eGIz2vsC9LIX7e6x3f2ChL2pCNuAjexGZ/OmEuKbDUU=;
        b=S1n7sKCL1YnW9WzO5L7McbMyllos/1ukZTFpDMQ1PTV9lfoHro/kKHrVaCH7XpHtbQ
         jp/XHCIcKFg+redgXQKmetRYtzf+W+xjiJEPUWacY9tEVyZOURl0XZN9lZHTRebOzQGO
         1wpZiEwEVc5mHF4p3TVgsDqGEf2X2xV0SbDMNehxig2fSrhCWo78asWq6Zs/RKeWkqpW
         NiZG7vHXgA82Bs88qKidiXON24j4XoQ8ofuX1N0ej1/mIIbZBMyy3LztMxUTmkZ91nKq
         GEB8XQOnZfxr3ui431U5QgG1CHvxtb2hTptvd2zitFRxZnYgt34zs9uEqCMhF8jGzN3T
         kQIw==
X-Gm-Message-State: AOAM531asGA0mM1witsiT8OmYcXPrObplW6LMHaMUs4c1vRwGEzfvFnJ
        xd62aqmWvhlj7UtICoTnuP4=
X-Google-Smtp-Source: ABdhPJx/jxUlqHYwsI+Z0vKJcGzCvgK6QSc4GmIYit35INnZuuf9l/jaQ2vi04WC1bn0eYiRzQnmlg==
X-Received: by 2002:a17:90b:3508:: with SMTP id ls8mr17032634pjb.240.1631828693310;
        Thu, 16 Sep 2021 14:44:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g24sm4037290pfk.52.2021.09.16.14.44.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Sep 2021 14:44:52 -0700 (PDT)
Subject: Re: [PATCH net-next 4/4] net: dsa: b53: Drop unused "cpu_port" field
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
References: <20210916120354.20338-1-zajec5@gmail.com>
 <20210916120354.20338-5-zajec5@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <29f5ccd6-5be2-b5f5-3429-9a8fbc6811e1@gmail.com>
Date:   Thu, 16 Sep 2021 14:44:44 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210916120354.20338-5-zajec5@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/16/21 5:03 AM, Rafał Miłecki wrote:
> From: Rafał Miłecki <rafal@milecki.pl>
> 
> It's set but never used anymore.
> 
> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
