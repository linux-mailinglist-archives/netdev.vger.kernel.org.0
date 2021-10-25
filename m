Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A820439821
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 16:08:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232679AbhJYOKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 10:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231512AbhJYOKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 10:10:20 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45FFC061243
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:07:58 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d5so10904525pfu.1
        for <netdev@vger.kernel.org>; Mon, 25 Oct 2021 07:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=TO0wBLaTkp83hOdg+u/tBpfJyVl6JWe0FqNIjJeveOA=;
        b=bXD7/wUVOsYvJ9uJAwEZEVJtHZKis0op0fWk6Y3PXIu+qchM6lXOKv8GJuM/33HnqA
         TzTwPOnrlusbbL3PHqoupO+u0dvqR+MmIdDVbtFEJm2cyuEueKJOV6TSysUzJYxh3YRU
         2WqTw3hpQiOAoiivstXxyzsOZ9lzQ5E4kFHqmbv/4PYfd4ezGAYUJvHyPbZZc7esHeTT
         ebBQWVsb+4VSjZ3Lj2jMRdO7ARIdhks3hra/PB6aCX6ae9UYggM5pBTZomksp0ol5u29
         JvjQXV7s+mtx6TyOpZldRZPt5JBkzVGBF/AUz6tNC6Rt1/8xrzUcnYA0au/LKLQNGJ+4
         k0GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=TO0wBLaTkp83hOdg+u/tBpfJyVl6JWe0FqNIjJeveOA=;
        b=ERG7iwWT8Q7J3pISkSY+csqFpN7Ls50TtL3JE/h8xe/x3ZYQWSPskwN3Pvj/0SPzNp
         qaBKsm12jr8NyHyhjx1JDGn48VMLYvc+W38nVvlFRUik42l/zscosqeCK06ck9WvgC59
         RCtQd+4aATFzdDyDbM6n5yuFXZSgK7nd3NmWPjNgvElsIzD+qlLlLdd4Q/3MD11PWQya
         UGNAeOd7BpY2ua/RPvfse1pNnwktCE9wnQzrgA9Txfn6T2p43u2C7gqjjCOuckKAvaBU
         eHdoGMtQgFJdzIUeFW4sGMzIKolWvmkIGo0tQ5K+39K85xW8Locu4QNVn/EXR2NXiUvB
         2Qmg==
X-Gm-Message-State: AOAM530lf0CCxiPcVy1MrXK3RA5zF6dKXEEFK9O98Cpt1Ddo5avK2Gln
        17yjpauj6cAHHN19Q7mbnUOrWWKodzhsSA==
X-Google-Smtp-Source: ABdhPJztTsVLk3XbJLE9Sj8rEhQoIAHSWkXXYoV5rw3PPE2DMcmZr/cJcWCxmJtMIFPl432eG4unhQ==
X-Received: by 2002:a63:8bc2:: with SMTP id j185mr4317135pge.14.1635170877881;
        Mon, 25 Oct 2021 07:07:57 -0700 (PDT)
Received: from [192.168.0.4] ([49.173.165.50])
        by smtp.gmail.com with ESMTPSA id n14sm1800783pfo.156.2021.10.25.07.07.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 07:07:57 -0700 (PDT)
Subject: Re: [PATCH iproute2-next] ip: add AMT support
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
References: <20211023193611.11540-1-ap420073@gmail.com>
 <20211024164641.3e14e35d@hermes.local>
From:   Taehee Yoo <ap420073@gmail.com>
Message-ID: <4f26fd10-4f17-502f-05e4-763f59a57de2@gmail.com>
Date:   Mon, 25 Oct 2021 23:07:54 +0900
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211024164641.3e14e35d@hermes.local>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stephen,

On 10/25/21 8:46 AM, Stephen Hemminger wrote:
 > On Sat, 23 Oct 2021 19:36:11 +0000
 > Taehee Yoo <ap420073@gmail.com> wrote:
 >
 >> +	if (tb[IFLA_AMT_MODE] && RTA_PAYLOAD(tb[IFLA_AMT_MODE]) < 
sizeof(__u32))
 >> +		return;
 >
 > What is this check here for? Is there a case where kernel returns
 > data without valid mode?
 >

This is an unnecessary check. So I will drop this code at the v2 patch.
Thanks a lot!
Taehee
