Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37FF7539DF8
	for <lists+netdev@lfdr.de>; Wed,  1 Jun 2022 09:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350265AbiFAHQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 03:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350844AbiFAHPy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 03:15:54 -0400
Received: from mailgw01.mediatek.com (unknown [60.244.123.138])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50282A26E6;
        Wed,  1 Jun 2022 00:15:36 -0700 (PDT)
X-UUID: 716a8cf323a7496ba4f7d438554a5a9b-20220601
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.5,REQID:1aa1ea8f-56af-4e4f-9002-5fef85241bad,OB:0,LO
        B:0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_Ham,ACT
        ION:release,TS:54
X-CID-INFO: VERSION:1.1.5,REQID:1aa1ea8f-56af-4e4f-9002-5fef85241bad,OB:0,LOB:
        0,IP:0,URL:0,TC:0,Content:0,EDM:0,RT:0,SF:54,FILE:0,RULE:Release_HamU,ACTI
        ON:release,TS:54
X-CID-META: VersionHash:2a19b09,CLOUDID:67008514-f88c-475e-badf-d9ee54230b8f,C
        OID:d03bb2fe049f,Recheck:0,SF:28|16|19|48,TC:nil,Content:0,EDM:-3,IP:nil,U
        RL:1,File:nil,QS:0,BEC:nil
X-UUID: 716a8cf323a7496ba4f7d438554a5a9b-20220601
Received: from mtkmbs10n1.mediatek.inc [(172.21.101.34)] by mailgw01.mediatek.com
        (envelope-from <lina.wang@mediatek.com>)
        (Generic MTA with TLSv1.2 ECDHE-RSA-AES256-GCM-SHA384 256/256)
        with ESMTP id 748532127; Wed, 01 Jun 2022 15:15:27 +0800
Received: from mtkmbs11n2.mediatek.inc (172.21.101.187) by
 mtkmbs10n1.mediatek.inc (172.21.101.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.792.15; Wed, 1 Jun 2022 15:15:26 +0800
Received: from mbjsdccf07.mediatek.inc (10.15.20.246) by
 mtkmbs11n2.mediatek.inc (172.21.101.73) with Microsoft SMTP Server id
 15.2.792.3 via Frontend Transport; Wed, 1 Jun 2022 15:15:25 +0800
From:   Lina Wang <lina.wang@mediatek.com>
To:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
CC:     Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Maciej enczykowski <maze@google.com>, <netdev@vger.kernel.org>,
        <linux-kselftest@vger.kernel.org>, <bpf@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lkp@intel.com>,
        <rong.a.chen@intel.com>, kernel test robot <oliver.sang@intel.com>
Subject: Re: [PATCH] selftests net: fix bpf build error
Date:   Wed, 1 Jun 2022 15:08:44 +0800
Message-ID: <20220601070844.10515-1-lina.wang@mediatek.com>
X-Mailer: git-send-email 2.18.0
In-Reply-To: <9c462ffc-f2c0-f542-4e61-251571da8c22@iogearbox.net>
References: <9c462ffc-f2c0-f542-4e61-251571da8c22@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,T_SCC_BODY_TEXT_LINE,
        T_SPF_HELO_TEMPERROR,T_SPF_TEMPERROR,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2022-06-01 at 01:01 +0200, Daniel Borkmann wrote:
> On 5/30/22 8:21 AM, Lina Wang wrote:
> clang -O2 -target bpf -c bpf/nat6to4.c -I../../bpf -I../../../../lib
> -I../../../../../usr/include/ -o
> /root/daniel/bpf/tools/testing/selftests/net/bpf/nat6to4.o
> In file included from bpf/nat6to4.c:27:
> In file included from /usr/include/linux/bpf.h:11:
> /usr/include/linux/types.h:5:10: fatal error: 'asm/types.h' file not
> found
> #include <asm/types.h>
>           ^~~~~~~~~~~~~
> 1 error generated.

maybe your pc is ubuntu or Debian, you should apt-get install gcc-multilib, 
guys on the internet meets the same problem when build libbpf related, just
install gcc-multilib package

> Could we reuse the build infra from tools/testing/selftests/bpf/ for nat6to4.c?

We discussed it before, please refer to https://patchwork.kernel.org/project/netdevbpf/patch/20220407084727.10241-1-lina.wang@mediatek.com/

Thanks!

