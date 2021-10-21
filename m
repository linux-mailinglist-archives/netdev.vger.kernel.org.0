Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0744362F0
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 15:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhJUNc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 09:32:28 -0400
Received: from mail-oi1-f182.google.com ([209.85.167.182]:40694 "EHLO
        mail-oi1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230072AbhJUNcX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 09:32:23 -0400
Received: by mail-oi1-f182.google.com with SMTP id n63so852673oif.7;
        Thu, 21 Oct 2021 06:30:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=V5N+7zO5qSAX0L4/A84OsXTp0ekly+BVlSHh5ax6RkA=;
        b=kpaPyr29eBdZo09OjqgpqJd6tfqpGAT4xfbRltAhVb4Sxku1vy/4FC4nTqUZVBEf5E
         mQThlWtywXlJtWpmEV8beKUbjqJd6aRa0arQO+vhFr/+k5hP1asNm54Ovf/aaYlePmAE
         oohS2+qBzLOogL9ZvZ0HvBkydPOGMuNPiHapU2+akoPvRkEbqhbZjGUij1UlbqMiuxCL
         oxr9JcS7ytxm04/ZrXtGwmsoIjQRUFk/WvwgP8HbUnnaBbzHCLoNasLrAJUpa54HnrDZ
         nsZ/b2Uaxub2t5KD92xOehhBCuN2OD7d3u7jJmTIoQZzghePg5i1fzW5BX/JyTSWyQuf
         eUTw==
X-Gm-Message-State: AOAM530ieOPCjRiqEt230ZvU4gN3Y4+QLy7C3VEwMGXzP/duXOQPhI0D
        XmBM+vCNKANIn3VseujvVQ==
X-Google-Smtp-Source: ABdhPJxbuh6jA4gLSE0j+Dt9lkKZIvpY3rCZOZ3TrDSn8R8XfMbnISH64PC+pQyPK0CUUwig7P7CFg==
X-Received: by 2002:a05:6808:13d2:: with SMTP id d18mr4837768oiw.73.1634823006689;
        Thu, 21 Oct 2021 06:30:06 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id x8sm1033148ota.75.2021.10.21.06.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Oct 2021 06:30:06 -0700 (PDT)
Received: (nullmailer pid 353164 invoked by uid 1000);
        Thu, 21 Oct 2021 13:30:05 -0000
From:   Rob Herring <robh@kernel.org>
To:     David Heidelberg <david@ixit.cz>
Cc:     Andy Gross <agross@kernel.org>, Rob Herring <robh+dt@kernel.org>,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        ~okias/devicetree@lists.sr.ht, linux-arm-msm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alex Elder <elder@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org
In-Reply-To: <20211020225435.274628-2-david@ixit.cz>
References: <20211020225435.274628-1-david@ixit.cz> <20211020225435.274628-2-david@ixit.cz>
Subject: Re: [PATCH 2/2] dt-bindings: net: qcom,ipa: IPA does support up to two iommus
Date:   Thu, 21 Oct 2021 08:30:05 -0500
Message-Id: <1634823005.083640.353162.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Oct 2021 00:54:35 +0200, David Heidelberg wrote:
> Fix warnings as:
> arch/arm/boot/dts/qcom-sdx55-mtp.dt.yaml: ipa@1e40000: iommus: [[21, 1504, 0], [21, 1506, 0]] is too long
> 	From schema: Documentation/devicetree/bindings/net/qcom,ipa.yaml
> 
> Signed-off-by: David Heidelberg <david@ixit.cz>
> ---
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipa.example.dt.yaml: ipa@1e40000: iommus: [[4294967295, 1824, 3]] is too short
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/qcom,ipa.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1544063

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

