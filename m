Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA0311909C
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 20:31:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbfLJTbj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 14:31:39 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47510 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbfLJTbi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 14:31:38 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 988E7146E9458;
        Tue, 10 Dec 2019 11:31:37 -0800 (PST)
Date:   Tue, 10 Dec 2019 11:31:37 -0800 (PST)
Message-Id: <20191210.113137.707618060141184181.davem@davemloft.net>
To:     mst@redhat.com
Cc:     linux-kernel@vger.kernel.org, jcfaracco@gmail.com,
        netdev@vger.kernel.org, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, dnmendes76@gmail.com,
        hkallweit1@gmail.com, jakub.kicinski@netronome.com,
        snelson@pensando.io, mhabets@solarflare.com
Subject: Re: [PATCH net-next v10 1/3] netdev: pass the stuck queue to the
 timeout handler
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191210130014.47179-2-mst@redhat.com>
References: <20191210130014.47179-1-mst@redhat.com>
        <20191210130014.47179-2-mst@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 10 Dec 2019 11:31:38 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Michael, please provide a proper introductory posting for your patch series
just like everyone else does.

Not only does it help people understand at a high level what the patch
series is doing, how it is doing it, and why it is doing it that way.  It
also gives me a single email to reply to when I apply your patch series.

Therefore, please respin this properly.

Thank you.
