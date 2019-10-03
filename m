Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 396E0CB18A
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 23:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730337AbfJCVxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 17:53:12 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46086 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726002AbfJCVxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 17:53:12 -0400
Received: by mail-pl1-f193.google.com with SMTP id q24so2114841plr.13
        for <netdev@vger.kernel.org>; Thu, 03 Oct 2019 14:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=X/vP8k2f52GvJo/+uHZKBpEGCZ+CKNpXtsaQsg0GexY=;
        b=nA/kHh2u1rp7EmyA5We6aecmw7KAqDbRs0KwixGsCGm4QiV4EPQ+d12puZUyeZPrSs
         NIy4cob6qqL2u+o+O7LFJAlRVh0F6SIe1IG23qlFbmHJUkjyBBrvRF+R15GrmL2X66yT
         vnl/BU0vrgu/5evK2iESpuIUGPEkMZdRSCFVPyvn9gl9f67BEQk6PAP3ewLoYNCdlxew
         1PI4lPP5q22zaKQgzTrAuEQ0GoUy9hJ0bkmcLfl3Q3l7Dn8MzqIksEGrnyD5M0gbLH7j
         BpznzQSt0tsQZl1o6ROBJ2CWzC9aI8NlZbM2p/iequvyybUuW9+4GNAZvxKAN8xq3QA7
         zHWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X/vP8k2f52GvJo/+uHZKBpEGCZ+CKNpXtsaQsg0GexY=;
        b=dIE8L5ddMSRbFcwSN6FBehZ04R0teaqMpcWlUqsKT68LLz/YpGkpkpDHKAhuERTyJN
         hNdHIEkEPgcDqgfyZkHSEgXOYFm0ku0eWMkkWTe+DSmpWhH2C992VTil0Vg994cpr/+c
         l6Q9QXCvFQiTazlr5Za7Tg6v+iyfCytu0uNHRajLbZCivVVET5wZor4IgwZLk6NPu8Xw
         1al/RLktfKSGb3a+Vthy987vnxugUCpZy0WRCWJzsBYzxlh0iiwfDuzMAFjFnHhU+8bi
         Ehz8GDuw1ewc1G1rmiZ2SyqXvfDttRGi7VEDRSnXHcS4eLLJRVK0U6ZvkY1OE5KZCixI
         03OA==
X-Gm-Message-State: APjAAAUiVegHU5kdbJSnB+ndP8iu/gV92CaYXdS6onFxUCADUOXQH25U
        raDu14XRwi2hci/odX8ST+Q=
X-Google-Smtp-Source: APXvYqzDyt7sZlQ2OIBukq2ENHwg8VdCOjsCMXJgt4buuF8RpJXe4xIFCF/ZX980Gy58OTYa7J9GOw==
X-Received: by 2002:a17:902:a9cb:: with SMTP id b11mr11393134plr.340.1570139591793;
        Thu, 03 Oct 2019 14:53:11 -0700 (PDT)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id i194sm5966631pgc.0.2019.10.03.14.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Oct 2019 14:53:11 -0700 (PDT)
Subject: Re: [PATCH net] Revert "ipv6: Handle race in addrconf_dad_work"
To:     David Ahern <dsahern@kernel.org>, davem@davemloft.net,
        jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, rajendra.dendukuri@broadcom.com,
        eric.dumazet@gmail.com, David Ahern <dsahern@gmail.com>,
        Eric Dumazet <edumazet@google.com>
References: <20191003214615.10119-1-dsahern@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <25d618f9-ea9d-54cb-8948-4cbbc09bc386@gmail.com>
Date:   Thu, 3 Oct 2019 14:53:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20191003214615.10119-1-dsahern@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/3/19 2:46 PM, David Ahern wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> This reverts commit a3ce2a21bb8969ae27917281244fa91bf5f286d7.
> 
> Eric reported tests failings with commit. After digging into it,
> the bottom line is that the DAD sequence is not to be messed with.
> There are too many cases that are expected to proceed regardless
> of whether a device is up.
> 
> Revert the patch and I will send a different solution for the
> problem Rajendra reported.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>
> Cc: Eric Dumazet <edumazet@google.com>

Reviewed-by: Eric Dumazet <edumazet@google.com>

