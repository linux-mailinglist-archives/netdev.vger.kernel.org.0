Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD8E922EBD1
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 14:13:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgG0MNw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 08:13:52 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:50090 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726555AbgG0MNv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 08:13:51 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.60])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 52BE860096;
        Mon, 27 Jul 2020 12:13:51 +0000 (UTC)
Received: from us4-mdac16-53.ut7.mdlocal (unknown [10.7.66.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 5098E2009A;
        Mon, 27 Jul 2020 12:13:51 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id D85B91C0051;
        Mon, 27 Jul 2020 12:13:50 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7B9D048005F;
        Mon, 27 Jul 2020 12:13:50 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Mon, 27 Jul
 2020 13:13:44 +0100
Subject: Re: [PATCH 2/7] sfc: drop unnecessary list_empty
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        Solarflare linux maintainers <linux-net-drivers@solarflare.com>
CC:     <kernel-janitors@vger.kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <1595761112-11003-1-git-send-email-Julia.Lawall@inria.fr>
 <1595761112-11003-3-git-send-email-Julia.Lawall@inria.fr>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <f8564082-0dad-a1a7-9d2e-198b429b58d4@solarflare.com>
Date:   Mon, 27 Jul 2020 13:13:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1595761112-11003-3-git-send-email-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25566.005
X-TM-AS-Result: No-1.399100-8.000000-10
X-TMASE-MatchedRID: fgYTp5XatxaHYS4ybQtcOvZvT2zYoYOwC/ExpXrHizwumZeX1WIQ8L88
        DvjRvF4An1Vi+LJeakUDvaj804LnkIwPUiPqp90EngIgpj8eDcC063Wh9WVqgmWCfbzydb0gsFZ
        /31Unt9AV0D/96nhBQ90H8LFZNFG76sBnwpOylLOFBEdPN6KLPexVt431s/sfUrA4AyYCpjRnnG
        sVz5KGCUq+D/qldGfLBsRAh8WmTAcG2WAWHb2qekrMHC7kmmSWJy4DmWREnABDDKa3G4nrLQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10-1.399100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25566.005
X-MDID: 1595852031-PHB02brAlX_u
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26/07/2020 11:58, Julia Lawall wrote:
> list_for_each_safe is able to handle an empty list.
> The only effect of avoiding the loop is not initializing the
> index variable.
> Drop list_empty tests in cases where these variables are not
> used.
Sure, why not.
Acked-by: Edward Cree <ecree@solarflare.com>
