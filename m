Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED8B2F22BD
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 23:27:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390271AbhAKW0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 17:26:50 -0500
Received: from mail-ot1-f45.google.com ([209.85.210.45]:33425 "EHLO
        mail-ot1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389909AbhAKW0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 17:26:50 -0500
Received: by mail-ot1-f45.google.com with SMTP id b24so457511otj.0;
        Mon, 11 Jan 2021 14:26:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=JwN7V3dbH4OLsq431395GidD0QpUQFZHGYXmdb5Rf9k=;
        b=ui01wP7NrexBJy1jPHFXQw+lIUf7GUFD1YruN988IZGrMEdSA0iIt3z+adEANnKH7a
         wUHk/iuszgyJgbu2iYxga5UEr8aCu76KhPZe5wwHIyWIC1LZkyxI+lddtAcxnUAj8w6J
         cRPWDwU9K1775KKmZ26v4m0UyvYzo2zmoWAivKs2zej4MSwCUfenZtezBcncYEbOggCi
         s3YosG99HQYkdZbVvkCJEjkYjDl3Rvcn8MOSIx1hM6WuJ/jsw+yt/o61KRa9zhN3k9NX
         LHLPFekt1gjcZQJvAS1BejblPeJ5Y3bwsK4yibFtmA3vqqEY/8OiaPAq1H3mdI8Dpe2+
         TnYw==
X-Gm-Message-State: AOAM530UBGFB19CCVGRPROrKxLc7rjs55S7Qa1KBp9DXlzcZ4F3eCKUd
        4G7uXjweYoQSzOS44vOl8Q==
X-Google-Smtp-Source: ABdhPJwVoRrLT8QjezvnMiijQU5N/avlkOQoZaMcSwJF15NUAqxdSaEP/lhVB/2Cqp0+AuWKsvUjVA==
X-Received: by 2002:a05:6830:578:: with SMTP id f24mr837995otc.7.1610403969311;
        Mon, 11 Jan 2021 14:26:09 -0800 (PST)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id w9sm242492otq.44.2021.01.11.14.26.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jan 2021 14:26:08 -0800 (PST)
Received: (nullmailer pid 3169359 invoked by uid 1000);
        Mon, 11 Jan 2021 22:26:07 -0000
Date:   Mon, 11 Jan 2021 16:26:07 -0600
From:   Rob Herring <robh@kernel.org>
To:     John-Eric Kamps <johnny86@gmx.de>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Vasily Khoruzhick <anarsoul@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org,
        Alistair Francis <alistair@alistair23.me>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] dt-bindings: net: bluetooth: Add rtl8723ds-bluetooth
Message-ID: <20210111222607.GA3169309@robh.at.kernel.org>
References: <20210102213803.1097624-1-johnny86@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210102213803.1097624-1-johnny86@gmx.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 02 Jan 2021 22:38:03 +0100, John-Eric Kamps wrote:
> Add binding documentation for bluetooth part of RTL8723DS
> 
> Signed-off-by: John-Eric Kamps <johnny86@gmx.de>
> ---
>  Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
