Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2C0A20ABD0
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 07:25:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727956AbgFZFY6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 01:24:58 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:44706 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725306AbgFZFY5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 01:24:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2C8612052E;
        Fri, 26 Jun 2020 07:24:56 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Vl9TWjW4tXJo; Fri, 26 Jun 2020 07:24:55 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 901522006F;
        Fri, 26 Jun 2020 07:24:55 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Fri, 26 Jun 2020 07:24:55 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 26 Jun
 2020 07:24:55 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id B6F8D3180155;
 Fri, 26 Jun 2020 07:24:54 +0200 (CEST)
Date:   Fri, 26 Jun 2020 07:24:54 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Petr =?utf-8?B?VmFuxJtr?= <pv@excello.cz>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v2] xfrm: introduce oseq-may-wrap flag
Message-ID: <20200626052454.GC19286@gauss3.secunet.de>
References: <20200525154633.GB22403@atlantis>
 <20200530123912.GA7476@arkam>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200530123912.GA7476@arkam>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 02:39:12PM +0200, Petr Vaněk wrote:
> RFC 4303 in section 3.3.3 suggests to disable anti-replay for manually
> distributed ICVs in which case the sender does not need to monitor or
> reset the counter. However, the sender still increments the counter and
> when it reaches the maximum value, the counter rolls over back to zero.
> 
> This patch introduces new extra_flag XFRM_SA_XFLAG_OSEQ_MAY_WRAP which
> allows sequence number to cycle in outbound packets if set. This flag is
> used only in legacy and bmp code, because esn should not be negotiated
> if anti-replay is disabled (see note in 3.3.3 section).
> 
> Signed-off-by: Petr Vaněk <pv@excello.cz>

Now applied to ipsec-next, thanks a lot!
