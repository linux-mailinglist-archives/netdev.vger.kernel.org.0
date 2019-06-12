Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63776422C4
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 12:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438048AbfFLKk2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 06:40:28 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47480 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403978AbfFLKk2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 06:40:28 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1hb0fz-0004eM-FG; Wed, 12 Jun 2019 12:40:19 +0200
Date:   Wed, 12 Jun 2019 12:40:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Colin King <colin.king@canonical.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] xfrm: fix missing break on AF_INET6 case
Message-ID: <20190612104019.2f6x72wa2qdxw5p3@breakpoint.cc>
References: <20190612103624.27246-1-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190612103624.27246-1-colin.king@canonical.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Colin King <colin.king@canonical.com> wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> It appears that there is a missing break statement for the AF_INET6 case
> that falls through to the default WARN_ONCE case. I don't think that is
> intentional. Fix this by adding in the missing break.

Yes, I sent same patch a few minutes ago:

https://patchwork.ozlabs.org/patch/1114377/

I don't mind which one gets applied.
