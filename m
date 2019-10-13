Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8922CD5708
	for <lists+netdev@lfdr.de>; Sun, 13 Oct 2019 19:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729326AbfJMR37 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Oct 2019 13:29:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726264AbfJMR37 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Oct 2019 13:29:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0A724144A0671;
        Sun, 13 Oct 2019 10:29:58 -0700 (PDT)
Date:   Sun, 13 Oct 2019 10:29:57 -0700 (PDT)
Message-Id: <20191013.102957.1417827829100829400.davem@davemloft.net>
To:     gnault@redhat.com
Cc:     netdev@vger.kernel.org, nicolas.dichtel@6wind.com,
        ast@plumgrid.com, jesse@nicira.com, pshelar@nicira.com,
        jbenc@redhat.com
Subject: Re: [RFC PATCH net] netns: fix GFP flags in rtnl_net_notifyid()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
References: <41b3fbfe3aac5ca03f4af0f1c4e146ae67c20570.1570734410.git.gnault@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 13 Oct 2019 10:29:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>
Date: Thu, 10 Oct 2019 21:07:29 +0200

> Before I spend more time on this, do we have a chance to make
> ovs_vport_cmd_fill_info() and __dev_notify_flags() sleepable?
> I'd like to avoid passing GFP flags along these call chains, if at all
> possible.

OVS folks, please weigh in.

Thanks.
