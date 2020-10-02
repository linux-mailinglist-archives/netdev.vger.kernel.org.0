Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2FBE281EB8
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:57:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725790AbgJBW5U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:57:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBW5U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:57:20 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1453C0613D0;
        Fri,  2 Oct 2020 15:57:19 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7D21311E49F77;
        Fri,  2 Oct 2020 15:40:31 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:57:18 -0700 (PDT)
Message-Id: <20201002.155718.1670574240166749204.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, tadavis@lbl.gov, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 6/6] bonding: make Kconfig toggle to
 disable legacy interfaces
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com>
References: <20201002174001.3012643-7-jarod@redhat.com>
        <20201002121317.474c95f0@hermes.local>
        <CAKfmpSc3-j2GtQtdskEb8BQvB6q_zJPcZc2GhG8t+M3yFxS4MQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:40:31 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 2 Oct 2020 16:23:46 -0400

> I'd had a bit of feedback that people would rather see both, and be
> able to toggle off the old ones, rather than only having one or the
> other, depending on the toggle, so I thought I'd give this a try. I
> kind of liked the one or the other route, but I see the problems with
> that too.

Please keep everything for the entire deprecation period, unconditionally.

Thank you.
