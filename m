Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AFF6662EB7
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 19:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbjAISVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 13:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjAISVT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 13:21:19 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEE88AE45
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 10:19:57 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id co23so9111520wrb.4
        for <netdev@vger.kernel.org>; Mon, 09 Jan 2023 10:19:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oeo5OtVq8imDZHD82tnbeCo8M/ylS8y24Un+2HomtKs=;
        b=Sl7Cj1xuTp7WQTESfCdvuPCm6DywpiiwjCQZJYA+LwFzIGbpb333b9Um+7zU1k9ecT
         2dMrjoE1W70ruVRvUm2evh/DWnuNEhWjQtOLm0wGdm36umYS0BUprjkmc6i58Cm1Pn1N
         bx2AGC6wH1vxYUu0yIHy1SMsDXAJz4wDO1YOqN29gCQC0pNGH/DPPCMDUW3do2AhBCE0
         E7CiCp0Fb8sMmO8DjHaKDtxW7Y5XvBjt9fTMHVCCyeusiMLrl7/rvLR5tCh1Q357f0/2
         gtnnNYQQOFqli8o9Y2iO4yPBnNuFFHW1AgNneNezr7xhQNoEbJOH/J+WiN1gg8HgOoRx
         0oIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oeo5OtVq8imDZHD82tnbeCo8M/ylS8y24Un+2HomtKs=;
        b=m1lcpT4VHgwENCfpXmohlPTaWmJ33uc/QSi8y4dbFh0pPDw6c7EIKvnG56uWqPBczn
         h32pvX9zpbmYPd/YHDsYovdS7wexR/rziOmxMtjopKdbuER4VXJK+hN4KzE+yfE70EDd
         LYIi+a6W5+GNa6b8p/7ajOWVaJYcXtSJNBUNyTyKvxEgjbtgKtBgomm9Ui/TFDKnyEhO
         hrIsQYKdHAwEpAQjKBnM79QH/6cuJJcUSjJhGrqQhqzBnO6ErreDcWSQQHKvqr4LbaXz
         C+PPr3howZG8FpTmpDFiy26VD6L4fIthYu3RnTjqMjdNPEQVSA/n9H+AkUPVwxxd/wju
         QcfQ==
X-Gm-Message-State: AFqh2kqdqdBDR4ddfGnszvhvF+JuOVkMgZPB2n19Vl/ooTx2mWX0hByO
        ACAsli7QVVY0mp2yts2MvXLMNg==
X-Google-Smtp-Source: AMrXdXsHmRrRWiLJ0gOPMtFN8/kxB3iO5ZcLc0KpMt7uRGmwjxmNtC8/G2RPCwQiylGezoGMKXZXJQ==
X-Received: by 2002:a05:6000:382:b0:2b0:eee2:a43e with SMTP id u2-20020a056000038200b002b0eee2a43emr12090389wrf.38.1673288396176;
        Mon, 09 Jan 2023 10:19:56 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id y15-20020adffa4f000000b002bbec19c8acsm3862109wrr.64.2023.01.09.10.19.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Jan 2023 10:19:55 -0800 (PST)
Message-ID: <8b634315-ae4e-1710-bebd-17f30620e52b@linaro.org>
Date:   Mon, 9 Jan 2023 19:19:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 06/18] dt-bindings: interconnect: qcom: document the
 interconnects for sa8775p
Content-Language: en-US
To:     Bartosz Golaszewski <brgl@bgdev.pl>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Georgi Djakov <djakov@kernel.org>,
        Will Deacon <will@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <joro@8bytes.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Jassi Brar <jassisinghbrar@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Vinod Koul <vkoul@kernel.org>, Alex Elder <elder@kernel.org>
Cc:     linux-arm-msm@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux.dev, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20230109174511.1740856-1-brgl@bgdev.pl>
 <20230109174511.1740856-7-brgl@bgdev.pl>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20230109174511.1740856-7-brgl@bgdev.pl>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/01/2023 18:44, Bartosz Golaszewski wrote:
> From: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> 
> Add a set of new compatibles and DT include defines for the sa8775p
> platforms.
> 
> Signed-off-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
> ---
>  .../bindings/interconnect/qcom,rpmh.yaml      |  14 ++
>  .../dt-bindings/interconnect/qcom,sa8775p.h   | 231 ++++++++++++++++++
>  2 files changed, 245 insertions(+)
>  create mode 100644 include/dt-bindings/interconnect/qcom,sa8775p.h
> 
> diff --git a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> index a429a1ed1006..ad3e0c7e9430 100644
> --- a/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> +++ b/Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml
> @@ -27,6 +27,20 @@ properties:
>  
>    compatible:
>      enum:
> +      - qcom,sa8775p-aggre1-noc
> +      - qcom,sa8775p-aggre2-noc
> +      - qcom,sa8775p-clk-virt

Are you sure they come with IO address space? IOW, was the binding and
DTS tested against each other?

All recent bindings are split into their own file:

https://lore.kernel.org/all/20221223132040.80858-3-krzysztof.kozlowski@linaro.org/

https://lore.kernel.org/all/20221202232054.2666830-2-abel.vesa@linaro.org/


> +      - qcom,sa8775p-config-noc
> +      - qcom,sa8775p-dc-noc
> +      - qcom,sa8775p-gem-noc
> +      - qcom,sa8775p-gpdsp-anoc
> +      - qcom,sa8775p-lpass-ag-noc
> +      - qcom,sa8775p-mc-virt
> +      - qcom,sa8775p-mmss-noc
> +      - qcom,sa8775p-nspa-noc
> +      - qcom,sa8775p-nspb-noc
> +      - qcom,sa8775p-pcie-anoc
> +      - qcom,sa8775p-system-noc
>        - qcom,sc7180-aggre1-noc
>        - qcom,sc7180-aggre2-noc
>        - qcom,sc7180-camnoc-virt
> diff --git a/include/dt-bindings/interconnect/qcom,sa8775p.h b/include/dt-bindings/interconnect/qcom,sa8775p.h
> new file mode 100644
> index 000000000000..8d5968854187
> --- /dev/null
> +++ b/include/dt-bindings/interconnect/qcom,sa8775p.h

Filename matching family/compatible style, so just like sm8550.

> @@ -0,0 +1,231 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */

Dual license.

Best regards,
Krzysztof

