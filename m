Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6A1B574ED
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 01:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbfFZXcS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 19:32:18 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:44010 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726373AbfFZXcS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 19:32:18 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hgHOi-0006um-6d; Thu, 27 Jun 2019 01:32:16 +0200
Date:   Thu, 27 Jun 2019 01:32:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Ran Rozenstein <ranro@mellanox.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Tariq Toukan <tariqt@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "edumazet@google.com" <edumazet@google.com>
Subject: Re: [PATCH net-next 0/2] net: ipv4: remove erroneous advancement of
 list pointer
Message-ID: <20190626233216.dke3tx3f5q4psj2n@breakpoint.cc>
References: <20190617140228.12523-1-fw@strlen.de>
 <08e102a0-8051-e582-56c8-d721bfc9e8b9@mellanox.com>
 <AM4PR0501MB276924D7AD83B349AA2A6A0BC5E30@AM4PR0501MB2769.eurprd05.prod.outlook.com>
 <20190625091903.gepfjgpiksslnyqy@breakpoint.cc>
 <AM4PR0501MB2769CE8DC11EE4A076B62CCCC5E20@AM4PR0501MB2769.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM4PR0501MB2769CE8DC11EE4A076B62CCCC5E20@AM4PR0501MB2769.eurprd05.prod.outlook.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Ran Rozenstein <ranro@mellanox.com> wrote:
> The test dose stress on the interface by running this 2 commands in loop:
> 
> command is: /sbin/ip -f inet addr add $IP/16 brd + dev ens8f1
> command is: ifconfig ens8f1 $IP netmask 255.255.0.0
> 
> when $IP change every iteration.
> 
> It execute every second when we see the reproduce somewhere between 40 to 200 seconds of execution.

I can reproduce this now,  I'll submit a fix tomorrow.
