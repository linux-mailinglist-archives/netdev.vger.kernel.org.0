Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1523A104317
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 19:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKTSP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 13:15:58 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727656AbfKTSP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 13:15:58 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1AAE914BD135D;
        Wed, 20 Nov 2019 10:15:56 -0800 (PST)
Date:   Wed, 20 Nov 2019 10:15:53 -0800 (PST)
Message-Id: <20191120.101553.1725688714844743661.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com
Subject: Re: [PATCH net-next] lwtunnel: add support for multiple geneve opts
From:   David Miller <davem@davemloft.net>
In-Reply-To: <9c4231b54baf60619c110c818ca7a6eb37a2e52e.1574156351.git.lucien.xin@gmail.com>
References: <9c4231b54baf60619c110c818ca7a6eb37a2e52e.1574156351.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 10:15:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Tue, 19 Nov 2019 17:39:11 +0800

> geneve RFC (draft-ietf-nvo3-geneve-14) allows a geneve packet to carry
> multiple geneve opts, so it's necessary for lwtunnel to support adding
> multiple geneve opts in one lwtunnel route. But vxlan and erspan opts
> are still only allowed to add one option.
> 
> With this patch, iproute2 could make it like:
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 geneve_opts 0:0:12121212,1:2:12121212 \
>     dst 10.1.0.2 dev geneve1
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 vxlan_opts 456 \
>     dst 10.1.0.2 dev erspan1
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 erspan_opts 1:123:0:0 \
>     dst 10.1.0.2 dev erspan1
> 
> Which are pretty much like cls_flower and act_tunnel_key.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin.
