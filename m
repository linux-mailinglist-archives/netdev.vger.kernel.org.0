Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08EFF12E6D9
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 14:37:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728374AbgABNhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 08:37:47 -0500
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:33808 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728342AbgABNhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 08:37:47 -0500
X-Virus-Scanned: Proofpoint Essentials engine
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us3.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99F039C0059;
        Thu,  2 Jan 2020 13:37:45 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1395.4; Thu, 2 Jan 2020
 13:37:40 +0000
Subject: Re: [PATCH net-next] sfc: Remove unnecessary dependencies on I2C
To:     Ben Hutchings <ben@decadent.org.uk>,
        <linux-net-drivers@solarflare.com>
CC:     <netdev@vger.kernel.org>
References: <20191231165908.GA329936@decadent.org.uk>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <a83e91a0-dece-3702-6537-0c1ce148fb8a@solarflare.com>
Date:   Thu, 2 Jan 2020 13:37:37 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20191231165908.GA329936@decadent.org.uk>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.5.1010-25142.003
X-TM-AS-Result: No-1.559100-8.000000-10
X-TMASE-MatchedRID: ZrceL/U8jXTmLzc6AOD8DfHkpkyUphL94OB3iDG6iklLxCuBTCXaKoS2
        oc9zOIJx4vM1YF6AJbZFi+KwZZttL9ObmsOXUd7v7Z4ofcsZ/0vA3uQfVY1UMY6HM5rqDwqtFOC
        V+nSJRraBqo1vjsdPhCLj9aJ8D+VcalQJUEF/TTzjME0FhuyavYfMZMegLDIeGU0pKnas+RbnCJ
        ftFZkZizYJYNFU00e7N+XOQZygrvY=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--1.559100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.5.1010-25142.003
X-MDID: 1577972266-cilSCz3tr0cV
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 31/12/2019 16:59, Ben Hutchings wrote:
> Only the SFC4000 code, now moved to sfc-falcon, needed I2C.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Edward Cree <ecree@solarflare.com>

Thanks Ben!
