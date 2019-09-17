Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14C48B5131
	for <lists+netdev@lfdr.de>; Tue, 17 Sep 2019 17:15:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728849AbfIQPPC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Sep 2019 11:15:02 -0400
Received: from new2-smtp.messagingengine.com ([66.111.4.224]:55861 "EHLO
        new2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727437AbfIQPPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Sep 2019 11:15:02 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 18F711E4F;
        Tue, 17 Sep 2019 11:15:01 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 17 Sep 2019 11:15:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dxuuu.xyz; h=
        content-transfer-encoding:content-type:date:from:to:cc:subject
        :message-id; s=fm1; bh=obiRstHvVhOQWl+S1fahFk3c9lGmtlq3gpWfhkuZP
        4A=; b=OvjRjDwcNAy5zVydT0Vu7hs90GroEHS1L09ShjMVerYe/oGrtntzGHXOs
        N0RqIZBVLBUUKDDCR5ZL5n6RvWhMR1eDAA7uzrtGznZUU2nFhfF34zJvK/IVHQpk
        PqYpl32ucp5AdFMi4SNk7jz2IqAnKJcCEg9dyLY0PlNGd6u64krhuXOdrxgQf+vF
        Zfw1oq5jSi1Ed63F9thKHWs+0eIpWcCewqb7Jo2wYIiuMIt6jno8OgBys8BYxpjR
        DEdEmobArRlJF64T+mwovAZhYGFVwWZCEeXPirZp/nhkVFShVfW4ne+90U8pjeDq
        1EKxf2bR5UuZaF5UZamPuLgTXt3Lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:subject:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=obiRstHvVhOQWl+S1
        fahFk3c9lGmtlq3gpWfhkuZP4A=; b=MsQ+58ItArbjMDjKnd9OQmJBh0DFBZ4mf
        R2LcfCDmN5qSI9o1hSiI9yV6qugLwPvjYZyQBYMx0LsY29TC0wNslWTB4LWWxblw
        seOChHFdHr7WLgXk8SG/UqZNzqWo01w3Or/iZLrPi46CwzyT8hSnSopPH3IiPRK6
        C+gmxyc3fYfOcps6FOrdA+nktS+ELB6BvuMZUhmNZSibXDtmpLXxFEaO9gIDiRHL
        tfdRHwRjXKQTL5ee9T1M9qzu/xvPhVUV3V1toHrZpVrG/7MDsBkJYJcho3IW1Poa
        idry+lM39l5YRoaQ8jvAURoXqfbyyUH3hJCHXU6rb2VOJoFIJsZtQ==
X-ME-Sender: <xms:c_iAXcKS-FRsC2NmKNT1aEOSrAzo11SBD5vQXuuuq6AHz89nd1Cu8g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudeigdehlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecufghrlhcuvffnffculdejtddmnecujfgurhepgfgtff
    fhvffukfesthhqredttddtjeenucfhrhhomhepfdffrghnihgvlhcuighufdcuoegugihu
    segugihuuhhurdighiiiqeenucfkphepudelledrvddtuddrieeirddtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegugihusegugihuuhhurdighiiinecuvehluhhsthgvrhfuihii
    vgeptd
X-ME-Proxy: <xmx:c_iAXRsoPLzGqx6-xPWx9ZtxzADCsnx-dn97oaEFutrW6TquYvEXow>
    <xmx:c_iAXWTd2qh3cswSzDDQRkeL_T0m3Xhhkfi8TYFJ5lqL0waW2jnJ7w>
    <xmx:c_iAXaRZzjc1dVfnMlrE8lLGxmHAAuLIDgYOOTy0srJzqYDtaDBsdQ>
    <xmx:dfiAXYGCcfhsMS6sNSrBxHZaCu-bv2z98ChKqMQ-VJ8h0EtjgQ2GEzBVmLU>
Received: from localhost (unknown [199.201.66.0])
        by mail.messagingengine.com (Postfix) with ESMTPA id 11CADD6005E;
        Tue, 17 Sep 2019 11:14:57 -0400 (EDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 17 Sep 2019 08:14:57 -0700
From:   "Daniel Xu" <dxu@dxuuu.xyz>
To:     "kbuild test robot" <lkp@intel.com>
Cc:     <kbuild-all@01.org>, <bpf@vger.kernel.org>,
        <songliubraving@fb.com>, <yhs@fb.com>, <andriin@fb.com>,
        <peterz@infradead.org>, <mingo@redhat.com>, <acme@kernel.org>,
        "Daniel Xu" <dxu@dxuuu.xyz>, <ast@fb.com>,
        <alexander.shishkin@linux.intel.com>, <jolsa@redhat.com>,
        <namhyung@kernel.org>, <linux-kernel@vger.kernel.org>,
        <netdev@vger.kernel.org>, <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 1/5] perf/core: Add PERF_FORMAT_LOST
 read_format
Message-Id: <BX2DJJRW6PA5.3GUFKIRSVLU15@dlxu-fedora-R90QNFJV>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue Sep 17, 2019 at 10:32 PM kbuild test robot wrote:
> All errors (new ones prefixed by >>):
>=20
>    kernel/events/core.c: In function 'perf_event_lost':
> >> kernel/events/core.c:4753:11: error: implicit declaration of function =
'perf_kprobe_missed'; did you mean 'perf_release'? [-Werror=3Dimplicit-func=
tion-declaration]
>       lost +=3D perf_kprobe_missed(event);
>               ^~~~~~~~~~~~~~~~~~
>               perf_release
>    cc1: some warnings being treated as errors
>=20

Ah forgot the #ifdef for CONFIG_KPROBE_EVENTS. I've applied the fix and
will send it in the next version.
