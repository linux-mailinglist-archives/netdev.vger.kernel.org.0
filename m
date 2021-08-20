Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6315D3F3618
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 23:36:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240666AbhHTVhC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 17:37:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232732AbhHTVhB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 17:37:01 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34968C061575;
        Fri, 20 Aug 2021 14:36:23 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x12so16023329wrr.11;
        Fri, 20 Aug 2021 14:36:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yZTuCM5rKLyLBbJAnIoNGoNdOlF/b6zSjjh4GCOGYPc=;
        b=Mq7gzKlbqW16jIags1osZC/swn8LdN5G+3zaqbaeaL5CEewRuxYvgR51X48q8fIHsP
         TEaTq1VWtGcDy2i/MR1N2twB78gH2HRdx22U6OkkC1desKXWprSt91LhnBnkISeyEZ4s
         9B06Stgo+co3m1fAW1td0MNMgCGvOrpVyZcoZnZlQcG0ooPJCP/j3sztwS1kpAbQHdRH
         LnQI5sCsVl8CMZO+d8TOFiOGTRYO0pc+jtDPHU93n6vmuheSQV/UTKOithhHIwaHm+KP
         rnz5BP72c2kgQYv+s97yEDwBMVaXpf+KDSj5wiOzSm2BfHgTCKnuemRDBxCav/AV9kHN
         Hm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yZTuCM5rKLyLBbJAnIoNGoNdOlF/b6zSjjh4GCOGYPc=;
        b=IZDFoTFpCFvaF9xNbb5g3mOnwZgwrdVzzg4ohT1ADUH52WZhPirURtWBKHRzKo492i
         PkKKCIaRNEGuZm4f9Q2bND5uYtAi9aXLXwACSNXDQJCnpD1KdJL/1yBhABnjq41t4F/G
         41+uXKq3QfdFINl4B7cG6n0IMuOYkjO7eiIiCE1dhRLr9hzEfw43YTqW5CgCC71GKc3G
         vrWagmxP2V7lddhyHSqt5NN8ND1kt/oh75coI1RvAG7whNIBbA/kJc8G31zz2NUCdxiz
         rp683/xAlDVmZhPnOw7HsxOczeyg8jZvDJdTMWQEerZYKOc8PndYJQrZV7KiCQOSEd42
         jH9w==
X-Gm-Message-State: AOAM533lQR5JoLZZaUK48a6S/r0RFNkONPfcR8e+jvaW8o9f9URwaqO9
        j7NLvu+IAdxAO0g9RtIGJDU4aUJ2YRs5aw==
X-Google-Smtp-Source: ABdhPJy8VWGBXt9UCrjKn7gprpLQiPe3YzVuPZ/0yYHlvv26i0LcShq9aDc5/kMmleq+YN59tvl3yA==
X-Received: by 2002:a5d:4c4e:: with SMTP id n14mr824330wrt.226.1629495381518;
        Fri, 20 Aug 2021 14:36:21 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f08:4500:5107:c891:e5ee:838c? (p200300ea8f0845005107c891e5ee838c.dip0.t-ipconnect.de. [2003:ea:8f08:4500:5107:c891:e5ee:838c])
        by smtp.googlemail.com with ESMTPSA id r10sm8727751wrq.32.2021.08.20.14.36.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Aug 2021 14:36:21 -0700 (PDT)
Subject: Re: [PATCH 0/8] PCI/VPD: Extend PCI VPD API
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        Siva Reddy Kallam <siva.kallam@broadcom.com>,
        Prashant Sreedharan <prashant@broadcom.com>,
        Michael Chan <mchan@broadcom.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210820205036.GA3356538@bjorn-Precision-5520>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <9c2e1cad-9c3e-634e-e9d7-2e08ec4825df@gmail.com>
Date:   Fri, 20 Aug 2021 23:36:14 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210820205036.GA3356538@bjorn-Precision-5520>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20.08.2021 22:50, Bjorn Helgaas wrote:
> On Wed, Aug 18, 2021 at 08:58:18PM +0200, Heiner Kallweit wrote:
>> This series adds three functions to the PCI VPD API that help to
>> simplify driver code. First users are sfc and tg3 drivers because
>> I have test hw. The other users of the VPD API will benefit from a
>> migration as well.
>> I'd propose to apply this series via the PCI tree.
>>
>> Added API calls:
>>
>> pci_vpd_alloc()
>> Dynamically allocates a properly sized buffer and reads the VPD into it.
>>
>> pci_vpd_find_ro_info_keyword()
>> Locates an info field keyword in the VPD RO section.
>> pci_vpd_find_info_keyword() can be removed once all
>> users have been migrated.
>>
>> pci_vpd_check_csum()
>> Check VPD checksum based on algorithm defined in the PCI specification.
>>
>> Tested on a SFN6122F and a BCM95719 card.
>>
>> Heiner Kallweit (8):
>>   PCI/VPD: Add pci_vpd_alloc
>>   PCI/VPD: Add pci_vpd_find_ro_info_keyword and pci_vpd_check_csum
>>   PCI/VPD: Add missing VPD RO field keywords
>>   sfc: Use new function pci_vpd_alloc
>>   sfc: Use new VPD API function pci_vpd_find_ro_info_keyword
>>   tg3: Use new function pci_vpd_alloc
>>   tg3: Use new function pci_vpd_check_csum
>>   tg3: Use new function pci_vpd_find_ro_info_keyword
>>
>>  drivers/net/ethernet/broadcom/tg3.c | 115 +++++++---------------------
>>  drivers/net/ethernet/broadcom/tg3.h |   1 -
>>  drivers/net/ethernet/sfc/efx.c      |  78 +++++--------------
>>  drivers/pci/vpd.c                   |  82 ++++++++++++++++++++
>>  include/linux/pci.h                 |  32 ++++++++
>>  5 files changed, 163 insertions(+), 145 deletions(-)
> 
> Beautiful!  I applied this with minor tweaks to pci/vpd for v5.15.
> 
> I dropped the "add missing keywords" patch because there are no users
> of the missing keywords yet.
> 
Chelsio T4 driver is using this keyword. Then I'll add this keyword
when migrating the driver.

> I would have removed pci_vpd_find_info_keyword() as well, but it looks
> like there are stilla few users of it.
> 
Right, there are few more users. In this initial series I only changed
users for which I have test hw.
