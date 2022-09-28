Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21D3F5ED38D
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:35:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232586AbiI1De5 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Sep 2022 23:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232475AbiI1Dez (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:34:55 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C5F027B01
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:34:53 -0700 (PDT)
Received: from canpemm100009.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Mchrg0k1TzHqMv;
        Wed, 28 Sep 2022 11:32:35 +0800 (CST)
Received: from canpemm500010.china.huawei.com (7.192.105.118) by
 canpemm100009.china.huawei.com (7.192.105.213) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Wed, 28 Sep 2022 11:34:51 +0800
Received: from canpemm500010.china.huawei.com ([7.192.105.118]) by
 canpemm500010.china.huawei.com ([7.192.105.118]) with mapi id 15.01.2375.031;
 Wed, 28 Sep 2022 11:34:51 +0800
From:   "liujian (CE)" <liujian56@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH net-next 0/2] Add helper functions to parse netlink msg of
 ip_tunnel
Thread-Topic: [PATCH net-next 0/2] Add helper functions to parse netlink msg
 of ip_tunnel
Thread-Index: AQHY0apyWP/8VG5pgky2xsQkDXXfg63y2eKAgAFYSNA=
Date:   Wed, 28 Sep 2022 03:34:51 +0000
Message-ID: <8d13b0eec28745a59533674a64c9cf48@huawei.com>
References: <20220926131944.137094-1-liujian56@huawei.com>
 <20220927075855.7c09921b@kernel.org>
In-Reply-To: <20220927075855.7c09921b@kernel.org>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.176.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Jakub Kicinski [mailto:kuba@kernel.org]
> Sent: Tuesday, September 27, 2022 10:59 PM
> To: liujian (CE) <liujian56@huawei.com>
> Cc: davem@davemloft.net; yoshfuji@linux-ipv6.org; dsahern@kernel.org;
> edumazet@google.com; pabeni@redhat.com; netdev@vger.kernel.org
> Subject: Re: [PATCH net-next 0/2] Add helper functions to parse netlink msg
> of ip_tunnel
> 
> On Mon, 26 Sep 2022 21:19:42 +0800 Liu Jian wrote:
> > Add helper functions to parse netlinkmsg of ip_tunnel
> >
> > Liu Jian (2):
> >   net: Add helper function to parse netlink msg of ip_tunnel_encap
> >   net: Add helper function to parse netlink msg of ip_tunnel_parm
> >
> >  include/net/ip_tunnels.h | 66
> ++++++++++++++++++++++++++++++++++++++++
> >  net/ipv4/ipip.c          | 62 ++-----------------------------------
> >  net/ipv6/ip6_tunnel.c    | 37 ++--------------------
> >  net/ipv6/sit.c           | 65 ++-------------------------------------
> 
> Do they need to be in a header file? Could you put them in
> net/ipv4/ip_tunnel.c or net/ipv4/ip_tunnel_core.c instead?
The v2 version has been sent. Thanks for your review.
