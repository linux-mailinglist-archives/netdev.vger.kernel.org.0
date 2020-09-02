Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCF3F25A2D3
	for <lists+netdev@lfdr.de>; Wed,  2 Sep 2020 04:02:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgIBCC1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Sep 2020 22:02:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbgIBCC0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Sep 2020 22:02:26 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AD9C061244
        for <netdev@vger.kernel.org>; Tue,  1 Sep 2020 19:02:24 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id x2so3638541ilm.0
        for <netdev@vger.kernel.org>; Tue, 01 Sep 2020 19:02:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=JeIxR+JFYDHg021W/Z8cvu5lirR8FoLfUvRHBC4g800=;
        b=tLmf6dlMDyJb/ZL7NIig7F3dGYlmPrFItwUX9bIv+v3mTJobYlDUMonwvABQsHxbFp
         5JP6LJFUOVh/9ucMAx0lUHYh5w+bRI2KLYxHfXBcmL9kU74s0lwMoLMHBcJEHa+p4uTM
         hFLHOanPprAr1Vg22MJxtWYOATBjPbEG1xbXXel/lhRa5fK+ixMWXowE8tVtfW8bRtWw
         lYjoa7jKNGcm1oPFkKws/OyYIaIFhPPs1YiHRck2dpUld09iV/omFUlbKGL/A3ZziqRO
         NREv6Zc/MCn9+mTAR2xQFgckUjCk2uVmY2r5ZAIPbFBE8iCkomnS6A1SyXkDVgRLXz+7
         kIrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JeIxR+JFYDHg021W/Z8cvu5lirR8FoLfUvRHBC4g800=;
        b=gs6cD8E1aZDxjidPzqb65AFTxGFZAFWs+yr5Neu40YjDnBdr0zTnAZ38EAvSjo6p56
         2oX2qdBRd5e69aI1HRwI/tCgjl+G0dY6JBJx217yfXGFIGGQULz6+/5CrqGhLwAqOKIe
         JE+Kkj1QKwnIKX3eIGgF54p4/AfY1rKTabjyFQbFAQImoUPNTD0XcokC1QJ/YL2JjXSd
         87X3LzBKCf2KiHYPpKQ5PAre6aCnIkm59HgrYU/eclT9BVzKnjPFvRDfwHhe5DLqhEDZ
         LfZbSXxS+++f8Kfj/FGB0+Dg4e9UMz2AYYKUSwvnrUJ2+JTkPTlYYv8zOqkjpNLOpLa4
         64jw==
X-Gm-Message-State: AOAM530B1nivEO2A69tHMwAxf/HMRcD+H8LuKkdW6KDdKg4UBZ9qKqNp
        Dl5FYPhmg0ZgPraI821aumU=
X-Google-Smtp-Source: ABdhPJxn3wj04VQXY5TiNA9rNStCMOVtNngxvLfRenIfOdg+aX/32vfwsJ1KSMpL7Czxngdpjyqh9A==
X-Received: by 2002:a92:798c:: with SMTP id u134mr1764940ilc.269.1599012143971;
        Tue, 01 Sep 2020 19:02:23 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:883e:eb9e:60a1:7cfb])
        by smtp.googlemail.com with ESMTPSA id z72sm1330711iof.29.2020.09.01.19.02.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 01 Sep 2020 19:02:23 -0700 (PDT)
Subject: Re: [iproute2-next] tipc: support 128bit node identity for peer
 removing
To:     Hoang Huu Le <hoang.h.le@dektech.com.au>, jmaloy@redhat.com,
        maloy@donjonn.com, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
References: <20200827023037.3204-1-hoang.h.le@dektech.com.au>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <42a727d2-385c-5918-f721-370e94695d41@gmail.com>
Date:   Tue, 1 Sep 2020 20:02:22 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200827023037.3204-1-hoang.h.le@dektech.com.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/26/20 8:30 PM, Hoang Huu Le wrote:
> From: Hoang Le <hoang.h.le@dektech.com.au>
> 
> Problem:
> In kernel upstream, we add the support to set node identity with
> 128bit. However, we are still using legacy format in command tipc
> peer removing. Then, we got a problem when trying to remove
> offline node i.e:
> 
> $ tipc node list
> Node Identity                    Hash     State
> d6babc1c1c6d                     1cbcd7ca down
> 
> $ tipc peer remove address d6babc1c1c6d
> invalid network address, syntax: Z.C.N
> error: No such device or address
> 
> Solution:
> We add the support to remove a specific node down with 128bit
> node identifier, as an alternative to legacy 32-bit node address.
> 
> Acked-by: Jon Maloy <jmaloy@redhat.com>
> Signed-off-by: Hoang Huu Le <hoang.h.le@dektech.com.au>
> ---
>  tipc/peer.c | 53 ++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 52 insertions(+), 1 deletion(-)
> 

applied to iproute2-next. Thanks


