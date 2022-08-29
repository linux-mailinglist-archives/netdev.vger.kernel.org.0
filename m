Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D89935A452F
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:34:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiH2Ieo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:34:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbiH2Ie1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:34:27 -0400
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E4858507;
        Mon, 29 Aug 2022 01:34:02 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1661762036; bh=1vMZ0dX5dY0+I40JPo+IzGf0b+MZYSJImU8ZR2XqqQs=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=SoCNSiGx48l+rdngjy81aq2A4fYWJspecsZEkjjwEL2b+JT7ZTzGs7NUXr8Jzv82C
         tBewXXCEwolXTcG7vLIXlULQBR5sr2LXgZHuAzR8peB7CXYUrK+922upum0Dtfe8WX
         oqgySWoXR6LZBOnWkekISbb23xJKpdi1Q6talUdNIdqioHryYH9PAYL0CpECe6E1ne
         3LBgIuIA285+22uzfJIRMY/QLrI/st0gbw0ow2HPfMnD1RpTnrYpeYTONOkn25P7xm
         xYZjTCT/haw87O7HyH1qD72e1AxW/raKc5QHvLyOKFxx39tJs3JtklN8Xdc41P1IwS
         ESfgrF2BBdlEQ==
To:     Zhengchao Shao <shaozhengchao@huawei.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        stephen@networkplumber.org
Cc:     cake@lists.bufferbloat.net, weiyongjun1@huawei.com,
        yuehaibing@huawei.com, shaozhengchao@huawei.com
Subject: Re: [PATCH net-next,v2] net: sched: remove redundant NULL check in
 change hook function
In-Reply-To: <20220829071219.208646-1-shaozhengchao@huawei.com>
References: <20220829071219.208646-1-shaozhengchao@huawei.com>
Date:   Mon, 29 Aug 2022 10:33:55 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87fshf78jw.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zhengchao Shao <shaozhengchao@huawei.com> writes:

> Currently, the change function can be called by two ways. The one way is
> that qdisc_change() will call it. Before calling change function,
> qdisc_change() ensures tca[TCA_OPTIONS] is not empty. The other way is
> that .init() will call it. The opt parameter is also checked before
> calling change function in .init(). Therefore, it's no need to check the
> input parameter opt in change function.
>
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>

for sch_cake:

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
