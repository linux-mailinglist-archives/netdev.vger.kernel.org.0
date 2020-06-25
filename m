Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BE420A0E1
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 16:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405385AbgFYObW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 10:31:22 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:53592 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2404890AbgFYObW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 10:31:22 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 6022D201AF;
        Thu, 25 Jun 2020 14:31:19 +0000 (UTC)
Received: from us4-mdac16-9.at1.mdlocal (unknown [10.110.49.191])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 55E40800B2;
        Thu, 25 Jun 2020 14:31:19 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.104])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id BBD9940072;
        Thu, 25 Jun 2020 14:31:18 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7A2FCB80083;
        Thu, 25 Jun 2020 14:31:18 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 15:31:14 +0100
Subject: Re: [PATCH net 0/4] napi_gro_receive caller return value cleanups
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>
References: <20200624220606.1390542-1-Jason@zx2c4.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <920ef69e-6479-2378-2e47-d0fffc2dc02b@solarflare.com>
Date:   Thu, 25 Jun 2020 15:31:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200624220606.1390542-1-Jason@zx2c4.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1020-25502.003
X-TM-AS-Result: No-0.292800-8.000000-10
X-TMASE-MatchedRID: u1zqiMeMcrrA46G+uSzVzfZvT2zYoYOwC/ExpXrHizxTbQ95zRbWVmUx
        0rFnw+Vpz/KaAXa1nO/lUb21iTHhT1T3aqamtljingIgpj8eDcCcIZLVZAQa0Gsr5yNKIeaXUEh
        Wy9W70AEnRE+fI6etkj8RKt+EnfRxVzQn+kX0xvYGx2McLsfC3VglaSNBu8pKmntKT/QZrppYcq
        TGA0A88Q/QLt7G/oc63pgQ4q/O6wuOSonfQdQNip6oP1a0mRIj
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--0.292800-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1020-25502.003
X-MDID: 1593095479-zdY8vaq9CA6k
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24/06/2020 23:06, Jason A. Donenfeld wrote:
> So, this series simply gets rid of the return value checking for the
> four useless places where that check never evaluates to anything
> meaningful.
I don't know much about the details of these drivers, but asfar as
 the general concept of the series is concerned,
Acked-by: Edward Cree <ecree@solarflare.com>
 as per my reply on the thread you linked.
