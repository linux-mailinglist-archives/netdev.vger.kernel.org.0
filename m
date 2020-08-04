Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E929923BB2D
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 15:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgHDNbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 09:31:23 -0400
Received: from dispatch1-us1.ppe-hosted.com ([67.231.154.164]:40098 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726198AbgHDNbN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Aug 2020 09:31:13 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.50.143])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EFB1F2008A;
        Tue,  4 Aug 2020 13:31:12 +0000 (UTC)
Received: from us4-mdac16-41.at1.mdlocal (unknown [10.110.48.12])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id EDBA6800AC;
        Tue,  4 Aug 2020 13:31:12 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.110.49.108])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99A2E40076;
        Tue,  4 Aug 2020 13:31:12 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 519BA14005A;
        Tue,  4 Aug 2020 13:31:12 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Tue, 4 Aug 2020
 14:31:07 +0100
Subject: Re: [PATCH v3 net-next 11/11] sfc_ef100: add nic-type for VFs, and
 bind to them
To:     David Miller <davem@davemloft.net>, <lkp@intel.com>
CC:     <linux-net-drivers@solarflare.com>, <kbuild-all@lists.01.org>,
        <netdev@vger.kernel.org>
References: <56e8d601-1dbd-f49e-369c-6cbed4d896bf@solarflare.com>
 <202008040935.VN2uKoeZ%lkp@intel.com>
 <20200803.183045.2051223193100039727.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <cea49f2a-d678-665f-5689-3b409e468567@solarflare.com>
Date:   Tue, 4 Aug 2020 14:31:03 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200803.183045.2051223193100039727.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25582.005
X-TM-AS-Result: No-3.488100-8.000000-10
X-TMASE-MatchedRID: e/tT8EyIjJTmLzc6AOD8DfHkpkyUphL9ay49w8WASDcFqrxVoN14Onm9
        LIai61FrNprjl1FQE2bqUwd4lb5Mcr9ZdlL8eonarjgFvJKloAc20PITYKXjDW4KlIF0bhOGec3
        QM3secWbOre6joOUXs7vGlStDFmNG/GMLJuLcPt+pC8EzG4Zc5apDh3yrmKSbooBB8uyeEuspZK
        3gOa9uGmJwouYrZN4qaw+fkLqdalN+3BndfXUhXQ==
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--3.488100-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25582.005
X-MDID: 1596547873-oVE9JHxaJgUf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 04/08/2020 02:30, David Miller wrote:
> I fixed this in my tree as follows:
LGTM.  Thanks for fixing, and thanks robot for catching it.
