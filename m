Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DEC281EB4
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725805AbgJBWzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:55:38 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51BB0C0613D0;
        Fri,  2 Oct 2020 15:55:38 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1E61E11E49F68;
        Fri,  2 Oct 2020 15:38:49 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:55:35 -0700 (PDT)
Message-Id: <20201002.155535.2066858020292000189.davem@davemloft.net>
To:     jarod@redhat.com
Cc:     stephen@networkplumber.org, linux-kernel@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kuba@kernel.org, tadavis@lbl.gov, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 5/6] bonding: update Documentation for
 port/bond terminology
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAKfmpSecU63B1eJ5KEyPcCAkXxeqZQdghvUMdn_yGn3+iQWwcQ@mail.gmail.com>
References: <20201002174001.3012643-6-jarod@redhat.com>
        <20201002121051.5ca41c1a@hermes.local>
        <CAKfmpSecU63B1eJ5KEyPcCAkXxeqZQdghvUMdn_yGn3+iQWwcQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 15:38:49 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jarod Wilson <jarod@redhat.com>
Date: Fri, 2 Oct 2020 16:12:49 -0400

> The documentation was updated to point to the new names, but the old
> ones still exist across the board, there should be no userspace
> breakage here. (My lnst bonding tests actually fall flat currently
> if the old names are gone).

The documentation is the reference point for people reading code in
userspace that manipulates bonding devices.

So people will come across the deprecated names in userland code and
therefore will try to learn what they do and what they mean.

Which means that the documentation must reference the old names.

You can mark them "(DEPRECATED)" or similar, but you must not remove
them.
