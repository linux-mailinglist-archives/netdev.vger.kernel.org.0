Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29ACD20A895
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407636AbgFYXJf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 19:09:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404729AbgFYXJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:09:35 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077EAC08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 16:09:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C7ECD153CC21E;
        Thu, 25 Jun 2020 16:09:34 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:09:33 -0700 (PDT)
Message-Id: <20200625.160933.1407534932291249716.davem@davemloft.net>
To:     ncardwell@google.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] tcp_cubic: fix spurious HYSTART_DELAY on RTT
 decrease
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200624164203.183122-1-ncardwell@google.com>
References: <20200624164203.183122-1-ncardwell@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:09:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neal Cardwell <ncardwell@google.com>
Date: Wed, 24 Jun 2020 12:42:01 -0400

> This series fixes a long-standing bug in the TCP CUBIC
> HYSTART_DELAY mechanim recently reported by Mirja Kuehlewind. The
> code can cause a spurious exit of slow start in some particular
> cases: upon an RTT decrease that happens on the 9th or later ACK
> in a round trip. This series fixes the original Hystart code and
> also the recent BPF implementation.

Series applied and queued up for -stable, thank you.
