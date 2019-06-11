Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F20893D6B6
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 21:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389125AbfFKTWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 15:22:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:50722 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728447AbfFKTWs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 15:22:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B941525DA26;
        Tue, 11 Jun 2019 12:22:47 -0700 (PDT)
Date:   Tue, 11 Jun 2019 12:22:47 -0700 (PDT)
Message-Id: <20190611.122247.1614282510422209015.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com
Subject: Re: [PATCH net-next 00/12] tls: add support for kernel-driven
 resync and nfp RX offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 12:22:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Mon, 10 Jun 2019 21:39:58 -0700

> This series adds TLS RX offload for NFP and completes the offload
> by providing resync strategies.  When TLS data stream looses segments
> or experiences reorder NIC can no longer perform in line offload.
> Resyncs provide information about placement of records in the
> stream so that offload can resume.
> 
> Existing TLS resync mechanisms are not a great fit for the NFP.
> In particular the TX resync is hard to implement for packet-centric
> NICs.  This patchset adds an ability to perform TX resync in a way
> similar to the way initial sync is done - by calling down to the
> driver when new record is created after driver indicated sync had
> been lost.
> 
> Similarly on the RX side, we try to wait for a gap in the stream
> and send record information for the next record.  This works very
> well for RPC workloads which are the primary focus at this time.

Series applied, thanks Jakub.
