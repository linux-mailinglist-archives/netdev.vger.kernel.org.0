Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D28F74A47B
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 16:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729442AbfFROvY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jun 2019 10:51:24 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39405 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729189AbfFROvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jun 2019 10:51:23 -0400
Received: by mail-io1-f67.google.com with SMTP id r185so24487055iod.6
        for <netdev@vger.kernel.org>; Tue, 18 Jun 2019 07:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9j7oCHE5zUCiZe1BNBhmdvX1Klq+foQyK5ygvulbnlo=;
        b=IkP25tj5DpvbV1oyF3jVje51kgEaMnNfxFjh+WNTxIIUGD0bUJzzf1/dLYWXCPHYuf
         89/mhzwCk56ERsQUkyzDCf0AsampmtUAKYYQrRk9kzuq7FWEEcW2JNrncVwLnVBYJ5s3
         VYdchJ25b/Nwo9EINrdArT60WQIG1XCcDCvYTAkBQA/O5HhxHMfvSNEtdLdtTjYkKehB
         ZnD1QYdU8IdoRF0Cm9/5ITvC32WbUpN2TqdvDT0gHh+FH5FjcVFwrtXgq8ZHKUJb2fc0
         slW+DlpbH2qWT8eYQA/IjirFC/WHtNSngoEn8ow1Vl2AfNw8eNxwiUjJwrHT+1UzCCSw
         +OCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9j7oCHE5zUCiZe1BNBhmdvX1Klq+foQyK5ygvulbnlo=;
        b=Aq/I56TalsdWYa+SqAUzg7zVwAB7IgHkGYME3K7q+KxjFjW+8uSj1uAQmA9nnrqijR
         ACVpvJ7DPS0IbKNg3YXPhwlRHcTttxW78sVMhEs6lrsNy0OWBZasRKYEh8a8xXO8whN5
         5eXzuG17f8j8WFc50x4svvcPNwjqneFRmMuNOTJN/87WdnyZKyFQJdSiaugS4xFB0kz7
         /ivE/4BnjZepAM7WADGctd6N0l65PZvzd6HT+daJRG4d12+hqYsr1XiayPmobB1tsfFJ
         Piy2Y9VkZBQQ1Nq8lqfMGKpa5h+Vh85/qNh714Evxrb6eh9mc6tX2zu4LL0oaFm8Dmp7
         GR2w==
X-Gm-Message-State: APjAAAVdKAShFs99n8dOAew8vIhHNavC/G/ZitXBKVMLxpFxZ0f3jNLm
        AKDczRp1CXva8B/9n0yroHbIg83v
X-Google-Smtp-Source: APXvYqwlX1upvg671kiSg++9T/O9PWGXwT1lfD/YBL7m8aAeeoqkxSxXwkT2GjOZRblYFuUzt+zzpw==
X-Received: by 2002:a5d:960e:: with SMTP id w14mr988123iol.189.1560869482340;
        Tue, 18 Jun 2019 07:51:22 -0700 (PDT)
Received: from ?IPv6:2601:282:800:fd80:fd97:2a7b:2975:7041? ([2601:282:800:fd80:fd97:2a7b:2975:7041])
        by smtp.googlemail.com with ESMTPSA id c17sm11710763ioo.82.2019.06.18.07.51.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Jun 2019 07:51:21 -0700 (PDT)
Subject: Re: [PATCH net v5 4/6] Revert "net/ipv6: Bail early if user only
 wants cloned entries"
To:     Stefano Brivio <sbrivio@redhat.com>,
        David Miller <davem@davemloft.net>
Cc:     Jianlin Shi <jishi@redhat.com>, Wei Wang <weiwan@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Eric Dumazet <edumazet@google.com>,
        Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>,
        netdev@vger.kernel.org
References: <cover.1560827176.git.sbrivio@redhat.com>
 <6c7a9a747d667a581addca95370dd2532a55c015.1560827176.git.sbrivio@redhat.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <d0789e11-ecae-289c-eae3-1f2a9de9b85a@gmail.com>
Date:   Tue, 18 Jun 2019 08:51:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6c7a9a747d667a581addca95370dd2532a55c015.1560827176.git.sbrivio@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/18/19 7:20 AM, Stefano Brivio wrote:
> This reverts commit 08e814c9e8eb5a982cbd1e8f6bd255d97c51026f: as we
> are preparing to fix listing and dumping of IPv6 cached routes, we
> need to allow RTM_F_CLONED as a flag to match routes against while
> dumping them.
> 
> Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
> ---
> v5: No changes
> 
> v4: New patch
> 
>  net/ipv6/ip6_fib.c | 7 ++-----
>  1 file changed, 2 insertions(+), 5 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@gmail.com>

