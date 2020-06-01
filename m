Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3EAC1EAEE2
	for <lists+netdev@lfdr.de>; Mon,  1 Jun 2020 20:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729805AbgFAS5z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 14:57:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729974AbgFAS5v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 14:57:51 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFAAC061A0E
        for <netdev@vger.kernel.org>; Mon,  1 Jun 2020 11:57:51 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E358120ED480;
        Mon,  1 Jun 2020 11:57:51 -0700 (PDT)
Date:   Mon, 01 Jun 2020 11:57:50 -0700 (PDT)
Message-Id: <20200601.115750.2156418651004039703.davem@davemloft.net>
To:     xiyou.wangcong@gmail.com
Cc:     dcaratti@redhat.com, jhs@mojatatu.com, Po.Liu@nxp.com,
        netdev@vger.kernel.org, ivecera@redhat.com
Subject: Re: [PATCH net-next] net/sched: fix a couple of splats in the
 error path of tfc_gate_init()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAM_iQpWJsbdkPbrD6kve4q9auNfMVmMKp+poduuGKQ15k5CCAw@mail.gmail.com>
References: <c0284a5f2d361658f90a9cada05426051e3c490d.1590703192.git.dcaratti@redhat.com>
        <20200601.113714.711382126517958012.davem@davemloft.net>
        <CAM_iQpWJsbdkPbrD6kve4q9auNfMVmMKp+poduuGKQ15k5CCAw@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 01 Jun 2020 11:57:51 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Mon, 1 Jun 2020 11:48:54 -0700

> You applied a wrong version. There is a V2 of this patch, and I had some
> review for it.

I just noticed that, sorry.

Please send follow-ups, as needed.
