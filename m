Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C04989334
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 20:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfHKS5X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 14:57:23 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33174 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfHKS5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Aug 2019 14:57:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E478154F2025;
        Sun, 11 Aug 2019 11:57:21 -0700 (PDT)
Date:   Sun, 11 Aug 2019 11:57:18 -0700 (PDT)
Message-Id: <20190811.115718.938803082109468275.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, nhorman@tuxdriver.com, jiri@mellanox.com,
        toke@redhat.com, dsahern@gmail.com, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, jakub.kicinski@netronome.com,
        andy@greyhouse.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, mlxsw@mellanox.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/10] drop_monitor: Capture dropped
 packets and metadata
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190811073555.27068-1-idosch@idosch.org>
References: <20190811073555.27068-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 11 Aug 2019 11:57:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Sun, 11 Aug 2019 10:35:45 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> So far drop monitor supported only one mode of operation in which a
> summary of recent packet drops is periodically sent to user space as a
> netlink event. The event only includes the drop location (program
> counter) and number of drops in the last interval.
> 
> While this mode of operation allows one to understand if the system is
> dropping packets, it is not sufficient if a more detailed analysis is
> required. Both the packet itself and related metadata are missing.
> 
> This patchset extends drop monitor with another mode of operation where
> the packet - potentially truncated - and metadata (e.g., drop location,
> timestamp, netdev) are sent to user space as a netlink event. Thanks to
> the extensible nature of netlink, more metadata can be added in the
> future.
 ...

Series applied.

