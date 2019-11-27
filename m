Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE7510B635
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 19:55:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727459AbfK0SzH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Nov 2019 13:55:07 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:56170 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726984AbfK0SzH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Nov 2019 13:55:07 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7B151149C922F;
        Wed, 27 Nov 2019 10:55:06 -0800 (PST)
Date:   Wed, 27 Nov 2019 10:55:06 -0800 (PST)
Message-Id: <20191127.105506.1224335279309401228.davem@davemloft.net>
To:     Jason@zx2c4.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org
Subject: Re: WireGuard for 5.5?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAHmME9oqT_BncUFaJRpj0xtL1MPcE=g5WQG_qE7oC231USQCPA@mail.gmail.com>
References: <CAHmME9oqT_BncUFaJRpj0xtL1MPcE=g5WQG_qE7oC231USQCPA@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 27 Nov 2019 10:55:06 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


I haven't read the patch and plan to do so soon.

The merge window is open and thus net-next is closed, so we can put
this into the next merge window.

Thank you.
