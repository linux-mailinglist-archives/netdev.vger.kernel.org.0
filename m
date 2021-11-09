Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4C1044A5A1
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 05:10:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236033AbhKIEMp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Nov 2021 23:12:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230126AbhKIEMo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Nov 2021 23:12:44 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1234::107])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4465C061764;
        Mon,  8 Nov 2021 20:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=zTTdSdW8U8r+TdaomUPgnnuC3BePNJA4zCUcaxkNo9c=; b=0TH5iLIEdozryDgutScCb8mJqd
        VhDi7DH3D08h+e9+EIta/sricldt+8iJhrxEf4kdu8VgU00OSeJPVwMDjeN9cBUQqnfkCDKy7jX4Q
        sXseZbUFEAb3M2wSxSyH2RIS+6q9FCY4HZUK04ZFI4TCl0YzJ18tz6nd+P00RjSdCJV8H8gr3exYY
        aS8HW7v2r3xyt6fuIavwGMOq/yhcn+ku2zIuOT3CRy+GgvOmtTRvWGVAqUhIrteq94dd8tCnVjl0D
        SGc8AYv/58XxSsMt4M6gMwOiHxu80Mg/lQdjxNVkt/aaGRCYYME65iamiThT1o4m/s89/c6fyqSoi
        UM/Ec2vw==;
Received: from [2601:1c0:6280:3f0::aa0b]
        by merlin.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mkISK-008lRZ-I8; Tue, 09 Nov 2021 04:09:56 +0000
Subject: Re: [PATCH net v9 3/3] net/8390: apne.c - add 100 Mbit support to
 apne.c driver
To:     Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org,
        geert@linux-m68k.org
Cc:     alex@kazik.de, netdev@vger.kernel.org
References: <20211109040242.11615-1-schmitzmic@gmail.com>
 <20211109040242.11615-4-schmitzmic@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <3d4c9e98-f004-755c-2f30-45b951ede6a6@infradead.org>
Date:   Mon, 8 Nov 2021 20:09:51 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211109040242.11615-4-schmitzmic@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/8/21 8:02 PM, Michael Schmitz wrote:
> diff --git a/drivers/net/ethernet/8390/Kconfig b/drivers/net/ethernet/8390/Kconfig
> index a4130e643342..b22c3cf96560 100644
> --- a/drivers/net/ethernet/8390/Kconfig
> +++ b/drivers/net/ethernet/8390/Kconfig
> @@ -136,6 +136,8 @@ config NE2K_PCI
>   config APNE
>   	tristate "PCMCIA NE2000 support"
>   	depends on AMIGA_PCMCIA
> +	select PCCARD
> +	select PCMCIA
>   	select CRC32

Hi,

There are no other drivers that "select PCCARD" or
"select PCMCIA" in the entire kernel tree.
I don't see any good justification to allow it here.

-- 
~Randy
