Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F152FFDDF
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 09:07:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727009AbhAVIFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 03:05:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbhAVIFZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 03:05:25 -0500
Received: from mail-qt1-x832.google.com (mail-qt1-x832.google.com [IPv6:2607:f8b0:4864:20::832])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F302C06174A;
        Fri, 22 Jan 2021 00:04:44 -0800 (PST)
Received: by mail-qt1-x832.google.com with SMTP id o18so3505842qtp.10;
        Fri, 22 Jan 2021 00:04:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Kx3sH6YHlpgK218Xqk1ihUZMM+LeKPCk6agxOk0gJmM=;
        b=D3e7DVZXhlIvnI8Jabvi3Ua7OjQqy3K9WCZPCDupl3J5qtqmO8a8VE7zup0z14bvWX
         jn+I9U4TbM7y3xkbY4ZlEwR7K7vE5D3KCkDeVKEzidU/sW4FIZFf/I8Lt4sQkeABNG9O
         rbNT9kke1JSvUe6eVkD+6CstOjPhswyElvy9JMuUDKjqnq26Ayue0Wsa/A+UQ4VLgXcO
         7tcIB7thrFFe200npdTBk6YsOjkZHXPZ74n6Tq7BeOwbAAQS8BZe5gG+3XZkUfymCDeL
         RA0vmPfbp6jcpWmqxt58XEa9TXr5fMtABVORBoIQREpybdUTvFPQc8pdJkp696y/VElP
         WalQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Kx3sH6YHlpgK218Xqk1ihUZMM+LeKPCk6agxOk0gJmM=;
        b=a21Q4EIV0QtM30OJAj86RdM32gD2iMfEJouqaAmdLUZBJl3gTa23fYHtZHEqDhEvS/
         pzGN9ps0LTV0fgiohtlU4BOJGPkK8uu4nxfopOivjXBn17EXASRotRM5u3Gid01gRXr+
         G32xMSdnXS6Z++yNuoLPumnfrl5sYA+OEzmYGYS5avH1GuAHTcqRIyItjYnK67efbKTX
         S1XOAPLpdC4n8GAyJQ1hirpSHIv4v25E2GrSTujH3YmudxWJypLRBgBPIvbo3rcs57El
         k/OU4AcClpgsgufr7VC7JO2RpbIWeFbQtnc41X1HGdPk0NtFBpg1nu4x9q9I0nfcxi7F
         +zww==
X-Gm-Message-State: AOAM532OFGmuO5kQ42quu5cOdZA7lVvxHrmWnV4SGmWGg39lz23HFdI8
        A6o7lQPy9K7YfoakHZji4VnsBiYBgEadfOXtyIY=
X-Google-Smtp-Source: ABdhPJxJHbeeR43zsgpwVrgT6+nsbNZ6WrgxKtmBY3w5+CnKtZ90SVA4xW0zshG3KJ3afUHPLQdcXw==
X-Received: by 2002:ac8:3987:: with SMTP id v7mr3243472qte.144.1611302683458;
        Fri, 22 Jan 2021 00:04:43 -0800 (PST)
Received: from [0.0.0.0] ([2001:19f0:5:2661:5400:2ff:fe99:4621])
        by smtp.gmail.com with ESMTPSA id e38sm5385674qtb.30.2021.01.22.00.04.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Jan 2021 00:04:42 -0800 (PST)
Subject: Re: [PATCH v1] can: mcp251xfd: Add some sysfs debug interfaces for
 registers r/w
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        manivannan.sadhasivam@linaro.org, thomas.kopp@microchip.com,
        wg@grandegger.com, davem@davemloft.net, kuba@kernel.org,
        lgirdwood@gmail.com, broonie@kernel.org
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210122062255.202620-1-suyanjun218@gmail.com>
 <7181a6a3-62c6-9021-ea63-827f55eacd98@pengutronix.de>
From:   Su <suyanjun218@gmail.com>
Message-ID: <f311f01e-5203-821b-e44f-f0088a4622e7@gmail.com>
Date:   Fri, 22 Jan 2021 16:04:21 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <7181a6a3-62c6-9021-ea63-827f55eacd98@pengutronix.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


在 2021/1/22 下午3:22, Marc Kleine-Budde 写道:
> On 1/22/21 7:22 AM, Su Yanjun wrote:
>> When i debug mcp2518fd, some method to track registers is
>> needed. This easy debug interface will be ok.
> NACK
>
> As the driver uses regmap, everything should be there already.
>
> To read use:
>
> | cat /sys/kernel/debug/regmap/spi0.0-crc/registers
>
> Register write support for devices that are handles by proper kernel drivers is
> a pure debugging tool, thus not enabled by default, not even with a Kconfig
> switch. You have to enable it manually, have a look at commit:
>
> 09c6ecd39410 regmap: Add support for writing to regmap registers via debugfs

You're right.

Thank you

>
> regards,
> Marc
>
