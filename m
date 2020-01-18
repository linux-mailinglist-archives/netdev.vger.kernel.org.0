Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4CB141A11
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 23:37:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgARWhl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 17:37:41 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:39575 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727008AbgARWhl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 17:37:41 -0500
Received: by mail-qt1-f194.google.com with SMTP id e5so24800246qtm.6
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 14:37:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5aun/jsg/3HG05MaG0eySQM7adj6Tat910ELcVfvxdE=;
        b=GtvHdsLhe5nBZL8U2Pb9uud4m1F1kMIb3HFsgjiNVeUqdvIZ03gMK5FJkAMH26AiQq
         nzoVKjru7Gbads/2eN0uXjlC38G3T+Ng4883Qji8/MLbjtJrLrMo9Elk06wR9LhQEh0G
         iezd7HBuV3tUbC1tHtTNCIqj2XD3lCULLugs3aNMqOeq8hK512gXEFxD//PufH6TImXe
         6MncuO/fAnCU3A/ARiBd2xcGqyqNjhc7bEF2HPDKbX7rdYzcSNiNj3Fn3tFGlRgcdmtq
         ixiY5TioBJBGn1tGlxOJsnmV/g+4Pg9GIBkF2g0iRRx+syQR7LRqF2pamlhMMtyvVNCQ
         J7og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5aun/jsg/3HG05MaG0eySQM7adj6Tat910ELcVfvxdE=;
        b=kxvbXjk4B3G2dI5hzEzcfR8klKhgBlYOHgP8sr7UJmPev/zQYGKXukAluYaRTugT65
         hB/9zkuQP3UcLT/wL5XLs5kQvNPy/LeAS7bd9dYVfnTRymnBhv6rVfDtrZU7JpzwtlRX
         b0WYyrjR6y008WlrbiX9iSXOs0j7XLZjs0Zkm4x2N4BbcSSCOqckZyHbpT/X+pJUx+z6
         sK85I8mhBIMqSKVmyjGw9bG6IaIhtv2F6amBLjw3+S4793oAXcyq7gwwDJWMkziJwrvv
         9kyJHrOEvVbzDZRGplnNwzPLc4Ro422D0pCmB1x9HQcfr9j25GKrwprC6QtAymPRXP3D
         IOiA==
X-Gm-Message-State: APjAAAWNzeklFlYj4Om6eX+dirCsc09QbB2s27eezc0uMxkq0FAs1LP6
        SeItF4ZJHbx9pm0zpRxEd0B9ETmk
X-Google-Smtp-Source: APXvYqybSMqXW8ULojPvdRSnbIR2P+FKJ71SLWz5qvygIe8RX2xd0tMZGxblYuLA7B/oAPyEkvqLeg==
X-Received: by 2002:ac8:140c:: with SMTP id k12mr13943042qtj.117.1579387060211;
        Sat, 18 Jan 2020 14:37:40 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:61e3:b62a:f6cf:af56? ([2601:282:803:7700:61e3:b62a:f6cf:af56])
        by smtp.googlemail.com with ESMTPSA id h6sm14975983qtr.33.2020.01.18.14.37.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 14:37:39 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: xfrm: add espintcp encapsulation
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     netdev@vger.kernel.org,
        Stephen Hemminger <stephen@networkplumber.org>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <0b5baa21f8d0048b5e97f927e801ac2f843bb5e1.1579104430.git.sd@queasysnail.net>
 <2df9df78-0383-c914-596e-1855c69fb170@gmail.com>
 <20200118223433.GA159952@bistromath.localdomain>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d57cc9bf-a399-c969-cbd8-35503fbc0cb5@gmail.com>
Date:   Sat, 18 Jan 2020 15:37:38 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200118223433.GA159952@bistromath.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/18/20 3:34 PM, Sabrina Dubroca wrote:
> Since the existing code wasn't using them (no idea why), I did the

I figured.

> same. I can change that if you prefer (and add udp.h to iproute's
> include/uapi, since it's currently missing).

I think that makes for readable code, so yes, resubmit with names. Thanks
