Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BB01B4D41
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 21:21:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgDVTVo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 15:21:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726102AbgDVTVo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 15:21:44 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B355FC03C1AB
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 12:21:43 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id r16so2416903edw.5
        for <netdev@vger.kernel.org>; Wed, 22 Apr 2020 12:21:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=YxCJuKeYutDLDPXAPSEMJzIV43DxzgPvToiuGHFZFLc=;
        b=o8msrCuYl9yzwxwdinHp/5zJ/iluTXdc1PKyO8gPAZru5AYRPBYpTv4YM7zOXc3nZ2
         FGujQQrnudYueNgJjGfkvcAh+9/zKbk6PPZq6bKDzW6/flpD97bfMTX1npa9m0v9spXg
         chVFpy1nyofJYumkysSQudI+cOAaRtj7pqe6tohr6PYBQvlIvsVKL0tQD9PjhghVSJiH
         zN9nuJGnSUuENXK2lVmroUT265WhUirrk/aBSjMAScCtF3fleu1UAPyUaP4gx31qOlCk
         QNC6+SqqfYISxB040FO1lDWibFTqu2SxfQZQxx/Mqavaf1xszxYhNDBN3QoHxy7651nB
         FG8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=YxCJuKeYutDLDPXAPSEMJzIV43DxzgPvToiuGHFZFLc=;
        b=nGZxajM0N+Q5QSIER3DbmHzZLFeeCqkKiIs9Z2UJcjW0SkB499aDlcaehU7px+CW/t
         3GKfcGlOblj4odvbON4EEDqXlafYzZI5FPtnsrxxY38FCyTXHGNAuRYF0h7hSjgL2Vij
         esVKOuN+/17mTNewjDl7iz1lLTbnpkjyPmgoVLgaGLSWLhtGet/0RKGUeYYGU67poNN0
         bYqwC/jdEd4MJCbjMhlCWL6OMqM9v77tgtqInbUx8hg45nLlfxwQqC16aonUs9fasWDX
         hW1E6ulFpmH05lProhXoawbUnzm49kNWaIGsZlKV/k9v4CKGub3aVmc55fF5L6L376hb
         5oUg==
X-Gm-Message-State: AGi0PuaQjVFclOSo6hSLLqg+/7YgYUnCQqmMwwLtkpt8i85+L9BKi0Mp
        0nEZaNLsLr0keNzuP9PnXd+FrKzB2hcDQxbQFMUh
X-Google-Smtp-Source: APiQypIvh77fUhTJY8QW3thwdXTgaIIw2VU2oQABHxAtS41WIPnpdUCvR4mja7yxyHkw8pkxV5zKKFWsvAua+tkBpBM=
X-Received: by 2002:a50:d98b:: with SMTP id w11mr129015edj.196.1587583302343;
 Wed, 22 Apr 2020 12:21:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200422190753.2077110-1-carnil@debian.org> <20200422191301.GA2361@lorien.valinor.li>
In-Reply-To: <20200422191301.GA2361@lorien.valinor.li>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 22 Apr 2020 15:21:31 -0400
Message-ID: <CAHC9VhSxMA3cjdjUt+wYFLnct835KedTL9JSRCgQsecqGs+wDQ@mail.gmail.com>
Subject: Re: [PATCH] netlabel: Kconfig: Update reference for NetLabel Tools project
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     netdev@vger.kernel.org, linux-security-module@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 22, 2020 at 3:13 PM Salvatore Bonaccorso <carnil@debian.org> wrote:
> On Wed, Apr 22, 2020 at 09:07:53PM +0200, Salvatore Bonaccorso wrote:
> > The NetLabel Tools project has moved from http://netlabel.sf.net to a
> > GitHub. Update to directly refer to the new home for the tools.
>
> Oh, well s/GitHub/GitHub project/.
>
> >
> > Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> > ---
> >  net/netlabel/Kconfig | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)

Thanks Salvatore.

Acked-by: Paul Moore <paul@paul-moore.com>

> > diff --git a/net/netlabel/Kconfig b/net/netlabel/Kconfig
> > index 64280a1d3906..07b03c306f28 100644
> > --- a/net/netlabel/Kconfig
> > +++ b/net/netlabel/Kconfig
> > @@ -14,6 +14,6 @@ config NETLABEL
> >         Documentation/netlabel as well as the NetLabel SourceForge project
> >         for configuration tools and additional documentation.
> >
> > -        * http://netlabel.sf.net
> > +        * https://github.com/netlabel/netlabel_tools
> >
> >         If you are unsure, say N.
> > --
> > 2.26.2

-- 
paul moore
www.paul-moore.com
