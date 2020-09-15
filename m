Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EB2326AE1D
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 21:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727818AbgIORHn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 13:07:43 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45965 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727800AbgIORGp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 13:06:45 -0400
Received: by mail-pg1-f193.google.com with SMTP id 67so2280660pgd.12;
        Tue, 15 Sep 2020 10:06:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TUBLEz0hsMNnjxbU82r0TebLuBdMSe/EPOZbJ7e3QlY=;
        b=klEICfyLYw4GIqEO5yrUxKA/LoTiKM1nieyVhMJs0btRXKMMNlq2RVjplVmFWhr23/
         +LSefdzkxEFI36h4PloVi2zxTxha4qL4D0DoS1wF8HEG0FIIwhj7OaY7QyY5hqplGosx
         Soobt1Fd8SbbePkoF+Tl1K0jyXd9+KaJOVSodYU0WutgCtELlk+XLd6QSS7roBdc3NfI
         wz4HQQy9TsZnv0CEQsoTZOFOSM6g2HPm4fzN769B0sMYAzs8BUtUNtTL0uu9Yatv3w6F
         4TdMDPNOc8oLT96YTnaR3zxxAHqgDI15OFZ83fwr4I/PvWw3EPCf34ecIg4X+Ouoo0ee
         Ngyw==
X-Gm-Message-State: AOAM531N+ASEV1pwD6H2VQkLH+bgY7u3kF3XZ8D26D90Sr1HbeZ0QqMs
        +UY468X1KJA43uuz2DuSzp9SN9ZLlW/8K0I=
X-Google-Smtp-Source: ABdhPJyjnn6vOZVu2xsfKKhOlKHlqPyeSuyRHbUErkzVYWRU9d4Gk1HXAlgAVFPbfqgBIz+7O54XCA==
X-Received: by 2002:a92:408e:: with SMTP id d14mr17628216ill.4.1600188895920;
        Tue, 15 Sep 2020 09:54:55 -0700 (PDT)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id v24sm7886131ioh.21.2020.09.15.09.54.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2020 09:54:55 -0700 (PDT)
Received: (nullmailer pid 2114741 invoked by uid 1000);
        Tue, 15 Sep 2020 16:54:53 -0000
Date:   Tue, 15 Sep 2020 10:54:53 -0600
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzk@kernel.org>
Cc:     devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Dan Murphy <dmurphy@ti.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: Correct interrupt flags in examples
Message-ID: <20200915165453.GA2114689@bogus>
References: <20200908145939.4569-1-krzk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200908145939.4569-1-krzk@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 08 Sep 2020 16:59:39 +0200, Krzysztof Kozlowski wrote:
> GPIO_ACTIVE_x flags are not correct in the context of interrupt flags.
> These are simple defines so they could be used in DTS but they will not
> have the same meaning:
> 1. GPIO_ACTIVE_HIGH = 0 = IRQ_TYPE_NONE
> 2. GPIO_ACTIVE_LOW  = 1 = IRQ_TYPE_EDGE_RISING
> 
> Correct the interrupt flags, assuming the author of the code wanted some
> logical behavior behind the name "ACTIVE_xxx", this is:
>   ACTIVE_LOW  => IRQ_TYPE_LEVEL_LOW
>   ACTIVE_HIGH => IRQ_TYPE_LEVEL_HIGH
> 
> Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/can/tcan4x5x.txt | 2 +-
>  Documentation/devicetree/bindings/net/nfc/nxp-nci.txt  | 2 +-
>  Documentation/devicetree/bindings/net/nfc/pn544.txt    | 2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
