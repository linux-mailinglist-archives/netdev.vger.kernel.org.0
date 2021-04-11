Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9700035B251
	for <lists+netdev@lfdr.de>; Sun, 11 Apr 2021 09:58:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbhDKH6U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Apr 2021 03:58:20 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:30517 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230103AbhDKH6S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Apr 2021 03:58:18 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1618127881; h=Content-Type: MIME-Version: Message-ID:
 In-Reply-To: Date: References: Subject: Cc: To: From: Sender;
 bh=FO7OT8tHpj9776EAErHbdSOjVc4fZtr9in7MuapDRcc=; b=RS1OXBBixhuQ8p6yhwBEetgNealqHgDBjghgxRsf8UygoKe8ECRgJO4lKyR9xQwMZAxTyoki
 TgG4LAgSDc4YN+VDZWYvbfnA+qRkkT832hHopeTl75vq8Y3Yq/PWjS3WvNKX5Ureb01KKp29
 DJ7JRxJRoB77zGaCp3YiBdrvUCg=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-west-2.postgun.com with SMTP id
 6072ac092cc44d3aea6856a3 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 11 Apr 2021 07:58:01
 GMT
Sender: kvalo=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 05771C43465; Sun, 11 Apr 2021 07:58:00 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,SPF_FAIL,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99A0FC433CA;
        Sun, 11 Apr 2021 07:57:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99A0FC433CA
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: aws-us-west-2-caf-mail-1.web.codeaurora.org; spf=fail smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Shawn Guo <shawn.guo@linaro.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <rafal@milecki.pl>,
        Arend van Spriel <aspriel@gmail.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Chi-hsien Lin <chi-hsien.lin@infineon.com>,
        Wright Feng <wright.feng@infineon.com>,
        Chung-hsien Hsu <chung-hsien.hsu@infineon.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com
Subject: Re: [PATCH 1/2] dt-binding: bcm43xx-fmac: add optional brcm,ccode-map
References: <20210408113022.18180-1-shawn.guo@linaro.org>
        <20210408113022.18180-2-shawn.guo@linaro.org>
Date:   Sun, 11 Apr 2021 10:57:54 +0300
In-Reply-To: <20210408113022.18180-2-shawn.guo@linaro.org> (Shawn Guo's
        message of "Thu, 8 Apr 2021 19:30:21 +0800")
Message-ID: <87k0p9mewt.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Shawn Guo <shawn.guo@linaro.org> writes:

> Add optional brcm,ccode-map property to support translation from ISO3166
> country code to brcmfmac firmware country code and revision.
>
> Signed-off-by: Shawn Guo <shawn.guo@linaro.org>
> ---
>  .../devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt | 7 +++++++
>  1 file changed, 7 insertions(+)
>
> diff --git a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> index cffb2d6876e3..a65ac4384c04 100644
> --- a/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> +++ b/Documentation/devicetree/bindings/net/wireless/brcm,bcm43xx-fmac.txt
> @@ -15,6 +15,12 @@ Optional properties:
>  	When not specified the device will use in-band SDIO interrupts.
>   - interrupt-names : name of the out-of-band interrupt, which must be set
>  	to "host-wake".
> + - brcm,ccode-map : multiple strings for translating ISO3166 country code to
> +	brcmfmac firmware country code and revision.  Each string must be in
> +	format "AA-BB-num" where:
> +	  AA is the ISO3166 country code which must be 2 characters.
> +	  BB is the firmware country code which must be 2 characters.
> +	  num is the revision number which must fit into signed integer.
>  
>  Example:
>  
> @@ -34,5 +40,6 @@ mmc3: mmc@1c12000 {
>  		interrupt-parent = <&pio>;
>  		interrupts = <10 8>; /* PH10 / EINT10 */
>  		interrupt-names = "host-wake";
> +		brcm,ccode-map = "JP-JP-78", "US-Q2-86";

The commit log does not answer "Why?". Why this needs to be in device
tree and, for example, not hard coded in the driver?

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
