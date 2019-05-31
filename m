Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1321E31259
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 18:28:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfEaQ2R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 12:28:17 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:33394 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726640AbfEaQ2R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 12:28:17 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hWkO8-0005hn-4N; Fri, 31 May 2019 18:28:16 +0200
Date:   Fri, 31 May 2019 18:28:16 +0200
From:   Florian Westphal <fw@strlen.de>
To:     David Howells <dhowells@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        linux-afs@lists.infradead.org
Subject: Re: [PATCH net-next v2 1/7] afs: do not send list of client addresses
Message-ID: <20190531162816.7u7qslht5v7tkntm@breakpoint.cc>
References: <20190531122214.18616-2-fw@strlen.de>
 <20190531122214.18616-1-fw@strlen.de>
 <10847.1559317119@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10847.1559317119@warthog.procyon.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:
> Florian Westphal <fw@strlen.de> wrote:
> 
> > David Howell says:
> 
> "Howells"

My bad.

> Apart from that:
> 
> Tested-by: David Howells <dhowells@redhat.com>

Thanks, a lot, I've re-submitted this as v3 retaining your tested-by.
