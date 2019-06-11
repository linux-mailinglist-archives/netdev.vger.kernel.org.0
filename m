Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 333B73D582
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 20:30:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfFKSaT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 14:30:19 -0400
Received: from merlin.infradead.org ([205.233.59.134]:58272 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727748AbfFKSaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 14:30:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=SRqwQ9Cq+VPPpQF4UBPOMXEl0SwrucZG3aVfiVN5Xaw=; b=dCUhd3Vwk6n2kdZ6NtCrgg1uAD
        nemybzhK0ahpNgOXaBV+1o8Hdjlfrpbs4HHUuBRROanNgi+e+OzlULEk+t0+KOR2WeA54ZM1P5BYk
        AhEasXPyNPyNJGtgztMZd886ilZDFBBNczr3V197/tEC/RCeSvc+kUK+GtOTLuA5amEBOlnjN9y+l
        uY1Dm2hPs7CmyvHxZXM+ITYJEoaNYwijCnIsXyS8A6kgTudCsflg6QVOkYLLalfUFL4IOq8M/Ws0A
        NgFx0rMOv1VY3QaQ9/OtjnXfeglsCCdNM0h0noxnjfnfQ0DWgwFC5r8o+0XYZgoFBrmumhTNxvJ9o
        ijwn/HOQ==;
Received: from static-50-53-52-16.bvtn.or.frontiernet.net ([50.53.52.16] helo=dragon.dunlab)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1halXE-0006et-ME; Tue, 11 Jun 2019 18:30:16 +0000
Subject: Re: linux-next: Tree for Jun 11 (net/dsa/tag_sja1105.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Vladimir Oltean <olteanv@gmail.com>
References: <20190611192432.1d8f11b2@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <12e489ae-d3d9-0390-dee7-0da6301fdcf8@infradead.org>
Date:   Tue, 11 Jun 2019 11:30:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190611192432.1d8f11b2@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/11/19 2:24 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20190607:
> 

on i386:

#
# Library routines
#
# CONFIG_PACKING is not set

ld: net/dsa/tag_sja1105.o: in function `sja1105_rcv':
tag_sja1105.c:(.text+0x40b): undefined reference to `packing'
ld: tag_sja1105.c:(.text+0x423): undefined reference to `packing'
ld: tag_sja1105.c:(.text+0x43e): undefined reference to `packing'
ld: tag_sja1105.c:(.text+0x456): undefined reference to `packing'
ld: tag_sja1105.c:(.text+0x471): undefined reference to `packing'


Should this driver select PACKING?


-- 
~Randy
