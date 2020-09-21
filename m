Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E937F272216
	for <lists+netdev@lfdr.de>; Mon, 21 Sep 2020 13:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIULQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 07:16:15 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60962 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726353AbgIULQP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 07:16:15 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Sep 2020 07:16:14 EDT
Received: from dispatch1-us1.ppe-hosted.com (localhost.localdomain [127.0.0.1])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 677082F1B22;
        Mon, 21 Sep 2020 11:09:10 +0000 (UTC)
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 2462160094;
        Mon, 21 Sep 2020 11:09:10 +0000 (UTC)
Received: from us4-mdac16-19.ut7.mdlocal (unknown [10.7.65.243])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 231E98009B;
        Mon, 21 Sep 2020 11:09:10 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.198])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id A534A280050;
        Mon, 21 Sep 2020 11:09:09 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 480D480064;
        Mon, 21 Sep 2020 11:09:09 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 21 Sep
 2020 12:09:03 +0100
Subject: Re: [PATCH net] sfc: Fix error code in probe
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>
CC:     Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <20200918143311.GD909725@mwanda>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a65bcb6c-a0a0-eb9d-82f0-766cfb3fbc13@solarflare.com>
Date:   Mon, 21 Sep 2020 12:09:00 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200918143311.GD909725@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25674.003
X-TM-AS-Result: No-1.659200-8.000000-10
X-TMASE-MatchedRID: lORh06tOiKiVvdyNUeenHvZvT2zYoYOwC/ExpXrHizxWm0JlHAu9AZv8
        OBKGKGJryV4nwPo8PJ5bCKebpR3kAmohFAYfTz4engIgpj8eDcC063Wh9WVqgmWCfbzydb0giCF
        ykZQ+I/rkwjHXXC/4I7I7zVffJqTz9MczSNkeYuFdAFp9PR8A620k9DEV75rzWrRC8SNfq4Ie+1
        Y24ck3WtQ17CngTb9OBKmZVgZCVnezGTWRXUlrx+EijnvekEIH
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.659200-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25674.003
X-MDID: 1600686550-7cbZsTNaApI7
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/09/2020 15:33, Dan Carpenter wrote:
> This failure path should return a negative error code but it currently
> returns success.
>
> Fixes: 51b35a454efd ("sfc: skeleton EF100 PF driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Acked-by: Edward Cree <ecree@solarflare.com>
Thanks for catching this.
