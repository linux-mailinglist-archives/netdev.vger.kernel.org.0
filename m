Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D72823382D
	for <lists+netdev@lfdr.de>; Thu, 30 Jul 2020 20:11:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730399AbgG3SLP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 14:11:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60750 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727835AbgG3SLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jul 2020 14:11:10 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D4256600CB;
        Thu, 30 Jul 2020 18:11:07 +0000 (UTC)
Received: from us4-mdac16-18.ut7.mdlocal (unknown [10.7.65.242])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id D2857200A0;
        Thu, 30 Jul 2020 18:11:07 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4CBA61C0076;
        Thu, 30 Jul 2020 18:11:07 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E4FF7700068;
        Thu, 30 Jul 2020 18:11:06 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 30 Jul
 2020 19:10:53 +0100
Subject: Re: [PATCH net-next 00/12] sfc: driver for EF100 family NICs, part 2
From:   Edward Cree <ecree@solarflare.com>
To:     <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>
References: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Message-ID: <d803d0cc-4533-9026-85e4-75f549c99f6a@solarflare.com>
Date:   Thu, 30 Jul 2020 19:10:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <abac4f27-7fac-2bd4-636b-4cfc401603ae@solarflare.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25572.005
X-TM-AS-Result: No-5.231800-8.000000-10
X-TMASE-MatchedRID: +c13yJDs902p5Rjnl5atAvZvT2zYoYOwC/ExpXrHizxTbQ95zRbWVogn
        LdHU7oiOICZEOWQkXtluB4JKL0LRr2u9i81cUykFhL9NX2TqmkCi8D/o42y/StUf6bWFkfAu5TL
        6apB3DsrRwvTbbD2NMX8BpiJwfCVVXHEPHmpuRH2DGx/OQ1GV8mrz/G/ZSbVq+gtHj7OwNO2J8Y
        JgRrgXF0HfhiZLfXdxcP/ujgmW8cOSbl/seemZHIaYrMFMCsGZ
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.231800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25572.005
X-MDID: 1596132667-c0uPZTQ1bGaP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 30/07/2020 15:31, Edward Cree wrote:
> This series implements the data path and various other functionality
>  for Xilinx/Solarflare EF100 NICs.
Drop this series; besides the build error (which looks like missing
 ifdeffery for CONFIG_RFS_ACCEL=n), patch #10 introduces a crash
 because the phy_ops aren't hooked up so e.g. get_link_ksettings
 tries to call NULL.
I'll try and spin v2 in the next few days to fix both issues (and
 hope there's an -rc8 ;)

-ed
