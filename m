Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0858148B487
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 18:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344873AbiAKRvQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 12:51:16 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:35810 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344709AbiAKRvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 12:51:12 -0500
Received: by mail-oi1-f179.google.com with SMTP id s127so133938oig.2;
        Tue, 11 Jan 2022 09:51:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YLwMXDjgYaMucaEpjbLaU3ZVYir+jitVxo6AlZa92zw=;
        b=mQby70h4xXugbBM63Xx3AuWGQythp0LcIYf20A1cP+ALmEHJ6N1lqp7kyCKEqoXyxl
         u/qk25t1ejerQiA5q4Nfn2uWX5XU0gIdTbuOv/1kkB299HXKtsILkAN6LeIzo26ynpdT
         O5/SEHI/g72jxTp02UAviaLh5yJzcLAjTJuRxhBsYd2gqJq0LI63C8Xr6HGWhZMupuDZ
         doa2XgEWhzqU80kwUsrI1veA2Q8cDMS4QH39zqGfNVWHeA2sx0SQsQnMc69wO/Uxb2Ir
         ml4/WSWJfst4+e6nPrOew/D8EafaphCLeFmBtJadnReWaWieKYEIuqL3Bt0rrN+URWev
         3Y7g==
X-Gm-Message-State: AOAM530jY3xQD7A1D7zoyx1LVLOjJ+S4xRsl4Cl6KkNgVuLxaLfpQxvb
        cDPrWajiAYXb3F8PgvV8Jg==
X-Google-Smtp-Source: ABdhPJxtF9KFP4FdzDu3hfRlArCaOryvwCUmwNwEqeKeTgBZ1PTN6Bp3xjoZeXc8CLs9kJ5aw29K9Q==
X-Received: by 2002:a05:6808:138e:: with SMTP id c14mr2703861oiw.55.1641923471316;
        Tue, 11 Jan 2022 09:51:11 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id l1sm2141051oti.51.2022.01.11.09.51.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 09:51:10 -0800 (PST)
Received: (nullmailer pid 3227865 invoked by uid 1000);
        Tue, 11 Jan 2022 17:51:09 -0000
Date:   Tue, 11 Jan 2022 11:51:09 -0600
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        Dan Murphy <dmurphy@ti.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: ti,dp83869: Drop value on boolean
 'ti,max-output-impedance'
Message-ID: <Yd3DjWmrHV71+1Ac@robh.at.kernel.org>
References: <20220107030513.2385482-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220107030513.2385482-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 06 Jan 2022 21:05:13 -0600, Rob Herring wrote:
> DT booleans don't have a value and 'ti,max-output-impedance' is defined and
> used as a boolean. So drop the bogus value in the example.
> 
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/ti,dp83869.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
