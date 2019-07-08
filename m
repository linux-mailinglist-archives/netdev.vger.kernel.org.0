Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4E7061FFA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 16:02:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731544AbfGHOCb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 10:02:31 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:39674 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729009AbfGHOCb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 10:02:31 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hkUDp-00013E-6A; Mon, 08 Jul 2019 16:02:25 +0200
Date:   Mon, 8 Jul 2019 16:02:25 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Florian Westphal <fw@strlen.de>, Jiri Pirko <jiri@mellanox.com>,
        Roi Dayan <roid@mellanox.com>,
        Yossi Kuperman <yossiku@mellanox.com>,
        Oz Shlomo <ozsh@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Aaron Conole <aconole@redhat.com>,
        Zhike Wang <wangzhike@jd.com>,
        Rony Efraim <ronye@mellanox.com>,
        "nst-kernel@redhat.com" <nst-kernel@redhat.com>,
        John Hurley <john.hurley@netronome.com>,
        Simon Horman <simon.horman@netronome.com>,
        Justin Pettit <jpettit@ovn.org>
Subject: Re: [PATCH net-next v4 1/4] net/sched: Introduce action ct
Message-ID: <20190708140225.42lp36fk3brcmkv3@breakpoint.cc>
References: <1562486612-22770-1-git-send-email-paulb@mellanox.com>
 <1562486612-22770-2-git-send-email-paulb@mellanox.com>
 <20190707120455.6li4tfb5ppht4xy7@breakpoint.cc>
 <55a5a05f-b2c0-dda0-e961-75a7b4821dc1@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55a5a05f-b2c0-dda0-e961-75a7b4821dc1@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Paul Blakey <paulb@mellanox.com> wrote:
> Like if conntrack has just timed it out (or conntrack flushed), and skb 
> holds the last ref?

Yes, thats very unlikely but its possible.
