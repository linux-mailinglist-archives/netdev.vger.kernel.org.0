Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8295141000C
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 21:50:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344904AbhIQTvv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 15:51:51 -0400
Received: from mail-oo1-f49.google.com ([209.85.161.49]:35532 "EHLO
        mail-oo1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242818AbhIQTu3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 15:50:29 -0400
Received: by mail-oo1-f49.google.com with SMTP id y3-20020a4ab403000000b00290e2a52c71so3573728oon.2;
        Fri, 17 Sep 2021 12:49:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=lIqQeQXnK4cjptHyGskWDQAslLOSJliGOSjwEw/Um2w=;
        b=Brr7/osIWtBSectNOwa3Tgwe2h5niCj8QpU/mMKAIaCfIUuIRohOLM0H7VflsZBnB2
         EBNFb0pr3sXGlrgALxWItEViWJk97ybVnD5Wr5Vnj2AxGrHGnwlt/jaE8wT4HFV+Ijxu
         ZhgnTeaVviK1fUZm1tJKJYcmKIIwhUZSkd3/uxbY5rtQyV0Vo8cyrJ6HS8FjI4tBUzSB
         whVhvrVMmhAJKr8usgu/103h3I6sC+B3rumGlIL1A1aXEXQJTwEfyX1DCJHBlr9HZQdo
         vxlWe+cteOQUF7XR7bAdGCgnmuHmah0k5rG6EAEWTK28ZQEsJWBrcNw+XhC/Mn0Mi3R5
         +krg==
X-Gm-Message-State: AOAM531ZvNkxdgXqrZNKl2fbzE98dox0qRaUxXl6/PgxNt6brBCrSlVY
        wG5VgtZ+adZAVkhP9EzOFA==
X-Google-Smtp-Source: ABdhPJxjY1Cr2X0gISlUEjpmrUwwPiPDDmYHTOQoeNCD+4D0iRzlv5pQ4zTOB4Md3k7uJKuLJjPi6Q==
X-Received: by 2002:a4a:dcd0:: with SMTP id h16mr10363770oou.44.1631908144964;
        Fri, 17 Sep 2021 12:49:04 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id z7sm1766832oti.65.2021.09.17.12.49.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Sep 2021 12:49:03 -0700 (PDT)
Received: (nullmailer pid 2025337 invoked by uid 1000);
        Fri, 17 Sep 2021 19:48:54 -0000
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        devel@driverdev.osuosl.org, devicetree@vger.kernel.org,
        =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-wireless@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20210917151401.2274772-3-Jerome.Pouiller@silabs.com>
References: <20210917151401.2274772-1-Jerome.Pouiller@silabs.com> <20210917151401.2274772-3-Jerome.Pouiller@silabs.com>
Subject: Re: [PATCH v6 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Fri, 17 Sep 2021 14:48:54 -0500
Message-Id: <1631908134.353915.2025336.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 17 Sep 2021 17:13:38 +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Prepare the inclusion of the wfx driver in the kernel.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 133 ++++++++++++++++++
>  1 file changed, 133 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:


doc reference errors (make refcheckdocs):
Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml: Documentation/devicetree/bindings/mmc/mmc-pwrseq-simple.txt

See https://patchwork.ozlabs.org/patch/1529457

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

