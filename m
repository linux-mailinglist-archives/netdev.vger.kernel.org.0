Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1909544EABD
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 16:42:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235142AbhKLPpp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 10:45:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233793AbhKLPpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 10:45:44 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAE82C061766;
        Fri, 12 Nov 2021 07:42:53 -0800 (PST)
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id BBC4A501046D3;
        Fri, 12 Nov 2021 07:42:44 -0800 (PST)
Date:   Fri, 12 Nov 2021 15:42:38 +0000 (GMT)
Message-Id: <20211112.154238.1786308722975241620.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     tadeusz.struk@linaro.org, elver@google.com, nathan@kernel.org,
        ndesaulniers@google.com, jonathan.lemon@gmail.com, alobakin@pm.me,
        willemb@google.com, pabeni@redhat.com, cong.wang@bytedance.com,
        haokexin@gmail.com, ilias.apalodimas@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev, keescook@chromium.org, edumazet@google.com
Subject: Re: [PATCH] skbuff: suppress clang object-size-mismatch error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <CANpmjNNuWfauPoUxQ6BETrZ8JMjWgrAAhAEqEXW=5BNsfWfyDA@mail.gmail.com>
        <931f1038-d7ab-f236-8052-c5e5b9753b18@linaro.org>
        <20211111095444.461b900e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 12 Nov 2021 07:42:51 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Thu, 11 Nov 2021 09:54:44 -0800

> I'm not sure if that stalled due to lack of time or some fundamental
> problems.

ran out of time, then had a stroke...

> Seems like finishing that would let us clean up such misuses?

yes it would
