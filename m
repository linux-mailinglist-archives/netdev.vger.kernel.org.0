Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5227D4BAD1
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 16:09:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728926AbfFSOJo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 10:09:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34630 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbfFSOJo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 10:09:44 -0400
Received: from localhost (unknown [144.121.20.163])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id BD0431521BD3C;
        Wed, 19 Jun 2019 07:09:42 -0700 (PDT)
Date:   Wed, 19 Jun 2019 10:09:41 -0400 (EDT)
Message-Id: <20190619.100941.294773141491798198.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, pablo@netfilter.org,
        ecree@solarflare.com, jakub.kicinski@netronome.com,
        idosch@mellanox.com
Subject: Re: [PATCH net-next 0/8] mlxsw: Implement flower ingress device
 matching offload
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190619064109.849-1-idosch@idosch.org>
References: <20190619064109.849-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 19 Jun 2019 07:09:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@idosch.org>
Date: Wed, 19 Jun 2019 09:41:01 +0300

> From: Ido Schimmel <idosch@mellanox.com>
> 
> Jiri says:
> 
> In case of using shared block, user might find it handy to be able to insert
> filters to match on particular ingress device. This patchset exposes the
> ingress ifindex through flow_dissector and flow_offload so mlxsw can use it to
> push down to HW. See the selftests for examples of usage.

Looks good, series applied.
