Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F26F5A442D
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 12:54:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfHaKy3 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sat, 31 Aug 2019 06:54:29 -0400
Received: from szxga02-in.huawei.com ([45.249.212.188]:3986 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728337AbfHaKy1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 06:54:27 -0400
Received: from DGGEML401-HUB.china.huawei.com (unknown [172.30.72.56])
        by Forcepoint Email with ESMTP id D4F60133D506515C692B;
        Sat, 31 Aug 2019 18:54:17 +0800 (CST)
Received: from DGGEML532-MBS.china.huawei.com ([169.254.7.34]) by
 DGGEML401-HUB.china.huawei.com ([fe80::89ed:853e:30a9:2a79%31]) with mapi id
 14.03.0439.000; Sat, 31 Aug 2019 18:54:16 +0800
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
Subject: Recall: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Topic: [PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty
 retransmit queue
Thread-Index: AdVf6m6MYqkinwCtOUunKpnrH9Dyzw==
X-CallingTelephoneNumber: IPM.Note
X-VoiceMessageDuration: 1
X-FaxNumberOfPages: 0
Date:   Sat, 31 Aug 2019 10:54:16 +0000
Message-ID: <F95AC9340317A84688A5F0DF0246F3F21AAAA832@dggeml532-mbs.china.huawei.com>
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

maowenan would like to recall the message, "[PATCH 4.14] tcp: fix tcp_rtx_queue_tail in case of empty retransmit queue".
