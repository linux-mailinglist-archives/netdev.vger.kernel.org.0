Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2C5846DEB
	for <lists+netdev@lfdr.de>; Sat, 15 Jun 2019 04:55:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726501AbfFOCy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 22:54:56 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:33100 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725825AbfFOCy4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Jun 2019 22:54:56 -0400
Received: by mail-io1-f65.google.com with SMTP id u13so10049460iop.0
        for <netdev@vger.kernel.org>; Fri, 14 Jun 2019 19:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fA7inJwg85yWuDlFyxgRCBhH49I0hMkZKD3Xxn4iGvY=;
        b=Vgfr9WS/pG8up+Op6GVSCYfF3wn1ufSD8JYrA2cDt0EBpzFQ8wTkeRdgcaKjUg0dz+
         jHCAJlhQ/mr+voXDBIrrIQbOufIxQAQ3FAkeliJCY/6Q6ZLD8Uq/SUpj2GR5QySZroJb
         e44ue1gpbu708+FHhaPlPzHr1P07TUS6tAmzFM7bFDGmf4UtKvZ3pbrTNRl1sZLLefwC
         GY02T8wC+Qc8edF6rsrlmLjPXh3zJkXbsmS0CgdazE2CrZ/yeqgvDjCQHCfNp8tUKaNL
         HxSfJ0lbtWxLerLmAs8Uq8TqkPBnkbAPlKiPPheqb+hE//9v/RR5v2rw+eXwAeB7rVVt
         eFMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fA7inJwg85yWuDlFyxgRCBhH49I0hMkZKD3Xxn4iGvY=;
        b=GOAr5Fcvohw//vB/aSkiyRE1UlCJUOaTJUjSoYFCs77cFHeiz5ff12zNhsXX5Ak7Rw
         L/IAcgguGihRzDKWC0+aYpQ2+91lXmhBRQg4ZOdDmxg1b3a8MeYJ2FxHchQIg9AyPFza
         jzD1fSabyYMdrldPtRcmyqC+Z6fqBiKkm95UXeIPXStMSvaPnx93FkKEUAIteuaqb2Ib
         HfLIExROSJHAAdQ77/omW57WZwQwbkjzNzB/7iosZt0FEj4jAWn3jMg7OWf7k1Z0jp6W
         5J5xVq41FvCHpJKWsi4GWK47Di6cpiNyCYi5DT2KW3IlC+M5vhIsK4BwIOJAWSdE3rxO
         l2Dg==
X-Gm-Message-State: APjAAAWWQxHTUTt61UWliTnd59Wc7AXtqup7v3PtXo4iNa24d9rcLxDC
        JFjopeJ8eKpftzGKCFJDh3aMAeu3uaw=
X-Google-Smtp-Source: APXvYqx9k626qCmLpmQHntfH2JZznsqfLTjyzsbQD5gL5PLYX+u6a5w6kU8f0QfTPzvTaS6rWdmCTQ==
X-Received: by 2002:a6b:6209:: with SMTP id f9mr7141922iog.236.1560567295021;
        Fri, 14 Jun 2019 19:54:55 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:6878:c29b:781:b371? ([2601:282:800:fd80:6878:c29b:781:b371])
        by smtp.googlemail.com with ESMTPSA id t14sm2856326ioi.60.2019.06.14.19.54.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jun 2019 19:54:53 -0700 (PDT)
Subject: Re: [PATCH net v4 1/8] ipv4/fib_frontend: Rename
 ip_valid_fib_dump_req, provide non-strict version
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>,
        Martin KaFai Lau <kafai@fb.com>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560561432.git.sbrivio@redhat.com>
 <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <4dfbaf6a-5cff-13ea-341e-2b1f91c25d04@gmail.com>
Date:   Fri, 14 Jun 2019 20:54:49 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <fb2bbc9568a7d7d21a00b791a2d4f488cfcd8a50.1560561432.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/14/19 7:32 PM, Stefano Brivio wrote:
> ip_valid_fib_dump_req() does two things: performs strict checking on
> netlink attributes for dump requests, and sets a dump filter if netlink
> attributes require it.
> 
> We might want to just set a filter, without performing strict validation.
> 
> Rename it to ip_filter_fib_dump_req(), and add a 'strict' boolean
> argument that must be set if strict validation is requested.
> 
> This patch doesn't introduce any functional changes.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> v4: New patch
> 

Can you explain why this patch is needed? The existing function requires
strict mode and is needed to enable any of the kernel side filtering
beyond the RTM_F_CLONED setting in rtm_flags.
