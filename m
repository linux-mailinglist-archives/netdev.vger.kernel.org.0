Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDF5260792
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 02:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgIHAd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 20:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727769AbgIHAd2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 20:33:28 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A50C061573;
        Mon,  7 Sep 2020 17:33:27 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so3876771pjr.3;
        Mon, 07 Sep 2020 17:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oFBThLvDCSaVk+LYPkYRElPuSVyI++MVj95WVo0ZeQE=;
        b=W8f7XQPI5HgV7D1YCXVHhqN/Ay6LQ+bmCNz0jOT9Amqie1oE4RaLLt9m8I01UPr78n
         KIUm2BedMDbksD8gQeTo5IfPuJv52tMnU8wjGn+sD3cbxWwZHdYhMMHRib3B5Utr/beE
         mWP0XaP5+FVvKsmxa4j9bju3tWM4jMzheNIGPBHcyXTkJDJvtw3dRKqQtfnrZVzS9qL6
         vHnk3NkVikaMDLAg+p/HyT/EIRT7N4/2g0bJ7UwBo4PIc0nEeRaUVieH4qeno6BYDevN
         PHRoTIiPN/oPHe/PZh1wPN4jpnVOAH/vRVh+Q1VPc8bddc5ufCFTxYSDwB0A9pWmmRCw
         nQGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oFBThLvDCSaVk+LYPkYRElPuSVyI++MVj95WVo0ZeQE=;
        b=cLEo8aohBkNyKFjOjAf9G9uDHucEsHr8F3PcxSWFKqhj8ZMKAIfmAFeuPreO4FsN5P
         K/09NucxmX5SDmCzcKmanPBexSEdGXoG3/p6CH67IkarMIkd165N9LpNXwqmjiD4I3Y1
         HY5EHoPNNIZ5rQtYA+xir4LCT+/9EiqUD6+UV3TmGhL/1w/Qqs71WTgfp0UgGS8Nnfrk
         o3NS6SlRQ1aY92MUOgQAJe0W8dTTrEZ3ItAPfqEu42kAKbZQ+/54Cx7VW80AIPwkMGPq
         8tKz0GSHwgOvb7UunFf9jp8sYaNwMzFAqzRucMiTtc+yZndgNLpd4+dzJafxTrJHv9Mw
         O69w==
X-Gm-Message-State: AOAM533Bh0TYtpYqVuZbF7vDJlmI7hIJc4QxJaUpEvTUyYTVI3qiSrQJ
        orxn2W+omjX7AS6/ITySMbYgOxuPYUhigg==
X-Google-Smtp-Source: ABdhPJw0G18Jqxw7J0CoSuv3lHejPs6cfUS5m06d8HzLuVRjIyjmgie0Xiu8Cd1Mwzz+1tCOBIeMxw==
X-Received: by 2002:a17:90a:81:: with SMTP id a1mr1512914pja.136.1599525207196;
        Mon, 07 Sep 2020 17:33:27 -0700 (PDT)
Received: from [192.168.1.5] ([159.192.167.159])
        by smtp.googlemail.com with ESMTPSA id v13sm13051688pjr.12.2020.09.07.17.33.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Sep 2020 17:33:26 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 4.14 17/33] net: usb: qmi_wwan: add Telit 0x1050
 composition
To:     Sasha Levin <sashal@kernel.org>,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?UTF-8?Q?Bj=c3=b8rn_Mork?= <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
References: <20191026132110.4026-1-sashal@kernel.org>
 <20191026132110.4026-17-sashal@kernel.org>
 <CAKfDRXjjuW4VM03HeVoeEyG=cULUK8ZXexWu48rfFvJE+DD8_g@mail.gmail.com>
 <20200907181552.GN8670@sasha-vm>
From:   Lars Melin <larsm17@gmail.com>
Message-ID: <6e09f3e2-674d-f7c1-e868-c170dff1dbb9@gmail.com>
Date:   Tue, 8 Sep 2020 07:33:21 +0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200907181552.GN8670@sasha-vm>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/8/2020 01:15, Sasha Levin wrote:
> On Mon, Sep 07, 2020 at 11:36:37AM +0200, Kristian Evensen wrote:
// snip

>> When testing the FN980 with kernel 4.14, I noticed that the qmi device
>> was not there. Checking the git log, I see that this patch was never
>> applied. The patch applies fine, so I guess it was just missed
>> somewhere. If it could be added to the next 4.14 release, it would be
>> much appreciated.
> 
> Interesting, yes - I'm not sure why it's missing. I'll queue it up.
> 

The patch is missing from all 4.x LTS kernels, not only 4.14


br
Lars
