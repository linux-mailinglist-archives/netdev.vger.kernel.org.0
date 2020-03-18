Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE5791896AC
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727401AbgCRILL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47844 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726733AbgCRILJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:09 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CC3A81489E4C3;
        Wed, 18 Mar 2020 01:11:08 -0700 (PDT)
Date:   Tue, 17 Mar 2020 22:52:45 -0700 (PDT)
Message-Id: <20200317.225245.265043758636947952.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, mathew.j.martineau@linux.intel.com
Subject: Re: [PATCH net-next] mptcp: move msk state update to
 subflow_syn_recv_sock()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ca414f55f4c74190bc419815f6ac7c61313bac2a.1584456734.git.pabeni@redhat.com>
References: <ca414f55f4c74190bc419815f6ac7c61313bac2a.1584456734.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 17 Mar 2020 15:53:34 +0100

> After commit 58b09919626b ("mptcp: create msk early"), the
> msk socket is already available at subflow_syn_recv_sock()
> time. Let's move there the state update, to mirror more
> closely the first subflow state.
> 
> The above will also help multiple subflow supports.
> 
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied, thank you.
