Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817372ACA21
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 02:13:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730605AbgKJBNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 20:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgKJBNw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Nov 2020 20:13:52 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E37B9206D8;
        Tue, 10 Nov 2020 01:13:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604970832;
        bh=Lm3Gdk0wak/Kkvd8zevT7qND9LrRrIwo5eCWBSfL0vI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZX4F5gnlX7ZvpmGl/7HPSo1Mw8fN0rq4ja1MYeQKcWppd40WcXYbuBfCxR04mjm5u
         bXr/CTZUXA8YOWl1hKu5hhPBbGfNgrqqDMDQkAtCsIJWWEwbhS/u+EwwG4tasBm+tI
         5CJ5+D4qJ8dl9C9x79OTGYSPV/5wVuFerNquhhxE=
Date:   Mon, 9 Nov 2020 17:13:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     menglong8.dong@gmail.com
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: udp: remove redundant initialization in
 udp_send_skb
Message-ID: <20201109171351.7a63f4d6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604644960-48378-4-git-send-email-dong.menglong@zte.com.cn>
References: <1604644960-48378-1-git-send-email-dong.menglong@zte.com.cn>
        <1604644960-48378-4-git-send-email-dong.menglong@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  6 Nov 2020 01:42:40 -0500 menglong8.dong@gmail.com wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> The initialization for 'err' with 0 is redundant and can be removed,
> as it is updated by ip_send_skb and not used before that.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

Applied.
