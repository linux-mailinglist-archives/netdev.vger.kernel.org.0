Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC378839BC
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725948AbfHFTiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:38:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48740 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFTiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 15:38:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BA4C11555E876;
        Tue,  6 Aug 2019 12:38:22 -0700 (PDT)
Date:   Tue, 06 Aug 2019 12:38:22 -0700 (PDT)
Message-Id: <20190806.123822.1326315361107457509.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com, toke@redhat.com,
        jiri@mellanox.com, dsahern@gmail.com, mlxsw@mellanox.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/6] drop_monitor: Various improvements and
 cleanups
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806131956.26168-1-idosch@idosch.org>
References: <20190806131956.26168-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 12:38:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Tue,  6 Aug 2019 16:19:50 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patchset performs various improvements and cleanups in drop monitor
> with no functional changes intended. There are no changes in these
> patches relative to the RFC I sent two weeks ago [1].
> 
> A followup patchset will extend drop monitor with a packet alert mode in
> which the dropped packet is notified to user space instead of just a
> summary of recent drops. Subsequent patchsets will add the ability to
> monitor hardware originated drops via drop monitor.
> 
> [1] https://patchwork.ozlabs.org/cover/1135226/

These all look fine to me, series applied.

Thanks.
