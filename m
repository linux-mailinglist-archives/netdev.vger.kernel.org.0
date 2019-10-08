Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9276FCFA27
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 14:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731039AbfJHMkf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 08:40:35 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:46337 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730608AbfJHMke (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 08:40:34 -0400
Received: by mail-qk1-f194.google.com with SMTP id 201so16510739qkd.13;
        Tue, 08 Oct 2019 05:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QcaaD2Kkp9q1dKv4LCmVZwmcx3ne0cSQScXyx4+4l/0=;
        b=LNvQQGLFdee2VJ1Y8N1LhQq2QMKUXTBwBZ3jHB9RKlLXGeS8tFB2htIFHPVSE5hC0O
         ZfF4QMtgO0b1IFeftV5/OOyooHK6DXs35+xcIKJXJrFJaudh2JduSyo5RvsAUj+845uX
         TH1PbE6C1uZXfJK1Tuegsc5acEEE287hO5Vyc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QcaaD2Kkp9q1dKv4LCmVZwmcx3ne0cSQScXyx4+4l/0=;
        b=JVSjNfskoh5F//n1UqY6fKU9axSmS6WfPhMhOxWtehcbYQIjvBNiboVMxnZl0iYMi7
         2vb+t6re+OPvR7uz91G2q12rseQ+6fnTdmDkf5sOLL/z5/DnlFvw8iaXviMdX4KvTgcs
         xFZO22obOcHJ825z4kdjMX4YBeWBB9gz2grsDHZ9XB5nWl11AxXgJP6Sz7XamURsOxsq
         S4SZ6JUr5P+xclDHGnfdDGtlCv96U+xKlgrlDGJyhzSo5CyTssQF9RUs5fw5aUbhltYL
         ApK5BK4q4kDm8p14FVh2xjuRUL0UomNuy/+PU1R0CyVc8Njkz1273yJS70Geo5uwyYM6
         +Zjw==
X-Gm-Message-State: APjAAAVERcQ16JVtKjaV0xBERsCzb4upytSRNflwDGofO7MukRUage3V
        rPd25VZgK7BF7eDEBPciRXKYaygitSPNj3gBWOMyZcjj
X-Google-Smtp-Source: APXvYqwkF6lq+t3CBdhUlmPrseGRIVSYeVvqMPJ6fXPG/nPcYV3BhIqU06DGPVBFxB6scD/DUZvx8Fb0j+IrJWbXzdQ=
X-Received: by 2002:a37:4f4c:: with SMTP id d73mr28718632qkb.171.1570538433471;
 Tue, 08 Oct 2019 05:40:33 -0700 (PDT)
MIME-Version: 1.0
References: <20191008115143.14149-1-andrew@aj.id.au> <20191008115143.14149-2-andrew@aj.id.au>
In-Reply-To: <20191008115143.14149-2-andrew@aj.id.au>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 8 Oct 2019 12:40:21 +0000
Message-ID: <CACPK8Xeqpx3f_rMOGOqE8cXENREHH3MBjm0Eco9Dr4-ocs+DLg@mail.gmail.com>
Subject: Re: [PATCH 1/3] dt-bindings: net: ftgmac100: Document AST2600 compatible
To:     Andrew Jeffery <andrew@aj.id.au>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        devicetree <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 at 11:50, Andrew Jeffery <andrew@aj.id.au> wrote:
>
> The AST2600 contains an FTGMAC100-compatible MAC, although it no-longer
> contains an MDIO controller.
>
> Signed-off-by: Andrew Jeffery <andrew@aj.id.au>

Acked-by: Joel Stanley <joel@jms.id.au>

> ---
>  Documentation/devicetree/bindings/net/ftgmac100.txt | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/Documentation/devicetree/bindings/net/ftgmac100.txt b/Documentation/devicetree/bindings/net/ftgmac100.txt
> index 72e7aaf7242e..04cc0191b7dd 100644
> --- a/Documentation/devicetree/bindings/net/ftgmac100.txt
> +++ b/Documentation/devicetree/bindings/net/ftgmac100.txt
> @@ -9,6 +9,7 @@ Required properties:
>
>       - "aspeed,ast2400-mac"
>       - "aspeed,ast2500-mac"
> +     - "aspeed,ast2600-mac"
>
>  - reg: Address and length of the register set for the device
>  - interrupts: Should contain ethernet controller interrupt
> --
> 2.20.1
>
