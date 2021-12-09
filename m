Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7315346DFB7
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 01:49:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241540AbhLIAwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 19:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbhLIAwu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 19:52:50 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A793C061746;
        Wed,  8 Dec 2021 16:49:18 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id j11so3590704pgs.2;
        Wed, 08 Dec 2021 16:49:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ArpiXiiRMMNxywH9lYO6hlsz/ack8Tk8QW26jOZRnm8=;
        b=pAnnUjRJ6KTfjhp0QbYQ18ZlE64fms2JaW1eUx5oAgZcjZOb5LsL4jzWZA1SkdYQme
         FP1AonXHEsGpDtk+a7xcz+VVXjzdPLBK2KjXvg+mApc/qzw4hX+ffRO8PfB3PQK9VLUJ
         9xNqakaGjNti85h6da08tssU4zmdV0w9Jrw710DL9XxpYJ1+c5lFyIdToZxJQW3o0toi
         oJUz7cQtRc08b7QCTVuK2aEsx4Ouz4wQXgLVnLGvevuB9jU/1sYI1OOJccxBJ3AApluo
         u9P5NPCMn+Xv3kgeUljbDjbMZ03LOPMjGaYDQFNmr2640+iZs38zfkK6xWUFjEYGuju2
         xBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ArpiXiiRMMNxywH9lYO6hlsz/ack8Tk8QW26jOZRnm8=;
        b=aswPckOdPykFbYoaMxMXktTlym3XXgwP5YLEKU+ybtR+72jUpEJvcJ6r6YJV3drkoG
         oPN+6/dsNUFQMxdGQunmoS+Rd+KfuWvQmPLoQ2ytuo8x62IqJlmkiQVR56oNvBPGuo3i
         hPzkDAFcN0O+Lyp9FJi61wuTXWLFYLX2bKBK6lhuTEs7EpvjRzJmJpwGaD+g6bLOgFo5
         sO0W4BDlv36/Fyaz56bnREf+susBlNkB6OGYnxwQ6T/QV4T4Qav7O92FcAU7Gj+tGRxI
         j12lFBtMDIh1n7KedylDSpHAaZ0FdEBz5xroWqafq4RkCFt+HP5T4+P8M+x0SV6UBSXw
         BQmg==
X-Gm-Message-State: AOAM531KcecrmjGsN1yotYCKbx5IXSyA2zf6blrHY5jQhQsfGBa5oZxI
        lnwyD0Qo1PDc5iLxdq4drM8reiqGHic=
X-Google-Smtp-Source: ABdhPJy24uNaIqk2mAh7Sg6mshvNbMFAbEi8B5kihXavLvtINv7CSfPlFg51iL0asEPbw9ZJPTocqg==
X-Received: by 2002:a62:6dc4:0:b0:4ac:fd66:b746 with SMTP id i187-20020a626dc4000000b004acfd66b746mr8813020pfc.17.1639010957153;
        Wed, 08 Dec 2021 16:49:17 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j7sm8386764pjf.41.2021.12.08.16.49.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Dec 2021 16:49:16 -0800 (PST)
Subject: Re: [PATCH v4 2/2] dt-bindings: net: Convert SYSTEMPORT to YAML
To:     Rob Herring <robh@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>,
        netdev@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
References: <20211208202801.3706929-1-f.fainelli@gmail.com>
 <20211208202801.3706929-3-f.fainelli@gmail.com>
 <YbEoC3e709/feQc4@robh.at.kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7f9bb4e7-2560-bf06-b5de-0886c7d749da@gmail.com>
Date:   Wed, 8 Dec 2021 16:49:14 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <YbEoC3e709/feQc4@robh.at.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/21 1:47 PM, Rob Herring wrote:
> On Wed, 08 Dec 2021 12:28:01 -0800, Florian Fainelli wrote:
>> Convert the Broadcom SYSTEMPORT Ethernet controller Device Tree binding
>> to YAML.
>>
>> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
>> ---
>>  .../bindings/net/brcm,systemport.txt          | 38 --------
>>  .../bindings/net/brcm,systemport.yaml         | 88 +++++++++++++++++++
>>  MAINTAINERS                                   |  1 +
>>  3 files changed, 89 insertions(+), 38 deletions(-)
>>  delete mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.txt
>>  create mode 100644 Documentation/devicetree/bindings/net/brcm,systemport.yaml
>>
> 
> Applied, thanks!

Thanks for applying the patches and fixing up my mistakes in the process.
-- 
Florian
