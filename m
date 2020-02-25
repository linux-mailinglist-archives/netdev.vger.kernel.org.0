Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8929916F135
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 22:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbgBYVfd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 16:35:33 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:56067 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgBYVfd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Feb 2020 16:35:33 -0500
Received: by mail-wm1-f68.google.com with SMTP id q9so771157wmj.5;
        Tue, 25 Feb 2020 13:35:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1C/K5Wsm9LPHzaz/4XpwnKAwYVbjEpz36KnNrq8NU6A=;
        b=H3rodxzqGzN4uqzCFXakGUegaCrnGqQBj076s1/t+ZJ7F+rkUIC/oHl3pPwrITc+QK
         rLYAMLWJ+S9U1Zr8FMmP0WgZwPDiiRx8LIcWnKBBXLL8YHGfOkYUvZJkWWS0h6r6LeWQ
         riPSMjAmdYalm3BL3wFUrG5dtpN7+Cx23tzs8X16Vpcl9rOLFMlws8ZaoSXnSTineKms
         L/F6EZD8Ia2bi2uYdIO05251bydHkLy+4+EbB0kIaRsljRdaTpIuuG9GafGWC/AjqxmH
         S/Nz0R8EE3gTsXsjp2aRtYPXELVnXO0Muy8Q0qYWABY5cIGeSKKgknpnBYp/mtZhuFG3
         G9xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1C/K5Wsm9LPHzaz/4XpwnKAwYVbjEpz36KnNrq8NU6A=;
        b=Y9KtnYS2uhJr67aRYhTV6K/hWesKopIzUOhKjbmEtzXgJYIpW4iDI8fvlloZjbOL0a
         G/Bgczg0UUZ/1hHWy45wljp6BdRrv4BxX53zu+uHdIe5D3rkIx3wlnAab1G44l7AM00w
         8brz2dXrPBQh9CF1n0uS/2lC0z8VAC3X08HWyleiuFLOv0EuybBi2t9ROsWmBNkArn0y
         GgOtX933dyA8GnKqrnZc4QJQCUdKIjS7IaZsX76nkq1cmw3Celja/U1EfpQS1vAOtN9Y
         hJAc6nkimpLDvO3Nu9XmUdcg7xsrY4oaRE9wNv4tf/u5Xv8o+dCl5cqckGzkgSvsitls
         IzEQ==
X-Gm-Message-State: APjAAAWumPJjlk91RhcNkokdbExyc9TxNdQxeTdhLwgtZOnxn+LJZY7t
        etE3mBmrX3Vj9jvuiymFHvg=
X-Google-Smtp-Source: APXvYqyWYGcFLzI85kNXTDFApx8I2QRip0B35i+/HX9sh1K62R6K8sQleTspdjAn0n60QhMt6lohQA==
X-Received: by 2002:a1c:541b:: with SMTP id i27mr1230756wmb.137.1582666530486;
        Tue, 25 Feb 2020 13:35:30 -0800 (PST)
Received: from ?IPv6:2003:ea:8f29:6000:3571:9abd:5d7f:e3ab? (p200300EA8F29600035719ABD5D7FE3AB.dip0.t-ipconnect.de. [2003:ea:8f29:6000:3571:9abd:5d7f:e3ab])
        by smtp.googlemail.com with ESMTPSA id k7sm5575667wmi.19.2020.02.25.13.35.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Feb 2020 13:35:30 -0800 (PST)
Subject: Re: [PATCH v3 1/8] PCI: add constant PCI_STATUS_ERROR_BITS
To:     Bjorn Helgaas <helgaas@kernel.org>
Cc:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Mirko Lindner <mlindner@marvell.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        alsa-devel@alsa-project.org
References: <20200225205047.GA194679@google.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <79cca560-1ef5-f9bf-b90d-b2199dd5aedb@gmail.com>
Date:   Tue, 25 Feb 2020 22:35:15 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200225205047.GA194679@google.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25.02.2020 21:50, Bjorn Helgaas wrote:
> On Tue, Feb 25, 2020 at 03:03:44PM +0100, Heiner Kallweit wrote:
> 
> Run "git log --oneline drivers/pci" and make yours match.  In
> particular, capitalize the first word ("Add").  Same for the other PCI
> patches.  I don't know the drivers/net convention, but please find and
> follow that as well.
> 
>> This constant is used (with different names) in more than one driver,
>> so move it to the PCI core.
> 
> The driver constants in *this* patch at least use the same name.
> 
Right, I have to fix the description.

>> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
>> ---
>>  drivers/net/ethernet/marvell/skge.h | 6 ------
>>  drivers/net/ethernet/marvell/sky2.h | 6 ------
>>  include/uapi/linux/pci_regs.h       | 7 +++++++
>>  3 files changed, 7 insertions(+), 12 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/marvell/skge.h b/drivers/net/ethernet/marvell/skge.h
>> index 6fa7b6a34..e149bdfe1 100644
>> --- a/drivers/net/ethernet/marvell/skge.h
>> +++ b/drivers/net/ethernet/marvell/skge.h
>> @@ -15,12 +15,6 @@
>>  #define  PCI_VPD_ROM_SZ	7L<<14	/* VPD ROM size 0=256, 1=512, ... */
>>  #define  PCI_REV_DESC	1<<2	/* Reverse Descriptor bytes */
>>  
>> -#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
>> -			       PCI_STATUS_SIG_SYSTEM_ERROR | \
>> -			       PCI_STATUS_REC_MASTER_ABORT | \
>> -			       PCI_STATUS_REC_TARGET_ABORT | \
>> -			       PCI_STATUS_PARITY)
>> -
>>  enum csr_regs {
>>  	B0_RAP	= 0x0000,
>>  	B0_CTST	= 0x0004,
>> diff --git a/drivers/net/ethernet/marvell/sky2.h b/drivers/net/ethernet/marvell/sky2.h
>> index b02b65230..851d8ed34 100644
>> --- a/drivers/net/ethernet/marvell/sky2.h
>> +++ b/drivers/net/ethernet/marvell/sky2.h
>> @@ -252,12 +252,6 @@ enum {
>>  };
>>  
>>  
>> -#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY | \
>> -			       PCI_STATUS_SIG_SYSTEM_ERROR | \
>> -			       PCI_STATUS_REC_MASTER_ABORT | \
>> -			       PCI_STATUS_REC_TARGET_ABORT | \
>> -			       PCI_STATUS_PARITY)
>> -
>>  enum csr_regs {
>>  	B0_RAP		= 0x0000,
>>  	B0_CTST		= 0x0004,
>> diff --git a/include/uapi/linux/pci_regs.h b/include/uapi/linux/pci_regs.h
>> index 543769048..9b84a1278 100644
>> --- a/include/uapi/linux/pci_regs.h
>> +++ b/include/uapi/linux/pci_regs.h
>> @@ -68,6 +68,13 @@
>>  #define  PCI_STATUS_SIG_SYSTEM_ERROR	0x4000 /* Set when we drive SERR */
>>  #define  PCI_STATUS_DETECTED_PARITY	0x8000 /* Set on parity error */
>>  
>> +#define PCI_STATUS_ERROR_BITS (PCI_STATUS_DETECTED_PARITY  | \
>> +			       PCI_STATUS_SIG_SYSTEM_ERROR | \
>> +			       PCI_STATUS_REC_MASTER_ABORT | \
>> +			       PCI_STATUS_REC_TARGET_ABORT | \
>> +			       PCI_STATUS_SIG_TARGET_ABORT | \
>> +			       PCI_STATUS_PARITY)
> 
> This actually *adds* PCI_STATUS_SIG_TARGET_ABORT, which is not in the
> driver definitions.  At the very least that should be mentioned in the
> commit log.
> 
> Ideally the addition would be in its own patch so it's obvious and
> bisectable, but I see the problem -- the subsequent patches
> consolidate things that aren't really quite the same.  One alternative
> would be to have preliminary patches that change the drivers
> individually so they all use this new mask, then do the consolidation
> afterwards.
> 
I checked the other patches and we'd need such preliminary patches
for three of them:
marvell: misses PCI_STATUS_SIG_TARGET_ABORT
skfp: misses PCI_STATUS_REC_TARGET_ABORT
r8169: misses PCI_STATUS_PARITY

> There is pitifully little documentation about the use of include/uapi,
> but AFAICT that is for the user API, and this isn't part of that.  I
> think this #define could go in include/linux/pci.h instead.
> 
OK, then I'll change the series accordingly.

>> +
>>  #define PCI_CLASS_REVISION	0x08	/* High 24 bits are class, low 8 revision */
>>  #define PCI_REVISION_ID		0x08	/* Revision ID */
>>  #define PCI_CLASS_PROG		0x09	/* Reg. Level Programming Interface */
>> -- 
>> 2.25.1
>>
>>
>>
>>

