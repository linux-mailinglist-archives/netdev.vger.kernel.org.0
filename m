Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BC561B143D
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 20:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727859AbgDTSSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 14:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbgDTSSh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 14:18:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3125C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:18:37 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id b8so5331536pfp.8
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 11:18:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=ExZSdtSgRx1RudYjxfLpEob/7ydnYIztrhy1LgZsxyY=;
        b=EDlqZ58Ih2GKrLpDn9Gw2rH3fmDeHJ43MhrCvjVRTu2Y599qD/CuaaEH9iqVc13f/b
         jOrXSmPD1u9Kbo2Vb7fSymfHDwqKPZW3bYD0K8Dcp4dVj7efum+x8b23cac0NKsxxdyP
         13JAKpfFw9ZY9sUHerQK9ButHMa8LK53FLqT/u3B4TszxTU6A/KdR3cEej9l8ZTEUqUs
         k03ZWD7n38KzdBLI54mTKlhepgnNnmA6WhRyL/fOT2olTDXB4X12cSxEGd/BvPBg/uEH
         Z77jGQ6uXo4Cmvkx9ifRC91YmAUVUJKHx2fikgnUEeeJNR8fwibtAfPffqHhMypV6qxh
         IBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ExZSdtSgRx1RudYjxfLpEob/7ydnYIztrhy1LgZsxyY=;
        b=RlEF5GsHdeXu5gpAoMSJKX2OhgTIXoy0lv5G7T1ffSnQqaJcN/bvFAzOQ0ocnmuxSn
         PWGAoTEmJGT2RE/5UbII8sTrbxvZHg4t9ORB0rE2b/IU6wNdO3sEJpAhJR6EX4Lpc+OU
         1+uQsPutVNZmuUMNazf2l2J1p0hBY/RNeQu4mdXQKFDuFtoUkagwgDE72tI6wCziQMKh
         ukRLAE2glGRGdwlgDA+vWAe84D4cJ7knoktZ3kCBWAs3H6B2UFhUuTLZnCs2hVaEQ+Wg
         XOJ6erC1e2nLPJJhlLaxQZqu/So+1cGpb2uQYd+jtSRZ+WEeIdKIeu1ktII2IGN4Wlk2
         EjjQ==
X-Gm-Message-State: AGi0PubqzSSpuRuXWqsFGwkLcqLxhbFG7ujDNR7nD0unFa8mpmtg8wmO
        YHrDnSvlyH+sMHTviFWv+jRoBhiB
X-Google-Smtp-Source: APiQypJF0IYOlHZfy/CHMocONIuKOl6aKxCZTm0EiTyS4S1LTqh4UtmyEHWPK07Zw+l89J6XUNdY1w==
X-Received: by 2002:a63:a511:: with SMTP id n17mr7632119pgf.33.1587406716865;
        Mon, 20 Apr 2020 11:18:36 -0700 (PDT)
Received: from [10.230.188.26] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c1sm147650pfo.152.2020.04.20.11.18.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 11:18:36 -0700 (PDT)
Subject: Re: [PATCH v1 1/2] net: bcmgenet: Drop ACPI_PTR() to avoid compiler
 warning
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Doug Berger <opendmb@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <d193529a-57af-b694-32e4-cd64455c6a96@gmail.com>
Date:   Mon, 20 Apr 2020 11:18:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420181652.34620-1-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 11:16 AM, Andy Shevchenko wrote:
> When compiled with CONFIG_ACPI=n, ACPI_PTR() will be no-op, and thus
> genet_acpi_match table defined, but not used. Compiler is not happy about
> such data. Drop ACPI_PTR() for good.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
