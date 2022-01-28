Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83CDC49F264
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 05:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345996AbiA1EU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 23:20:56 -0500
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:54824
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240880AbiA1EU4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 23:20:56 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 5BB7F3F051;
        Fri, 28 Jan 2022 04:20:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643343654;
        bh=dIUsbvJS0yr08KtexnYfpQvKUob/zoM+k9/hXRBANvY=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=WIS5+AJLCH4FWjTvlIUlroyecxA2xYnd07eBNPT2iabfBOkSvvIEAMmVtH0PghlqK
         Ksi3JMfxFH7oMJekXT9wVo2N/wZ9vL5cU92+4sn7y6XYwF1Je+8JGTCbpZXSOfspWQ
         itCT3Yll//KUMX71NpIWOVZlg951LMDg7gZ7Zs26obFuihx9Vf5y3RORa+7i8OeEka
         loZxnY0jMtveDeFFOsE7MDQvJif5u4CTYx7D0o+zUhpY0d0mc6uHIv+dNZXUuLtvbu
         DkVX/4Avt9pi2WT1j1j6pykV24cRkXhBFXfgjZrOSoGQfCLbfzDvcqI6MCC8s4GlQE
         B+5zcP+TDO08A==
Message-ID: <0a0c91c4-93f5-042f-fff0-eb7376470e2c@canonical.com>
Date:   Fri, 28 Jan 2022 12:20:48 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Content-Language: en-US
To:     Hayes Wang <hayeswang@realtek.com>,
        "Mario.Limonciello@amd.com" <Mario.Limonciello@amd.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "henning.schild@siemens.com" <henning.schild@siemens.com>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "tiwai@suse.de" <tiwai@suse.de>
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <35834c36763b4c24a9f1ab8a292732b5@realtek.com>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <35834c36763b4c24a9f1ab8a292732b5@realtek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/27/22 19:07, Hayes Wang wrote:
> I think the devices with the VID/PID of Lenovo, such as 0x17EF/0x3082 and 0x17EF/0xA387,
> would always return -ENODEV here. Is it what you want?
> 

This was a mistake.
Try to fix it in V3.

Thanks,
Aaron

> 
> Best Regards,
> Hayes
