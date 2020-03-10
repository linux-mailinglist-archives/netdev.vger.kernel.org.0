Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C425817EDC5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 02:10:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgCJBJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Mar 2020 21:09:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34438 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726445AbgCJBJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Mar 2020 21:09:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D649815A04B10;
        Mon,  9 Mar 2020 18:09:49 -0700 (PDT)
Date:   Mon, 09 Mar 2020 18:09:49 -0700 (PDT)
Message-Id: <20200309.180949.633904935953558472.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        jere.leppanen@nokia.com, michael.tuexen@lurchi.franken.de
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
From:   David Miller <davem@davemloft.net>
In-Reply-To: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 09 Mar 2020 18:09:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon,  2 Mar 2020 14:57:15 +0800

> As it says in rfc6458#section-9.2:
> 
>   The application uses the sctp_peeloff() call to branch off an
>   association into a separate socket.  (Note that the semantics are
>   somewhat changed from the traditional one-to-one style accept()
>   call.)  Note also that the new socket is a one-to-one style socket.
>   Thus, it will be confined to operations allowed for a one-to-one
>   style socket.
> 
> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
> on which some operations are not allowed, like shutdown, as Jere
> reported.
> 
> This patch is to change it to return a one-to-one type socket instead.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: Leppanen, Jere (Nokia - FI/Espoo) <jere.leppanen@nokia.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

I don't know what to do with this patch.

There seems to be some discussion about a potential alternative approach
to the fix, but there were problems with that suggestion.

Please advise, thank you.
