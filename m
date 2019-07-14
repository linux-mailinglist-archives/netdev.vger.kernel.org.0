Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4854267CB2
	for <lists+netdev@lfdr.de>; Sun, 14 Jul 2019 04:24:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728177AbfGNCYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Jul 2019 22:24:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46450 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727918AbfGNCYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 13 Jul 2019 22:24:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5A8041405185E;
        Sat, 13 Jul 2019 19:24:53 -0700 (PDT)
Date:   Sat, 13 Jul 2019 19:24:52 -0700 (PDT)
Message-Id: <20190713.192452.957081589182741509.davem@davemloft.net>
To:     rosenp@gmail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] net-next: ag71xx: Rearrange ag711xx struct to
 remove holes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190713020921.18202-2-rosenp@gmail.com>
References: <20190713020921.18202-1-rosenp@gmail.com>
        <20190713020921.18202-2-rosenp@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 13 Jul 2019 19:24:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 12 Jul 2019 19:09:21 -0700

> Removed ____cacheline_aligned attribute to ring structs. This actually
> causes holes in the ag71xx struc as well as lower performance.
> 
> Rearranged struct members to fall within respective cachelines. The RX
> ring struct now does not share a cacheline with the TX ring. The NAPI
> atruct now takes up its own cachelines and does not share.
> 
> According to pahole -C ag71xx -c 32
 ...

net-next is closed, therefore it is not appropriate to submit this change
at the current time.
