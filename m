Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A09FC475C38
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 16:51:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242892AbhLOPvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 10:51:18 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:42962 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239535AbhLOPvS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 10:51:18 -0500
Received: by mail-ot1-f48.google.com with SMTP id 47-20020a9d0332000000b005798ac20d72so25396273otv.9;
        Wed, 15 Dec 2021 07:51:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=pdK0gyQoqEsphmqeufkGK5o7YXz8EBDgW679ZIC6HGU=;
        b=aT/Y5JXCjv1/4xqmfbIbX0gCVSKjPs20OGxZd/UCdu2g/v2/WBTpGue8rz+WqAC3/6
         vLI9mcxpu5nvjsrVpNknSlWVQficvTWJWA/rVjJYW0I9hwa/mXG1l8TjAS4nbdtngqY4
         X37hwSv7Rcx/nCFy/+z5neBNSXIDx+qD9qJJEaAxIRlm26b2Jou733C275hZprIkvQqS
         Vc5zcsJBI9IwgBfNaX+hWsAtNAKonwT3sbo2Tdl3MTyl5sPhI2dNQC0P2VPDPcRTmuq2
         qbIEzOYe3myR1jXd4vrC7KHKq45FqHCcwgL4WxWzQd5NXxCmav3LQzeKsmpdmdQW6V1m
         YrTg==
X-Gm-Message-State: AOAM532cLCSuwQtCBnGlPnqBlInDAib9X0Q6kg/prlI00RIlPFYlITWG
        CTIygEb0998uzSLOwTX3BPcYteTkYg==
X-Google-Smtp-Source: ABdhPJyoys+jy/xYPVQSh/DOieI2fwabC8h5KCqbKub5pe//PrJNbrqllAY2V/m6aUD9m7ivkHCvFw==
X-Received: by 2002:a05:6830:410a:: with SMTP id w10mr9149630ott.55.1639583477695;
        Wed, 15 Dec 2021 07:51:17 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x16sm498449ott.8.2021.12.15.07.51.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 07:51:17 -0800 (PST)
Received: (nullmailer pid 1378398 invoked by uid 1000);
        Wed, 15 Dec 2021 15:51:16 -0000
Date:   Wed, 15 Dec 2021 09:51:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     joseph_chang@davicom.com.tw, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v5, 1/2] yaml: Add dm9051 SPI network yaml file
Message-ID: <YboO9DVkX3wMb9Z2@robh.at.kernel.org>
References: <20211215073507.16776-1-josright123@gmail.com>
 <20211215073507.16776-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211215073507.16776-2-josright123@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 15 Dec 2021 15:35:06 +0800, JosephCHANG wrote:
> This is a new yaml base data file for configure davicom dm9051 with
> device tree
> 
> Signed-off-by: JosephCHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 


Please add Acked-by/Reviewed-by tags when posting new versions. However,
there's no need to repost patches *only* to add the tags. The upstream
maintainer will do that for acks received on the version they apply.

If a tag was not added on purpose, please state why and what changed.

