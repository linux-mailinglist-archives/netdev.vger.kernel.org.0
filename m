Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A44F11D3EB4
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgENUJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:09:15 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:58886 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726128AbgENUJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:09:13 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EK5cOS026124;
        Thu, 14 May 2020 13:09:12 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=P/9CelUr/wrmGSDBYd3NdOSitpRXmmRYm4nL3IDSRE0=;
 b=n6KpS6PjNkefxNxopKMijZQ6Oqr+eemstvCa9vBu7l52sfEk4Iiwf2bWHCPVzPEt7i2E
 mQEukSqN2jadsHW0QolyIfZt3l627V9FazrqQo4kwdGvMNoDkXijR4PH3angMVeaJCQz
 8H99ht5uTPIyChx+hIP9hoy2kWRaZ86RhsLTjuLWDPXMPLJ1ygdU1KMx91+4MPVevq0O
 r2g5dUmkTsIcNDkN64ZgypI11tCvvlzY25W57nJyzgbifGCovft1W3V5JyxjJYYaV5nq
 otPlhbSlZ3NJF4+8BKoxh9wezGFr+1332mYpT+4V3NhcZUrDq6oOWNsuvyzXtijhtQb3 Mw== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 3100xamd43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 13:09:12 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 13:09:10 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 13:09:10 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id D93103F7040;
        Thu, 14 May 2020 13:09:08 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw
 error handling
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
 <20200514120659.6f64f6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <2a29996c-21a6-7566-c27e-7b8fb280e18c@marvell.com>
 <20200514130241.177c3e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <1839baf9-ea0e-722b-c720-d02d24d3d480@marvell.com>
Date:   Thu, 14 May 2020 23:09:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200514130241.177c3e2d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_07:2020-05-14,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 14/05/2020 11:02 pm, Jakub Kicinski wrote:

> That's fine, I'm just saying - I hope the devlink part doesn't take too
> long to implement :)
> 

> I'm only applying this series because I trust that you will actually do
> the
> devlink work, and you will have it done and submitted in a reasonable
> amount
> of ti me.

I see. Thanks Jakub, David. Doing hard already on devlink side.

> Also, patch #4 had trailing empty lines added to a file, which is
> warned about by 'git' when I apply your patches.  I fixed it up, but
> this is the kind of thing you should have sorted out before you submit
> changes to the list.

Sorry for that miss, will do in future.

Thanks
  Igor
