Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3C32B04D
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 10:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfE0IfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 04:35:08 -0400
Received: from mx0b-00191d01.pphosted.com ([67.231.157.136]:34906 "EHLO
        mx0a-00191d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725869AbfE0IfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 04:35:07 -0400
Received: from pps.filterd (m0049462.ppops.net [127.0.0.1])
        by m0049462.ppops.net-00191d01. (8.16.0.27/8.16.0.27) with SMTP id x4R8QGcE016624;
        Mon, 27 May 2019 04:34:30 -0400
Received: from tlpd255.enaf.dadc.sbc.com (sbcsmtp3.sbc.com [144.160.112.28])
        by m0049462.ppops.net-00191d01. with ESMTP id 2src6c0b7c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 27 May 2019 04:34:30 -0400
Received: from enaf.dadc.sbc.com (localhost [127.0.0.1])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4R8YSRc046697;
        Mon, 27 May 2019 03:34:29 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [135.46.181.149])
        by tlpd255.enaf.dadc.sbc.com (8.14.5/8.14.5) with ESMTP id x4R8YObi046559
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Mon, 27 May 2019 03:34:24 -0500
Received: from zlp30499.vci.att.com (zlp30499.vci.att.com [127.0.0.1])
        by zlp30499.vci.att.com (Service) with ESMTP id 08648400B57D;
        Mon, 27 May 2019 08:34:24 +0000 (GMT)
Received: from clpi183.sldc.sbc.com (unknown [135.41.1.46])
        by zlp30499.vci.att.com (Service) with ESMTP id DD0CB400B579;
        Mon, 27 May 2019 08:34:23 +0000 (GMT)
Received: from sldc.sbc.com (localhost [127.0.0.1])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id x4R8YLpG022608;
        Mon, 27 May 2019 03:34:23 -0500
Received: from mail.eng.vyatta.net (mail.eng.vyatta.net [10.156.50.82])
        by clpi183.sldc.sbc.com (8.14.5/8.14.5) with ESMTP id x4R8YEgk022206;
        Mon, 27 May 2019 03:34:14 -0500
Received: from gwilkie-Precision-7520 (unknown [10.156.17.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.eng.vyatta.net (Postfix) with ESMTPSA id 7D5DB3600D5;
        Mon, 27 May 2019 01:34:11 -0700 (PDT)
Date:   Mon, 27 May 2019 09:34:02 +0100
From:   George Wilkie <gwilkie@vyatta.att-mail.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Shrijeet Mukherjee <shrijeet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] vrf: local route leaking
Message-ID: <20190527083402.GA7269@gwilkie-Precision-7520>
References: <20190524080551.754-1-gwilkie@vyatta.att-mail.com>
 <0d920356-8d12-b0b5-c14b-3600e54e9390@gmail.com>
 <20190525070924.GA1184@debian10.local>
 <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47e25c7c-1dd4-25ee-1d7b-f8c4c0783573@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-27_06:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_policy_notspam policy=outbound_policy score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1015 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=742 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905270059
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 25, 2019 at 09:13:13AM -0600, David Ahern wrote:
> > Using a loopback doesn't work, e.g. if 10.1.1.0/24 was on a global interface:
> >    ip ro add vrf vrf-a 10.1.1.0/24 dev lo
> 
> That works for MPLS when you exit the LSP and deliver locally, so it
> should work here as well. I'll take a look early next week.

OK, thanks.

> I would prefer to avoid it if possible. VRF route leaking for forwarding
> does not have the second lookup and that is the primary use case. VRL
> with local delivery is a 1-off use case and you could just easily argue
> that the connection should not rely on the leaked route. ie., the
> control plane is aware of both VRFs, and the userspace process could use
> the VRF-B path.
> 

Although it isn't always possible to change the userspace process -
may be running in a specific vrf by 'ip vrf exec'
