Return-Path: <netdev+bounces-5949-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 531C571397C
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 14:53:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CF54E1C2098E
	for <lists+netdev@lfdr.de>; Sun, 28 May 2023 12:53:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2A70620FD;
	Sun, 28 May 2023 12:53:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D67C1384
	for <netdev@vger.kernel.org>; Sun, 28 May 2023 12:53:54 +0000 (UTC)
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 431CEB9;
	Sun, 28 May 2023 05:53:52 -0700 (PDT)
Received: from dggpemm500012.china.huawei.com (unknown [172.30.72.53])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4QTdlF2Dngz18LS2;
	Sun, 28 May 2023 20:49:13 +0800 (CST)
Received: from localhost.localdomain (10.175.124.27) by
 dggpemm500012.china.huawei.com (7.185.36.89) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.23; Sun, 28 May 2023 20:53:47 +0800
From: gaoxingwang <gaoxingwang1@huawei.com>
To: <edumazet@google.com>
CC: <davem@davemloft.net>, <dsahern@kernel.org>, <gaoxingwang1@huawei.com>,
	<liaichun@huawei.com>, <linux-kernel@vger.kernel.org>,
	<netdev@vger.kernel.org>, <pabeni@redhat.com>, <yanan@huawei.com>,
	<yoshfuji@linux-ipv6.org>
Subject: Re: ip6_gre: paninc in ip6gre_header
Date: Sun, 28 May 2023 20:53:25 +0800
Message-ID: <20230528125325.913443-1-gaoxingwang1@huawei.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <CANn89iLzMBJE31VBL3jtu-ojdoAYwV_KLo1Qo+L6LWZ+5UKMtg@mail.gmail.com>
References: <CANn89iLzMBJE31VBL3jtu-ojdoAYwV_KLo1Qo+L6LWZ+5UKMtg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.124.27]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemm500012.china.huawei.com (7.185.36.89)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Thanks for your reply. As a newbie,I'm sorry to bother you with this problem. 

>Yes, there is a fix already.
I'm not sure which patch fixes this problem, would you mind to provide a commit id?
So that I can fix my kernel by patching it.

