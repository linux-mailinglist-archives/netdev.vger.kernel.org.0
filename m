Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E219E5EBC3
	for <lists+netdev@lfdr.de>; Wed,  3 Jul 2019 20:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbfGCSlm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Jul 2019 14:41:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60814 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726430AbfGCSlm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Jul 2019 14:41:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED3F71411AB95;
        Wed,  3 Jul 2019 11:41:41 -0700 (PDT)
Date:   Wed, 03 Jul 2019 11:41:41 -0700 (PDT)
Message-Id: <20190703.114141.21086700743761959.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com
Subject: Re: [PATCH net] sctp: count data bundling sack chunk for
 outctrlchunks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
References: <62e917e312bc582e96fa19b502561e37ca7f91a6.1562149220.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Jul 2019 11:41:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  3 Jul 2019 18:20:20 +0800

> Now all ctrl chunks are counted for asoc stats.octrlchunks and net
> SCTP_MIB_OUTCTRLCHUNKS either after queuing up or bundling, other
> than the chunk maked and bundled in sctp_packet_bundle_sack, which
> caused 'outctrlchunks' not consistent with 'inctrlchunks' in peer.
> 
> This issue exists since very beginning, here to fix it by increasing
> both net SCTP_MIB_OUTCTRLCHUNKS and asoc stats.octrlchunks when sack
> chunk is maked and bundled in sctp_packet_bundle_sack.
> 
> Reported-by: Ja Ram Jeon <jajeon@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied.
