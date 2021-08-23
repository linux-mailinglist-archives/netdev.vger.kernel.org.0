Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F36133F48FF
	for <lists+netdev@lfdr.de>; Mon, 23 Aug 2021 12:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236214AbhHWKw0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 06:52:26 -0400
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52863 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234848AbhHWKwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 06:52:25 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 1EE89580A21;
        Mon, 23 Aug 2021 06:51:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 23 Aug 2021 06:51:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ufqiem
        6SAD2gmS09HTUfWTb2O1UhArrikQy5twUdyAM=; b=E/i4PVIBqPIWwQVvxsJ7lB
        /ch89DlRbyc5BxRHqoRS67vkrTz8CMJaXLxv5uNMxxJI5un3sIYR63l7KSJR9+xl
        HqJFeSXGFdUPsfxOmR0Xamo2Gc/2UneCBO4osHK4B81WgneJSEM5muPNVN8NVLaI
        2FpDUI8+I8l+NGp9I0Z2vmMXYGfKa1DTz2zdFENecYjd4TyiuaPcaaoW3ZjK37m0
        37Ic0BYcAOq1NOh9YfwftPs5pEv7amYT5Lq/CxDG2HpbhOQdCfD4L3Hld4H2mP0i
        80bq0Ml9763Z5H/w+AvZ4u/tm1n2mQhE/V6hk9oT9sQI544Y/wlyMtEYFmN0f4dw
        ==
X-ME-Sender: <xms:vX0jYUcyEE8vrmJYXf4ZsIV6Vgz3DTG1KquaUokB8ikSPY-lkZNHIQ>
    <xme:vX0jYWNOe2rS3BFbchYZP14gIExgde03L5Hg3IaNlHIGq9E06IceW6n-HDrR--bkt
    JNhPh_ayb0WH3o>
X-ME-Received: <xmr:vX0jYViqkTNTVzlpd9FncxNu_tbma1rcETYC7Jy1P09CxG0FyamRqjmtPISRcWU9_Bmo8c6kcbNXz_tEzxtDUnk8EabelQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddthedgfeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpeffhffvuffkfhggtggujgesthdtre
    dttddtvdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnheptdffkeekfeduffevgeeujeffjefhte
    fgueeugfevtdeiheduueeukefhudehleetnecuvehluhhsthgvrhfuihiivgeptdenucfr
    rghrrghmpehmrghilhhfrhhomhepihguohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:vX0jYZ8DFHJOiFUiR_bO0CqHgq9oElfpC5FHNHIXEpgQOLhqvRefPA>
    <xmx:vX0jYQspngJOJnnKiJGEajAvpqlU39yiHhmtteL0uCRVcTW2NiMRvw>
    <xmx:vX0jYQH4QRfr4xMozMu46ay9hnn7Id-jH2toU2fw2H56FKhUFp2SPA>
    <xmx:v30jYdM_Qq06SgakyddvTyx_3qFCY4hBio5OT6nQhVMUOC_tsn4UPw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 23 Aug 2021 06:51:40 -0400 (EDT)
Date:   Mon, 23 Aug 2021 13:51:38 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        skhan@linuxfoundation.org, petrm@nvidia.co,
        oleksandr.mazur@plvision.eu, idosch@nvidia.com, jiri@nvidia.com,
        nikolay@nvidia.com, gnault@redhat.com, simon.horman@netronome.com,
        baowen.zheng@corigine.com, danieller@nvidia.com
Subject: Re: [PATCH] selftests/net: Use kselftest skip code for skipped tests
Message-ID: <YSN9uiXAI/LGfjWZ@shredder>
References: <20210823085854.40216-1-po-hsu.lin@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210823085854.40216-1-po-hsu.lin@canonical.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 23, 2021 at 04:58:54PM +0800, Po-Hsu Lin wrote:
> There are several test cases in the net directory are still using
> exit 0 or exit 1 when they need to be skipped. Use kselftest
> framework skip code instead so it can help us to distinguish the
> return status.
> 
> Criterion to filter out what should be fixed in net directory:
>   grep -r "exit [01]" -B1 | grep -i skip
> 
> This change might cause some false-positives if people are running
> these test scripts directly and only checking their return codes,
> which will change from 0 to 4. However I think the impact should be
> small as most of our scripts here are already using this skip code.
> And there will be no such issue if running them with the kselftest
> framework.

Looks OK to me. We are running some of these selftests as part of
regression, so I applied your patch and will report results tomorrow.

Thanks
