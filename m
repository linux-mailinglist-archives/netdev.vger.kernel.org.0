Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 281503DD02D
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 07:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhHBF5E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 01:57:04 -0400
Received: from so254-9.mailgun.net ([198.61.254.9]:13619 "EHLO
        so254-9.mailgun.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhHBF5D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Aug 2021 01:57:03 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1627883814; h=Message-ID: References: In-Reply-To: Subject:
 To: From: Date: Content-Transfer-Encoding: Content-Type: MIME-Version:
 Sender; bh=mHK5Rlos+NApTL5SucpSA2y+gG/KQyAJIDcqK/1IyRY=; b=X5Z+5ObyOErohjClwrHufmETHOIbiCdYzUD8hVDGQcVORZAXu1XrlVeM8mEFcWdV5ppW/1oB
 A0uugBzBz7MiWt0f4bVSS3CFbjYYzYQhodt3SD3X2bMEp8fJVxs4atPvpn5a2lPLfFwyhnbp
 uQzTZSuEMDv71hNM+uzfWhcAFYI=
X-Mailgun-Sending-Ip: 198.61.254.9
X-Mailgun-Sid: WyJiZjI2MiIsICJuZXRkZXZAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n06.prod.us-west-2.postgun.com with SMTP id
 6107891ae81205dd0a66e98f (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 02 Aug 2021 05:56:42
 GMT
Sender: luoj=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 4C55EC433D3; Mon,  2 Aug 2021 05:56:42 +0000 (UTC)
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        aws-us-west-2-caf-mail-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: luoj)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 8056DC433F1;
        Mon,  2 Aug 2021 05:56:40 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 02 Aug 2021 13:56:40 +0800
From:   luoj@codeaurora.org
To:     undisclosed-recipients:;
Subject: Re: [PATCH 2/3] net: mdio-ipq4019: rename mdio_ipq4019 to mdio_ipq
In-Reply-To: <YQKp9gsnjBNmXYIc@lunn.ch>
References: <20210729125358.5227-1-luoj@codeaurora.org>
 <20210729125358.5227-2-luoj@codeaurora.org> <YQKp9gsnjBNmXYIc@lunn.ch>
Message-ID: <7931e7a44e9af6be9b145b264b1596cf@codeaurora.org>
X-Sender: luoj@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-07-29 21:15, Andrew Lunn wrote:
> On Thu, Jul 29, 2021 at 08:53:57PM +0800, Luo Jie wrote:
>> mdio_ipq driver supports more SOCs such as ipq40xx, ipq807x,
>> ipq60xx and ipq50xx.
>> 
>> Signed-off-by: Luo Jie <luoj@codeaurora.org>
>> ---
>>  drivers/net/mdio/Kconfig                      |  6 +-
>>  drivers/net/mdio/Makefile                     |  2 +-
>>  .../net/mdio/{mdio-ipq4019.c => mdio-ipq.c}   | 66 
>> +++++++++----------
>>  3 files changed, 37 insertions(+), 37 deletions(-)
>>  rename drivers/net/mdio/{mdio-ipq4019.c => mdio-ipq.c} (81%)
> 
> Hi Luo
> 
> We don't rename files unless there is a very good reason. It makes
> back porting of fixes harder in stable. There are plenty of examples
> of files with device specific names, but supporting a broad range of
> devices. Take for example lm75, at24.
> 
> Hi Andrew
> Thanks for the comments, will update the patch set to keep the name 
> unchanged.
> 
>> -config MDIO_IPQ4019
>> -	tristate "Qualcomm IPQ4019 MDIO interface support"
>> +config MDIO_IPQ
>> +	tristate "Qualcomm IPQ MDIO interface support"
>>  	depends on HAS_IOMEM && OF_MDIO
>>  	depends on GPIOLIB && COMMON_CLK && RESET_CONTROLLER
>>  	help
>>  	  This driver supports the MDIO interface found in Qualcomm
>> -	  IPQ40xx series Soc-s.
>> +	  IPQ40xx, IPQ60XX, IPQ807X and IPQ50XX series Soc-s.
> 
> Please leave the MDIO_IPQ4019 unchanged, so we don't break backwards
> compatibility, but the changes to the text are O.K.
> 
> will correct it in the next patch set.
> 
>> @@ -31,38 +31,38 @@
>>  /* 0 = Clause 22, 1 = Clause 45 */
>>  #define MDIO_MODE_C45				BIT(8)
>> 
>> -#define IPQ4019_MDIO_TIMEOUT	10000
>> -#define IPQ4019_MDIO_SLEEP		10
>> +#define IPQ_MDIO_TIMEOUT	10000
>> +#define IPQ_MDIO_SLEEP		10
> 
> This sort of mass rename will also make back porting fixes
> harder. Please don't do it.
> 
> will keep it unchanged in the next patch set.
> 
>> -static const struct of_device_id ipq4019_mdio_dt_ids[] = {
>> +static const struct of_device_id ipq_mdio_dt_ids[] = {
>>  	{ .compatible = "qcom,ipq4019-mdio" },
>> +	{ .compatible = "qcom,ipq-mdio" },
>>  	{ }
>>  };
> 
> Such a generic name is not a good idea. It appears this driver is not
> compatible with the IPQ8064? It is O.K. to add more specific
> compatibles. So you could add
> 
> qcom,ipq40xx, qcom,ipq60xx, qcom,ipq807x and qcom,ipq50xx.
> 
> But really, there is no need. Take for example snps,dwmac-mdio, which
> is used in all sorts of devices.
> 
>    Andrew

> Hi Andrew, yes, this driver is not compatible with IPQ8064, but it is 
> compatible with
> the new chipset such as ipq807x, ipq60xx and ipq50xx, will take your 
> suggestion in
> the next patch set, thanks for the comments.
> 
