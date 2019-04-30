Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3367CFC12
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 17:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbfD3PBG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 11:01:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44755 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725995AbfD3PBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 11:01:06 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1D3EA81E1C;
        Tue, 30 Apr 2019 15:01:01 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.32.181.131])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 70A1134821;
        Tue, 30 Apr 2019 15:01:00 +0000 (UTC)
Message-ID: <9548f8204de3f2761759ae782a52ee4b293ce700.camel@redhat.com>
Subject: Re: [PATCH iproute2-next] tc: add support for plug qdisc
From:   Paolo Abeni <pabeni@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Date:   Tue, 30 Apr 2019 17:00:59 +0200
In-Reply-To: <20190429101638.1a250c01@hermes.lan>
References: <05c43d9415d196730ad382574a992497fd1d456d.1556121941.git.pabeni@redhat.com>
         <20190424134906.14311678@hermes.lan>
         <b6629ad2cb9afe49615360d359fce60ef2b19915.camel@redhat.com>
         <20190429101638.1a250c01@hermes.lan>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Tue, 30 Apr 2019 15:01:06 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2019-04-29 at 10:16 -0700, Stephen Hemminger wrote:
> On Fri, 26 Apr 2019 10:47:52 +0200
> Paolo Abeni <pabeni@redhat.com> wrote:
> > The problem here is that the sch_plug qdisc does not implement the
> > dump() qdisc_op, so this callback has nothing to dump.
> > 
> > Must I patch sch_plug first?
> > 
> > Thanks,
> > 
> > Paolo
> > 
> 
> OK, lets put the patch in as is for now. And then fix the kernel, then add print?

Sounds good to me. I'll send soon a v2 with the SPDX.

Thanks,

Paolo


