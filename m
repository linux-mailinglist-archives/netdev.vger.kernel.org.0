Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D8F72EF76C
	for <lists+netdev@lfdr.de>; Fri,  8 Jan 2021 19:35:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728528AbhAHSei (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Jan 2021 13:34:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728114AbhAHSei (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Jan 2021 13:34:38 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A38C061380
        for <netdev@vger.kernel.org>; Fri,  8 Jan 2021 10:33:58 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b5so6655318pjl.0
        for <netdev@vger.kernel.org>; Fri, 08 Jan 2021 10:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rElT68AcPFuFv5u37CbHczZIemRCEy0PYqTzR64q4Ow=;
        b=lCmVCABj5PeeLGK3rVRqlSCsdahrCEdGsrgJLpYWWio11EVsjy9hNmlJNQ32cuwamB
         S2weZJfJlax3GPpwV41W9AtsW6kfVAay1GCedgYhxRKSMFV8pul6ROx1uj2/idni2RUk
         vH6Tye5DnzAyFMrsq49fPF0eU4mruogEN9WLjFfmi91ZimUNfiXjcfFlUm0G3f3jDIUl
         JodirQXgudKEqGqxznJBA/sr7ZALvE2VF9iCUeZ7Pt6znfHp+8iQ9nprVvfbLA4OuQqz
         Ek8y6pru7I3y0gbzGJghyb7kS9rgvAxCuZPPCjrXgOsjy91WF/3v5J3X9+U1T0lnVuT4
         zNpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rElT68AcPFuFv5u37CbHczZIemRCEy0PYqTzR64q4Ow=;
        b=jLPtJrQzNwIbRzuZ5wqmmmYfOV12ZnegY5r2xiqQ+XCQUGaWr+4SKkjwnLzxstjyEE
         GJBCWc6CQSa/ROGdDhnOc9cri3V+SHk+0Mm+M01Q6Q8Y7EJ3afn0UR3eFGhaCupFPyAR
         BD2pc7kT9KYSaNJTW832YRZVU0xRcGCGTG3kly3IHho/H+2neYHK3am3xRS+pJntK7jI
         k9fQq23PXPQ2XXuKPCg8txBngjYDlpSNt9JBOlydJZOKo9cCV+77BmnHByewXiPst9QG
         dkJmHYTQIyMo6F/M9aPnXSrKZ+F/CEx4xjp1q+t6rdjNfnxHQ/ztcAXGJbuFZGOkOogD
         4KPg==
X-Gm-Message-State: AOAM531kndtZAj9C5pKIDo3Bq4vmaBdr28RUgB/L3uV4u5b5mRfFjJUa
        rONNZa1YibX2ivV7eYIy5Ww=
X-Google-Smtp-Source: ABdhPJz2pmTcXrrnM825fIeCEoJcqxYNBkb9jX4weTfN0EDbwYkxxeejS0QjFuY9hytpcOGruNKViA==
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr5068081pjb.39.1610130837793;
        Fri, 08 Jan 2021 10:33:57 -0800 (PST)
Received: from [10.230.29.29] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id s33sm8890528pjj.56.2021.01.08.10.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Jan 2021 10:33:56 -0800 (PST)
Subject: Re: [PATCH v3 net-next 04/10] net: dsa: felix: reindent struct
 dsa_switch_ops
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     alexandre.belloni@bootlin.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, xiaoliang.yang_1@nxp.com,
        hongbo.wang@nxp.com, kuba@kernel.org, jiri@resnulli.us,
        idosch@idosch.org, UNGLinuxDriver@microchip.com
References: <20210108175950.484854-1-olteanv@gmail.com>
 <20210108175950.484854-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <04486ee6-c787-6ce9-dfb3-1629219662ed@gmail.com>
Date:   Fri, 8 Jan 2021 10:33:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210108175950.484854-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/8/2021 9:59 AM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The devlink function pointer names are super long, and they would break
> the alignment. So reindent the existing ops now by adding one tab.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
