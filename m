Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E9A196A33
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 22:24:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730804AbfHTUYN convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 20 Aug 2019 16:24:13 -0400
Received: from clt-mbsout-01.mbs.boeing.net ([130.76.144.162]:24378 "EHLO
        clt-mbsout-01.mbs.boeing.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728283AbfHTUYM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 16:24:12 -0400
Received: from localhost (localhost [127.0.0.1])
        by clt-mbsout-01.mbs.boeing.net (8.14.4/8.14.4/DOWNSTREAM_MBSOUT) with SMTP id x7KKO8kQ021542;
        Tue, 20 Aug 2019 16:24:09 -0400
Received: from XCH16-04-10.nos.boeing.com (xch16-04-10.nos.boeing.com [144.115.66.88])
        by clt-mbsout-01.mbs.boeing.net (8.14.4/8.14.4/UPSTREAM_MBSOUT) with ESMTP id x7KKNwSG020442
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=FAIL)
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 16:23:58 -0400
Received: from XCH16-04-08.nos.boeing.com (144.115.66.86) by
 XCH16-04-10.nos.boeing.com (144.115.66.88) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.1.1713.5; Tue, 20 Aug 2019 13:23:57 -0700
Received: from XCH16-04-08.nos.boeing.com ([fe80::e17a:9526:b2ae:8c93]) by
 XCH16-04-08.nos.boeing.com ([fe80::e17a:9526:b2ae:8c93%2]) with mapi id
 15.01.1713.004; Tue, 20 Aug 2019 13:23:57 -0700
From:   "Tran (US), Katherine K" <katherine.k.tran@boeing.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: IPv6 user level fragmentation & reassembly
Thread-Topic: IPv6 user level fragmentation & reassembly
Thread-Index: AdVXhP0a5txcn1FvRiK6VZfo2m92zQ==
Date:   Tue, 20 Aug 2019 20:23:57 +0000
Message-ID: <aca1e04da7c0487abbf5da64ce3bbe45@boeing.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.137.12.6]
x-tm-snts-smtp: A471E3F21E5A87F5044AB4316ECAE16B02E2CE6688A89FF9750E0B2ABEB4FEFE2000:8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-TM-AS-GCONF: 00
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

Would anyone have suggestions/recommendation for an existing API or program (preferably open source) that implements user level fragmentation and reassembly for IPv6? 

Thanks
