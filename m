Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F723174F6
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 11:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727245AbfEHJUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 05:20:52 -0400
Received: from dc2-smtprelay2.synopsys.com ([198.182.61.142]:57310 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727149AbfEHJUw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 05:20:52 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 69A7DC00FF;
        Wed,  8 May 2019 09:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557307245; bh=n9sL7wuc8FcF1500fyJpY1fWlaHiUIwZw0xsAf6h2no=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=Yak2cg9/nP6D3SK26luT+YtPatCUR9Y2kdGieKd6X9f8bvh6jXtI9Ocl4M7N1mBne
         VCej8ld5NgYDRIibengKgLy9+QM6+BLP7RlFDaegD/X0l34ljpCFTJCQYvVOs6/5kh
         zMERshNGt5egnpCAjXgz9OagIrYjCL3o7J7m233f5AxtKWf3EdwjDPM9EW0ZmfR2hI
         Lmoek2ImEClJOXdd2jy4Zy9w+d1oESz4OCxS98/Wlv06GHKSidkTEn63/YOcTtR8I7
         xEV7+OUoWbwpZb1epMHFIs+99dEm8hLOt6mpICdV1fHDnt1zsvqyYDWdfC4a95561a
         pMeb7R6XCLjuw==
Received: from US01WEHTC2.internal.synopsys.com (us01wehtc2.internal.synopsys.com [10.12.239.237])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 3D5BBA02DD;
        Wed,  8 May 2019 09:20:50 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WEHTC2.internal.synopsys.com (10.12.239.237) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 8 May 2019 02:20:50 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Wed,
 8 May 2019 11:20:48 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Cheng Han <hancheng2009@gmail.com>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] dwmac4_prog_mtl_tx_algorithms() missing write operation
Thread-Topic: [PATCH] dwmac4_prog_mtl_tx_algorithms() missing write operation
Thread-Index: AQHVBT6Utp3kThhxOkaJwHgA4qLfsqZg8/7g
Date:   Wed, 8 May 2019 09:20:47 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B478D51@DE02WEMBXB.internal.synopsys.com>
References: <20190508013657.14766-1-hancheng2009@gmail.com>
In-Reply-To: <20190508013657.14766-1-hancheng2009@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cheng Han <hancheng2009@gmail.com>
Date: Wed, May 08, 2019 at 02:36:57

> Signed-off-by: Cheng Han <hancheng2009@gmail.com>

Please specify that this is for -net tree, write a commit log and add the=20
"Fixes" tag.

Thanks,
Jose Miguel Abreu
