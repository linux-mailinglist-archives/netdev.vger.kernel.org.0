Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 649C9200AD
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 09:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726542AbfEPHwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 03:52:40 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:46016 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726363AbfEPHwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 03:52:40 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 3A78FC2634;
        Thu, 16 May 2019 07:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557993149; bh=9PSf5qStiTiN7G0Rs+TvXW44EQP+VkAyDeSi/WBBYs4=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=a0eafnwhQSLULa6CClpPs+c41eTX/3jFVvLiyys9gpmyen1udET+zciQrygX8MxY+
         jFHJYUvZq8vjZIC9Uf6kOuTXCZlAsjPIk7umk9KgAy1w9y28IJm3n6gBoSAdZG80my
         sgZ8IoI0WWslHe061Oy3ueAoeRwpQceerAf/RLD1KTXaUmreqe2cbCq9ImOEVLkGMS
         ySly7yH5XEjqIwqYGODnZOhMHzmxq7DW9hDrfDzXvkf7xaIaXK8xo8q+VaM8ynRcre
         yyQO80WUz/2MZV5LcYuMhpu5N3MOXc6I5qBahNwAjeqyMzZiPF489oDf8C8sRKx9eu
         IgZ95SATvTv+A==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 2B4E3A0095;
        Thu, 16 May 2019 07:52:34 +0000 (UTC)
Received: from DE02WEHTCA.internal.synopsys.com (10.225.19.92) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Thu, 16 May 2019 00:52:34 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCA.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Thu,
 16 May 2019 09:52:31 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Corentin Labbe <clabbe.montjoie@gmail.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: RE: [RFC net-next v2 00/14] net: stmmac: Selftests
Thread-Topic: [RFC net-next v2 00/14] net: stmmac: Selftests
Thread-Index: AQHVCmwZe0pPTbFIM0O0cHECuOY9LqZsURgAgAER6JA=
Date:   Thu, 16 May 2019 07:52:32 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B9216D0@DE02WEMBXB.internal.synopsys.com>
References: <cover.1557848472.git.joabreu@synopsys.com>
 <20190515172922.GA30321@Red>
In-Reply-To: <20190515172922.GA30321@Red>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Corentin Labbe <clabbe.montjoie@gmail.com>
Date: Wed, May 15, 2019 at 18:29:22

> I will try to investigate the MMC failure. Does -1 (vs other -EXXXX) is t=
he right error code to return from the driver ?

Thank you for testing!

Yes, I will fix to return a valid error code.

As per MMC failure this can be due to your HW not having all MMC counters=20
available. Can you please remove all if conditions in stmmac_test_mmc()=20
and just leave the "mmc_tx_framecount_g" check ?

Thanks,
Jose Miguel Abreu
