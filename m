Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0936C28AEBD
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 09:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgJLHEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 03:04:08 -0400
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:41818 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726953AbgJLHDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 03:03:38 -0400
X-IronPort-AV: E=Sophos;i="5.77,366,1596492000"; 
   d="scan'208";a="472053769"
Received: from abo-173-121-68.mrs.modulonet.fr (HELO hadrien) ([85.68.121.173])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Oct 2020 09:03:35 +0200
Date:   Mon, 12 Oct 2020 09:03:35 +0200 (CEST)
From:   Julia Lawall <julia.lawall@inria.fr>
X-X-Sender: jll@hadrien
To:     David Howells <dhowells@redhat.com>
cc:     Julia Lawall <Julia.Lawall@inria.fr>,
        =?UTF-8?Q?Valdis_Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
        Joe Perches <joe@perches.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-afs@lists.infradead.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] rxrpc: use semicolons rather than commas to separate
 statements
In-Reply-To: <1215803.1602486055@warthog.procyon.org.uk>
Message-ID: <alpine.DEB.2.22.394.2010120903170.2901@hadrien>
References: <1602412498-32025-2-git-send-email-Julia.Lawall@inria.fr> <1602412498-32025-1-git-send-email-Julia.Lawall@inria.fr> <1215803.1602486055@warthog.procyon.org.uk>
User-Agent: Alpine 2.22 (DEB 394 2020-01-19)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Mon, 12 Oct 2020, David Howells wrote:

> Julia Lawall <Julia.Lawall@inria.fr> wrote:
>
> > -		call->completion = compl,
> > +		call->completion = compl;
>
> Looks good.  Do you want me to pick up the patch or send it yourself?

Please pick it up.  Thanks.

julia

>
> If the latter:
>
> Acked-by: David Howells <dhowells@redhat.com>
>
>
