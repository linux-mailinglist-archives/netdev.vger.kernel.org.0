Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFCAF1E1885
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 02:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388126AbgEZAi1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 May 2020 20:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726350AbgEZAi1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 May 2020 20:38:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9BBC061A0E
        for <netdev@vger.kernel.org>; Mon, 25 May 2020 17:38:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1A5D51278B453;
        Mon, 25 May 2020 17:38:23 -0700 (PDT)
Date:   Mon, 25 May 2020 17:38:18 -0700 (PDT)
Message-Id: <20200525.173818.1886112260004012915.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@mellanox.com,
        benjamin.lahaise@netronome.com, tom@herbertland.com,
        pieter.jansenvanvuuren@netronome.com, pablo@netfilter.org,
        liels@mellanox.com, ronye@mellanox.com
Subject: Re: [PATCH net-next v2 0/2] flow_dissector, cls_flower: Add
 support for multiple MPLS Label Stack Entries
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1590081480.git.gnault@redhat.com>
References: <cover.1590081480.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 May 2020 17:38:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Thu, 21 May 2020 19:47:08 +0200

> Currently, the flow dissector and the Flower classifier can only handle
> the first entry of an MPLS label stack. This patch series generalises
> the code to allow parsing and matching the Label Stack Entries that
> follow.
> 
> Patch 1 extends the flow dissector to parse MPLS LSEs until the Bottom
> Of Stack bit is reached. The number of parsed LSEs is capped at
> FLOW_DIS_MPLS_MAX (arbitrarily set to 7). Flower and the NFP driver
> are updated to take into account the new layout of struct
> flow_dissector_key_mpls.
> 
> Patch 2 extends Flower. It defines new netlink attributes, which are
> independent from the previous MPLS ones. Mixing the old and the new
> attributes in a same filter is not allowed. For backward compatibility,
> the old attributes are used when dumping filters that don't require the
> new ones.
> 
> Changes since v1:
>   * Fix compilation of NFP driver (kbuild test robot).
>   * Fix sparse warning with entropy label (kbuild test robot).

Series applied, thanks.
