Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 129FB4ACA01
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 21:05:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237656AbiBGUEA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 15:04:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240744AbiBGUCm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 15:02:42 -0500
Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F1FEC0401E4;
        Mon,  7 Feb 2022 12:02:42 -0800 (PST)
Received: by mail-oi1-f178.google.com with SMTP id 4so18197313oil.11;
        Mon, 07 Feb 2022 12:02:42 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6g2OywXkOltjhYgyUuhblAaYEZhORD0IBmHExC6IZOs=;
        b=8GZmvyd4+WnAtVksthAWHKaWqN+ohqIKjok+KtJyEtn2i1/nEfXTlZVcDKXn4vjmit
         uNIHQyptzganRxEOe6UPJNp9ywOW5zF3XVOviEcxkKQv8vsjjs/tvfgxDK92LX3FNZf/
         KDRB0Ut1fYp5df3nANqoekt2rP2XfDGP1AxbQpHXV/epWuz7zUD5Vh6hLnyLx1F6WoXW
         Fv+FaND7BXDXS3BbZQFHrz2Pf/iOjL4wvevc9U+Y+6/0ogmRTEn1E0GA1UQxBr+GkWoQ
         2M/IrbhmxEbmigZtjHTl/P9dYbcx4wWLIx7cqFunWdvuFNMQKWAfVvLDdbJpwbu7ZKQO
         XOGg==
X-Gm-Message-State: AOAM5333gk9AoVz+nqRXOM2tWUVqOUQPFxm3RE4y8yJcoRhjYa/XSF9K
        ArqJYFFqjRz+NJmvQq+UjA==
X-Google-Smtp-Source: ABdhPJzVUwKaH5QFeSKDvtCdhijO7ETNidfSfdE/o+oI1Qzq0pKtVhp85ohVxa3yV67/gpxYzgt9Cw==
X-Received: by 2002:a05:6808:158f:: with SMTP id t15mr253058oiw.245.1644264161609;
        Mon, 07 Feb 2022 12:02:41 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e192sm4470969oob.11.2022.02.07.12.02.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 12:02:40 -0800 (PST)
Received: (nullmailer pid 812724 invoked by uid 1000);
        Mon, 07 Feb 2022 20:02:39 -0000
Date:   Mon, 7 Feb 2022 14:02:39 -0600
From:   Rob Herring <robh@kernel.org>
To:     Joseph CHAMG <josright123@gmail.com>
Cc:     netdev@vger.kernel.org, andy.shevchenko@gmail.com,
        "David S . Miller" <davem@davemloft.net>, andrew@lunn.ch,
        Rob Herring <robh+dt@kernel.org>, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>, leon@kernel.org,
        devicetree@vger.kernel.org, joseph_chang@davicom.com.tw
Subject: Re: [PATCH v18, 1/2] dt-bindings: net: Add Davicom dm9051 SPI
 ethernet controller
Message-ID: <YgF633cnBDfss7L4@robh.at.kernel.org>
References: <20220207090906.11156-1-josright123@gmail.com>
 <20220207090906.11156-2-josright123@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220207090906.11156-2-josright123@gmail.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 07 Feb 2022 17:09:05 +0800, Joseph CHAMG wrote:
> This is a new yaml base data file for configure davicom dm9051 with
> device tree
> 
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Joseph CHAMG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 62 +++++++++++++++++++
>  1 file changed, 62 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>
