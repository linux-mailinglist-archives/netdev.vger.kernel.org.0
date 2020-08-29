Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF8972569DB
	for <lists+netdev@lfdr.de>; Sat, 29 Aug 2020 21:28:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728439AbgH2T1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Aug 2020 15:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728335AbgH2T1x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Aug 2020 15:27:53 -0400
Received: from mail-il1-x143.google.com (mail-il1-x143.google.com [IPv6:2607:f8b0:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365CC061236;
        Sat, 29 Aug 2020 12:27:52 -0700 (PDT)
Received: by mail-il1-x143.google.com with SMTP id t4so3457663iln.1;
        Sat, 29 Aug 2020 12:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jlsNy+dwE1MBR5TBIEJpV1N/vsndwqO8gJ1RtyIu2VY=;
        b=BbnK7wCaya4I9Usd//PcEjZN7YjQpXkdXnOU9yp6uie79BkSjtJoKXvZv0lq5qLZOH
         8++Kq6V2VnPxrAF0/JBOUcvtba+UB95DCAEwnII5mRMReaxNOuvFZFCXemDRSSLmgQbI
         cvx9Jpn0PfiICvZvUibc9MFNK/oqjZnS0+m+l8PHty/VzbhqvMvbO9m45nSU5Vv2JZS5
         75x6Yxv9cDOeaS24wf4cNjMGEn+rkeAYUMmJoBPZVL4/FZHxM+69J1zcBrEPZ4c+m6ub
         OmeTJvAsXCKLNeu4DjTfeiJjYuv/ysW4Rh5sCTL0uRh8LzdfFxm/Glk65TWU4qyxY0sS
         MwTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jlsNy+dwE1MBR5TBIEJpV1N/vsndwqO8gJ1RtyIu2VY=;
        b=pA7/MJCC/3+Ftw/AGyUaxzn4Dl/do+9KM3jSF41eO4Ut3J20SYt0AJF6xAr55o0lSE
         GgSzNPLDLl0pMEQsEAoiiuEfVF/STVbxIEGVKzmHxBRZ8Raab3nyjYmYVw6a6qPWCXgv
         HqpnIcoUHX22BmdTzlRYYU+JAKhod9qTUC26GzysgX6OwY/ZneZypUM+G1W6mWa1Ibx1
         4FA/k7AfkuIWCUfRt9JlH/xDGhoPYryJs8wRvIY3YgoNIiwx9mO06/E1o9vfA+zTg9GE
         6hx+HdBh2xRelCsVC9DCi9K1njR4uELBS1RPpAsvBt6PheUvMdVpHuQegat4Y8pmymbi
         ZHRg==
X-Gm-Message-State: AOAM530s+b6cKhSGJRnwoFkYvHdMSdfOVjU3tb7rgCOz53wtt4mik3Mn
        LmJ3HjIwzDmOs0LKNuK6QpMQj+tVmsxgQA==
X-Google-Smtp-Source: ABdhPJzeavam2avH8hjrKCcLPwcUVvweRtrKaUaYSgFdmo2zgbky0bGzhAZsTEhb/HcEwrH1MLP/2Q==
X-Received: by 2002:a92:d1cd:: with SMTP id u13mr3509546ilg.120.1598729272066;
        Sat, 29 Aug 2020 12:27:52 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([2601:282:803:7700:21a5:5fc5:213b:a337])
        by smtp.googlemail.com with ESMTPSA id l144sm1800444ill.6.2020.08.29.12.27.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Aug 2020 12:27:51 -0700 (PDT)
Subject: Re: [PATCH] net: ipv4: remove unused arg exact_dif in compute_score
To:     Miaohe Lin <linmiaohe@huawei.com>, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20200829090151.61891-1-linmiaohe@huawei.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <a17afcff-deba-90ea-7a6c-f29798d0f771@gmail.com>
Date:   Sat, 29 Aug 2020 13:27:50 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20200829090151.61891-1-linmiaohe@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/20 3:01 AM, Miaohe Lin wrote:
> @@ -277,15 +277,13 @@ static struct sock *inet_lhash2_lookup(struct net *net,
>  				const __be32 daddr, const unsigned short hnum,
>  				const int dif, const int sdif)
>  {
> -	bool exact_dif = inet_exact_dif_match(net, skb);

inet_exact_dif_match is no longer needed after the above is removed.
