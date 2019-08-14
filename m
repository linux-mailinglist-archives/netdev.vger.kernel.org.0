Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 366928DD0B
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 20:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfHNSd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 14:33:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43984 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726522AbfHNSd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 14:33:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id y8so17426wrn.10;
        Wed, 14 Aug 2019 11:33:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y+U2P77L5yF3rgxH6FgzV86C/p2e7T5M7nztZM7FoNA=;
        b=GNSNKHY4zlXwjJmo8GGkNFDOKzfrG/bQ/NfZfGL2Ss4sCbVZlBpMpyLo/vQYhrC4Yl
         6uf+pD0n3YbxhPrLR0cjUZzZhWcdbxGu3wTPx+3qzGKXW7g0of+8cbaEK2HeKfnhfKrk
         GHsSTW1JUg6CIIaNrt2h/7TGsWZadezEv98TbcgIpSofwDMbDQvsCQgqlE9l+jL7o/1Y
         102Wqp165KiFejssUf4Ppk8aXprgHen9aBn8dXhIXtZLBsiYeCLAeajqCUhyWwaWYOBx
         RikW9DUaM/3+YPPg7j5F0qm/hYA19558nyKUcTBdCTjUyIIjwCWCnDFYct6vwLJInT43
         LSbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y+U2P77L5yF3rgxH6FgzV86C/p2e7T5M7nztZM7FoNA=;
        b=M6mDGwnXAO6Scgr/asT5AA3DC5gp4keY8mBJnRFiOgQLq/GmDsXRlSZ8F1Sxxj/Hd1
         kS9nB9mWImTrsyT5r13ZPXH/gZfZK5+oMxEAcbfpQqqBFOn5EHua702EOKuqwIFtnNRk
         4edkqiPG/LrXXJ6Ovdfrts2ZXhggx5TtdIY2Pw8SWFyHNmhfCkMKk/8GCcsc4SVKeAyq
         2oUT7k0w9LI5mA8wrWU1IanqEBDOPqiP59eSnWFqZd7z5Gp5rLVMc0TcxFJ591omqn40
         2/LMUK/rjkAaBIIlfeL3BMLFjMOTz8+PNbJlik0KxIsqHhfmQo4tDKNYw5POyYJajY7q
         wRuQ==
X-Gm-Message-State: APjAAAXUY5DNNAD3WUbtbtLXuLj6xXyElwzfFdlZYSuFQ26fXJnNDeBR
        H1aY+rIOPMS9ek7E3PvVgna1dvVB
X-Google-Smtp-Source: APXvYqweTB2T6SpZJVzamx/JzBXYuLVcM/CWoxcHkdiddFthlEGPTteWPA8k8w75i7seeSHcSIBkZw==
X-Received: by 2002:a05:6000:1284:: with SMTP id f4mr1226050wrx.89.1565807635304;
        Wed, 14 Aug 2019 11:33:55 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f2f:3200:5905:9c04:aa53:7427? (p200300EA8F2F320059059C04AA537427.dip0.t-ipconnect.de. [2003:ea:8f2f:3200:5905:9c04:aa53:7427])
        by smtp.googlemail.com with ESMTPSA id r11sm375854wrt.84.2019.08.14.11.33.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Aug 2019 11:33:54 -0700 (PDT)
Subject: Re: [PATCH] MAINTAINERS: r8169: Update path to the driver
To:     Denis Efremov <efremov@linux.com>
Cc:     joe@perches.com, linux-kernel@vger.kernel.org,
        nic_swsd@realtek.com, "David S . Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org
References: <69fac52e-8464-ea87-e2e5-422ae36a92c8@gmail.com>
 <20190814121209.3364-1-efremov@linux.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <7110b633-fd6b-68cf-2ade-81ccf30beb77@gmail.com>
Date:   Wed, 14 Aug 2019 20:33:47 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190814121209.3364-1-efremov@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 14.08.2019 14:12, Denis Efremov wrote:
> Update MAINTAINERS record to reflect the filename change.
> The file was moved in commit 25e992a4603c ("r8169: rename
> r8169.c to r8169_main.c")
> 
> Cc: Heiner Kallweit <hkallweit1@gmail.com>
> Cc: nic_swsd@realtek.com
> Cc: David S. Miller <davem@davemloft.net>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Denis Efremov <efremov@linux.com>
> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index a43a1f0be49f..905efeda56fb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -183,7 +183,7 @@ M:	Realtek linux nic maintainers <nic_swsd@realtek.com>
>  M:	Heiner Kallweit <hkallweit1@gmail.com>
>  L:	netdev@vger.kernel.org
>  S:	Maintained
> -F:	drivers/net/ethernet/realtek/r8169.c
> +F:	drivers/net/ethernet/realtek/r8169*
>  
>  8250/16?50 (AND CLONE UARTS) SERIAL DRIVER
>  M:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
For net-next.
Reviewed-by: Heiner Kallweit <hkallweit1@gmail.com>

