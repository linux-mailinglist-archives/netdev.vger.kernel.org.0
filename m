Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 990FC1E33E8
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 02:00:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbgE0AAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 20:00:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725891AbgE0AAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 20:00:21 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6367DC061A0F;
        Tue, 26 May 2020 17:00:20 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id f189so22681122qkd.5;
        Tue, 26 May 2020 17:00:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RQpblavivf0sa4vg0uiYY3iKvNyBsJZUzHQgN1h/lmg=;
        b=aaeWpMouXtx2LFJPHuT+FhiG16wyYp5gdnnR45cu9Vgyz0kg2oyzoPgRcNU6GyU5mi
         QS4/WKZNXmjM+/UrYB8S0j0OVs72k5xpORCqh3ebm4Z+etOjApSkpMCqPlVwu5grm7dT
         PZA88BgqtxVg8sNWl7M1NIJBWMpqvxaXU2BLh+3KZfhk0vyOiWgUyfPOcD6iRKPfhy19
         5AhA4bnJVa4nEQMdL/3klVMj4rTG1nJ+ixDGtD1fFACc0u5H70+Mdr0DOWALqUGWF+PW
         n0YwNsztpfQzGNEGC3QVsfm5vli+G1wu7G+71Bwp6+0eSpEVf7+H6jBf/7bVTPdBb+xM
         0URg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=RQpblavivf0sa4vg0uiYY3iKvNyBsJZUzHQgN1h/lmg=;
        b=BKfKdkWm+a3PA90QVo151xKaCr4wR1kXRbPiFzxdxBUqhzxtx2op4z6j1ZaKcGw7hL
         2kkl4ejOXrA628im40k1EKOTOfPMU9Dwl2hhpXesPXmEP0QmmeBSpCukUNK5EbuC6QQP
         MwkdCP7y2omk/5o497cFqNI1aV/T1iPTeOoKuaQxtZe1BfnTY3YUCFodi8FDVPEHUPIo
         hQiBOlTYLewsUZMlBbpsiVxsxqmhbXVg/wssaBdoi12eYeYdxhx0GS9sGYlR3lRnPbvM
         0BX3kZ1ri+C54BAPRMwRFaq6p2Kp2kQ+adwmxkbG2tAHoAr0vhS8LQt7dRMrF4taRYo+
         KMIg==
X-Gm-Message-State: AOAM530R5VyP1N6eFs93ba72l4C9bBYBCHrCh+rroIXt25+A4+IewYR8
        o3XUf2WQoBX61h53FSatR0Nj75HK
X-Google-Smtp-Source: ABdhPJxzJI4xai9rTGV2j1EnGCQ8x7MUDQw7Z6Y71HI8eaXBIgwB4HOqgdgGs5VeGYx008xNjrfllw==
X-Received: by 2002:a05:620a:13d7:: with SMTP id g23mr1418122qkl.136.1590537619658;
        Tue, 26 May 2020 17:00:19 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:85b5:c99:767e:c12? ([2601:282:803:7700:85b5:c99:767e:c12])
        by smtp.googlemail.com with ESMTPSA id r7sm1123275qtc.25.2020.05.26.17.00.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 17:00:18 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/4] RAW format dumps through RDMAtool
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
References: <20200520102539.458983-1-leon@kernel.org>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <acfe3236-0ab9-53ae-eb3b-7ff8a510e599@gmail.com>
Date:   Tue, 26 May 2020 18:00:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200520102539.458983-1-leon@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/20/20 4:25 AM, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@mellanox.com>
> 
> Hi,
> 
> The following series adds support to get the RDMA resource data in RAW
> format. The main motivation for doing this is to enable vendors to
> return the entire QP/CQ/MR data without a need from the vendor to set
> each field separately.
> 
> User-space part of the kernel series [1].
> 
> Thanks
> 
> [1] https://lore.kernel.org/linux-rdma/20200513095034.208385-1-leon@kernel.org
> 
> Maor Gottlieb (4):
>   rdma: Refactor res_qp_line
>   rdma: Add support to get QP in raw format
>   rdma: Add support to get CQ in raw format
>   rdma: Add support to get MR in raw format
> 

The set depends on UAPI files not visible in either Dave or Linus' tree
yet. We moved rdma uapi files under rdma/include/uapi/ and as I recall
the expectation is that you submit updates with your patches once they
are accepted and that the headers are in sync with Linus' tree once the
code arrives there.
