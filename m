Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 665E22F1A13
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 16:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730512AbhAKPuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 10:50:11 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:33584 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731838AbhAKPuK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 10:50:10 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyzRY-00HYgS-SJ; Mon, 11 Jan 2021 16:49:20 +0100
Date:   Mon, 11 Jan 2021 16:49:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Eran Ben Elisha <eranbe@nvidia.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Jiri Pirko <jiri@nvidia.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Jakub Sitnicki <jakub@cloudflare.com>,
        Guillaume Nault <gnault@redhat.com>
Subject: Re: [PATCH net-next v2 0/2] Dissect PTP L2 packet header
Message-ID: <X/xzgP/eJ1Edm79j@lunn.ch>
References: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1610358412-25248-1-git-send-email-eranbe@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 11:46:50AM +0200, Eran Ben Elisha wrote:
> Hi Jakub, Dave,
> 
> This series adds support for dissecting PTP L2 packet
> header (EtherType 0x88F7).
> 
> For packet header dissecting, skb->protocol is needed. Add protocol
> parsing operation to vlan ops, to guarantee skb->protocol is set,
> as EtherType 0x88F7 occasionally follows a vlan header.
> 
> Changelog:
> v2:
> - Add more people to CC list.

Hi Eran

How about adding the PTP maintainer to the CC: list?

    Andrew
