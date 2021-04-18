Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68DCB3632C5
	for <lists+netdev@lfdr.de>; Sun, 18 Apr 2021 02:09:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235936AbhDRAJl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Apr 2021 20:09:41 -0400
Received: from smtprelay0218.hostedemail.com ([216.40.44.218]:54102 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230339AbhDRAJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Apr 2021 20:09:40 -0400
Received: from omf02.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id A877318011AD6;
        Sun, 18 Apr 2021 00:09:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf02.hostedemail.com (Postfix) with ESMTPA id 426A21D42F4;
        Sun, 18 Apr 2021 00:09:11 +0000 (UTC)
Message-ID: <e256ba8bf66ec4baa5267b4a2f64b2a215817d16.camel@perches.com>
Subject: Re: [PATCH RESEND][next] rtl8xxxu: Fix fall-through warnings for
 Clang
From:   Joe Perches <joe@perches.com>
To:     Jes Sorensen <jes.sorensen@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
Date:   Sat, 17 Apr 2021 17:09:09 -0700
In-Reply-To: <6bcce753-ceca-8731-ec66-6f467a3199fd@gmail.com>
References: <20210305094850.GA141221@embeddedor>
         <20210417175201.2D5A7C433F1@smtp.codeaurora.org>
         <6bcce753-ceca-8731-ec66-6f467a3199fd@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 426A21D42F4
X-Spam-Status: No, score=1.60
X-Stat-Signature: hgnmhy4119fdik7mx4bit7j8p7jbgjp3
X-Rspamd-Server: rspamout01
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1/LdIaJsZonw8iNo1xt8+C1+emAnnvBTaA=
X-HE-Tag: 1618704551-717195
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 2021-04-17 at 14:30 -0400, Jes Sorensen wrote:
> On 4/17/21 1:52 PM, Kalle Valo wrote:
> > "Gustavo A. R. Silva" <gustavoars@kernel.org> wrote:
> > 
> > > In preparation to enable -Wimplicit-fallthrough for Clang, fix
> > > multiple warnings by replacing /* fall through */ comments with
> > > the new pseudo-keyword macro fallthrough; instead of letting the
> > > code fall through to the next case.
> > > 
> > > Notice that Clang doesn't recognize /* fall through */ comments as
> > > implicit fall-through markings.
> > > 
> > > Link: https://github.com/KSPP/linux/issues/115
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > 
> > Patch applied to wireless-drivers-next.git, thanks.
> > 
> > bf3365a856a1 rtl8xxxu: Fix fall-through warnings for Clang
> > 
> 
> Sorry this junk patch should not have been applied.

I don't believe it's a junk patch.
I believe your characterization of it as such is flawed.

You don't like the style, that's fine, but:

Any code in the kernel should not be a unique style of your own choosing
when it could cause various compilers to emit unnecessary warnings.

Please remember the kernel code base is a formed by a community with a
nominally generally accepted style.  There is a real desire in that
community to both enable compiler warnings that might show defects and
simultaneously avoid unnecessary compiler warnings.

This particular change just avoids a possible compiler warning.

