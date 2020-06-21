Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA032027A3
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 02:35:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728904AbgFUAff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jun 2020 20:35:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728641AbgFUAff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Jun 2020 20:35:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E53D0C061794
        for <netdev@vger.kernel.org>; Sat, 20 Jun 2020 17:35:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2E358120ED49C;
        Sat, 20 Jun 2020 17:35:34 -0700 (PDT)
Date:   Sat, 20 Jun 2020 17:35:33 -0700 (PDT)
Message-Id: <20200620.173533.2221395901727998476.davem@davemloft.net>
To:     liuhangbin@gmail.com
Cc:     netdev@vger.kernel.org, lucasb@mojatatu.com,
        simon.horman@netronome.com, dcaratti@redhat.com
Subject: Re: [PATCHv2 net] tc-testing: update geneve options match in
 tunnel_key unit tests
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200619032445.664868-1-liuhangbin@gmail.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
        <20200619032445.664868-1-liuhangbin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 20 Jun 2020 17:35:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>
Date: Fri, 19 Jun 2020 11:24:45 +0800

> Since iproute2 commit f72c3ad00f3b ("tc: m_tunnel_key: add options
> support for vxlan"), the geneve opt output use key word "geneve_opts"
> instead of "geneve_opt". To make compatibility for both old and new
> iproute2, let's accept both "geneve_opt" and "geneve_opts".
> 
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Applied, thanks.
