Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12B5622DA19
	for <lists+netdev@lfdr.de>; Sat, 25 Jul 2020 23:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727119AbgGYVcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 17:32:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726601AbgGYVca (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 17:32:30 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6CBC08C5C0;
        Sat, 25 Jul 2020 14:32:30 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id h28so9459539edz.0;
        Sat, 25 Jul 2020 14:32:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=nzlkgUksKHKvjyC1WqdXTsA35q0rjk7MHaBjqIWnjlQ=;
        b=Zl3F8eWDLHoNjgDQzdT30Kx8/4VIzHWj4mf2BDBlDvZZLunYSlOMCdumd+tO/rN3mD
         A9HXEHa5aW7K5huN5rJr3kPbSSsw8yC0+c+8NHslxgzjPbZno1Z2U6gODVFT/y/2gzW4
         bx6++p7Q9t+zWvXBMSg05PCABlPv+Jc5hZeuUzWui8i2VgIPiY03gH4f2D/m5XxRCCCb
         btpx2NcWAW4pZtRni++2PBNFYUwzYBd97TcQsbJXf9kY5gD7xc84l/otAN0KMOySWV41
         vh4mlDqN9N5UHmSpK4g883NB/GDjvCO0DEV8QPBmHoDg6sc4qC1BchbiJWYvTmLObT6E
         MyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=nzlkgUksKHKvjyC1WqdXTsA35q0rjk7MHaBjqIWnjlQ=;
        b=QG0eHdapeLDZ/aj6GgpeoAzjmXaI+0UmLZqIvyj5C6zAUrumMtPpeixnCE3A1gHZaq
         Tc4HT9puyhsvcwOCqzBCdM1ObzGIiZqlKJMTdgE1sC2zVTTAxKPsiPkF+b3dUs5lZzgw
         5faU3OOAR3OWQKu8K6cXju45SibKl3uTY5VmUcaGRI8aHYU2vx29ODRZE4Veh6juVL//
         PcVL4iqFvZ5Zou1RmNlhm/YN28Tqx00CsRzLprniHPXeJO0feWXWPJi8uRgWsH5MvAx9
         rdrKNR62qYvzPYFJTn+kJwTzYWj0Ar2BeD8FEp6SvWoGZ5dFueYfwm22MBJcj44gPZ7E
         0aPw==
X-Gm-Message-State: AOAM532q/OruOn/Lt0vrOdG++2A5Td7b+2gLWO4qOBgeBI+mHZ2vzLuA
        UV1B4zRXzJ/aCvrfNt1OATN0EWVh
X-Google-Smtp-Source: ABdhPJxkqWGCqIFsWuIpm5PG1NeWwlCwFstln3uF/Q8Qgxf6PaIOHJkWz0pVirMYDs1F18x9r2v6MQ==
X-Received: by 2002:a05:6402:3099:: with SMTP id de25mr15061729edb.228.1595712749179;
        Sat, 25 Jul 2020 14:32:29 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id vr6sm1727656ejb.36.2020.07.25.14.32.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jul 2020 14:32:28 -0700 (PDT)
Date:   Sun, 26 Jul 2020 00:32:26 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, kuba@kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 3/3] docs: networking: timestamping: add a set
 of frequently asked questions
Message-ID: <20200725213226.hknk62rdovm3nmrz@skbuf>
References: <20200717161027.1408240-4-olteanv@gmail.com>
 <e6b6f240-c2b2-b57c-7334-4762f034aae3@intel.com>
 <20200718113519.htopj6tgfvimaywn@skbuf>
 <887fcc0d-4f3d-3cb8-bdea-8144b62c5d85@intel.com>
 <20200720210518.5uddqqbjuci5wxki@skbuf>
 <0fb4754b-6545-f8dc-484f-56aee25796f6@intel.com>
 <20200720221314.xkdbw25nsjsyvgbv@skbuf>
 <20200721002150.GB21585@hoboy>
 <20200721195127.nxuxg6ef2h6cs3wj@skbuf>
 <20200722032553.GB12524@hoboy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200722032553.GB12524@hoboy>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 08:25:53PM -0700, Richard Cochran wrote:
> On Tue, Jul 21, 2020 at 10:51:27PM +0300, Vladimir Oltean wrote:
> > So I think the position of "just don't have software timestamping code
> > in DSA and you'll be fine" won't be getting us anywhere. Either you can
> > or you can't, and there isn't anything absurd about it, so sooner or
> > later somebody will want to do it. The rules surrounding it, however,
> > are far from being ready, or clear.
> > 
> > Am I missing something?
> 
> I'm just trying to make things easy for you, as the author of DSA
> drivers.  There is no need to set skb flags that have no purpose
> within the stack.
> 
> Nobody is demanding software time stamps from any DSA devices yet, and
> so I don't see the point in solving a problem that doesn't exist.
> 
> I'm sorry if the "rules" are not clear, but if you look around the
> kernel internals, you will be hard pressed to find perfectly
> documented rules anywhere!
> 
> Thanks,
> Richard

Could we perhaps take a step back and see what can be improved about the
documentation updates?

Thanks,
-Vladimir
