Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F915164A5
	for <lists+netdev@lfdr.de>; Tue,  7 May 2019 15:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbfEGNfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 May 2019 09:35:22 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:37826 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726295AbfEGNfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 May 2019 09:35:22 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hO0FS-0003pu-QV; Tue, 07 May 2019 15:35:11 +0200
Date:   Tue, 7 May 2019 15:35:10 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Lukasz Pawelczyk <l.pawelczyk@samsung.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukasz Pawelczyk <havner@gmail.com>
Subject: Re: [PATCH] extensions: libxt_owner: Add complementary groups option
Message-ID: <20190507133510.u6jq5fhhkehlkr34@breakpoint.cc>
References: <CGME20190426160306eucas1p1a0c8ec9783cc78db7381582a70d6de10@eucas1p1.samsung.com>
 <20190426160257.4139-1-l.pawelczyk@samsung.com>
 <20190505225930.w4bcrlsgzq7cipvg@salvia>
 <d071578df35b11b858752f014f4ae5923b61be49.camel@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d071578df35b11b858752f014f4ae5923b61be49.camel@samsung.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukasz Pawelczyk <l.pawelczyk@samsung.com> wrote:
> On Mon, 2019-05-06 at 00:59 +0200, Pablo Neira Ayuso wrote:
> > On Fri, Apr 26, 2019 at 06:02:57PM +0200, Lukasz Pawelczyk wrote:
> > > The --compl-groups option causes GIDs specified with --gid-owner to
> > > be
> > > also checked in the complementary groups of a process.
> > 
> > Please, could you also update manpage?
> 
> Will do. iptables-extensions(8) I presume? Anything else?

Yes, thats the one.
