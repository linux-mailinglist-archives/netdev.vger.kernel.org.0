Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444FD426853
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 12:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240018AbhJHK4w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 06:56:52 -0400
Received: from smtprelay0079.hostedemail.com ([216.40.44.79]:48316 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230076AbhJHK4v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Oct 2021 06:56:51 -0400
Received: from omf04.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay05.hostedemail.com (Postfix) with ESMTP id BB37C181C223F;
        Fri,  8 Oct 2021 10:54:55 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf04.hostedemail.com (Postfix) with ESMTPA id 769ADD1518;
        Fri,  8 Oct 2021 10:54:54 +0000 (UTC)
Message-ID: <21a4fcacc72b6d45576da7c78001a519d275a2ea.camel@perches.com>
Subject: Re: [RESEND PATCH v2 2/7] nfc: nci: replace GPLv2 boilerplate with
 SPDX
From:   Joe Perches <joe@perches.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        Krzysztof Opasiak <k.opasiak@samsung.com>,
        Mark Greer <mgreer@animalcreek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org
Date:   Fri, 08 Oct 2021 03:54:53 -0700
In-Reply-To: <9669a6cd-77de-ca0c-153c-75b531bd2490@canonical.com>
References: <20211007133021.32704-1-krzysztof.kozlowski@canonical.com>
         <20211007133021.32704-3-krzysztof.kozlowski@canonical.com>
         <34cc3eda06fa2e793c46b48ee734fd879e6f8ab1.camel@perches.com>
         <9669a6cd-77de-ca0c-153c-75b531bd2490@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 769ADD1518
X-Spam-Status: No, score=-2.89
X-Stat-Signature: 9khaeqtsjic1piurpz5k1nttf6hezmgx
X-Rspamd-Server: rspamout02
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX1+Fyqv1yNPdUZqhVa2I9gyj1a5PqJfsXHw=
X-HE-Tag: 1633690494-74783
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-10-08 at 12:46 +0200, Krzysztof Kozlowski wrote:
> On 08/10/2021 12:33, Joe Perches wrote:
> > On Thu, 2021-10-07 at 15:30 +0200, Krzysztof Kozlowski wrote:
> > > Replace standard GPLv2 only license text with SPDX tag.
> > 
> > Nak
> > 
> > This is actually licenced with GPL-2.0-or-later
> > 
> > > diff --git a/net/nfc/nci/uart.c b/net/nfc/nci/uart.c
> > []
> > > @@ -1,20 +1,8 @@
> > > +// SPDX-License-Identifier: GPL-2.0
> > []
> > You may use, redistribute and/or modify this File in
> > > - * accordance with the terms and conditions of the License, a copy of which
> > > - * is available on the worldwide web at
> > > - * http://www.gnu.org/licenses/old-licenses/gpl-2.0.txt.
> > 
> > See the actual text at the old link which includes:
> > 
> >     This program is free software; you can redistribute it and/or modify
> >     it under the terms of the GNU General Public License as published by
> >     the Free Software Foundation; either version 2 of the License, or
> >     (at your option) any later version.
> 
> 
> Thanks Joe for checking this. Isn't this conflicting with first
> paragraph in the source file:
> 
>   This software file (the "File") is distributed by Marvell
> InternationalLtd. under the terms of the GNU General Public License
> Version 2, June 1991(the "License").
> 
> This part does not specify "or later".

It doesn't need to as it calls out the exact license which by
specific reference includes the "or later".

And this is a nominal 'weakness' in the spdx license referencing
system which relies on contents of files in the LICENSE directory.


