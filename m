Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95493250745
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 20:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726793AbgHXSRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 14:17:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:54762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726734AbgHXSQ6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 14:16:58 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7C501206BE;
        Mon, 24 Aug 2020 18:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598293017;
        bh=QN3GnLsscsR8svGqnTbqMwMHQQ/bDpS/a2eA2g9QReo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VjpynL60QoLTwzWlZN5zinIiAG0E1d50mScSwVQ45XMIwzJd+oUNJRzpCsC9/j0mt
         /864QiX79PnsTEQpJmsHEamETUShKdibWmLPcMN/C7OreR5WGPwoY0XncNN5R3+XTZ
         Q+6IIKuKJV7Jy7+nJPy6ZAfVC9iYmnnAaeKFpmzU=
Date:   Mon, 24 Aug 2020 11:16:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Himadri Pandya <himadrispandya@gmail.com>
Cc:     davem@davemloft.net,
        linux-kernel-mentees@lists.linuxfoundation.org,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Subject: Re: [PATCH] net: usb: Fix uninit-was-stored issue in
 asix_read_cmd()
Message-ID: <20200824111655.20a3193e@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200823082042.20816-1-himadrispandya@gmail.com>
References: <20200823082042.20816-1-himadrispandya@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 23 Aug 2020 13:50:42 +0530 Himadri Pandya wrote:
> Initialize the buffer before passing it to usb_read_cmd() function(s) to
> fix the uninit-was-stored issue in asix_read_cmd().
> 
> Fixes: KMSAN: kernel-infoleak in raw_ioctl

Regardless of the ongoing discussion - could you please make this line
a correct Fixes tag?

Right now integration scripts are complaining that it doesn't contain a
valid git hash.

> Reported by: syzbot+a7e220df5a81d1ab400e@syzkaller.appspotmail.com
> 

This empty line is unnecessary.

> Signed-off-by: Himadri Pandya <himadrispandya@gmail.com>

