Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2637946DDC9
	for <lists+netdev@lfdr.de>; Wed,  8 Dec 2021 22:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237461AbhLHVsi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 16:48:38 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:46945 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231163AbhLHVsi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 16:48:38 -0500
Received: by mail-ot1-f48.google.com with SMTP id x3-20020a05683000c300b0057a5318c517so4112368oto.13;
        Wed, 08 Dec 2021 13:45:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5m11c41289x0vkukeKS3TNTyI6RlkS6yIBC6/es8kAk=;
        b=WEyfQzkfbRYBS0Obhpk9TR36ktmbEyBqy3cXD+FSmhUzttBAasr6b1+VPnuRX58vIQ
         M4aJK2ECnRpgJsI5Cv2C1OXsrNPkYdOsI3m7N71NfO6l7xND7/gxAJddCWZj5RQnKMb1
         elJtLWHQSrXkpLMuQSBkd6sUHyyTQDW8c5u+9uYENEaKzrWWVje++eWq/HkyreofQGFl
         h/1ce61whOaVNkcIIq2TYKorhtUaeZUnKKERgTuYvWzEu6x7mu5LLiWUCZ921L/TSjT2
         ZaS7EB8AjsgCZxaeNiDC/cuN6kq23BWAwzg242Qb1daxMMwiD8mdje1ZY22QtAY+X9Gd
         5agg==
X-Gm-Message-State: AOAM530IzRbBVPAP2/C5v3lAP2MKauTata5tJZ01YvVU4juk8D6c4eNq
        RZPaJaQJCrLmYtYKgAvQNg==
X-Google-Smtp-Source: ABdhPJw5+Fgpa7SZDW4uhEADbKGv33Jz8dZ83GdYBtcNHP5x7bR3xmK5mBtKxqd4151ONqJ01Tq+hQ==
X-Received: by 2002:a9d:6a4e:: with SMTP id h14mr1678218otn.134.1638999905430;
        Wed, 08 Dec 2021 13:45:05 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id o14sm667893ote.41.2021.12.08.13.45.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 13:45:05 -0800 (PST)
Received: (nullmailer pid 456334 invoked by uid 1000);
        Wed, 08 Dec 2021 21:45:04 -0000
Date:   Wed, 8 Dec 2021 15:45:04 -0600
From:   Rob Herring <robh@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 1/2] dt-bindings: net: Convert AMAC to YAML
Message-ID: <YbEnYNhbcW52720d@robh.at.kernel.org>
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
 <20211208202801.3706929-2-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211208202801.3706929-2-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 08 Dec 2021 12:28:00 -0800, Florian Fainelli wrote:
> Convert the Broadcom AMAC Device Tree binding to YAML to help with
> schema and dtbs checking.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> ---
>  .../devicetree/bindings/net/brcm,amac.txt     | 30 -------
>  .../devicetree/bindings/net/brcm,amac.yaml    | 88 +++++++++++++++++++
>  MAINTAINERS                                   |  2 +-
>  3 files changed, 89 insertions(+), 31 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,amac.txt
>  create mode 100644 Documentation/devicetree/bindings/net/brcm,amac.yaml
> 

Applied, thanks!
