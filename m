Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ABCC432853
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 22:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233960AbhJRUT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 16:19:26 -0400
Received: from mail-oi1-f180.google.com ([209.85.167.180]:39468 "EHLO
        mail-oi1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233928AbhJRUTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 16:19:23 -0400
Received: by mail-oi1-f180.google.com with SMTP id m67so1428160oif.6;
        Mon, 18 Oct 2021 13:17:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WuQpwH7TTX6JVYtdgxAwhDMH1nR7A5PIOjWQH7p4M6c=;
        b=xiNrGfrXNqcJCexn8K3q4Ynhmk7bUEoJ3nk23hsvuc4NVeb4dUsNEgzbFGJm11Ih2H
         SQFkuaaAgnc1Y3qf+mGFgiBe+DHv65Eiy3f2SjgI6+CscKUFOWxJjsP52PH4ltRBWYvJ
         vina5z3G4VRL+nIM4/Ph0JJQeewfI4EynpJGOMg7jnzg2Rl7TgG9yux5srFZIFvU9kUa
         PhISeRcnMN5FN3XbNJvFJEQtcQ2Zgi7CzSY0qLKe+1FrDn8U2bK8AxXX9ZC+OKKukL5v
         0AWDGsCf/Gcykt+G8TmzbFdS6YVVKnY/O5/558j8b193vqCcJ1CXRUG1SMtqk5RTRHMy
         nSOA==
X-Gm-Message-State: AOAM5307wefbTDptOGS+D8SKbMTe1dGNT3XtZlyQbHSYemj7D0L1ySaA
        Qje0X3awAWvRCJE6ER00bQ==
X-Google-Smtp-Source: ABdhPJx6eKTzbv6UgJbyyWq/9hPHZtgFPywZzdJn94H+wL5SRAjv8j9SpvJBMPnHmHO0VmsZlBq8sA==
X-Received: by 2002:a05:6808:2025:: with SMTP id q37mr837443oiw.122.1634588231435;
        Mon, 18 Oct 2021 13:17:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e59sm3236592ote.14.2021.10.18.13.17.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 13:17:10 -0700 (PDT)
Received: (nullmailer pid 2884155 invoked by uid 1000);
        Mon, 18 Oct 2021 20:17:10 -0000
Date:   Mon, 18 Oct 2021 15:17:10 -0500
From:   Rob Herring <robh@kernel.org>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     Rob Herring <robh+dt@kernel.org>, linux-nfc@lists.01.org,
        Mark Greer <mgreer@animalcreek.com>,
        linux-wireless@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Charles Gorand <charles.gorand@effinnov.com>,
        devicetree@vger.kernel.org, None@robh.at.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 7/8] dt-bindings: nfc: ti,trf7970a: convert to dtschema
Message-ID: <YW3WRsrojpSZDtHk@robh.at.kernel.org>
References: <20211011073934.34340-1-krzysztof.kozlowski@canonical.com>
 <20211011073934.34340-8-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011073934.34340-8-krzysztof.kozlowski@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Oct 2021 09:39:33 +0200, Krzysztof Kozlowski wrote:
> Convert the TI TRF7970A NFC to DT schema format.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> ---
>  .../bindings/net/nfc/ti,trf7970a.yaml         | 98 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/trf7970a.txt  | 43 --------
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 99 insertions(+), 44 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/ti,trf7970a.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/trf7970a.txt
> 

Applied, thanks!
