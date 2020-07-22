Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9727229B38
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 17:21:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732742AbgGVPVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 11:21:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:46882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727778AbgGVPVb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Jul 2020 11:21:31 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C04772071A;
        Wed, 22 Jul 2020 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595431291;
        bh=HRQPDogTtGevza2j2bcSJiFbQ4He1k12bta9i1FPxTc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oPZg7rY+1BZNv5oUf0Qk2L4LciqWk4AD+PYMmygQ7YgxJMoBOro7pKc+oa58w2CGr
         QLtQxYWiRj1QlrDx2KCT0kjSih/zUvWAZ/iEeJUXtj935gE7my1GugIOEWMcWUXAVv
         3LntQlemz6ZOxMkI5/tqynVapjG1JUisMvD1hQsg=
Date:   Wed, 22 Jul 2020 08:21:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pabeni@redhat.com, pshelar@ovn.org
Subject: Re: [PATCH net-next 2/2] net: openvswitch: make masks cache size
 configurable
Message-ID: <20200722082128.53cf22e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <159540647223.619787.13052866492035799125.stgit@ebuild>
References: <159540642765.619787.5484526399990292188.stgit@ebuild>
        <159540647223.619787.13052866492035799125.stgit@ebuild>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Jul 2020 10:27:52 +0200 Eelco Chaudron wrote:
> This patch makes the masks cache size configurable, or with
> a size of 0, disable it.
> 
> Reviewed-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Hi Elco!

This patch adds a bunch of new sparse warnings:

net/openvswitch/flow_table.c:376:23: warning: incorrect type in assignment (different address spaces)
net/openvswitch/flow_table.c:376:23:    expected struct mask_cache_entry *cache
net/openvswitch/flow_table.c:376:23:    got void [noderef] __percpu *
net/openvswitch/flow_table.c:386:25: warning: incorrect type in assignment (different address spaces)
net/openvswitch/flow_table.c:386:25:    expected struct mask_cache_entry [noderef] __percpu *mask_cache
net/openvswitch/flow_table.c:386:25:    got struct mask_cache_entry *cache
net/openvswitch/flow_table.c:411:27: warning: incorrect type in assignment (different address spaces)
net/openvswitch/flow_table.c:411:27:    expected struct mask_cache [noderef] __rcu *mask_cache
net/openvswitch/flow_table.c:411:27:    got struct mask_cache *
net/openvswitch/flow_table.c:440:35: warning: incorrect type in argument 1 (different address spaces)
net/openvswitch/flow_table.c:440:35:    expected struct mask_cache *mc
net/openvswitch/flow_table.c:440:35:    got struct mask_cache [noderef] __rcu *mask_cache
