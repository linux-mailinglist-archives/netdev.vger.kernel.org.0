Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D317821E46F
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 02:22:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbgGNAWm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 20:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgGNAWl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 20:22:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B897C061755
        for <netdev@vger.kernel.org>; Mon, 13 Jul 2020 17:22:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1BE0F1298205F;
        Mon, 13 Jul 2020 17:22:40 -0700 (PDT)
Date:   Mon, 13 Jul 2020 17:22:39 -0700 (PDT)
Message-Id: <20200713.172239.1872494406241976647.davem@davemloft.net>
To:     petrm@mellanox.com
Cc:     netdev@vger.kernel.org, pablo@netfilter.org, kuba@kernel.org,
        jiri@mellanox.com, mlxsw@mellanox.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, leon@kernel.org, kadlec@netfilter.org,
        fw@strlen.de, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        simon.horman@netronome.com, idosch@mellanox.com
Subject: Re: [PATCH net-next v2 00/13] mlxsw: Add support for buffer drops
 mirroring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1594416408.git.petrm@mellanox.com>
References: <cover.1594416408.git.petrm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Jul 2020 17:22:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Petr Machata <petrm@mellanox.com>
Date: Sat, 11 Jul 2020 00:55:02 +0300

> This set offloads the recently introduced qevent infrastructure in TC and
> allows mlxsw to support mirroring of packets that were dropped due to
> buffer related reasons (e.g., early drops) during forwarding.
 ...

Series applied, thanks.
