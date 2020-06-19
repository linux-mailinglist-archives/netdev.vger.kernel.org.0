Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B912000A3
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 05:18:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbgFSDSm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 23:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgFSDSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Jun 2020 23:18:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2DFCC06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 20:18:40 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 53139120ED49C;
        Thu, 18 Jun 2020 20:18:40 -0700 (PDT)
Date:   Thu, 18 Jun 2020 20:18:39 -0700 (PDT)
Message-Id: <20200618.201839.23639510763313500.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     Po.Liu@nxp.com, xiyou.wangcong@gmail.com, olteanv@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net v3 0/2] two fixes for 'act_gate' control plane
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1592338450.git.dcaratti@redhat.com>
References: <cover.1592338450.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 18 Jun 2020 20:18:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Tue, 16 Jun 2020 22:25:19 +0200

> - patch 1/2 attempts to fix the error path of tcf_gate_init() when users
>   try to configure 'act_gate' rules with wrong parameters
> - patch 2/2 is a follow-up of a recent fix for NULL dereference in
>   the error path of tcf_gate_init()
> 
> further work will introduce a tdc test for 'act_gate'.
> 
> changes since v2:
>   - fix undefined behavior in patch 1/2
>   - improve comment in patch 2/2
> changes since v1:
>   coding style fixes in patch 1/2 and 2/2

Series applied, thanks Davide.
