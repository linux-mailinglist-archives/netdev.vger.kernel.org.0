Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE253517ED
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 19:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235652AbhDARnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 13:43:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234652AbhDARi6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 13:38:58 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9055AC02FEB6;
        Thu,  1 Apr 2021 09:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=/sqwMRuO/Lyty4C5nMLg9Ty/SDjhPOzpiUZZqAcCB4k=; b=Dsm4NcHPU28c7Gz7pL3zZFCfiN
        +ESznWZW0moMrc+HAkbhbZvk4FL8nXXXviCKb5jvXGnbMwFDkiZfl/UWN5IUh54kyPavFjdHYBG/V
        b72yS20xmpHG17IU9JaIZmSufKVJ09GyASpfHBfit+fGdyqbdwL/nE5I9TUHQQcJ5e1rz390RcjV9
        45+6bo+vDtgNO8gIXaRHWuNCFtgi2FSiXtfc0O0DyQcKxEosjBzsY/h0zxOP+B12ruLuAwflbPZNF
        X8meml66J6zcQ3FhPQ4CfoOwsKoPRGrA4nYL6Gow91HtxR+xVHvje8zoZm+G5rcjHiSLxM6sY/n/v
        JnqqOR/g==;
Received: from [2601:1c0:6280:3f0::e0e1]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lS0Bz-006M3N-9a; Thu, 01 Apr 2021 16:29:13 +0000
Subject: Re: linux-next: Tree for Mar 31
 (drivers/phy/marvell/phy-mvebu-cp110-utmi.o)
To:     Kostya Porotchkin <kostap@marvell.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <CO6PR18MB4417A9BE44A8879928B0D0A7CA7B9@CO6PR18MB4417.namprd18.prod.outlook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <b567ac02-c5b1-188e-1431-a903a2a00a34@infradead.org>
Date:   Thu, 1 Apr 2021 09:29:06 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <CO6PR18MB4417A9BE44A8879928B0D0A7CA7B9@CO6PR18MB4417.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/1/21 5:33 AM, Kostya Porotchkin wrote:
> Hi, Randy,
> 
>> -----Original Message-----
>> From: Randy Dunlap <rdunlap@infradead.org>
>> Sent: Wednesday, March 31, 2021 18:28
>> To: Stephen Rothwell <sfr@canb.auug.org.au>; Linux Next Mailing List <linux-
>> next@vger.kernel.org>
>> Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>; Kostya
>> Porotchkin <kostap@marvell.com>; netdev@vger.kernel.org
>> Subject: [EXT] Re: linux-next: Tree for Mar 31 (drivers/phy/marvell/phy-mvebu-
>> cp110-utmi.o)
>>
> 
> 
>>
>> on i386:
>>
>> ld: drivers/phy/marvell/phy-mvebu-cp110-utmi.o: in function
>> `mvebu_cp110_utmi_phy_probe':
>> phy-mvebu-cp110-utmi.c:(.text+0x152): undefined reference to
>> `of_usb_get_dr_mode_by_phy'
>>
> [KP] This driver depends on ARCH_MVEBU (arm64).
> How it happens that it is included in i386 builds?

Due to COMPILE_TEST:

config PHY_MVEBU_CP110_UTMI
	tristate "Marvell CP110 UTMI driver"
	depends on ARCH_MVEBU || COMPILE_TEST
	depends on OF
	select GENERIC_PHY


> 
> Regards
> Kosta
>>
>> Full randconfig file is attached.
>>
>> --


-- 
~Randy

