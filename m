Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FD5417587
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 12:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726969AbfEHKAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 06:00:15 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:42034 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726839AbfEHKAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 06:00:14 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hOJMl-0001nq-VX; Wed, 08 May 2019 12:00:00 +0200
Date:   Wed, 8 May 2019 11:59:59 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Pravin B Shelar <pshelar@ovn.org>,
        "David S . Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Flavio Leitner <fbl@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] openvswitch: Replace removed NF_NAT_NEEDED with
 IS_ENABLED(CONFIG_NF_NAT)
Message-ID: <20190508095959.4zei2weel54g7hay@breakpoint.cc>
References: <20190508065232.23400-1-geert@linux-m68k.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190508065232.23400-1-geert@linux-m68k.org>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> Commit 4806e975729f99c7 ("netfilter: replace NF_NAT_NEEDED with
> IS_ENABLED(CONFIG_NF_NAT)") removed CONFIG_NF_NAT_NEEDED, but a new user
> popped up afterwards.

Thnaks for spotting this.

Acked-by: Florian Westphal <fw@strlen.de>
