Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C299048B8DC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 21:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244479AbiAKUtj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 15:49:39 -0500
Received: from mail-oi1-f176.google.com ([209.85.167.176]:37568 "EHLO
        mail-oi1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbiAKUtj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jan 2022 15:49:39 -0500
Received: by mail-oi1-f176.google.com with SMTP id i9so743787oih.4;
        Tue, 11 Jan 2022 12:49:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=U76C2a19MWE9uT4WLaPrUqwz6TsEjxbpHwmPW7gPznI=;
        b=8ARJ19Of6uW1ythyL8fs5FRJPT/y+IDICg9NmOy7lnBA76JoC5vcwqk9OPeEwDhh4q
         JyAC8KiAwpjmP/nNVV84Li+vK/08Hw7aWnLK2yuUFb77FSZnVBfY/6Ga5yHWyQm+atrT
         6A6HuStELx+JuEVDCmvm+kJ0/IjQd/PCH0YTYB0caQ5JKOy716ubcR8iSwVLgdx6KHTd
         MSBe0gXEsqvrpKo4uSDz9eIJBrR+Lrn7m62Gsi7llT23yluziOYfpLEI/i+RZsKdnzpU
         cFTwGBJEASs7q9tKi2n24P7cGr8/8Voj44kL4RhjJG9TXtxGsi12pRVBt5nVo3a8OsFo
         xhWw==
X-Gm-Message-State: AOAM532+ibBTibuz/eb248LycNpp0BfJn8i79lYaBIIsrjrtWDDnkmnD
        W2pHrp6MkDlGR0LqImiViuq4WgaxqQ==
X-Google-Smtp-Source: ABdhPJyphqSOHGSY9thM6FbjwFquqWnM/ksTcDqbx78SxrpLMWiSpEXzKtszrmyfWwxjdWJk7gcjFQ==
X-Received: by 2002:a05:6808:3b9:: with SMTP id n25mr3095147oie.100.1641934178423;
        Tue, 11 Jan 2022 12:49:38 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id g61sm2263305otg.43.2022.01.11.12.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 12:49:37 -0800 (PST)
Received: (nullmailer pid 3479811 invoked by uid 1000);
        Tue, 11 Jan 2022 20:49:36 -0000
From:   Rob Herring <robh@kernel.org>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        linux-wireless@vger.kernel.org,
        =?utf-8?b?SsOpcsO0bWUgUG91aWxsZXI=?= <jerome.pouiller@silabs.com>,
        Rob Herring <robh+dt@kernel.org>, linux-mmc@vger.kernel.org,
        devel@driverdev.osuosl.org
In-Reply-To: <20220111171424.862764-3-Jerome.Pouiller@silabs.com>
References: <20220111171424.862764-1-Jerome.Pouiller@silabs.com> <20220111171424.862764-3-Jerome.Pouiller@silabs.com>
Subject: Re: [PATCH v9 02/24] dt-bindings: introduce silabs,wfx.yaml
Date:   Tue, 11 Jan 2022 14:49:36 -0600
Message-Id: <1641934176.672363.3479810.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 11 Jan 2022 18:14:02 +0100, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> Prepare the inclusion of the wfx driver in the kernel.
> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  .../bindings/net/wireless/silabs,wfx.yaml     | 138 ++++++++++++++++++
>  1 file changed, 138 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.example.dt.yaml: wifi@0: compatible: 'anyOf' conditional failed, one must be fixed:
	['silabs,brd4001a', 'silabs,wf200'] is too long
	Additional items are not allowed ('silabs,wf200' was unexpected)
	'silabs,wf200' was expected
	'silabs,brd8022a' was expected
	'silabs,brd8023a' was expected
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.example.dt.yaml: wifi@1: compatible: 'anyOf' conditional failed, one must be fixed:
	['silabs,brd8022a', 'silabs,wf200'] is too long
	Additional items are not allowed ('silabs,wf200' was unexpected)
	'silabs,wf200' was expected
	'silabs,brd4001a' was expected
	'silabs,brd8023a' was expected
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/wireless/silabs,wfx.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1578580

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

