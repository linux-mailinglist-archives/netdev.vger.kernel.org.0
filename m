Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABB922DCF58
	for <lists+netdev@lfdr.de>; Thu, 17 Dec 2020 11:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727990AbgLQKPJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Dec 2020 05:15:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:7704 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727796AbgLQKPI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Dec 2020 05:15:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1608200107; x=1639736107;
  h=subject:to:cc:references:from:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=gEkW6RbrgOxi90YpOZkCKsJYSwuRnd4VKz5XMjUVr8U=;
  b=xcGhxuPdRWAsVX7+yeKEj0y5FAdxlvAFvyC9AH9jqkk5/K6uVuug2ksq
   Yw8TkvwMfVlbuws6SuGWGTZ01CI7eYVkrr2UE6FNDGAMtBlcquPxGrPux
   XROgxmT8uwZ5fOH2i2utlrIsA9cL+l8wxyHPERzpcCId40PHs3BPJU1AU
   TlIa3jM6cpwks6TJHaSvfmRUCwggdJ2/xfqOD30rxseY1wOGC9Bwl0doB
   GJJAzdTzFitze01w4w+mWWcicFKJQpU/Z25+swtsbWhiZDTTKIf9i1oVw
   CvnkGhdZ8GXORhnHnXma/L3/U4AZBYGDERS7BfradQaA/7JH1iYn/a511
   w==;
IronPort-SDR: XEIhSz+1243SkrqAaquvhpaycDwjiYjytgf/0ojV8Ra+XGEh7Ub5SegTOh9PrYmkwiHPh9KbLn
 Pl790Ke1EUiS7vYmW3T9r81Eicw8r5rDDCK3xUTlaTjtHmW507fFjDS4WVjSvjas3p4LEpVUOh
 0Mjngbi1OqJbQkCcJgIPAmdYP3EQFre5wvdcTbEVE0zBzLA8GmtkGyvcxPbhCWJ0eI/LQYnuHV
 m9uYSCejclBipVOKhyxrDIW6kI2bbsPp13sNQI+b+9plwmnNJ5dh4/XqCtQdxDxDUPPMUCVhbO
 vyE=
X-IronPort-AV: E=Sophos;i="5.78,426,1599548400"; 
   d="scan'208";a="97439396"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Dec 2020 03:13:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 17 Dec 2020 03:13:50 -0700
Received: from [10.171.246.74] (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 17 Dec 2020 03:13:46 -0700
Subject: Re: [PATCH v3 0/8] net: macb: add support for sama7g5
To:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <robh+dt@kernel.org>,
        <linux@armlinux.org.uk>, <paul.walmsley@sifive.com>,
        <palmer@dabbelt.com>, <natechancellor@gmail.com>,
        <ndesaulniers@google.com>
CC:     <yash.shah@sifive.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-riscv@lists.infradead.org>,
        <clang-built-linux@googlegroups.com>
References: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
From:   Nicolas Ferre <nicolas.ferre@microchip.com>
Organization: microchip
Message-ID: <419c402d-b214-410d-24c4-45c1d2ba388d@microchip.com>
Date:   Thu, 17 Dec 2020 11:13:45 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1607519019-19103-1-git-send-email-claudiu.beznea@microchip.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/12/2020 at 14:03, Claudiu Beznea wrote:
> Hi,
> 
> This series adds support for SAMA7G5 Ethernet interfaces: one 10/100Mbps
> and one 1Gbps interfaces.
> 
> Along with it I also included a fix to disable clocks for SiFive FU540-C000
> on failure path of fu540_c000_clk_init().
> 
> Thank you,
> Claudiu Beznea
> 
> Changed in v3:
> - use clk_bulk_disable_unprepare in patch 3/8
> - corrected clang compilation warning in patch 3/8
> - revert changes in macb_clk_init() in patch 3/8
> 
> Changes in v2:
> - introduced patch "net: macb: add function to disable all macb clocks" and
>    update patch "net: macb: unprepare clocks in case of failure" accordingly
> - collected tags
> 
> Claudiu Beznea (8):
>    net: macb: add userio bits as platform configuration
>    net: macb: add capability to not set the clock rate
>    net: macb: add function to disable all macb clocks
>    net: macb: unprepare clocks in case of failure
>    dt-bindings: add documentation for sama7g5 ethernet interface
>    dt-bindings: add documentation for sama7g5 gigabit ethernet interface
>    net: macb: add support for sama7g5 gem interface
>    net: macb: add support for sama7g5 emac interface

For the whole series:
Acked-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Thanks Claudiu, best regards,
   Nicolas

>   Documentation/devicetree/bindings/net/macb.txt |   2 +
>   drivers/net/ethernet/cadence/macb.h            |  11 ++
>   drivers/net/ethernet/cadence/macb_main.c       | 134 ++++++++++++++++++-------
>   3 files changed, 111 insertions(+), 36 deletions(-)
> 


-- 
Nicolas Ferre
