Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6D62A5BB9
	for <lists+netdev@lfdr.de>; Mon,  2 Sep 2019 19:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfIBRMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Sep 2019 13:12:14 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:32947 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfIBRMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Sep 2019 13:12:14 -0400
Received: by mail-lf1-f66.google.com with SMTP id d10so2984864lfi.0
        for <netdev@vger.kernel.org>; Mon, 02 Sep 2019 10:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cogentembedded-com.20150623.gappssmtp.com; s=20150623;
        h=from:subject:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E7g5tM3WWBAJ5GFVwE5QOy9tpwo5F4zgFbFtuMqETxU=;
        b=UWqWQQr4d/4D7FyY68KrSzqJ5FAmWICdxsRrLt/6MqTqO1X0VP3Jcrxa8ez5V6Mxle
         GLwe6tmvpcfOjH4GVsHtWSOBhxMBSHVLtKkNKKiq49XEV8iVj441qxiYBe6fecS0gcgL
         ngp97u5TzHmAyOzuWek3I1DyZJS/Pi9thXo8P8fJZP/fNtw85YGADkWH0U1xPPdGbEAw
         m8m5PAZBWset3rWjH5+3YHGxI9gwrcYEpzM/ixjk1bjZdle0ysfkCsngKrnVa95lcjdC
         9JfzDEPmuodlurtbQp118TFFEWbSAzqrnYpUVNS6pI79VL+sX4vwL1MR98biRu5FI1/T
         eA7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=E7g5tM3WWBAJ5GFVwE5QOy9tpwo5F4zgFbFtuMqETxU=;
        b=eGTgySGHMWmgTOndSiloyKej2NUmU+/tPFUy6cw8+kyX5W2vtSq417ubfFpfGe6RlD
         /N4OeQNsL/sBWgXgMPaXbox17mrWI71DoW6xQW51mNT8Oq4NRmELmkO7xzHg9iAK47bv
         Myg3fdQhp6woGLVP16QDAnNLa0j/kuIyH7EFdsm0iNJXUklb7rXgv4LypFvha8o7uCNN
         Hnp7aAaun1TwAGUKX57DjEBlSQ9DB3tLBKG9NJGlhCCcILXtn5mn3F4gDD2LA07zfZNE
         4S8YJx8L9ZWSNa4kyk8kt5ce45vGHkKs0qMxM5cr2bWYmvvaY06JqVIxnxTkQqzsM0fR
         AXkw==
X-Gm-Message-State: APjAAAUccaQyOpLiaifcBiDUkYG+SynbhAfj3YqWDznpmGam0pJA8P2Q
        Q5jR2rUVaIb6EC5N4B+I83Zh2g==
X-Google-Smtp-Source: APXvYqwdTVQmz0A+5FgQoXERvwk0lxN6oEmHMMkbrlTQvyjpnXiPRqsuZ2Kh1YESSBlrfK1oOqDBKQ==
X-Received: by 2002:ac2:528c:: with SMTP id q12mr201010lfm.135.1567444332875;
        Mon, 02 Sep 2019 10:12:12 -0700 (PDT)
Received: from wasted.cogentembedded.com ([2a00:1fa0:272:5afe:be7d:d15f:cff2:c9cf])
        by smtp.gmail.com with ESMTPSA id l23sm2413295lje.106.2019.09.02.10.12.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 02 Sep 2019 10:12:12 -0700 (PDT)
From:   Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [net-next 1/3] ravb: correct typo in FBP field of SFO register
To:     Simon Horman <horms+renesas@verge.net.au>,
        David Miller <davem@davemloft.net>
Cc:     Magnus Damm <magnus.damm@gmail.com>, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org,
        Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
References: <20190902080603.5636-1-horms+renesas@verge.net.au>
 <20190902080603.5636-2-horms+renesas@verge.net.au>
Organization: Cogent Embedded
Message-ID: <f0811b31-c51a-db1e-a9f3-26f7f0416517@cogentembedded.com>
Date:   Mon, 2 Sep 2019 20:12:11 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.1
MIME-Version: 1.0
In-Reply-To: <20190902080603.5636-2-horms+renesas@verge.net.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-MW
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 09/02/2019 11:06 AM, Simon Horman wrote:

> From: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> 
> The field name is FBP rather than FPB.
> 
> This field is unused and could equally be removed from the driver entirely.
> But there seems no harm in leaving as documentation of the presence of the
> field.
> 
> Signed-off-by: Kazuya Mizuguchi <kazuya.mizuguchi.ks@renesas.com>
> Signed-off-by: Simon Horman <horms+renesas@verge.net.au>

Acked-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

> ---
> v0 - Kazuya Mizuguchi
> 
> v1 - Simon Horman
> * Extracted from larger patch

   I'd just claim the authorship in this case (and mentioned that it's based
on Mizuguchi-san's large patch right in the change log).

> * Wrote changelog
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index ac9195add811..bdb051f04b0c 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -317,7 +312,7 @@ enum UFCD_BIT {
> 
>  /* SFO */
>  enum SFO_BIT {
> -	SFO_FPB		= 0x0000003F,
> +	SFO_FBP		= 0x0000003F,
>  };
> 
>  /* RTC */
> ---

   This is where the actual patch starts, right?

>  drivers/net/ethernet/renesas/ravb.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/renesas/ravb.h b/drivers/net/ethernet/renesas/ravb.h
> index ac9195add811..2596a95a4300 100644
> --- a/drivers/net/ethernet/renesas/ravb.h
> +++ b/drivers/net/ethernet/renesas/ravb.h
> @@ -317,7 +317,7 @@ enum UFCD_BIT {
>  
>  /* SFO */
>  enum SFO_BIT {
> -	SFO_FPB		= 0x0000003F,
> +	SFO_FBP		= 0x0000003F,
>  };
>  
>  /* RTC */

MBR, Sergei
