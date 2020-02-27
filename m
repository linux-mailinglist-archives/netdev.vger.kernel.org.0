Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 020F9170FA2
	for <lists+netdev@lfdr.de>; Thu, 27 Feb 2020 05:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728346AbgB0EYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 23:24:54 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36938 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728221AbgB0EYy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 23:24:54 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B453415B4786E;
        Wed, 26 Feb 2020 20:24:53 -0800 (PST)
Date:   Wed, 26 Feb 2020 20:24:53 -0800 (PST)
Message-Id: <20200226.202453.378034778398671449.davem@davemloft.net>
To:     arjunroy.kdev@gmail.com
Cc:     netdev@vger.kernel.org, arjunroy@google.com, soheil@google.com,
        edumazet@google.com, willemb@google.com
Subject: Re: [PATCH v2 net-next] tcp-zerocopy: Update returned getsockopt()
 optlen.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200225203854.184524-1-arjunroy.kdev@gmail.com>
References: <20200225203854.184524-1-arjunroy.kdev@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 26 Feb 2020 20:24:54 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arjun Roy <arjunroy.kdev@gmail.com>
Date: Tue, 25 Feb 2020 12:38:54 -0800

> From: Arjun Roy <arjunroy@google.com>
> 
> TCP receive zerocopy currently does not update the returned optlen for
> getsockopt() if the user passed in a larger than expected value.
> Thus, userspace cannot properly determine if all the fields are set in
> the passed-in struct. This patch sets the optlen for this case before
> returning, in keeping with the expected operation of getsockopt().
> 
> Fixes: c8856c051454 ("tcp-zerocopy: Return inq along with tcp receive zerocopy.")
> Signed-off-by: Arjun Roy <arjunroy@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Soheil Hassas Yeganeh <soheil@google.com>
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thank you.
