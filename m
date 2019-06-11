Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB5C3DBAB
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 22:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406463AbfFKUJA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 16:09:00 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51386 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405799AbfFKUJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 16:09:00 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 06A7215260066;
        Tue, 11 Jun 2019 13:08:58 -0700 (PDT)
Date:   Tue, 11 Jun 2019 13:08:56 -0700 (PDT)
Message-Id: <20190611.130856.1857826051148231972.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        syzbot+f7e9153b037eac9b1df8@syzkaller.appspotmail.com,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com
Subject: Re: [PATCH v3] [sctp] Free cookie before we memdup a new one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611192245.9110-1-nhorman@tuxdriver.com>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190611192245.9110-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 13:08:59 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 11 Jun 2019 15:22:45 -0400

> v2->v3
> net->sctp
> also free peer_chunks

Neil this isn't the first time you're submitting sctp patches right? ;-)

Subject: "[PATCH v3 net] sctp: Free cookie before we memdup a new one"

It's "subsystem_prefix: " and I even stated this explicitly yesterday.
