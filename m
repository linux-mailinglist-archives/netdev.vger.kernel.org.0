Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48AF0243BFA
	for <lists+netdev@lfdr.de>; Thu, 13 Aug 2020 16:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgHMOzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Aug 2020 10:55:35 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:59884 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726622AbgHMOzd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Aug 2020 10:55:33 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.150])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id E1DBF200C9;
        Thu, 13 Aug 2020 14:55:31 +0000 (UTC)
Received: from us4-mdac16-65.at1.mdlocal (unknown [10.110.50.184])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id DEBBB800A3;
        Thu, 13 Aug 2020 14:55:31 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 6948D100080;
        Thu, 13 Aug 2020 14:55:31 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 2384814005B;
        Thu, 13 Aug 2020 14:55:31 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 13 Aug
 2020 15:55:25 +0100
Subject: Re: [PATCH] sfc_ef100: Fix build failure on powerpc
To:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Solarflare linux maintainers" <linux-net-drivers@solarflare.com>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        "Jakub Kicinski" <kuba@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        <netdev@vger.kernel.org>
References: <44e26ec6a1bc01b5b138c29b623c83d5846718b2.1597329390.git.christophe.leroy@csgroup.eu>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <fe9bfb29-cef3-51e6-71ab-886e02996ec4@solarflare.com>
Date:   Thu, 13 Aug 2020 15:55:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <44e26ec6a1bc01b5b138c29b623c83d5846718b2.1597329390.git.christophe.leroy@csgroup.eu>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25600.005
X-TM-AS-Result: No-5.375500-8.000000-10
X-TMASE-MatchedRID: 7ySqCuYCpfgZKb71Tl2YYfZvT2zYoYOwC/ExpXrHizzAlr9zf1x/lojw
        YzF1DjNPWiR9CUpDXWeo+OAAmru7hxxtkIHKGuMRT3nBCKOvAEvpVMb1xnESMsz/SxKo9mJ4wQ3
        t1bD9XwKRY9dCWcgj9mJwCsb/Z8alTX7PJ/OU3vKDGx/OQ1GV8vaSyLmE5Bx3+gtHj7OwNO2Ohz
        Oa6g8KrV90guFwhBetqWzlavUblWzUlw+R3vVZXldVttIi2JlLK2TLqpu5/SM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.375500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25600.005
X-MDID: 1597330531-ci2M3Uh6fLvl
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/08/2020 15:39, Christophe Leroy wrote:
> ppc6xx_defconfig fails building sfc.ko module, complaining
> about the lack of _umoddi3 symbol.
>
> This is due to the following test
>
>  		if (EFX_MIN_DMAQ_SIZE % reader->value) {
>
> Because reader->value is u64.
Already fixed in net.git by 41077c990266 ("sfc: fix ef100 design-param checking").
But thanks anyway.
