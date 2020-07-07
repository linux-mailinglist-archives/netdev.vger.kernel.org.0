Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A355A2176D2
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 20:35:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgGGSfC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jul 2020 14:35:02 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:58972 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728073AbgGGSfC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jul 2020 14:35:02 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.61])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A6411600E4;
        Tue,  7 Jul 2020 18:35:01 +0000 (UTC)
Received: from us4-mdac16-70.ut7.mdlocal (unknown [10.7.64.189])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id A5C04800BA;
        Tue,  7 Jul 2020 18:35:01 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.66.35])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 0295C80070;
        Tue,  7 Jul 2020 18:35:01 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 7FC9D48007B;
        Tue,  7 Jul 2020 18:35:00 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 7 Jul 2020
 19:34:54 +0100
Subject: Re: [PATCH net-next 03/15] sfc_ef100: skeleton EF100 PF driver
To:     kernel test robot <lkp@intel.com>,
        <linux-net-drivers@solarflare.com>, <davem@davemloft.net>
CC:     <kbuild-all@lists.01.org>, <netdev@vger.kernel.org>
References: <b9ccfacc-93c8-5f60-d3a5-ecd87fcef5ee@solarflare.com>
 <202007041218.2NXltj0z%lkp@intel.com>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <24a6f07b-7888-e722-0c4c-41fb3a8f3cc7@solarflare.com>
Date:   Tue, 7 Jul 2020 19:34:51 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202007041218.2NXltj0z%lkp@intel.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25526.003
X-TM-AS-Result: No-5.905300-8.000000-10
X-TMASE-MatchedRID: +c13yJDs902czwUwXNyhwjVUc/h8Ki+CABYRpyLYSPrk1kyQDpEj8Iu3
        renu5Y0w8XVI39JCRnSjfNAVYAJRAtkPVp3JBnY+CWlWR223da4KogTtqoQiBkYuFnR35mKodyG
        0kjowQuNfPdB4I1erZ1/9ixLlAv/alwV2iaAfSWc5f9Xw/xqKXXJnzNw42kCxxEHRux+uk8jHUU
        +U0ACZwCxk9hS/bFnI4fZtGyJTLKM3DiKzYX7ITUVPqJ4sus2Nnqg/VrSZEiM=
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--5.905300-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25526.003
X-MDID: 1594146901-B4Ug2pXIY86v
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/07/2020 05:16, kernel test robot wrote:
>>> drivers/net/ethernet/sfc/ptp.c:1442:1-4: alloc with no test, possible model on line 1457
This one's a false positive, see below:
> vim +1442 drivers/net/ethernet/sfc/ptp.c
>
> 5d0dab01175bff0 Ben Hutchings   2013-10-16  1434  
> ac36baf817c39fc Ben Hutchings   2013-10-15  1435  /* Initialise PTP state. */
> ac36baf817c39fc Ben Hutchings   2013-10-15  1436  int efx_ptp_probe(struct efx_nic *efx, struct efx_channel *channel)
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1437  {
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1438  	struct efx_ptp_data *ptp;
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1439  	int rc = 0;
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1440  	unsigned int pos;
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1441  
> 7c236c43b838221 Stuart Hodgson  2012-09-03 @1442  	ptp = kzalloc(sizeof(struct efx_ptp_data), GFP_KERNEL);
We allocate ptp...
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1443  	efx->ptp_data = ptp;
... assign it to efx->ptp_data...
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1444  	if (!efx->ptp_data)
> 7c236c43b838221 Stuart Hodgson  2012-09-03  1445  		return -ENOMEM;
... which we then test.

So by here...
> 7c236c43b838221 Stuart Hodgson  2012-09-03 @1457  	ptp->workwq = create_singlethread_workqueue("sfc_ptp");
... we know ptp is non-NULL.

-ed
