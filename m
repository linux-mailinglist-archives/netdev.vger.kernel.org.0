Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E4FE533B90
	for <lists+netdev@lfdr.de>; Wed, 25 May 2022 13:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243159AbiEYLQh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 May 2022 07:16:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243019AbiEYLQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 May 2022 07:16:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44987A0D04;
        Wed, 25 May 2022 04:16:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 790966149C;
        Wed, 25 May 2022 11:16:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EDCC385B8;
        Wed, 25 May 2022 11:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653477367;
        bh=zvHvvKhh15Y2BqWukRDNqFM8VSwimq+KIzL7XmZ+I+I=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=awLyCuscCEosO88GzDNL/5EqsLe6Yejfb7d/ZZypbejB5j3JPDEJvi4ZvW/ZBPePx
         eLJEizQo17DMkAuImvuGZPRkeeKVxg6Eibsu8bFBKgZyHmUms8LQinfh6Zez0/tI1H
         NL4qPUxMtTX4/Azc6hdQqMzjhaeQWFm65gWkLl5/6EfgW3TDLJq3PT4FRs2CQhc4GQ
         1o6bPcmXFbgJBxaRjFVdXe4J9R8F3zUIPhxUw0CEOqflsWpF90HuxxjOf1J4zZNxmF
         gHRPA6Vwy9aQ+223HXtyYz6qN9p+n9y+XRosGNqZq9xSc1YpAzw6A429NXME+6L1Fq
         l/+mbPh49pnwQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id B41F23DED4C; Wed, 25 May 2022 13:16:05 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH v3,bpf-next] samples/bpf: check
 detach prog exist or
 not in xdp_fwd
In-Reply-To: <eb8ee7fe2ffc477299eb2eceb622ca29@huawei.com>
References: <20220521043509.389007-1-shaozhengchao@huawei.com>
 <eb8ee7fe2ffc477299eb2eceb622ca29@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 25 May 2022 13:16:05 +0200
Message-ID: <87leupooay.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Hi Toke,
> Do you have any more feedback? Does it look better to you now?

Ah, sorry, missed your v3; replied now. Please make sure to add me
directly to Cc on any follow-ups to make sure I don't miss them :)

-Toke
