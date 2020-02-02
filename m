Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397CF14FF71
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 22:47:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727066AbgBBVqy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 16:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:41984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgBBVqx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 16:46:53 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B404820679;
        Sun,  2 Feb 2020 21:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580680013;
        bh=Y8VhYCn8SLYoDLvdtw5adPkQSiS1U3K567neLTCYUFM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TT8ylOUYjKatixXm8qyM98wc2ZqE9XKJLjp69oEblNZmHp+kat6qXxc5sTuIwGDqC
         wNeFAaNBpw4NiX429E4JZMuAPD9FH3noi3vpg1ggRObPxBrXlkJ5HYy/Cg17kLY4gC
         1WUc7msPy3wLA8eAgA3Jgx3axpkerpIU0LWapVzQ=
Date:   Sun, 2 Feb 2020 13:46:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     sj38.park@gmail.com
Cc:     edumazet@google.com, David.Laight@aculab.com, aams@amazon.com,
        davem@davemloft.net, eric.dumazet@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, ncardwell@google.com,
        shuah@kernel.org, sjpark@amazon.de
Subject: Re: [PATCH v3 0/2] Fix reconnection latency caused by FIN/ACK
 handling race
Message-ID: <20200202134652.0e89ce89@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200202033827.16304-1-sj38.park@gmail.com>
References: <20200202033827.16304-1-sj38.park@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  2 Feb 2020 03:38:25 +0000, sj38.park@gmail.com wrote:
> The first patch fixes the problem by adjusting the first resend delay of
> the SYN in the case.  The second one adds a user space test to reproduce
> this problem.
> 
> The patches are based on the v5.5.  You can also clone the complete git
> tree:
> 
>     $ git clone git://github.com/sjp38/linux -b patches/finack_lat/v3
> 
> The web is also available:
> https://github.com/sjp38/linux/tree/patches/finack_lat/v3

Applied to net, thank you!

In the future there is no need to duplicate the info from commit
messages in the cover letter.
