Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98E7A664772
	for <lists+netdev@lfdr.de>; Tue, 10 Jan 2023 18:32:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233819AbjAJRcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Jan 2023 12:32:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231928AbjAJRcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Jan 2023 12:32:20 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E1758D17;
        Tue, 10 Jan 2023 09:32:19 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id bk16so12546798wrb.11;
        Tue, 10 Jan 2023 09:32:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9FW+YfnIg3H0PjnW3zlZEUF8cpvzgsg6qSJnyFKIcbQ=;
        b=mPmTs1ES8tDFTdVkPXf8zTI42WWPhpKzucDvxXcQHh8FBNEh2k1KtS6Hb0nn2uVOy/
         dTtzW46uWobho5HRDJr7GWGlbtt8fBZ0rNZoprHilM7+hNgAw7/wqYpOio+DovnVXUMm
         cw2qIvX6gyLd9BHwUqkRY0G0eIU53klJ0Zz3Hyk4djMGWPshQnqAHTpBRiI9N4fvRTvG
         Kkh3pkn0ZXpq1zGgsnu2FSebadBsa/UvKNzgKXOzPRB9XzWJHphDUPBct+xoqCzKhcDL
         L8LRzS/A5pphbPEiTUYeb1GkxvJkzAJMNQhVA9bwrUB83kwMavYvEt2dFzuwhNij8YvN
         YMhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9FW+YfnIg3H0PjnW3zlZEUF8cpvzgsg6qSJnyFKIcbQ=;
        b=jJdanZCbuswz8Kihi31q6YAtqlsyjZf8Ozxx3gcERjWis0kOfCBRE7sTV/VePFOXUr
         T7e5aMIwpjIxIzwhG+lhNgwSvxxHIxRMA46IKVJmiJxe1k5CHgHcDIRe1tQ5DzuVgpwf
         iyKFd/BIQ1NtySEBogi8gxgQJjKL3r3cg/CLzxtM8j4rdUfXO2ur1fAWtTfElyp8sh+x
         mCmgWH7YNRAKFM8mj0eb3V68jwhu9tYP7NBXTJ29p5JI0qvK5yHUyhXw0CO2mhDz6jtb
         dR/7oPtxdVaAr63Lc8OObQgC3+jssM1CGDZlzd7oGu1cU2BRhUEAQ3sLwqwPExCeyMNF
         +EnA==
X-Gm-Message-State: AFqh2koNc6/UQ3fs7I1q46ojV5WNHNosc+aoe/FucQGOKKFkzzlOoRF6
        ezpHvRSr4Rc/qb47w8lIt6M=
X-Google-Smtp-Source: AMrXdXtSAwkXsuuIXJ74yW4K+8h7qVTsH1sAoempc3trWRcddT3a1A6Np3X/2IdCa/sbS77hIWRgkA==
X-Received: by 2002:adf:ec03:0:b0:2bd:be31:cd77 with SMTP id x3-20020adfec03000000b002bdbe31cd77mr1354599wrn.30.1673371937584;
        Tue, 10 Jan 2023 09:32:17 -0800 (PST)
Received: from [10.83.37.24] ([217.173.96.166])
        by smtp.gmail.com with ESMTPSA id d20-20020adfa354000000b002bc50ba3d06sm6630908wrb.9.2023.01.10.09.32.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Jan 2023 09:32:17 -0800 (PST)
Message-ID: <a2821ac8-6903-372e-36a4-9667b9fceac2@gmail.com>
Date:   Tue, 10 Jan 2023 17:32:15 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] xfrm: compat: change expression for switch in
 xfrm_xlate64
Content-Language: en-US
To:     Anastasia Belova <abelova@astralinux.ru>,
        Steffen Klassert <steffen.klassert@secunet.com>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
References: <20230110091450.21696-1-abelova@astralinux.ru>
From:   Dmitry Safonov <0x7f454c46@gmail.com>
In-Reply-To: <20230110091450.21696-1-abelova@astralinux.ru>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/10/23 09:14, Anastasia Belova wrote:
> Compare XFRM_MSG_NEWSPDINFO (value from netlink
> configuration messages enum) with nlh_src->nlmsg_type
> instead of nlh_src->nlmsg_type - XFRM_MSG_BASE.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.

Nice find!

Looking at the details:
xfrm_xlate64() is for translating 64-bit kernel-issued message to 32-bit
userspace ABI. The message is XFRM_MSG_NEWSPDINFO and there's a selftest
that checks if the attributes (thresh valued) were correctly translated
in tools/testing/selftests/net/ipsec.c

So, I was interested in how did it go unnoticed?
The switch here is to differ XFRMA_* attributes from XFRMA_SPD_*
attributes, which can be just copied as they are as they occupy the same
space on 64-bit as well as on 32-bit.

enum xfrm_spdattr_type_t {
	XFRMA_SPD_UNSPEC,
	XFRMA_SPD_INFO,
	XFRMA_SPD_HINFO,
	XFRMA_SPD_IPV4_HTHRESH,
	XFRMA_SPD_IPV6_HTHRESH,
	__XFRMA_SPD_MAX
};
attributes went through xfrm_xlate64_attr() instead of just being
copied. That worked in result as
	case XFRMA_UNSPEC:
	case XFRMA_ALG_AUTH:
	case XFRMA_ALG_CRYPT:
	case XFRMA_ALG_COMP:
	case XFRMA_ENCAP:
	case XFRMA_TMPL:
		return xfrm_nla_cpy(dst, src, nla_len(src));
are equal by value (XFRMA_UNSPEC == 0 == XFRMA_SPD_UNSPEC) and so on.
So, in result, even with this typo the code worked.

What about the reverse case, what was being copied by this
XFRM_MSG_NEWSPDINFO case?
XFRM_MSG_NEWSPDINFO == 0x24
So, before this patch (XFRM_MSG_NEWSPDINFO - XFRM_MSG_BASE) == 0x14 ==
XFRM_MSG_DELPOLICY type of messages would fit this switch case.

Luckily enough, kernel doesn't send back XFRM_MSG_DELPOLICY messages to
userspace. That's how it went unnoticed, by unexpectedly still working.


> Fixes: 4e9505064f58 ("net/xfrm/compat: Copy xfrm_spdattr_type_t atributes")
> Signed-off-by: Anastasia Belova <abelova@astralinux.ru>

Thanks for the patch,
Acked-by: Dmitry Safonov <0x7f454c46@gmail.com>
Tested-by: Dmitry Safonov <0x7f454c46@gmail.com>

> ---
>  net/xfrm/xfrm_compat.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/xfrm/xfrm_compat.c b/net/xfrm/xfrm_compat.c
> index a0f62fa02e06..12405aa5bce8 100644
> --- a/net/xfrm/xfrm_compat.c
> +++ b/net/xfrm/xfrm_compat.c
> @@ -302,7 +302,7 @@ static int xfrm_xlate64(struct sk_buff *dst, const struct nlmsghdr *nlh_src)
>  	nla_for_each_attr(nla, attrs, len, remaining) {
>  		int err;
>  
> -		switch (type) {
> +		switch (nlh_src->nlmsg_type) {
>  		case XFRM_MSG_NEWSPDINFO:
>  			err = xfrm_nla_cpy(dst, nla, nla_len(nla));
>  			break;

