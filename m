Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1558D163D12
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:32:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726270AbgBSGb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:31:56 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:39633 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726133AbgBSGb4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 01:31:56 -0500
Received: by mail-pl1-f194.google.com with SMTP id g6so9143631plp.6;
        Tue, 18 Feb 2020 22:31:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=yHHgpBANwrMB3jhs9hI0b1CDaiyJ2Cjlf5IBS/MPeGo=;
        b=IjeBbZQUFOdhM9b+UyK5lJqf3gDoZ0Zhe707jyNovSSDOez8X/Tu/7asUcWC5tvBxX
         eC9+ShCPTZGQGNIins6XiE5JMLC8urRb+cPNn2mpk52UgzFZe2dMdAcTJsaX8v5/vQYf
         s9uHUYJXWcgDUkPAy4ukI8ViP/9q+32cK69loQqb8iPrrhMBld/3i5Jlo2pLDbnUcW7f
         +W5sB6gwuPQk2PexwdCdWSvjNt7xsHyP9p7F4DOgfmT67iiqpUAFM7Beig1HcXrDoxKc
         u5cuolfzhLiDi1UjAxcFVO8bq7dY76O8UI1lZUUaBNbuhetz7zHP5w8YMd70UqxSixJ5
         U6lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=yHHgpBANwrMB3jhs9hI0b1CDaiyJ2Cjlf5IBS/MPeGo=;
        b=uf1PpzQ6Ky3E4TyEVtS8qKp1TUkly9vVs5lHiRJ4FJfo8+LdBpy4rIf6/JbQc0WIxm
         5dMy8uLvc+U1EfofqgpZLWqp8QSuh8GXkKlVrA0Gu9NyRCeGMBvmnO3HQ0cMjwke2sqM
         Jp3xFfmK7ziYwzf6TerwKyHBzk5KUYR0Gn8VYLwkP2JKSccj39Qoezn7vI/jBKJG0VvZ
         CqmsIfdpC4yXTWIC9PhmsncexlMqVm29majHx9KpUs51HXvtfNgVXbrdVFy47HtH/h+8
         WBOGff6IPSD3n6iii0bfr2SCfXfMBCGFmjbQ3r6RJEmC//31zeLCK710NTPyKkFw7NGN
         3OkQ==
X-Gm-Message-State: APjAAAWE/42qWfrH2rUuRrHg5bTaBTmB4oW4oHHeaxBL+KyV0vIhmTC+
        k7QpNGdU4GrUoEG6NuGB/6hIWHSJ
X-Google-Smtp-Source: APXvYqzds47dr4tLMQlbJAHaKvXWG2xLrP8jOwn9XRTGCXyf6gKnsxD15JrWb4ks/Qj5UazhHoX/1A==
X-Received: by 2002:a17:90a:ec10:: with SMTP id l16mr7158975pjy.19.1582093915829;
        Tue, 18 Feb 2020 22:31:55 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id w17sm1169047pfi.56.2020.02.18.22.31.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 22:31:55 -0800 (PST)
Date:   Tue, 18 Feb 2020 22:31:46 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <5e4cd6527bf96_404b2ac01efba5b491@john-XPS-13-9370.notmuch>
In-Reply-To: <20200217200111.GA5283@embeddedor>
References: <20200217200111.GA5283@embeddedor>
Subject: RE: [PATCH][next] bpf, sockmap: Replace zero-length array with
 flexible-array member
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Gustavo A. R. Silva wrote:
> The current codebase makes use of the zero-length array language
> extension to the C90 standard, but the preferred mechanism to declare
> variable-length types such as these ones is a flexible array member[1][2],
> introduced in C99:
> 
> struct foo {
>         int stuff;
>         struct boo array[];
> };
> 
> By making use of the mechanism above, we will get a compiler warning
> in case the flexible array does not occur last in the structure, which
> will help us prevent some kind of undefined behavior bugs from being
> inadvertently introduced[3] to the codebase from now on.
> 
> Also, notice that, dynamic memory allocations won't be affected by
> this change:
> 
> "Flexible array members have incomplete type, and so the sizeof operator
> may not be applied. As a quirk of the original implementation of
> zero-length arrays, sizeof evaluates to zero."[1]
> 
> This issue was found with the help of Coccinelle.
> 
> [1] https://gcc.gnu.org/onlinedocs/gcc/Zero-Length.html
> [2] https://github.com/KSPP/linux/issues/21
> [3] commit 76497732932f ("cxgb3/l2t: Fix undefined behaviour")
> 
> Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
> ---
>  net/core/sock_map.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/core/sock_map.c b/net/core/sock_map.c
> index 085cef5857bb..3a7a96ab088a 100644
> --- a/net/core/sock_map.c
> +++ b/net/core/sock_map.c
> @@ -518,7 +518,7 @@ struct bpf_htab_elem {
>  	u32 hash;
>  	struct sock *sk;
>  	struct hlist_node node;
> -	u8 key[0];
> +	u8 key[];
>  };
>  
>  struct bpf_htab_bucket {
> -- 
> 2.25.0
> 

The same pattern is in ./kernel/bpf/hashtab.c can you also change
it here then if this is the case so sockmap is aligned with bpf
coding style.

.John
