Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C326F43BBB6
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 22:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbhJZUlh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 16:41:37 -0400
Received: from mail-oi1-f175.google.com ([209.85.167.175]:43813 "EHLO
        mail-oi1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239231AbhJZUlb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 16:41:31 -0400
Received: by mail-oi1-f175.google.com with SMTP id o4so343631oia.10;
        Tue, 26 Oct 2021 13:39:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=nlTgUp5qItfNiEj5SUL7gvzHOZ7DO4OwjbwHdix/bLs=;
        b=in29vQQIFRR+BtESS8faUPzm05Wq10FvUDjhcAgSKczrVmFsN69Lizkjr8lsPsA+lm
         qFRiJrssAuQHCuD63b+0oFUxbwaDUMEa5V4a2UO8N+0ASZ0e0yD05yVVq6cK+dIlvnmH
         p5WwvwNXLCXwgSRGmF2JRmlYRMJM1ys2oRm2Et3xiQcNPYkzt/FpPPa/rS+1Kic3AC6h
         paRhKEitbGlkooDxZcdhGbBH0wgw3EKrHtQroc4aKzqlTiPUUO+9jx0GjUftQBSVz2Zv
         zSpaupkShlgHNhudlKe7z0w6VRqtYh3ePo2f6TWdrTP/cJpxesHnfF/U1DAbsCYXtpfX
         U+ag==
X-Gm-Message-State: AOAM530RxFkjKq8IU9mxyUy7ccXc8B4BbjBxr3jZzPeAHWb5rqxrTvUL
        b6EZNaGvUat2qq2db94nC8SriDEObQ==
X-Google-Smtp-Source: ABdhPJwulVD4Ce+LCyYWNUj7ujCjfERRm8f5MOIE9nIJV7cBxZ8EIdSw358FwPXw2GI2S2Jdn4rzJA==
X-Received: by 2002:a05:6808:8f6:: with SMTP id d22mr806869oic.88.1635280746721;
        Tue, 26 Oct 2021 13:39:06 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id d10sm4170935ooj.24.2021.10.26.13.39.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 13:39:06 -0700 (PDT)
Received: (nullmailer pid 3204673 invoked by uid 1000);
        Tue, 26 Oct 2021 20:39:05 -0000
Date:   Tue, 26 Oct 2021 15:39:05 -0500
From:   Rob Herring <robh@kernel.org>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Jacek Anaszewski <jacek.anaszewski@gmail.com>, pavel@ucw.cz,
        netdev@vger.kernel.org, linux-leds@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>, robh+dt@kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: leds: Deprecate `linux,default-trigger`
 property
Message-ID: <YXhnaUOrNm7jcp9l@robh.at.kernel.org>
References: <20211013204424.10961-1-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20211013204424.10961-1-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Oct 2021 22:44:22 +0200, Marek Behún wrote:
> This property is deprecated in favor of the `function` property.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  Documentation/devicetree/bindings/leds/common.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
