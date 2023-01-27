Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1436C67EE78
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 20:42:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbjA0Tme (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 14:42:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbjA0Tma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 14:42:30 -0500
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D40047E6E9;
        Fri, 27 Jan 2023 11:41:51 -0800 (PST)
Received: by mail-qt1-x836.google.com with SMTP id z9so4966916qtv.5;
        Fri, 27 Jan 2023 11:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nrR4W00Y0TgiFcHd6pUVelmAdP0rx76b/pAw6kny76k=;
        b=cDf0F9IUE89vD+s3BJP4EjO5oS/nwRRX0eqPyTemjE2qknrTVlm/Ny16lMEkleUX6Z
         5YT5/OmhlVr33eE0ZPYYEC1djfAPoq+fc9XUXm+bkhlR4/UDBlzNgh9fQ42WVV8bqHFl
         XlN/rLwrxmD0M0ku+9pbtsRvC6mReoI0cIbz6RTFxa1IHVcRGicUog5RLk8UQCbsBlJv
         SL5IMzHjYy0tpQiH5vXsmON8+LYI6XnEHpSBIees/10i7nx00UQKFUthlNtLMRMMmmfg
         Fc+7/7bd0Kem3jqPRO5CCsfLXHFxLk8FQta1VwJLyE7RTAhtOZfvfRQCHGIP5eyhoVat
         1eLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nrR4W00Y0TgiFcHd6pUVelmAdP0rx76b/pAw6kny76k=;
        b=y1MhcREG4DSTMIgUjD4jufFBxSHvMX6kOlBQ/fGFWAYy+JgtaP4+Y8BC9QmSz0o+qs
         ryXeToiPuJvkcLXL1VWvrfZGCeoueXt6E822ALUD9DaQzh9rvTWIlCm+agGICET6dLvS
         V5IN1eU6X1WWb6dawVTBmWqwcQsOl0o5EiVE1zZkJbm2xbOh8S82qkGth/jcufHoVTZ7
         AEnLrYz592ggHuPPtASkxSWvZT+kkA0k3MxIKU2jlNylO11F6bR5JFsp8AgUSd+xak4z
         DGC8g32eIBAo8jPB/ZDGbWNJqIXB2ol8AqwfVfL6uPQeD3mRyT/K5GA71UaI7NhYAcu6
         Ux2g==
X-Gm-Message-State: AO0yUKVU/tE/lvC+WWdkz7eED1t/JXyJ54KNRRl7IU/tq2YgVWuTJs2J
        afXI+OGd/g6KvG4l6RqZunk=
X-Google-Smtp-Source: AK7set8eMzzpAqo2XE0SOLSqZqEIoZWx5rBNzuTzKWJ4N3N2/eQkFrJNywrdr6kIBPFC0liFx9o3GA==
X-Received: by 2002:a05:622a:c3:b0:3b8:312e:bafb with SMTP id p3-20020a05622a00c300b003b8312ebafbmr1040755qtw.46.1674848426803;
        Fri, 27 Jan 2023 11:40:26 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g13-20020ac8468d000000b003a7e4129f83sm3181590qto.85.2023.01.27.11.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 11:40:25 -0800 (PST)
Message-ID: <1a359e6a-0836-9281-6246-b06fe252e431@gmail.com>
Date:   Fri, 27 Jan 2023 11:40:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.0
Subject: Re: [PATCH v5 net-next 07/13] net: dsa: felix: add support for MFD
 configurations
Content-Language: en-US
To:     Colin Foster <colin.foster@in-advantage.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc:     Russell King <linux@armlinux.org.uk>,
        Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Lee Jones <lee@kernel.org>
References: <20230127193559.1001051-1-colin.foster@in-advantage.com>
 <20230127193559.1001051-8-colin.foster@in-advantage.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230127193559.1001051-8-colin.foster@in-advantage.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/27/2023 11:35 AM, Colin Foster wrote:
> The architecture around the VSC7512 differs from existing felix drivers. In
> order to add support for all the chip's features (pinctrl, MDIO, gpio) the
> device had to be laid out as a multi-function device (MFD).
> 
> One difference between an MFD and a standard platform device is that the
> regmaps are allocated to the parent device before the child devices are
> probed. As such, there is no need for felix to initialize new regmaps in
> these configurations, they can simply be requested from the parent device.
> 
> Add support for MFD configurations by performing this request from the
> parent device.
> 
> Signed-off-by: Colin Foster <colin.foster@in-advantage.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
