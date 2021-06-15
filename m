Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECD83A77BF
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 09:12:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229613AbhFOHO6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Jun 2021 03:14:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbhFOHO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Jun 2021 03:14:56 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 472CCC061767
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:12:51 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id h11-20020a05600c350bb02901b59c28e8b4so1010623wmq.1
        for <netdev@vger.kernel.org>; Tue, 15 Jun 2021 00:12:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kEhS8WbNxJAAxy+rRYN5HF72Ei2eiyxrBNTYMUGogrM=;
        b=WEznw+gSNTwaNg9bTgABcEpoGQeieROV0X/07g0yo0lSPpifCt3g2VgXN6qSY8jS95
         BuCXxyQJOLY2Mw8Ux4V46YjbEHHzO2TV00hdXO6BIgyhjAJ7Y38egCe68BGoDWOog4lj
         Wb/xZWDfgMMJ6S9YN4HEk/5GHQ4tiZPPpl9UnL9bVikad8VCxHzv1bvA2YkZQL/2mB7j
         PKmVyfEAsRhXIv1AkAjPutaMduvtVCG06QzlpXqyWSqEuf8mmeFNTtYbODfYNA9QaB6c
         MghLkJ3vVpUPqFcGKMMakp42bBtR28MPUTIQnCUQvm65VP8sPDV+Yw9xYsZf+sg6bMGI
         o59w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=kEhS8WbNxJAAxy+rRYN5HF72Ei2eiyxrBNTYMUGogrM=;
        b=I806vSNH9iemazXLnBIDBzVaK5HCwCUREn43VziYIHdRAtpQL1hXDKQbSijWGWaAiB
         CfLiLfc/69QQxmXur4UAMG4Mqo04kJ8jSwmMpu0pQSiPIm6GxGpm1sS2NP2iXT5oa9id
         qrHEvtxKXnjugjAr4Or0GS5A1Cl93SKFkA/XmOCVi/TIoIvymEE6lY5m9j7diotV/VvR
         HyFK5/yQ5ZCqeXZy0aetFgYVKMUlu72UGlQx2DPlDA/gkELVRWcoVCppcPqyGaWW6wEG
         GImS7kkrZiaqmQPk+V5EmjzlmZ213HwAFfZ1yDnpzkKN3e6m+Gh78qLJPinH7lvnIaQ7
         g7/w==
X-Gm-Message-State: AOAM532XreXv6m8SmsHkkfNaq8Q0n7LAuZVCJFNR335ldQLX0iRLgeCs
        eGeOccZgZFLoMcbWt+B1ZAg/fpLs45Kakg==
X-Google-Smtp-Source: ABdhPJzmLwFT9XQvACf8HmmCLcNkB+g8HpiIn+v/HmS5WF8h4UfFYwdUc497xEnSDW5xUBxjmQB+MA==
X-Received: by 2002:a7b:c10b:: with SMTP id w11mr3492332wmi.186.1623741169903;
        Tue, 15 Jun 2021 00:12:49 -0700 (PDT)
Received: from ?IPv6:2a01:e0a:410:bb00:ddd2:2038:ae02:164a? ([2a01:e0a:410:bb00:ddd2:2038:ae02:164a])
        by smtp.gmail.com with ESMTPSA id k5sm18893753wrv.85.2021.06.15.00.12.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jun 2021 00:12:49 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH nf] MAINTAINERS: netfilter: add irc channel
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        netdev <netdev@vger.kernel.org>
References: <20210528084849.19058-1-nicolas.dichtel@6wind.com>
 <9b60107e-dcd4-3ca0-f83d-0e51ccf5d67c@6wind.com>
 <20210614171712.GA28746@salvia>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
Message-ID: <bc0680f0-c15c-95ac-3f17-6b403ffdd741@6wind.com>
Date:   Tue, 15 Jun 2021 09:12:48 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210614171712.GA28746@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 14/06/2021 à 19:17, Pablo Neira Ayuso a écrit :
> On Mon, Jun 14, 2021 at 03:18:00PM +0200, Nicolas Dichtel wrote:
>> Le 28/05/2021 à 10:48, Nicolas Dichtel a écrit :
>>> The community #netfilter IRC channel is now live on the libera.chat network
>>> (https://libera.chat/).
>>>
>>> CC: Arturo Borrero Gonzalez <arturo@netfilter.org>
>>> Link: https://marc.info/?l=netfilter&m=162210948632717
>>> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
>> I have no feedback on this. Is there a problem to add the irc channel in the
>> MAINTAINERS file?
> 
> *Problem*? Nah.
;-)

> 
> I'll add this patch to the nf queue.
> 
Thanks Pablo.
