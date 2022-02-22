Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA53D4BEF98
	for <lists+netdev@lfdr.de>; Tue, 22 Feb 2022 03:43:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232476AbiBVCfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 21:35:46 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232402AbiBVCfp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 21:35:45 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEDD25C68
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:35:20 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id v12so30219590wrv.2
        for <netdev@vger.kernel.org>; Mon, 21 Feb 2022 18:35:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nexus-software-ie.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=jLeoDKxdwnU86FqAyKHrzlc3sYaNoShMt5vzZKAqVnU=;
        b=YLYiw/GJe6N2PwGUCG5AVaFqz/ELegzIJUEUHlJr3uAzC8od+yTj7yGPzcrIQJDGJd
         I7Hob4DgGeEtOnS3pV24BNxM3G6/WZyAz36pT/pHN9Zu9lKV6BfNWsYoVqwSUJqaXdwe
         EdNnSkIOyImu6vV2vX63yHIHVnJsHDo6JEGOBlpNZQ79wUTVLhIWjMEFYNpr6NJ44DDz
         ratEQVeLRNOGM2teCl7mNMcnlU7eoKKXiJdaWXAJK33kUyrMtwJe7jd/mUii9wddHRP4
         JO8PDnGiRAKWp1uVA4AVBOEczAnyyycpobn6n3wMzZkJnl4t6fAVnL2y7+IP79FDbnYq
         CdZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=jLeoDKxdwnU86FqAyKHrzlc3sYaNoShMt5vzZKAqVnU=;
        b=79//Eatd3mCM0MitMq4OXMny+t/kfH/+XiSZ9z/DhztEJmpnIrTap6b+UajjwJ9HYL
         jFj3J2ONv2vAeERT29GymZar17d9Wg49rmIevxzCr+9tpzNbcFhvDjKYXjAH57LaCFXh
         NI5k9zLq11YalGGk3sphauSiaI1jKwjnc+VUP6ozsxKcDbx90A8lb8UYOvtSYD9MeXat
         ApQK5OI405gf5b6RCwNjonLGUvOzxBFCsZ6e4bLN6UZ7npJNg7YwpDqZpmpYbBrKeIgP
         0obV01yyVIMWMKS1abdF73yA1di5BSGC7hZ9hYICglGIsuLbrTUtvkC9jllFeH+uvUZI
         LXbg==
X-Gm-Message-State: AOAM531fWRTnu4SBCGzp2AAqXKJZeIZ4QsxYu73GE2UG5ud6nx7yfOUw
        21RPPEihjHIPpijq4xum2eU1yQ==
X-Google-Smtp-Source: ABdhPJyqPDo3XoKbcjFWaHKc7Ti9M7c8DZWsA64OC+IgfP2GHabcBt4NAf5oMtyKGX7PCu86dAseZw==
X-Received: by 2002:a5d:58d9:0:b0:1e5:6b50:24f3 with SMTP id o25-20020a5d58d9000000b001e56b5024f3mr17640844wrf.622.1645497319497;
        Mon, 21 Feb 2022 18:35:19 -0800 (PST)
Received: from [192.168.0.162] (188-141-3-169.dynamic.upc.ie. [188.141.3.169])
        by smtp.gmail.com with ESMTPSA id c6sm978114wmb.25.2022.02.21.18.35.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Feb 2022 18:35:18 -0800 (PST)
Message-ID: <f6d6c7d7-0dc2-fd80-9d6a-ada080eaa15a@nexus-software.ie>
Date:   Tue, 22 Feb 2022 02:35:17 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 2/2] arm64: dts: qcom: ipq6018: Add mdio bus description
Content-Language: en-US
To:     Baruch Siach <baruch@tkos.co.il>, Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Robert Marko <robert.marko@sartura.hr>
Cc:     Baruch Siach <baruch.siach@siklu.com>,
        Bryan O'Donoghue <bryan.odonoghue@linaro.org>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
References: <a4b1ad7b15c13f368b637efdb903da143b830a88.1645454002.git.baruch@tkos.co.il>
 <5e7e06e0cb189bab4586646470894bbda572785d.1645454002.git.baruch@tkos.co.il>
From:   Bryan O'Donoghue <pure.logic@nexus-software.ie>
In-Reply-To: <5e7e06e0cb189bab4586646470894bbda572785d.1645454002.git.baruch@tkos.co.il>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21/02/2022 14:33, Baruch Siach wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> The IPQ60xx has the same MDIO bug block as IPQ4019. Add IO range and
> clock resources description.
> 
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> ---
>   arch/arm64/boot/dts/qcom/ipq6018.dtsi | 10 ++++++++++
>   1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/boot/dts/qcom/ipq6018.dtsi b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> index 5eb7dc9cc231..093011d18ca6 100644
> --- a/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> +++ b/arch/arm64/boot/dts/qcom/ipq6018.dtsi
> @@ -635,6 +635,16 @@ qrtr_requests {
>   			};
>   		};
>   
> +		mdio: mdio@90000 {
> +			#address-cells = <1>;
> +			#size-cells = <0>;
> +			compatible = "qcom,ipq6018-mdio", "qcom,ipq4019-mdio";
> +			reg = <0x0 0x90000 0x0 0x64>;
> +			clocks = <&gcc GCC_MDIO_AHB_CLK>;
> +			clock-names = "gcc_mdio_ahb_clk";
> +			status = "disabled";
> +		};
> +
>   		qusb_phy_1: qusb@59000 {
>   			compatible = "qcom,ipq6018-qusb2-phy";
>   			reg = <0x0 0x059000 0x0 0x180>;

LGTM
Reviewd-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
