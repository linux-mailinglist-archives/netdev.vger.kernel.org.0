Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 618A4115C1C
	for <lists+netdev@lfdr.de>; Sat,  7 Dec 2019 12:55:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726371AbfLGLzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Dec 2019 06:55:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:60030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726025AbfLGLzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Dec 2019 06:55:04 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0F7824673;
        Sat,  7 Dec 2019 11:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575719704;
        bh=G8sWODe3m9KgcYiOVAUre5nxdNZnIw9Agsw5BxV9Btg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yqvwvdKWAfKnsRrx5thLfJ7bWBMpk1XcAn0BLK0bMC1JYRTk//g0+cVyso4yVWGwp
         kJxXPxYaEf3w3rQECIABTAbNQnrsiZ0KQuUVILAbR+PO+iegWtIjN5fW/eH94N99j0
         XbFzxFpuMrFOdTa0hSN9ZqlUea4hiWyqDDzFh1AQ=
Date:   Sat, 7 Dec 2019 12:55:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        Soheil Hassas Yeganeh <soheil@google.com>
Subject: Re: [PATCH v4.14] tcp: exit if nothing to retransmit on RTO timeout
Message-ID: <20191207115501.GA325082@kroah.com>
References: <20191206182016.137529-1-edumazet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191206182016.137529-1-edumazet@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 06, 2019 at 10:20:16AM -0800, Eric Dumazet wrote:
> Two upstream commits squashed together for v4.14 stable :
> 
>  commit 88f8598d0a302a08380eadefd09b9f5cb1c4c428 upstream.
> 
>   Previously TCP only warns if its RTO timer fires and the
>   retransmission queue is empty, but it'll cause null pointer
>   reference later on. It's better to avoid such catastrophic failure
>   and simply exit with a warning.
> 
> Squashed with "tcp: refactor tcp_retransmit_timer()" :
> 
>  commit 0d580fbd2db084a5c96ee9c00492236a279d5e0f upstream.

Note, this commit is only in Dave's tree, not stable just yet.  I'll
queue this up now, but I'm expecting that commit will come in to the
stable trees through the "normal" stable networking process.

thanks,

greg k-h
