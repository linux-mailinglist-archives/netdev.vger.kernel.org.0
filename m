Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3037136C94
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728017AbgAJL6K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:58:10 -0500
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60990 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727710AbgAJL6K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:58:10 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 4FB93940060;
        Fri, 10 Jan 2020 11:58:08 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Fri, 10 Jan
 2020 11:58:01 +0000
Subject: Re: [PATCH net-next] sfc: remove duplicated include from ef10.c
To:     YueHaibing <yuehaibing@huawei.com>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
CC:     <netdev@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <kernel-janitors@vger.kernel.org>
References: <20200110013517.37685-1-yuehaibing@huawei.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <422eff3d-05ea-d967-ff1b-448b6dc9dcb5@solarflare.com>
Date:   Fri, 10 Jan 2020 11:57:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200110013517.37685-1-yuehaibing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25158.003
X-TM-AS-Result: No-0.728100-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfjmLzc6AOD8DfHkpkyUphL9MVx/3ZYby795t7W19HpOSInk
        wRg6lRQ7YBSz+G5WOZ1NopDNndSAdcx079ojRyOiuwdUMMznEA/Uk/02d006RVjBUeMsjed6QBz
        oPKhLashO9UxJ8vboSappUg2a/OM2XHEPHmpuRH2DGx/OQ1GV8l/EokdYvzRR+gtHj7OwNO2Ohz
        Oa6g8KrXRn8zaQo/+Meh0Kazpb0bcoszuMlgVLjU3K33XCov4A6yBdeO88+nxyPOdEY4MyA4mZp
        km845EgWff/h11Liu/RPW7LVvsuo+L59MzH0po2K2yzo9Rrj9wPoYC35RuihKPUI7hfQSp5eCBc
        UCG1aJiUTGVAhB5EbQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.728100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25158.003
X-MDID: 1578657489-izF-tTf2gs7g
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/01/2020 01:35, YueHaibing wrote:
> Remove duplicated include.
>
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Edward Cree <ecree@solarflare.com>
but you seem to have come up with a strange CC list, full of bpf maintainers
 rather than sfc driver maintainers; check your submission scripts?  (AFAIK
 the MAINTAINERS file has the right things in.)

-Ed
> ---
>  drivers/net/ethernet/sfc/ef10.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/ethernet/sfc/ef10.c b/drivers/net/ethernet/sfc/ef10.c
> index dc037dd927f8..fa460831af7d 100644
> --- a/drivers/net/ethernet/sfc/ef10.c
> +++ b/drivers/net/ethernet/sfc/ef10.c
> @@ -16,7 +16,6 @@
>  #include "workarounds.h"
>  #include "selftest.h"
>  #include "ef10_sriov.h"
> -#include "rx_common.h"
>  #include <linux/in.h>
>  #include <linux/jhash.h>
>  #include <linux/wait.h>
>
>
>

