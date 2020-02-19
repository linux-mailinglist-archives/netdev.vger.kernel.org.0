Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5CD6163CE5
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 07:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726175AbgBSGJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 01:09:41 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36257 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbgBSGJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 01:09:40 -0500
Received: by mail-pf1-f195.google.com with SMTP id 185so11966654pfv.3;
        Tue, 18 Feb 2020 22:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=XRx7+/ZhOH6YkRAd+n2fjfG4ZqnFn+5bcm4X+MuwWhA=;
        b=A5FdGI4rv9gdn4TUYmWLo2n8/E3e0zxW50uHOVqVHQh/aOVaelUhNVH8ecBSdj5QwN
         OwBxFYvno3jtegz94k2Ymuh/xQa2H752yDEyQQvgTb9RiItIeZketnX4R7O5ZHiVdPFt
         MJUtfbqW1KJL40esvYsV8RzmNcY6ogIGC/wloGf/VIr87E6m8x8vKEif4k5OebtQ5Hj6
         5pJ2zjo6FF5O5fzuaVvCDSJcNvj9wyrIFsvMF17l055b+BlZ3tqhWA5zKc+9a5NkdjXD
         pDLkOACRlGWif+e4IRIGTQ3rpyG6ddJemf2Yeqb2zfgjFD1lCTst6CREjtiF0T2CAzic
         JLkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=XRx7+/ZhOH6YkRAd+n2fjfG4ZqnFn+5bcm4X+MuwWhA=;
        b=KsWA4fbz9g2wZAtY+Q9Oq6ENaNXkpLy8SX0JTtd/bHWjXK9ZlWc30P7WSfqbHEtjdX
         OreXYfHg3b0oFxwFCseF7Z466BhL9sYCkCayITjVR7dZscDlsMV7r3OSyvfDnu/6Htib
         B+SS0KZHR1954vmecRJHhhUoKgFdHve1N1pCmhdOz3dIb9UUa21U5FQsuU2PscuLQQvq
         aJlmEpO1qi1RzRhGi7MIy/WzAmNSAyVoHfNYOAOs2QPLbfdBtFH3/3Gd4kO36DYC3HWC
         ij9ismx4eZ7nrACecRGoV0eZS7Pf4d0zPUW+vURFDyzcI7yDsEisAg7AonGccLyfKELO
         c+Zw==
X-Gm-Message-State: APjAAAV43TWX1W5w0KPWfXeP3atlvffCH6qejQTaEXRt7RdXSyvXXwZT
        ND0x4wdSSOyHGmZp5v2AbmU=
X-Google-Smtp-Source: APXvYqzK8BIhzWQAJJ/RqNONP45inNg/eW/A3lcsWLxeDdsBQQbynyvv05vmFHJz1A8jWFPpIivNDQ==
X-Received: by 2002:a63:5e07:: with SMTP id s7mr25831014pgb.261.1582092578658;
        Tue, 18 Feb 2020 22:09:38 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r3sm1127845pfg.145.2020.02.18.22.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 22:09:37 -0800 (PST)
Date:   Tue, 18 Feb 2020 22:09:29 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>, bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>
Message-ID: <5e4cd1191433d_404b2ac01efba5b4d3@john-XPS-13-9370.notmuch>
In-Reply-To: <20200217121530.754315-2-jakub@cloudflare.com>
References: <20200217121530.754315-1-jakub@cloudflare.com>
 <20200217121530.754315-2-jakub@cloudflare.com>
Subject: RE: [PATCH bpf-next 1/3] bpf, sk_msg: Let ULP restore sk_proto and
 write_space callback
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Sitnicki wrote:
> We don't need a fallback for when the socket is not using ULP.
> tcp_update_ulp handles this case exactly the same as we do in
> sk_psock_restore_proto. Get rid of the duplicated code.
> 
> Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
> ---
>  include/linux/skmsg.h | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)
> 
> diff --git a/include/linux/skmsg.h b/include/linux/skmsg.h
> index 14d61bba0b79..8605947d6c08 100644
> --- a/include/linux/skmsg.h
> +++ b/include/linux/skmsg.h
> @@ -361,16 +361,7 @@ static inline void sk_psock_restore_proto(struct sock *sk,
>  	sk->sk_prot->unhash = psock->saved_unhash;
>  
>  	if (psock->sk_proto) {
> -		struct inet_connection_sock *icsk = inet_csk(sk);
> -		bool has_ulp = !!icsk->icsk_ulp_data;
> -
> -		if (has_ulp) {
> -			tcp_update_ulp(sk, psock->sk_proto,
> -				       psock->saved_write_space);
> -		} else {
> -			sk->sk_prot = psock->sk_proto;
> -			sk->sk_write_space = psock->saved_write_space;
> -		}
> +		tcp_update_ulp(sk, psock->sk_proto, psock->saved_write_space);
>  		psock->sk_proto = NULL;
>  	} else {
>  		sk->sk_write_space = psock->saved_write_space;
> -- 
> 2.24.1
> 

Acked-by: John Fastabend <john.fastabend@gmail.com>
