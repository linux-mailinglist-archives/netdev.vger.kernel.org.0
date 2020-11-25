Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F042C4A3A
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 22:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732518AbgKYVpI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 16:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730249AbgKYVpI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 16:45:08 -0500
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B153C0617A7
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 13:45:08 -0800 (PST)
Received: by mail-il1-x144.google.com with SMTP id v3so6246ilo.5
        for <netdev@vger.kernel.org>; Wed, 25 Nov 2020 13:45:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=no1bO+ckW6W8DUgsFvzWdRgxxx68msjiEzdWapddJA0=;
        b=Al+QYKrQ6R3a2rHiS3QhZy+tjQg/wBZqF4aZzmCD3toqI0qi1e2VVmB3WYcGH3kzbw
         KXA3svqCRG8xaDiFNo86hCT5IqL4BOvHHmiM73XdhNJ+c50LIKz2wIxmY0BYgr4sfHDm
         gdQGGUQtaOvObJ3YwZT6xws0TUpZ2CTFSFUig=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=no1bO+ckW6W8DUgsFvzWdRgxxx68msjiEzdWapddJA0=;
        b=gu8h31k5GrbwJzv4TUKi/VAV3Nl3NpvVH4VKOaE4ilQ7Hd8h/YQ83BtVCpu5jSE1mp
         uvsqZagntDUSSDI7iJtcn6lGkABXiY3i0HIkJkl+AGpdxVw7QJVKmblWCeVmFv5msX9n
         1whLtDYfraSDByWArmUXft/3532sr36hJUE7yHvFsvz5rlAHHYxtj0BI/kjXj2E7pslU
         p1c21gXNrI6mbCRjjHCagsPfFip9k5VypuKtwKTTWouc30nFrcYalc0SZ2hMZbjLkJfB
         EWFby76WALQ2zcpdiU9oWanydJqqMA9wdfhbcRjDcCNzmrov6QVow4kKCi5V4apO67mh
         uctQ==
X-Gm-Message-State: AOAM530aq77QRMYK/JWUBwsuYoumxpsE0gp5ysKEEvyC7xD+Bx1wFR+T
        BiYYtkWSwMraKPSJzVIfFjRbmQ==
X-Google-Smtp-Source: ABdhPJxe6T5zgXwtV3mF6ttSWU6Njun4e63eXCdaro0fB9Jk6jCGEiAvqo1VkX2iFXUEJIiRGuNRlw==
X-Received: by 2002:a05:6e02:1204:: with SMTP id a4mr4840785ilq.135.1606340707301;
        Wed, 25 Nov 2020 13:45:07 -0800 (PST)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id m6sm1469909ioq.33.2020.11.25.13.45.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 13:45:06 -0800 (PST)
Subject: Re: [PATCH net-next 1/2] soc: qcom: ipa: Constify static qmi structs
To:     Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Alex Elder <elder@kernel.org>, Kalle Valo <kvalo@codeaurora.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
References: <20201122234031.33432-1-rikard.falkeborn@gmail.com>
 <20201122234031.33432-2-rikard.falkeborn@gmail.com>
From:   Alex Elder <elder@ieee.org>
Message-ID: <ee9dfc18-092e-6a5c-d310-d4ce52db6042@ieee.org>
Date:   Wed, 25 Nov 2020 15:45:05 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.2
MIME-Version: 1.0
In-Reply-To: <20201122234031.33432-2-rikard.falkeborn@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/22/20 5:40 PM, Rikard Falkeborn wrote:
> These are only used as input arguments to qmi_handle_init() which
> accepts const pointers to both qmi_ops and qmi_msg_handler. Make them
> const to allow the compiler to put them in read-only memory.
> 
> Signed-off-by: Rikard Falkeborn <rikard.falkeborn@gmail.com>

Good idea.  Thanks a lot.

Acked-by: Alex Elder <elder@linaro.org>

> ---
>   drivers/net/ipa/ipa_qmi.c | 8 ++++----
>   1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
> index 5090f0f923ad..d2c3f273c233 100644
> --- a/drivers/net/ipa/ipa_qmi.c
> +++ b/drivers/net/ipa/ipa_qmi.c
> @@ -168,7 +168,7 @@ static void ipa_server_bye(struct qmi_handle *qmi, unsigned int node)
>   	ipa_qmi->indication_sent = false;
>   }
>   
> -static struct qmi_ops ipa_server_ops = {
> +static const struct qmi_ops ipa_server_ops = {
>   	.bye		= ipa_server_bye,
>   };
>   
> @@ -234,7 +234,7 @@ static void ipa_server_driver_init_complete(struct qmi_handle *qmi,
>   }
>   
>   /* The server handles two request message types sent by the modem. */
> -static struct qmi_msg_handler ipa_server_msg_handlers[] = {
> +static const struct qmi_msg_handler ipa_server_msg_handlers[] = {
>   	{
>   		.type		= QMI_REQUEST,
>   		.msg_id		= IPA_QMI_INDICATION_REGISTER,
> @@ -261,7 +261,7 @@ static void ipa_client_init_driver(struct qmi_handle *qmi,
>   }
>   
>   /* The client handles one response message type sent by the modem. */
> -static struct qmi_msg_handler ipa_client_msg_handlers[] = {
> +static const struct qmi_msg_handler ipa_client_msg_handlers[] = {
>   	{
>   		.type		= QMI_RESPONSE,
>   		.msg_id		= IPA_QMI_INIT_DRIVER,
> @@ -463,7 +463,7 @@ ipa_client_new_server(struct qmi_handle *qmi, struct qmi_service *svc)
>   	return 0;
>   }
>   
> -static struct qmi_ops ipa_client_ops = {
> +static const struct qmi_ops ipa_client_ops = {
>   	.new_server	= ipa_client_new_server,
>   };
>   
> 

