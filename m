Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991AA232282
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 18:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgG2QXD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 12:23:03 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:52288 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgG2QXC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jul 2020 12:23:02 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2F66A6009C;
        Wed, 29 Jul 2020 16:23:02 +0000 (UTC)
Received: from us4-mdac16-12.ut7.mdlocal (unknown [10.7.65.236])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2A1BF200A3;
        Wed, 29 Jul 2020 16:23:02 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.175])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 84A381C0055;
        Wed, 29 Jul 2020 16:23:01 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id EFA56700070;
        Wed, 29 Jul 2020 16:23:00 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 29 Jul
 2020 17:22:55 +0100
Subject: Re: [PATCH net-next] sfc_ef100: remove duplicated include from
 ef100_netdev.c
To:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20200729021950.179850-1-yuehaibing@huawei.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <1f137324-de06-8186-e32e-ec7b4c9ed663@solarflare.com>
Date:   Wed, 29 Jul 2020 17:22:52 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200729021950.179850-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25570.005
X-TM-AS-Result: No-1.849100-8.000000-10
X-TMASE-MatchedRID: 4kTn4W3NajPmLzc6AOD8DfHkpkyUphL9GEfoClqBl86bKItl61J/ycnj
        LTA/UDoAmP38c3DNiyQCU1PRf9o2szrAb8A0QSRm+gtHj7OwNO2eVW/ZdL52j6mL38BB4XpI2Jx
        Co7JdH5QOvi0Uj2alF2On29N3B+JX8B1+fkPI48NcLq4mdz+nRKyCWSW0HzF0amjOS5qVJMM7py
        Vyc/F9UH7cGd19dSFd
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.849100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25570.005
X-MDID: 1596039782-HPJeJZ59kahH
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29/07/2020 03:19, YueHaibing wrote:
> Remove duplicated include.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Edward Cree <ecree@solarflare.com>
