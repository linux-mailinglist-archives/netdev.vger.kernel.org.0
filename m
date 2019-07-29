Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6D8579135
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 18:39:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbfG2Qjo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 12:39:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35638 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfG2Qjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 12:39:44 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 48ED112662B78;
        Mon, 29 Jul 2019 09:39:43 -0700 (PDT)
Date:   Mon, 29 Jul 2019 09:39:42 -0700 (PDT)
Message-Id: <20190729.093942.444986138886341871.davem@davemloft.net>
To:     brouer@redhat.com
Cc:     xdp-newbies@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com
Subject: Re: [PATCH net-next] MAINTAINERS: Remove mailing-list entry for
 XDP (eXpress Data Path)
From:   David Miller <davem@davemloft.net>
In-Reply-To: <156440259790.6123.1563221733550893420.stgit@carbon>
References: <156440259790.6123.1563221733550893420.stgit@carbon>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 29 Jul 2019 09:39:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jesper Dangaard Brouer <brouer@redhat.com>
Date: Mon, 29 Jul 2019 14:16:37 +0200

> This removes the mailing list xdp-newbies@vger.kernel.org from the XDP
> kernel maintainers entry.
> 
> Being in the kernel MAINTAINERS file successfully caused the list to
> receive kbuild bot warnings, syzbot reports and sometimes developer
> patches. The level of details in these messages, doesn't match the
> target audience of the XDP-newbies list. This is based on a survey on
> the mailing list, where 73% voted for removal from MAINTAINERS file.
> 
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

I'll apply this to 'net', thanks Jesper.
