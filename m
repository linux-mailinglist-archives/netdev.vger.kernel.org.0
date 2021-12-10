Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B466C470263
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 15:04:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241978AbhLJOHE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 09:07:04 -0500
Received: from mail-oi1-f169.google.com ([209.85.167.169]:44748 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239304AbhLJOHD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 09:07:03 -0500
Received: by mail-oi1-f169.google.com with SMTP id be32so13296089oib.11;
        Fri, 10 Dec 2021 06:03:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject:date
         :message-id;
        bh=cmSW+URoSJmxzdlkdp7KmlXjXD8YhbaUa3uiUwCEFPQ=;
        b=0ht3f9gCPLh+hkhb1+M87KY2NzhAd9GnDHtOdf9Q0rCbWjuPYTnOa+aaCw8cMwwyp9
         XvYYqzK0LhRwPc9FpzgbOP4hWzMo23UyDRNEyquvYKFjIosAY1HwTObY4cN4K1Kthz+A
         RJs+wWnvM10GOyEIPh9mkR+G8TCqkvfkRRBlxDQ1l3BkuXw466+JXKf64pgZrvM2cjZa
         96G5cXcjp6ok7ZK3ZJcCzXggUywS8vzAxSKuyroKx+vOdzJEdtQmeUjE0q0g5OkjH5mT
         OcYg8J75f/yBjOhuOCLQXdfT18pXqiKgaIB3LVtvvqkcOEc3rlqYx4v4nxxp+9dNUq93
         801g==
X-Gm-Message-State: AOAM53092grA7BAkqAUPcfcmluWD3O0Jfc+I36bsWua+Ji0Q3KshzziJ
        BimbiuUERHuUWO/j5SUa+Uj55pZ6iA==
X-Google-Smtp-Source: ABdhPJwvuCzn8GNvs/o/qd74p21TOX8Jbd/TVv7jRdtB9heZ54fYoxEFk1kpIpUHBJdFORqkVelUSA==
X-Received: by 2002:aca:5983:: with SMTP id n125mr12248280oib.153.1639144987822;
        Fri, 10 Dec 2021 06:03:07 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id h3sm527714ooe.13.2021.12.10.06.03.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 06:03:06 -0800 (PST)
Received: (nullmailer pid 1252251 invoked by uid 1000);
        Fri, 10 Dec 2021 14:02:56 -0000
From:   Rob Herring <robh@kernel.org>
To:     JosephCHANG <josright123@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, joseph_chang@davicom.com.tw,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>
In-Reply-To: <20211210084021.13993-2-josright123@gmail.com>
References: <20211210084021.13993-1-josright123@gmail.com> <20211210084021.13993-2-josright123@gmail.com>
Subject: Re: [PATCH v3, 1/2] yaml: Add dm9051 SPI network yaml file
Date:   Fri, 10 Dec 2021 08:02:56 -0600
Message-Id: <1639144976.213447.1252247.nullmailer@robh.at.kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 16:40:20 +0800, JosephCHANG wrote:
> For support davicom dm9051 device tree configure
> 
> Signed-off-by: JosephCHANG <josright123@gmail.com>
> ---
>  .../bindings/net/davicom,dm9051.yaml          | 71 +++++++++++++++++++
>  1 file changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/davicom,dm9051.yaml
> 

My bot found errors running 'make DT_CHECKER_FLAGS=-m dt_binding_check'
on your patch (DT_CHECKER_FLAGS is new in v5.13):

yamllint warnings/errors:

dtschema/dtc warnings/errors:
/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/davicom,dm9051.example.dt.yaml: dm9051@0: $nodename:0: 'dm9051@0' does not match '^ethernet(@.*)?$'
	From schema: /builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/davicom,dm9051.yaml

doc reference errors (make refcheckdocs):

See https://patchwork.ozlabs.org/patch/1566354

This check can fail if there are any dependencies. The base for a patch
series is generally the most recent rc1.

If you already ran 'make dt_binding_check' and didn't see the above
error(s), then make sure 'yamllint' is installed and dt-schema is up to
date:

pip3 install dtschema --upgrade

Please check and re-submit.

