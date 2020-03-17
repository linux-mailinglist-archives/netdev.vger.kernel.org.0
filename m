Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A9DB187773
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 02:31:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729964AbgCQB3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 21:29:47 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:35474 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729643AbgCQB3V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 21:29:21 -0400
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A751010005E;
        Tue, 17 Mar 2020 01:29:19 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Tue, 17 Mar
 2020 01:29:11 +0000
Subject: Re: [PATCH net-next 1/9] net: sfc: reject unsupported coalescing
 params
To:     Jakub Kicinski <kuba@kernel.org>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-net-drivers@solarflare.com>,
        <mhabets@solarflare.com>, <jaswinder.singh@linaro.org>,
        <ilias.apalodimas@linaro.org>, <Jose.Abreu@synopsys.com>,
        <andy@greyhouse.net>, <grygorii.strashko@ti.com>, <andrew@lunn.ch>,
        <michal.simek@xilinx.com>, <radhey.shyam.pandey@xilinx.com>,
        <mkubecek@suse.cz>
References: <20200316204712.3098382-1-kuba@kernel.org>
 <20200316204712.3098382-2-kuba@kernel.org>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <10298329-6f0b-8a91-e51f-499ea45fac4b@solarflare.com>
Date:   Tue, 17 Mar 2020 01:29:02 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200316204712.3098382-2-kuba@kernel.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25296.003
X-TM-AS-Result: No-1.537300-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxbmLzc6AOD8DfHkpkyUphL9wwD0mzFpRrd0+4P4W65ejqlO
        2ekqlDI68M1BQSuxIAYXW7oNRX6ypXbI+PVdeqUpiVJZi91I9Jh9LQinZ4QefL6qvLNjDYTwIq9
        5DjCZh0zLOq+UXtqwWAtuKBGekqUpnH7sbImOEBQLfTZDqgvNZeIyXAnWFg7dZ7jRYIlzRnz3Cq
        U3Tst+nJyAWsk/zKrmUdNvZjjOj9C63BPMcrcQuXeYWV2RaAfD8VsfdwUmMsnAvpLE+mvX8g==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.537300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25296.003
X-MDID: 1584408560-yUa8Xb0KDgHj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/03/2020 20:47, Jakub Kicinski wrote:
> Set ethtool_ops->supported_coalesce_params to let
> the core reject unsupported coalescing parameters.
>
> This driver did not previously reject unsupported parameters.
> The check for use_adaptive_tx_coalesce will now be done by
> the core.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Acked-by: Edward Cree <ecree@solarflare.com>
