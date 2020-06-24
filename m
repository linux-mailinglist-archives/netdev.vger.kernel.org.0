Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE51207EAC
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 23:35:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404306AbgFXVfm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 17:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403996AbgFXVfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 17:35:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACDE5C061573
        for <netdev@vger.kernel.org>; Wed, 24 Jun 2020 14:35:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC7BC1272E975;
        Wed, 24 Jun 2020 14:35:40 -0700 (PDT)
Date:   Wed, 24 Jun 2020 14:35:40 -0700 (PDT)
Message-Id: <20200624.143540.1656228939439920292.davem@davemloft.net>
To:     lorenzo@kernel.org
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, nusiddiq@redhat.com,
        gvrose8192@gmail.com, lorenzo.bianconi@redhat.com,
        dev@openvswitch.org
Subject: Re: [PATCH v2 net] openvswitch: take into account
 de-fragmentation/gso_size in execute_check_pkt_len
From:   David Miller <davem@davemloft.net>
In-Reply-To: <fd266728e5de48e1b4bd82d08e345f308f77eb5a.1592929525.git.lorenzo@kernel.org>
References: <fd266728e5de48e1b4bd82d08e345f308f77eb5a.1592929525.git.lorenzo@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 24 Jun 2020 14:35:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lorenzo Bianconi <lorenzo@kernel.org>
Date: Tue, 23 Jun 2020 18:33:15 +0200

> ovs connection tracking module performs de-fragmentation on incoming
> fragmented traffic. Take info account if traffic has been de-fragmented
> in execute_check_pkt_len action otherwise we will perform the wrong
> nested action considering the original packet size. This issue typically
> occurs if ovs-vswitchd adds a rule in the pipeline that requires connection
> tracking (e.g. OVN stateful ACLs) before execute_check_pkt_len action.
> Moreover take into account GSO fragment size for GSO packet in
> execute_check_pkt_len routine
> 
> Fixes: 4d5ec89fc8d14 ("net: openvswitch: Add a new action check_pkt_len")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Applied and queued up for -stable, thank you.
