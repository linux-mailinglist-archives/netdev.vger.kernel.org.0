Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C95841929B
	for <lists+netdev@lfdr.de>; Mon, 27 Sep 2021 12:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbhI0K5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Sep 2021 06:57:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33044 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233862AbhI0K5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Sep 2021 06:57:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632740145;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2JE0HA2kjVRv/yC9BRKKuYAvNtJ6qvPfXlz+a7vWuQY=;
        b=EbVHnx/DHzDOrYj5zJuPyU8Gb7HeDySG6J+NJKoXWsQbnSpxVgtSsvAs/wnC0ClPzxKY1C
        UjquM9G+bOil/ryduEmTMeTueY9SNQpkzOIx9k4TSYyTSbF/y+j3a6lV/PmuwUQH30TgnU
        h0b8DwUtOQ9qaUKEwmiIwqElzXbaVlw=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-531-eyx5DD7YOuSMKiHd_X85kw-1; Mon, 27 Sep 2021 06:55:44 -0400
X-MC-Unique: eyx5DD7YOuSMKiHd_X85kw-1
Received: by mail-lf1-f69.google.com with SMTP id o4-20020a056512230400b003fc39bb96c7so15462467lfu.8
        for <netdev@vger.kernel.org>; Mon, 27 Sep 2021 03:55:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:cc:subject:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2JE0HA2kjVRv/yC9BRKKuYAvNtJ6qvPfXlz+a7vWuQY=;
        b=cR4RyQ55SaEhQ2qd87r5X5X6pUf7dZ+6fz57QJAsB7lI8LdEdd14R2xIiYAPTd5/ng
         ZF5swlTa+ukzaP5mhpUuq8wo6d1hX7ZlA+yYNFA//Ih8C3243CSBu0vTl/zQQgFBkxCs
         VirxGjcZqpyqXLt9kMknTqGztEpJHdi/FchMi2a5M4lTlna1XZWCHjM99h6Pc0h+XHlA
         8q41X4L8mVwlEs3sTKnFcFaCS956AJtMAOGrRV3v4NeF7EMri8BHnJUbLnIVlgX+/4rZ
         OZAbylCuMZ3kgSs2Gy3F1IsfzsK4eyc+gZlnGaxNUnAgVM47vh0nVrKJ36z05Nqx9/5v
         yqXQ==
X-Gm-Message-State: AOAM532PvPsirP8V0d2so++ljlKq+qytIf+bhGvsO9TCPhVc4unBHcuC
        Rq4Pd10J+7qERhjioAnORaRVQ9Z/phwU3WOyxKzKsCUXG9w/XrLCY2HUh2kqCmguWdwrOpoWKAC
        1VLNwBD5e0QZQfnSg7iFBhrEl7F4ODcxTZFyyoK6XRKlRiT0JQrqsZ5NrgsRI+6tsXWQ=
X-Received: by 2002:a05:6512:3f86:: with SMTP id x6mr23793080lfa.389.1632740142178;
        Mon, 27 Sep 2021 03:55:42 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx16ZHxl/Cg5h5Xa3Dn6dXvExbeycQ+N4mXUgoU052iMOkDO/9DkWxj/nPvIZrl4F3RmcU4IQ==
X-Received: by 2002:a05:6512:3f86:: with SMTP id x6mr23793051lfa.389.1632740141894;
        Mon, 27 Sep 2021 03:55:41 -0700 (PDT)
Received: from [192.168.42.238] (87-59-106-155-cable.dk.customer.tdc.net. [87.59.106.155])
        by smtp.gmail.com with ESMTPSA id f7sm1555462lfv.96.2021.09.27.03.55.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 03:55:41 -0700 (PDT)
From:   Jesper Dangaard Brouer <jbrouer@redhat.com>
X-Google-Original-From: Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     brouer@redhat.com, linux-kernel@vger.kernel.org,
        Netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH] Trivial: docs: correct some English grammar and spelling
To:     Kev Jackson <foamdino@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
References: <YVF/Q5pA9h9S+wS9@kev-VirtualBox>
Message-ID: <71dea92b-e22b-9791-5755-df3a4f48f893@redhat.com>
Date:   Mon, 27 Sep 2021 12:55:40 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <YVF/Q5pA9h9S+wS9@kev-VirtualBox>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kev,

You should send this patch to the mailing list netdev@vger.kernel.org or 
bpf@vger.kernel.org ... else I don't think it will be picked up.

On 27/09/2021 10.22, Kev Jackson wrote:
> Header DOC on include/net/xdp.h contained a few English
>   grammer and spelling errors.
> 
> Signed-off-by: Kev Jackson<foamdino@gmail.com>
> ---
>   include/net/xdp.h | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

--Jesper

