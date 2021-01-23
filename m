Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22492301233
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 03:13:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbhAWCLq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 21:11:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:33270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbhAWCLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 21:11:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E624623B26;
        Sat, 23 Jan 2021 02:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611367828;
        bh=SDzrsLBERCXV1WC6VdsluqTz+iNrN+9KM0jBmvv8bQU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=H1BMlC6O1M/7Dhe11DFquWE672L6iGwkYZFe48bl12ychwfKOjVnMsm6OGLvwMxZP
         /u8nxBahI670FjMsP7ja49HFsqUvbp7QLg7GtkfeFCkarKRoq4HponO1R2UGnBAAkJ
         2NwoYysy7wvgy/b0x0rz6fZ+W3CZ9TFzVG1urGhuXKgZS+kf7f/L9x3qq/lCkTnDD8
         hwr8VrWOe0LO9pZCceChX9essM7yydP/MJPszmO9POvlU28krJRQxpi9VWA2WLdT3Q
         OYbOYmxYrlYVCcWlXOJn5E49w7mc5RLDua3M8Xko0Um5Bx0KicMHEhPZKoMMG6KkgG
         SWE6W91WJeH8Q==
Date:   Fri, 22 Jan 2021 18:10:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <edumazet@google.com>,
        Pengcheng Yang <yangpc@wangsu.com>
Cc:     Yuchung Cheng <ycheng@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] tcp: remove unused ICSK_TIME_EARLY_RETRANS
Message-ID: <20210122181027.24295866@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CANn89iLbOqbJKMbC5UWiBSuuK1vQ-tzGj9fTWrL7hqdK7qGogg@mail.gmail.com>
References: <1611239473-27304-1-git-send-email-yangpc@wangsu.com>
        <CANn89iLbOqbJKMbC5UWiBSuuK1vQ-tzGj9fTWrL7hqdK7qGogg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 Jan 2021 16:32:36 +0100 Eric Dumazet wrote:
> On Thu, Jan 21, 2021 at 3:32 PM Pengcheng Yang <yangpc@wangsu.com> wrote:
> >
> > Since the early retransmit has been removed by
> > commit bec41a11dd3d ("tcp: remove early retransmit"),
> > we also remove the unused ICSK_TIME_EARLY_RETRANS macro.
> >
> > Signed-off-by: Pengcheng Yang <yangpc@wangsu.com>
>
> Signed-off-by: Eric Dumazet <edumazet@google.com>

Applied, thank you!
