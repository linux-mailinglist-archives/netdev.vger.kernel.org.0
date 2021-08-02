Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7393DD037
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 08:02:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232108AbhHBGCc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 02:02:32 -0400
Received: from m43-7.mailgun.net ([69.72.43.7]:48627 "EHLO m43-7.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231148AbhHBGCb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 02:02:31 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627884142; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=TplfSCiO7WT9WfVPNqlfuo72B0soKCJJ7QbqqJVg9i4=;
 b=Kgzom8aaZ+Lyi+Sqpqpm8b1YaCxJeYAR5FDcJhOy68Z1Ro/VZE9p9+RhxpDXqkQljE6kbSI4
 ZJ9ocYGiw3Et30qltqbMGjL6N5pc2SLJI+1G553sPA9K5i+Qm0vYpB8LHS5mCgP1Z0QuVvPt
 An6zSHRwDWefYq76GsKh4uvIt4E=
X-Mailgun-Sending-Ip: 69.72.43.7
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-east-1.postgun.com with SMTP id
 61078a64290ea35ee6cc1276 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Aug 2021 06:02:12
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8364BC4360C; Mon,  2 Aug 2021 06:02:11 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00
        autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id E2580C433D3;
        Mon,  2 Aug 2021 06:02:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 02 Aug 2021 14:02:10 +0800
From:   luoj@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, davem@davemloft.net, kuba@kernel.org,
        p.zabel@pengutronix.de, agross@kernel.org,
        bjorn.andersson@linaro.org, robh+dt@kernel.org,
        robert.marko@sartura.hr, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH 3/3] dt-bindings: net: rename Qualcomm IPQ MDIO bindings
In-Reply-To: <YQKqhoJ4iPOTiGHZ@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-3-luoj@codeaurora.org> <YQKqhoJ4iPOTiGHZ@lunn.ch>
Message-ID: <29253aa91875a05ab086c229da50dfb6@codeaurora.org>
X-Sender: luoj@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-29 21:17, Andrew Lunn wrote:
>> @@ -23,7 +25,29 @@ properties:
>>      const: 0
>> 
>>    reg:
>> -    maxItems: 1
>> +    maxItems: 2
>> +
>> +  clocks:
>> +    items:
>> +      - description: MDIO clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: gcc_mdio_ahb_clk
>> +
>> +  resets:
>> +    items:
>> +      - description: MDIO reset & GEPHY hardware reset
>> +
>> +  reset-names:
>> +    items:
>> +      - const: gephy_mdc_rst
>> +
>> +  phy-reset-gpios:
>> +    maxItems: 3
>> +    description:
>> +      The phandle and specifier for the GPIO that controls the RESET
>> +      lines of PHY devices on that MDIO bus.
> 
> This is clearly not a rename. It is great you are adding missing
> properties, but please do it as a separate patch.
> 
> 	    Andrew

> Hi Andrew, thanks for the comments, will separate it out in the next 
> patch set.
