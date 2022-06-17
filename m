Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12BDD54FCE5
	for <lists+netdev@lfdr.de>; Fri, 17 Jun 2022 20:28:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbiFQS0Q convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 17 Jun 2022 14:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230122AbiFQS0Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jun 2022 14:26:16 -0400
Received: from relay1-d.mail.gandi.net (relay1-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::221])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A75C730F7A;
        Fri, 17 Jun 2022 11:26:14 -0700 (PDT)
Received: (Authenticated sender: pbl@bestov.io)
        by mail.gandi.net (Postfix) with ESMTPSA id 78C13240005;
        Fri, 17 Jun 2022 18:26:08 +0000 (UTC)
Mime-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset=UTF-8
Date:   Fri, 17 Jun 2022 20:26:07 +0200
Message-Id: <CKSMCVPQ37DW.1WE1OE0CGQUX0@enhorning>
Cc:     "David S . Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Eric Dumazet" <edumazet@google.com>,
        "Jakub Kicinski" <kuba@kernel.org>,
        "Paolo Abeni" <pabeni@redhat.com>, <kernel-team@android.com>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        "Miaohe Lin" <linmiaohe@huawei.com>,
        =?utf-8?q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Subject: Re: [PATCH v2] ipv4: ping: fix bind address validity check
From:   "Riccardo Paolo Bestetti" <pbl@bestov.io>
To:     "Carlos Llamas" <cmllamas@google.com>
X-Mailer: aerc 0.9.0
References: <20220617085435.193319-1-pbl@bestov.io>
 <YqyuOfvR4mesRTfe@google.com>
In-Reply-To: <YqyuOfvR4mesRTfe@google.com>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri Jun 17, 2022 at 6:39 PM CEST, Carlos Llamas wrote:
> Thanks Riccardo for adding the test cases. I would appreciate it if next
> time you add a co-developed tag or maybe a separate commit as opposed to
> overriding the original author. This is fine though.

For context, I had the whole patch ready since a few days ago. This
morning I woke up to the v1, so I decided to just apply my tests and
send it off as a v2.

I evidently forgot to add the Co-developed-by in the process, for which
I apologize. I wish that could be fixed, but the patch was almost
immediately applied to the tree. (I stand by the choice of having a
single commit for the fix, however.)

Riccardo P. Bestetti

