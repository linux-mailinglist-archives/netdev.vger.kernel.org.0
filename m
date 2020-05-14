Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCF81D3DB7
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 21:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728331AbgENTkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 15:40:23 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:48492 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727991AbgENTkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 15:40:22 -0400
Received: from pps.filterd (m0045851.ppops.net [127.0.0.1])
        by mx0b-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 04EJZvFK006218;
        Thu, 14 May 2020 12:40:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=ioz9s9Db0hD+UoeJk0y10uQzFERgzgWZ1ySFpGLY+cI=;
 b=PvW1/NDs6erhkCCbc2nGigy4oAi1Oq2F0o2GXJH82WmhjcxZFhkd4/oUsSPjVPGgShsF
 ma6zV9fZ79wSCjElJ+ZSV3pQGN8j7Iln+0umaUP3yg601Kkss2hSWE3bs++/eTp8hUJf
 +SLAxWmjUlfJgg3GhbHB9bKQoUrIH2PmDpzKd7jq2FusLRhLlXkhYd9WesKMLOZ6Tb6a
 xi2t7Z1/ieSDivQSPN6i2Yz4JgVKbZOJPN6OOn4z8tgVA6MbRD/atuJUyzxWXv4Bghjb
 wgPJDF0HozYfb3TXqKwxrMnjxBqtviphltygKJLl80Bc2V0zWKwISP9xF0oCHT7mMdYW sg== 
Received: from sc-exch01.marvell.com ([199.233.58.181])
        by mx0b-0016f401.pphosted.com with ESMTP id 3100xk44rr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 14 May 2020 12:40:17 -0700
Received: from DC5-EXCH01.marvell.com (10.69.176.38) by SC-EXCH01.marvell.com
 (10.93.176.81) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 14 May
 2020 12:40:15 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 14 May 2020 12:40:15 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id A6B6D3F7040;
        Thu, 14 May 2020 12:40:13 -0700 (PDT)
Subject: Re: [EXT] Re: [PATCH v2 net-next 00/11] net: qed/qede: critical hw
 error handling
To:     Jakub Kicinski <kuba@kernel.org>
CC:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        "Ariel Elior" <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        "Denis Bolotin" <dbolotin@marvell.com>
References: <20200514095727.1361-1-irusskikh@marvell.com>
 <20200514120659.6f64f6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <2a29996c-21a6-7566-c27e-7b8fb280e18c@marvell.com>
Date:   Thu, 14 May 2020 22:40:12 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:77.0) Gecko/20100101
 Thunderbird/77.0
MIME-Version: 1.0
In-Reply-To: <20200514120659.6f64f6e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.676
 definitions=2020-05-14_07:2020-05-14,2020-05-14 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> I'm not 100% happy that the debug data gets reported to the management
> FW before the devlink health code is in place. For the Linux community,
> I think, having standard Linux interfaces implemented first is the
> priority.

Hi Jakub,

Thanks for the comment. I feel these two are a bit separate. We try to push
important messages to MFW, not debug data. And all these messages are as well
perfectly being reported on device level error printouts, they are not kind of
lost.

And for devlink, we anyway will need all the above infrastructure, to
eventually implement devlink dumps and other features.

Or, may be I didn't get your point?

Thanks,
  Igor
