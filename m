Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25C98201C11
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 22:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390724AbgFSUMg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 16:12:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730512AbgFSUMf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 16:12:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42338C06174E
        for <netdev@vger.kernel.org>; Fri, 19 Jun 2020 13:12:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6120C11D69C3E;
        Fri, 19 Jun 2020 13:12:34 -0700 (PDT)
Date:   Fri, 19 Jun 2020 13:12:33 -0700 (PDT)
Message-Id: <20200619.131233.353256561480957986.davem@davemloft.net>
To:     satish.d@oneconvergence.com
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        kuba@kernel.org, netdev@vger.kernel.org,
        simon.horman@netronome.com, kesavac@gmail.com,
        prathibha.nagooru@oneconvergence.com,
        intiyaz.basha@oneconvergence.com, jai.rana@oneconvergence.com
Subject: Re: [PATCH net-next 0/3] cls_flower: Offload unmasked key
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619094156.31184-1-satish.d@oneconvergence.com>
References: <20200619094156.31184-1-satish.d@oneconvergence.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Jun 2020 13:12:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You are giving no context on what hardware and with what driver
your changes make a difference for.

This kind of context and information is required in order for
anyone to understand your changes.

We're not accepting these changes until you explain all of this.

Thank you.
