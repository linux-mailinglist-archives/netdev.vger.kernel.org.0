Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFDD72355B2
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 08:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHBGaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 02:30:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:54970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725798AbgHBGay (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Aug 2020 02:30:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D3412076B;
        Sun,  2 Aug 2020 06:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596349854;
        bh=s+L0U8SYjfQdqJYaY42N4VU+qvySTS5Xee4dhuCBX9U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I/oX3DpgcNRRhOjx0JjtQZ1e/KUK3Tfa6vijN3rhYLm2irsgdoJZmTsNJF7hlEAf6
         voTF1U0eu7qD96zxUQw19Kwej9hBNJ3EKG0AK4zdxtRsITJXOh+/Y3Srbn+XVZZsaP
         ZOiFFxHHSDJyEUlpCJ9JS+8inrlUVBSYsfMJH/fM=
Date:   Sun, 2 Aug 2020 08:30:37 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     syzbot <syzbot+2446dd3cb07277388db6@syzkaller.appspotmail.com>
Cc:     coreteam@netfilter.org, davem@davemloft.net,
        devel@driverdev.osuosl.org, forest@alittletooquiet.net,
        johan.hedberg@gmail.com, kaber@trash.net, kadlec@blackhole.kfki.hu,
        kuba@kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, marcel@holtmann.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        pablo@netfilter.org, rvarsha016@gmail.com,
        syzkaller-bugs@googlegroups.com
Subject: Re: WARNING in hci_conn_timeout
Message-ID: <20200802063037.GA3650705@kroah.com>
References: <0000000000007450a405abd572a8@google.com>
 <000000000000b54f9f05abd8cfbb@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000b54f9f05abd8cfbb@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Aug 01, 2020 at 03:56:09PM -0700, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit 3d30311c0e4d834c94e6a27d6242a942d6a76b85
> Author: Varsha Rao <rvarsha016@gmail.com>
> Date:   Sun Oct 9 11:13:56 2016 +0000
> 
>     staging: vt6655: Removes unnecessary blank lines.

I doubt this is the real issue :(

