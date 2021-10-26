Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF10B43BDED
	for <lists+netdev@lfdr.de>; Wed, 27 Oct 2021 01:33:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240310AbhJZXfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 19:35:24 -0400
Received: from mail-oi1-f172.google.com ([209.85.167.172]:33463 "EHLO
        mail-oi1-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240306AbhJZXfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 19:35:23 -0400
Received: by mail-oi1-f172.google.com with SMTP id q129so1015868oib.0;
        Tue, 26 Oct 2021 16:32:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U0VixVt2ZHEQsaOQQxe0TrabmQFV0H1KLO4eFGtC0OY=;
        b=N92iOJHf8qyZ1kcak/t6oUdo2Sddr78+Vr8ZMKtFt0jxv9h1QU2fGxs/f8ia3gwuLc
         KbrMoeZGjNhX8cpzwv6rD4f8Vn6CKrdg6clu3uOmx0N7N4rnIYapkcc9azGx5h96GPE9
         nlbd8ES2MAsyvFCxLAkM8nBi53npCfjC+4eYB2X4frjs1n8zhWGrEOXKEntDKLioe7fx
         ciYvNWQmPhR7fZwBbmsA4jisppMYokyqIWGMI2Zq0Do4mtZ32MU32nGWAWx2axaMgi90
         eSUCR44YyQpVEsWpMyM6hncMRogCqTMwmyENZjuywHnBjV3kPQGRsUOhwdmqbEuh0lVH
         tYdA==
X-Gm-Message-State: AOAM530ZLlHzNodam1a7e56tWVvvKecaxk6A16W8fNNI3jXVAHREDw3v
        RQA0pmqJFZMXJQstsR501wW3SWbwRg==
X-Google-Smtp-Source: ABdhPJyJvkFqJzPNJdV7qiSoN+4lX+UiDvnHPGcknDgTNJf499Sd0Wsq3fAsGquHYzzmYFbO++6Alw==
X-Received: by 2002:a05:6808:e90:: with SMTP id k16mr1302011oil.166.1635291178661;
        Tue, 26 Oct 2021 16:32:58 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id bq10sm3691826oib.25.2021.10.26.16.32.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 16:32:58 -0700 (PDT)
Received: (nullmailer pid 3523722 invoked by uid 1000);
        Tue, 26 Oct 2021 23:32:57 -0000
Date:   Tue, 26 Oct 2021 18:32:57 -0500
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Rob Herring <robh+dt@kernel.org>, ~okias/devicetree@lists.sr.ht,
        Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v4] dt-bindings: net: nfc: nxp,pn544: Convert txt
 bindings to yaml
Message-ID: <YXiQKS61CUoMhe7W@robh.at.kernel.org>
References: <20211017160210.85543-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211017160210.85543-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 17 Oct 2021 18:02:10 +0200, David Heidelberg wrote:
> Convert bindings for NXP PN544 NFC driver to YAML syntax.
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
> v2
>  - Krzysztof is a maintainer
>  - pintctrl dropped
>  - 4 space indent for example
>  - nfc node name
> v3
>  - remove whole pinctrl
> v4
>  - drop clock-frequency, which is inherited by i2c bus
> 
>  .../bindings/net/nfc/nxp,pn544.yaml           | 56 +++++++++++++++++++
>  .../devicetree/bindings/net/nfc/pn544.txt     | 33 -----------
>  2 files changed, 56 insertions(+), 33 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/nfc/nxp,pn544.yaml
>  delete mode 100644 Documentation/devicetree/bindings/net/nfc/pn544.txt
> 

Applied, thanks!
