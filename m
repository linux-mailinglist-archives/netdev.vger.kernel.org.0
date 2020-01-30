Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8314D80D
	for <lists+netdev@lfdr.de>; Thu, 30 Jan 2020 10:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726885AbgA3JAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jan 2020 04:00:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:52412 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726865AbgA3JAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jan 2020 04:00:14 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1B1CC10574BA0;
        Thu, 30 Jan 2020 01:00:12 -0800 (PST)
Date:   Thu, 30 Jan 2020 10:00:11 +0100 (CET)
Message-Id: <20200130.100011.1303339090607584614.davem@davemloft.net>
To:     willemdebruijn.kernel@gmail.com
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, willemb@google.com
Subject: Re: [PATCH net] udp: document udp_rcv_segment special case for
 looped packets
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200129202017.67765-1-willemdebruijn.kernel@gmail.com>
References: <20200129202017.67765-1-willemdebruijn.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Jan 2020 01:00:14 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date: Wed, 29 Jan 2020 15:20:17 -0500

> From: Willem de Bruijn <willemb@google.com>
> 
> Commit 6cd021a58c18a ("udp: segment looped gso packets correctly")
> fixes an issue with rare udp gso multicast packets looped onto the
> receive path.
> 
> The stable backport makes the narrowest change to target only these
> packets, when needed. As opposed to, say, expanding __udp_gso_segment,
> which is harder to reason to be free from unintended side-effects.
> 
> But the resulting code is hardly self-describing.
> Document its purpose and rationale.
> 
> Signed-off-by: Willem de Bruijn <willemb@google.com>

Applied, thanks for following up on this Willem.
