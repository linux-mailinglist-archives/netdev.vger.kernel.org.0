Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDBA524CD40
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 07:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbgHUFX1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 01:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726757AbgHUFXQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 01:23:16 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 227C0C061386;
        Thu, 20 Aug 2020 22:23:16 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id m34so452304pgl.11;
        Thu, 20 Aug 2020 22:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kIrZF45/BAvVQh8mbn5wXf5JnEyRG1slRn5cBPdhKss=;
        b=DfmN6vb4B8kr6tDcwzZIlusSYb6WCJA3RduM6NIddsXJ65ZCz0UVsNaSyZ/NUR94yX
         ad0zV3EMKOJ83IR0u+lHcjAwgFJDJKkeH8FmYfKUKTx8pEf/X9xczjahG5CklZRDaYt8
         LGWLqc39N+77WCD/ZUtlc0C2QUrBUbV/3Cp95Y2kGvBEF/Je37P3NW8CK/uZ0psozI2W
         Njup1s9Cp5s4PD4P24sGOxLs4YGeB9pgtv7xzwS9RKjuBetZSzMD8hENsgFAwHcyxgTD
         A/6NranznkC+nF4OyGfyN1j0af4E4UTcwGaAvyfxYW/tksZsXad+V5CDtj+USGPUUaNb
         5ruw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kIrZF45/BAvVQh8mbn5wXf5JnEyRG1slRn5cBPdhKss=;
        b=ahClYMkByhWiqrShZ2UpiQGNyCXrj6/8J0IqRyC2mMLSXKJk5w0q7W7Uitv6zrexDU
         yvR7e2qV6c6nxxMOCqRnXCh/2C20Aq+KGOxOQcEge9CkAT+RQFuAD/9IW0McyXt7089P
         qbckef1w4j9FBe8ACsJVPR5i+HuiCzPBk1cRkHc0Rx8UYdReih5+A0YSQvtmN9bQ8WlF
         H26yVGArkROlBdK4VC/73e1SyGGAyeIDfEPGY/FwdTWkhbjiql6j24o7YcPNUWdPZ1HW
         hl62FbeGkBpbN6Q9GnCD+F3fdhLNH7CET729OAUvVGOTjN0R4VketZdSZAoeAS8qE4A/
         K2Kg==
X-Gm-Message-State: AOAM532VtZyanoe9Ng9PjlX3af9zcMqLHXJuSztm15NuKPQistodcrFa
        MUX5WwRFdq4YhQUYaZDaEuE=
X-Google-Smtp-Source: ABdhPJwGMTHU2migh+Vtz36GIcyJKI0+/w+/wl9eaIpMSvJqvm5WwNJmFhE51zJndWVMYSVxv0mnRw==
X-Received: by 2002:a62:3583:: with SMTP id c125mr1136819pfa.1.1597987395542;
        Thu, 20 Aug 2020 22:23:15 -0700 (PDT)
Received: from f3 (ae055068.dynamic.ppp.asahi-net.or.jp. [14.3.55.68])
        by smtp.gmail.com with ESMTPSA id l7sm593466pjf.43.2020.08.20.22.23.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 22:23:14 -0700 (PDT)
Date:   Fri, 21 Aug 2020 14:23:08 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Coiby Xu <coiby.xu@gmail.com>
Cc:     netdev@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>
Subject: Re: [RFC 1/3] Initialize devlink health dump framework for the dlge
 driver
Message-ID: <20200821052308.GA12235@f3>
References: <20200814160601.901682-1-coiby.xu@gmail.com>
 <20200814160601.901682-2-coiby.xu@gmail.com>
 <20200816025640.GA27529@f3>
 <20200821030822.huyuxa5o5tcvtv2o@Rk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821030822.huyuxa5o5tcvtv2o@Rk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 11:08 +0800, Coiby Xu wrote:
[...]
> > > diff --git a/drivers/staging/qlge/qlge_health.h b/drivers/staging/qlge/qlge_health.h
> > > new file mode 100644
> > > index 000000000000..07d3bafab845
> > > --- /dev/null
> > > +++ b/drivers/staging/qlge/qlge_health.h
> > > @@ -0,0 +1,2 @@
> > > +#include <net/devlink.h>
> > > +int qlge_health_create_reporters(struct qlge_devlink *priv);
> > 
> > I would suggest to put this in qlge.h instead of creating a new file.
> 
> Although there are only two lines for now, is it possible qlge will add
> more devlink code? If that's the case, a file to single out these code

I would say that if there's more content in the future, it can move to a
separate file in the future.

If you feel strongly about putting this in its own file right away, then
make sure to add the usual
#ifndef QLGE_HEALTH_H
#define QLGE_HEALTH_H
...
