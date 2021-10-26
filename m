Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ADF4443B2BA
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 14:53:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhJZM4C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 08:56:02 -0400
Received: from mail-oi1-f178.google.com ([209.85.167.178]:35449 "EHLO
        mail-oi1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233805AbhJZMz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Oct 2021 08:55:59 -0400
Received: by mail-oi1-f178.google.com with SMTP id r6so20419687oiw.2;
        Tue, 26 Oct 2021 05:53:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=o0sKLuOigkZzRb9mIiQk8+FcI77ASATTLv5/Ga7FhFA=;
        b=LiN5b/hUlWdKTy22hfFNhcVPgP2d9oZTpnTBCB4F+ceWJ7c0gDrb88A18gFTBSItm+
         ciwbn06AoG+RBwZ0QvaH7xW+TvWFIZJQMhatFiXk6Oye8CM7d3bAzLoe41hR4vyfYq2U
         Q4ysH9xFsXdUZvVwM9ANoZYj0sNxG/BNciH8Na13e9xtiGUpTmv0HxCY9xH7HJk9r3h4
         4UkXOT7YcXDuzW1zLyT4G+aqmufgi5UFL3Kd8NZZpZ6d/u2++EN6rcs2Bh9aI7hRw9hC
         6ZUh5iPpekGPMqhCOYxs47WR6Q5nysQ8qzoe5x00qvRqlKXrcgwljnukCV0gT0ZNkM2O
         4Z/Q==
X-Gm-Message-State: AOAM533lbAtFgm9jDD7jbjpLAl/m87n4NQd3HTBAKzwYa2dydELKxDy/
        4PZLZ8yGLGe0q7vNnmHVag==
X-Google-Smtp-Source: ABdhPJwP8phGmuV03HOFOfdE+cAf7lJnT51ZIqVF78khc0VQIqXv3RKQK4+vTgDjB/WIq+QnAMnzvA==
X-Received: by 2002:a05:6808:144d:: with SMTP id x13mr17653853oiv.132.1635252815289;
        Tue, 26 Oct 2021 05:53:35 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id j6sm3760099oot.18.2021.10.26.05.53.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 05:53:34 -0700 (PDT)
Received: (nullmailer pid 2444200 invoked by uid 1000);
        Tue, 26 Oct 2021 12:53:33 -0000
Date:   Tue, 26 Oct 2021 07:53:33 -0500
From:   Rob Herring <robh@kernel.org>
To:     Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        linux-arm-msm@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v1 01/15] dt-bindings: add pwrseq device tree bindings
Message-ID: <YXf6TbV2IpPbB/0Y@robh.at.kernel.org>
References: <20211006035407.1147909-1-dmitry.baryshkov@linaro.org>
 <20211006035407.1147909-2-dmitry.baryshkov@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006035407.1147909-2-dmitry.baryshkov@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 06, 2021 at 06:53:53AM +0300, Dmitry Baryshkov wrote:
> Add device tree bindings for the new power sequencer subsystem.
> Consumers would reference pwrseq nodes using "foo-pwrseq" properties.
> Providers would use '#pwrseq-cells' property to declare the amount of
> cells in the pwrseq specifier.

Please use get_maintainers.pl.

This is not a pattern I want to encourage, so NAK on a common binding.

> 
> Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> ---
>  .../bindings/power/pwrseq/pwrseq.yaml         | 32 +++++++++++++++++++
>  1 file changed, 32 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml
> 
> diff --git a/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml b/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml
> new file mode 100644
> index 000000000000..4a8f6c0218bf
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/power/pwrseq/pwrseq.yaml
> @@ -0,0 +1,32 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/power/pwrseq/pwrseq.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Power Sequencer devices
> +
> +maintainers:
> +  - Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> +
> +properties:
> +  "#powerseq-cells":
> +    description:
> +      Number of cells in a pwrseq specifier.
> +
> +patternProperties:
> +  ".*-pwrseq$":
> +    description: Power sequencer supply phandle(s) for this node
> +
> +additionalProperties: true
> +
> +examples:
> +  - |
> +    qca_pwrseq: qca-pwrseq {
> +      #pwrseq-cells = <1>;
> +    };
> +
> +    bluetooth {
> +      bt-pwrseq = <&qca_pwrseq 1>;
> +    };
> +...
> -- 
> 2.33.0
> 
> 
