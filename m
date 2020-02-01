Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9646614F6DE
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 07:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbgBAGW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 01:22:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:47944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726038AbgBAGW1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 01:22:27 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A89A20679;
        Sat,  1 Feb 2020 06:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580538146;
        bh=NYBLxaAFa/3nquk/df5kICOOftdPm0WcE/P1uRYempw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r8lsQolax6B9o6W2qdX6lwvgU+dxew48rNKO/R4mxWyIAanLisjTx2tro9cybzOJR
         vC89/hTXlINhzLNjjChnOPDqTA7ZoNymrcsA4Gxr8VkhwteJoAshHfs792dcgoaA95
         JPRvZfSkLlX6V2gQbecv3pP2sRkC/SduZ4K8LLNQ=
Date:   Fri, 31 Jan 2020 22:22:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Neal Cardwell <ncardwell@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Marcelo Ricardo Leitner <mleitner@redhat.com>,
        Yuchung Cheng <ycheng@google.com>
Subject: Re: [PATCH net] tcp: clear tp->segs_{in|out} in tcp_disconnect()
Message-ID: <20200131222225.7198c45b@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200131184450.159417-1-edumazet@google.com>
References: <20200131184450.159417-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 10:44:50 -0800, Eric Dumazet wrote:
> tp->segs_in and tp->segs_out need to be cleared in tcp_disconnect().
> 
> tcp_disconnect() is rarely used, but it is worth fixing it.
> 
> Fixes: 2efd055c53c0 ("tcp: add tcpi_segs_in and tcpi_segs_out to tcp_info")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Cc: Marcelo Ricardo Leitner <mleitner@redhat.com>
> Cc: Yuchung Cheng <ycheng@google.com>
> Cc: Neal Cardwell <ncardwell@google.com>

Applied all 4 disconnect fixes, and queued them for stable. 

Thank you!
