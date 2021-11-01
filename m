Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62325442046
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 19:49:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232147AbhKASvs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 14:51:48 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:42632 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232100AbhKASvk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 14:51:40 -0400
Received: by mail-ot1-f47.google.com with SMTP id v19-20020a9d69d3000000b00555a7318f31so14489637oto.9;
        Mon, 01 Nov 2021 11:49:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=H7wFgbeLMuUv4++Ly+4nu5qsuu1wVGNwUtHn/JRfj8Q=;
        b=kyEFBbOvjdfWCW+vwycyC3tv6vcGYTTriLxOQCeHImdWZ19ms/ou2IVg4YcsRU/vvU
         wBiyYfzXbuAu2y+RvcgTqBuRaTGpWzPvtAXxFvCCQ9ekmJ4KwjNHkOe4OXesLHV9AHa8
         KmX6Bd5Sr8OqlrZaWYKPNqAhBUq32QWMiFBIajWJ2WdIwnoccHLCNKpgpUiinwIFX6Up
         65aMXLtb7omaOSMEc1OOuuK8XmepIRNDG0vlmljxeTMdkKxHLNcFmZMqy0ihT6w0duVQ
         VXzvl7f/fx6CcLzpGDGO3N2WHMVQJ8/v1ZXOoghB+h5bqeG6ErznWx4P84GV1bz65+1H
         PFeA==
X-Gm-Message-State: AOAM5331ZGJIRwhonzicrcKH2kLq81c/FGi4bNcOfKDeSbINJISN5NTL
        IgvmQY1jHp5idjJGlyhKgRXTp/O5tA==
X-Google-Smtp-Source: ABdhPJwOH3OGownRZ9Fvz+SijRxwkSjoLikgygUWYcUfS9iA8bYqhjT3m323jyxbtuICTpdVNFhn6g==
X-Received: by 2002:a05:6830:3498:: with SMTP id c24mr7839863otu.263.1635792542039;
        Mon, 01 Nov 2021 11:49:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id e20sm1751291oow.5.2021.11.01.11.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 11:49:01 -0700 (PDT)
Received: (nullmailer pid 813055 invoked by uid 1000);
        Mon, 01 Nov 2021 18:49:00 -0000
Date:   Mon, 1 Nov 2021 13:49:00 -0500
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alex Elder <elder@kernel.org>, linux-arm-msm@vger.kernel.org,
        ~okias/devicetree@lists.sr.ht, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] dt-bindings: net: qcom,ipa: IPA does support up to
 two iommus
Message-ID: <YYA2nEd6jkSwx8QW@robh.at.kernel.org>
References: <20211026163240.131052-1-david@ixit.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211026163240.131052-1-david@ixit.cz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 18:32:40 +0200, David Heidelberg wrote:
> Fix warnings as:
> arch/arm/boot/dts/qcom-sdx55-mtp.dt.yaml: ipa@1e40000: iommus: [[21, 1504, 0], [21, 1506, 0]] is too long
> 	From schema: Documentation/devicetree/bindings/net/qcom,ipa.yaml
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Applied, thanks!
