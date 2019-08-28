Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB312A0CCF
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:54:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbfH1VyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:54:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726400AbfH1VyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:54:11 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 67AF4153A66BE;
        Wed, 28 Aug 2019 14:54:10 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:54:09 -0700 (PDT)
Message-Id: <20190828.145409.412910250799244993.davem@davemloft.net>
To:     gvrose8192@gmail.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, joe@wand.net.nz
Subject: Re: [PATCH V3 net 1/2] openvswitch: Properly set L4 keys on
 "later" IP fragments
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
References: <1566917890-22304-1-git-send-email-gvrose8192@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Aug 2019 14:54:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Greg Rose <gvrose8192@gmail.com>
Date: Tue, 27 Aug 2019 07:58:09 -0700

> When IP fragments are reassembled before being sent to conntrack, the
> key from the last fragment is used.  Unless there are reordering
> issues, the last fragment received will not contain the L4 ports, so the
> key for the reassembled datagram won't contain them.  This patch updates
> the key once we have a reassembled datagram.
> 
> The handle_fragments() function works on L3 headers so we pull the L3/L4
> flow key update code from key_extract into a new function
> 'key_extract_l3l4'.  Then we add a another new function
> ovs_flow_key_update_l3l4() and export it so that it is accessible by
> handle_fragments() for conntrack packet reassembly.
> 
> Co-authored by: Justin Pettit <jpettit@ovn.org>
> Signed-off-by: Greg Rose <gvrose8192@gmail.com>

Applied with Co-authored-by fixed.
