Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 826191B1909
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 00:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgDTWJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 18:09:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726362AbgDTWJ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 18:09:59 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7DF9C061A0C
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:09:58 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id y24so1354482wma.4
        for <netdev@vger.kernel.org>; Mon, 20 Apr 2020 15:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=XVDACxGXYhFvIQWcTaBbbajwmLnCSBNwA/uR2imEzWs=;
        b=ryPLo9Qnjob7nlxTrnk2KuIq1lFcWwIn/+KN50zoi6+f25vS+tXrbQFlTg0jNVR3qh
         tEmkBA9vVkPUiYcuM5kmI138WkFtUegisbaP/lco1vCe3MxImq64xatOtxRLLbH7tht6
         x1gQS4imeyQmyu7la9GUyBqNfSeAbDaPK3M/lhSsz91MrufgAtE8T1DrlfOH5CGRqYM9
         RY1A62IAAdMG/9aTAl/T7febGgqQ4zUFNknrIFOWX69Bw7XYAL9TGrh8pPvc7BbjtRkW
         wWByyeCC+2LEL+CZVcuY0j/G4yZ4RrESdKsGvxf2gkxGxyO0uwZcMwP72pJMhb3da6gs
         9+Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XVDACxGXYhFvIQWcTaBbbajwmLnCSBNwA/uR2imEzWs=;
        b=iYP5Q/Kzvkuo3O6brTEsoeuCzS26/vM34/GEiA7vR89pLGzGaKCHSEZXlWl6CxdKuk
         lcfjLNdBPPpgPYPOEfHZO0aZmSkD44q2eqBj3pvUcqrT+ex/Wl4qskCKMWD7CKcEWt6q
         OjkPazz7J4A4je1QulPDXh9A++lrDRPD+J7Vl5tyHqzTarE7m+FTgu65bruvQ0oxPGd0
         0YRaajPxdF/ADY/PlnNoByNc+X/NdlSaPXD8iuzxggFuMH6J4H/TSJwWVbJEolKMNoRW
         ELRgHTawpymZl/B936qBcalqGxHKI9QSevmsms0Kh2H2UeHw3cRUjfx1oMpueWQB4TG6
         1UuQ==
X-Gm-Message-State: AGi0PublmHN9QqSrqHdIs81z5oznT1alD8Dt4diQTgHui4BXMDyzqACV
        XLppv4axpZL444JHdxQ6feQ=
X-Google-Smtp-Source: APiQypJUS7z69P5jPAyMktz/HwnyjGzfoWw5UfLei9DLazU3E26WWMmVDaXIbB242bdUX4QEvoxnGg==
X-Received: by 2002:a1c:99d3:: with SMTP id b202mr1601298wme.126.1587420597547;
        Mon, 20 Apr 2020 15:09:57 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id n2sm1206520wrq.74.2020.04.20.15.09.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Apr 2020 15:09:56 -0700 (PDT)
Subject: Re: [PATCH v2 5/5] net: bcmgenet: Drop too many parentheses in
 bcmgenet_probe()
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Doug Berger <opendmb@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jeremy Linton <jeremy.linton@arm.com>
References: <20200420215121.17735-1-andriy.shevchenko@linux.intel.com>
 <20200420215121.17735-6-andriy.shevchenko@linux.intel.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <62b9086c-e129-3796-9ab9-f6b8a007874a@gmail.com>
Date:   Mon, 20 Apr 2020 15:09:54 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200420215121.17735-6-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/20/2020 2:51 PM, Andy Shevchenko wrote:
> No need to have parentheses around plain pointer variable or
> negation operator. Drop them for good.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
