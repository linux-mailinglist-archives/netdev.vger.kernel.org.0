Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E47C5198276
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729021AbgC3RgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:36:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40020 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727302AbgC3RgM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:36:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B224215C1395D;
        Mon, 30 Mar 2020 10:36:10 -0700 (PDT)
Date:   Mon, 30 Mar 2020 10:36:09 -0700 (PDT)
Message-Id: <20200330.103609.280066541686500729.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, steffen.klassert@secunet.com,
        pabeni@redhat.com
Subject: Re: [PATCH net] udp: initialize is_flist with 0 in udp_gro_receive
From:   David Miller <davem@davemloft.net>
In-Reply-To: <6014932c7cdef91c11cdb0dcf73dbf77b65f8638.1585582305.git.lucien.xin@gmail.com>
References: <6014932c7cdef91c11cdb0dcf73dbf77b65f8638.1585582305.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 30 Mar 2020 10:36:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Mon, 30 Mar 2020 23:31:45 +0800

> Without NAPI_GRO_CB(skb)->is_flist initialized, when the dev doesn't
> support NETIF_F_GRO_FRAGLIST, is_flist can still be set and fraglist
> will be used in udp_gro_receive().
> 
> So fix it by initializing is_flist with 0 in udp_gro_receive.
> 
> Fixes: 9fd1ff5d2ac7 ("udp: Support UDP fraglist GRO/GSO.")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied and queued up for v5.6 -stable, thanks.
