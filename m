Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8858A4451
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 13:44:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfHaLoJ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 31 Aug 2019 07:44:09 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3987 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726143AbfHaLoJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 07:44:09 -0400
Received: from DGGEML404-HUB.china.huawei.com (unknown [172.30.72.53])
        by Forcepoint Email with ESMTP id 076821186AEDFA088919;
        Sat, 31 Aug 2019 19:44:07 +0800 (CST)
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.34]) by
 DGGEML404-HUB.china.huawei.com ([fe80::b177:a243:7a69:5ab8%31]) with mapi id
 14.03.0439.000; Sat, 31 Aug 2019 19:44:03 +0800
From:   maowenan <maowenan@huawei.com>
To:     David Miller <davem@davemloft.net>,
        "cpaasch@apple.com" <cpaasch@apple.com>
CC:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tim.froidcoeur@tessares.net" <tim.froidcoeur@tessares.net>,
        "matthieu.baerts@tessares.net" <matthieu.baerts@tessares.net>,
        "aprout@ll.mit.edu" <aprout@ll.mit.edu>,
        "edumazet@google.com" <edumazet@google.com>,
        "jtl@netflix.com" <jtl@netflix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "ncardwell@google.com" <ncardwell@google.com>,
        "sashal@kernel.org" <sashal@kernel.org>,
        "ycheng@google.com" <ycheng@google.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Topic: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Index: AQHVX55YYqkinwCtOUunKpnrH9Dyz6cUAA+AgAEi0HA=
Date:   Sat, 31 Aug 2019 11:44:02 +0000
Message-ID: <F95AC9340317A84688A5F0DF0246F3F21AAAA8E1@dggeml532-mbs.china.huawei.com>
References: <20190824060351.3776-1-tim.froidcoeur@tessares.net>
        <400C4757-E7AD-4CCF-8077-79563EA869B1@gmail.com>
        <20190830232657.GL45416@MacBook-Pro-64.local>
 <20190830.192049.1447010488040109227.davem@davemloft.net>
In-Reply-To: <20190830.192049.1447010488040109227.davem@davemloft.net>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.177.96.96]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tim 

 Can you share the reproduce steps for this issue? C or syzkaller is ok.
 Thanks a lot.
 
