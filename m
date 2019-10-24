Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35656E3B27
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 20:40:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440113AbfJXSj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 14:39:59 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:41412 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2440106AbfJXSj6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 14:39:58 -0400
Received: by mail-ed1-f67.google.com with SMTP id a21so2400116edj.8;
        Thu, 24 Oct 2019 11:39:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=C1bh5n/xf11piXwY2og3Hyew3R1/gTscdEIIWfQpIFc=;
        b=aITfjgs2zrQpKgd10Gh9pleo1jxTnSqBELnKvlqxU6l7rFg5RFSUXhnqBSUuK4oXtI
         vQmfN9Z2lNublyB1caPtreIws7xYWtmsKpcIOWE+oYr1ELxKfzMVJSixCmN78lN0cEng
         c+H2X9Qq6F+VzNU9fA+q3H6Enp4X6C+rAi3FZzLO+IuBUQFXli+W7HrUmcKZbF4jUG1a
         H2cMNbT4e+YGSMWfKzG3/hmeHwcY5bt+8zmLGz96l8CfSh/lehtntcg6RBod6npv2rzP
         4DhFJrxEPmGf9mCnXTeVVgZHJtUxCFUa3lir6MgqLlDQWW38HXPLO7RGyY3njKqMOyGf
         jBQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=C1bh5n/xf11piXwY2og3Hyew3R1/gTscdEIIWfQpIFc=;
        b=sKqaQQlzIdLtFTYFlIeTExDq+GowxpnTRjiDScTWUvW3HKjAVVYD84LKaISWt8JVfX
         fKXY2LHkLDUihGnhycSLHjcEJVF7sVCcaoA7uixLQPPM/ZViRYlu/LCSQziVVKWjnJw5
         aCMw4eNXz4dSZ8RfuOGjHEkYjKlmwa7SxjiXXSz6dxO0oYG6RCyD/zdgVH2wycV2UPV0
         Eddrzk0C2OKIr+4hi9Ih+sPmaMKl5Cvo0/osZVZcE8V/JIi8NSXOX+LkESdezItcsi/P
         G+PK529n0z/F1Z7evju6sThhAlA2KGpy+/73upKeiQVJGMq/BvJUM7yQifzvGJx+bwFk
         s1qg==
X-Gm-Message-State: APjAAAUQY1t0PoWcl3P9Cmx3MEsla39I0ZmVTaudQY8gmPj/GN5mMqDU
        MgwgyyNY7EROsVh4ie1xBG6rztN+
X-Google-Smtp-Source: APXvYqxgHpVsphPvBXxHOY0BnbCt2GRKgX0Q5q/t6cSfw9b607S4Vkz3G11kCVctmz+LGc+HbSTdMw==
X-Received: by 2002:a17:906:f1c5:: with SMTP id gx5mr15825928ejb.314.1571942394100;
        Thu, 24 Oct 2019 11:39:54 -0700 (PDT)
Received: from [10.67.50.53] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j9sm975919edt.15.2019.10.24.11.39.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 24 Oct 2019 11:39:53 -0700 (PDT)
Subject: Re: [PATCH V3 0/3] Add OP-TEE based bnxt f/w manager
To:     Sheetal Tigadoli <sheetal.tigadoli@broadcom.com>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Simek <michal.simek@xilinx.com>,
        Rajan Vaja <rajan.vaja@xilinx.com>,
        Scott Branden <scott.branden@broadcom.com>,
        Ray Jui <ray.jui@broadcom.com>,
        Vikram Prakash <vikram.prakash@broadcom.com>,
        Jens Wiklander <jens.wiklander@linaro.org>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vikas Gupta <vikas.gupta@broadcom.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        tee-dev@lists.linaro.org, bcm-kernel-feedback-list@broadcom.com,
        netdev@vger.kernel.org
References: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <183f68bc-8145-ef98-07ca-8d3f85d66a17@gmail.com>
Date:   Thu, 24 Oct 2019 11:39:42 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <1571895161-26487-1-git-send-email-sheetal.tigadoli@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/23/19 10:32 PM, Sheetal Tigadoli wrote:
> This patch series adds support for TEE based BNXT firmware
> management module and the driver changes to invoke OP-TEE
> APIs to fastboot firmware and to collect crash dump.

Sorry for chiming on this so late, the more I look into this and the
more it seems like you have built a custom TEE firmware loading solution
rather than thinking about extending the firmware API to load a firmware
opaque handle from somewhere other than the filesystem.

The TEE integration appears okay to me in that you leverage the TEE bus
to advertise your driver. What seems to violating layers is that you
have bnxt directly tap into your TEE driver's services and that looks
not ideal to say the least. That approach does not scale well over
multiple drivers (bnxt or otherwise), but also does not really scale
over trusted components providers. TEE is one of them, but conceptually
the same thing could exist with ACPI/UEFI or any platform that has
services that offer some sort of secure/non-secured world differentiation.

The way I would imagine you to integrate this is to basically register a
TEE firmware provider through the firmware API, continue using the
firmware API from within bnxt, possibly with using a specific file
handle/flag that designates whether you want to favor loading from
disk/file system or TEE. It should not matter to bnxt how the firmware
is obtained basically.

> 
> changes from v2:
>  - address review comments from Jakub
> 
> Vasundhara Volam (2):
>   bnxt_en: Add support to invoke OP-TEE API to reset firmware
>   bnxt_en: Add support to collect crash dump via ethtool
> 
> Vikas Gupta (1):
>   firmware: broadcom: add OP-TEE based BNXT f/w manager
> 
>  drivers/firmware/broadcom/Kconfig                 |   8 +
>  drivers/firmware/broadcom/Makefile                |   1 +
>  drivers/firmware/broadcom/tee_bnxt_fw.c           | 277 ++++++++++++++++++++++
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c         |  13 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h         |   6 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c |  37 ++-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.h |   2 +
>  include/linux/firmware/broadcom/tee_bnxt_fw.h     |  14 ++
>  8 files changed, 354 insertions(+), 4 deletions(-)
>  create mode 100644 drivers/firmware/broadcom/tee_bnxt_fw.c
>  create mode 100644 include/linux/firmware/broadcom/tee_bnxt_fw.h
> 


-- 
Florian
