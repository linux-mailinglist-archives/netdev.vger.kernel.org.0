Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A53E262E77
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 05:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727077AbfGIDFL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 23:05:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34234 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfGIDFK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 23:05:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F0DA5133E9BDB;
        Mon,  8 Jul 2019 20:05:09 -0700 (PDT)
Date:   Mon, 08 Jul 2019 20:05:09 -0700 (PDT)
Message-Id: <20190708.200509.2125973923907133864.davem@davemloft.net>
To:     john.hurley@netronome.com
Cc:     netdev@vger.kernel.org, jiri@mellanox.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        willemdebruijn.kernel@gmail.com, dcaratti@redhat.com,
        mrv@mojatatu.com, simon.horman@netronome.com,
        jakub.kicinski@netronome.com, oss-drivers@netronome.com
Subject: Re: [PATCH net-next v7 0/5] Add MPLS actions to TC
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
References: <1562508118-28841-1-git-send-email-john.hurley@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jul 2019 20:05:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: John Hurley <john.hurley@netronome.com>
Date: Sun,  7 Jul 2019 15:01:53 +0100

> This patchset introduces a new TC action module that allows the
> manipulation of the MPLS headers of packets. The code impliments
> functionality including push, pop, and modify.
> 
> Also included are tests for the new funtionality. Note that these will
> require iproute2 changes to be submitted soon.
> 
> NOTE: these patches are applied to net-next along with the patch:
> [PATCH net 1/1] net: openvswitch: fix csum updates for MPLS actions
> This patch has been accepted into net but, at time of posting, is not yet
> in net-next.
 ...

Thanks for mentioning that dependency.

Series applied to net-next, thank you.
