Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 913DC79003
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 17:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388345AbfG2P7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 11:59:37 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35006 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387768AbfG2P7h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 11:59:37 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B38B31265A1FF;
        Mon, 29 Jul 2019 08:59:35 -0700 (PDT)
Date:   Mon, 29 Jul 2019 08:59:35 -0700 (PDT)
Message-Id: <20190729.085935.210780424592470601.davem@davemloft.net>
To:     rahulv@marvell.com
Cc:     netdev@vger.kernel.org, aelior@marvell.com, mkalderon@marvell.com
Subject: Re: [PATCH net-next 1/1] qed[net-next] Add new ethtool supported
 port types based on media.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190729074959.25286-1-rahulv@marvell.com>
References: <20190729074959.25286-1-rahulv@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 08:59:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please don't format the Subject line this way.

The only place 'net-next' should appear is in the initial [] brackted patch
designation [PATCH net-next 1/1], the later one "qed[net-next]" must be
removed and replaced by a colon charater "qed: "

Thanks.
