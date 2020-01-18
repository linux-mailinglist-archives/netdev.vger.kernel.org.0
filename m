Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E831B1419D8
	for <lists+netdev@lfdr.de>; Sat, 18 Jan 2020 22:24:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727178AbgARVYt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jan 2020 16:24:49 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34689 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726957AbgARVYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Jan 2020 16:24:48 -0500
Received: by mail-qt1-f193.google.com with SMTP id 5so24721449qtz.1
        for <netdev@vger.kernel.org>; Sat, 18 Jan 2020 13:24:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+eUNtlMyHwd5JzdtRLfxtKvXWpdYtAqoWWzXrqYtZXA=;
        b=mY6h63CjpenUp+8aNI+RawUveUBT11BGq02aOAs6IBOeVYX0iFCRYvCwypbIfvp8ne
         ntpSaSwNp2vXOTZ27h1c2JYzg9lDC3A8FKEyfcr23aN5J+qvaBmNRPzkn6q1EkW7BOho
         /8KkNcQ/2SWyHqnW6634IHWzP26/QdhEF6wPjIQrb/WAcRJhaHGhVNU+/JuLaht2GKoD
         FUx3YPip4DM2ax97IrNaPg5ncCeOt/dl4RU6bSmk+8redHVXSCJi2sf68ZepCpzcTCk6
         S2rcr6fhwlvZWENdz6oqBgOa3KLg0LCBdO2kqjSmR7b2AcZCHV87mbbXMGMgxNdu3dpt
         zUUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+eUNtlMyHwd5JzdtRLfxtKvXWpdYtAqoWWzXrqYtZXA=;
        b=mpF1zTFh36dPDZ0ImI6C793nCrZKeNZbP4bsLR3EF7eG4W7/BuHOWtpqWMqIQQHTAo
         067kpPZqDjKDvZwlfrW9IbeyLVEaoQzcoorzNp9O6ZRzKY0mMq3w8TlY4epDTwe5F02F
         G2Y662SKDFfvEYLiBXTJZcKUNISJrOrCn1J6b8xraCa+qeqd9mE3KMR2EOQS0duxkBI5
         HDBzcDz3+vnfah/2Bg0C+pp9cJ9XjNwR48/B3uDHSk2lEepRlChYVDpgLbHn8AddWNBV
         ownJtOpjUxHd+anw1Hu4vFAojKtC3O7l5AtxvR08Iq75oU3q8YmDwDYDhCl+EnNvvVOM
         mrag==
X-Gm-Message-State: APjAAAU7n6ImntahcRoNJvU5mNX8vQ9ZppaFDb+T61GVh4e3dW+xhbNF
        VplIdItAQRb2XZLSGLV7bEg=
X-Google-Smtp-Source: APXvYqycex6erVu4KPxiyKWy/DpuFCFcLWosHwifFZv6QzB7XbmrI9Kq4ti54Q67YczIKWhdJ//prw==
X-Received: by 2002:aed:2ae7:: with SMTP id t94mr13664847qtd.130.1579382687970;
        Sat, 18 Jan 2020 13:24:47 -0800 (PST)
Received: from ?IPv6:2601:282:803:7700:61e3:b62a:f6cf:af56? ([2601:282:803:7700:61e3:b62a:f6cf:af56])
        by smtp.googlemail.com with ESMTPSA id k62sm13542856qkc.95.2020.01.18.13.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jan 2020 13:24:47 -0800 (PST)
Subject: Re: [PATCH iproute2-next] ip: xfrm: add espintcp encapsulation
To:     Sabrina Dubroca <sd@queasysnail.net>, netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Herbert Xu <herbert@gondor.apana.org.au>
References: <0b5baa21f8d0048b5e97f927e801ac2f843bb5e1.1579104430.git.sd@queasysnail.net>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <2df9df78-0383-c914-596e-1855c69fb170@gmail.com>
Date:   Sat, 18 Jan 2020 14:24:45 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <0b5baa21f8d0048b5e97f927e801ac2f843bb5e1.1579104430.git.sd@queasysnail.net>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/16/20 3:39 AM, Sabrina Dubroca wrote:
> diff --git a/ip/ipxfrm.c b/ip/ipxfrm.c
> index 32f560933a47..e310860b9f1f 100644
> --- a/ip/ipxfrm.c
> +++ b/ip/ipxfrm.c
> @@ -759,6 +759,9 @@ void xfrm_xfrma_print(struct rtattr *tb[], __u16 family,
>  		case 2:
>  			fprintf(fp, "espinudp ");
>  			break;
> +		case 7:
> +			fprintf(fp, "espintcp ");
> +			break;
>  		default:
>  			fprintf(fp, "%u ", e->encap_type);
>  			break;
> @@ -1211,6 +1214,8 @@ int xfrm_encap_type_parse(__u16 *type, int *argcp, char ***argvp)
>  		*type = 1;
>  	else if (strcmp(*argv, "espinudp") == 0)
>  		*type = 2;
> +	else if (strcmp(*argv, "espintcp") == 0)
> +		*type = 7;
>  	else
>  		invarg("ENCAP-TYPE value is invalid", *argv);
>  

are there enums / macros for the magic numbers?
