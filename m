Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B001136A14
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 10:40:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbgAJJka (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 04:40:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40909 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727192AbgAJJka (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 04:40:30 -0500
Received: by mail-wr1-f68.google.com with SMTP id c14so1124788wrn.7
        for <netdev@vger.kernel.org>; Fri, 10 Jan 2020 01:40:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=WXnTgOPDH+z337Wfb0xCw3m14azvnAshyBDM3QUKc5M=;
        b=FX0STnnPKdszYYa4KuXolRqcRbEGWUUvxdeiCooR5NQaVjkEaKIJyQuTN/Z10qG47P
         W1IZbKae9yQl7qsUMgJ43TVBzyV0NILejXw71O7sCyXapzar7F+Uc4HTPeg0PaIn6O/Z
         /JcZXDIV2jZkziwsT8lNNBWv2iSIPoPqv9GeOg094PiK1K4j6nSzGcgVqcntsOLr0BwC
         tnBFunhQjcG0qM5Nuk9d+/C1U/nGBIkV6RM+mFwKI/daCg1pYMuMm3VA66NhoHjIGfAL
         Dg7x/fs0eujoW3dQaWguAqM4x8MuA9v+hzPWCi2Z2mjTih1ldlB5/bJCLwUbRlFumc2R
         9duQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WXnTgOPDH+z337Wfb0xCw3m14azvnAshyBDM3QUKc5M=;
        b=ATWoAbhMp70lygflodA/6LPXiFCTPdJyx85rhh6B7WDZz0NPfQrpex165YV5OyeWlQ
         poqe22ufDl+Q28h0Ajyx4EAkKiBmKC3W5O0VeqhaWiN/nIE+9qS4J/PyXe5GLqtn3m4L
         lVt3CWmoxmwM+fKPMlx/EQyxLqrLxdQlsJKCv+cIpA5OMFeVIhRnbROzywYfRh4PrPWE
         IQFrgyn0sff3/p5XrvLkMF8Qsn/ht6bowJUzbj4EdjVsgoV8O60D0WE6EUhw6CFzlUxL
         tQ9DlynmRtu6aNZ/ifL/OkWCYw7gP7LgXRpaUFw/uZgQ/TJsZf0P8v0I/SELRBWHxeUq
         KS9A==
X-Gm-Message-State: APjAAAW5EEwHWO/HSBXVEgAkCp+QsAD0mz96yafQBc/CTaVzTTgZm3C6
        qOVLG7REt4BwYAfeVsP0eeRng0BsxpI=
X-Google-Smtp-Source: APXvYqwRnBAQuUjmRM4OL3kRTTDv9X0aXtDjC22rqh+y80PD9ds/D2Zz9Myo2ME6oa7xZ/LtBIuZqg==
X-Received: by 2002:adf:f98c:: with SMTP id f12mr2380319wrr.138.1578649228503;
        Fri, 10 Jan 2020 01:40:28 -0800 (PST)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id c2sm1552635wrp.46.2020.01.10.01.40.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jan 2020 01:40:28 -0800 (PST)
Date:   Fri, 10 Jan 2020 10:40:27 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com
Subject: Re: [PATCH v2 0/3] devlink region trigger support
Message-ID: <20200110094027.GL2235@nanopsycho.orion>
References: <20200109193311.1352330-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200109193311.1352330-1-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jan 09, 2020 at 08:33:07PM CET, jacob.e.keller@intel.com wrote:
>This series consists of patches to enable devlink to request a snapshot via
>a new DEVLINK_CMD_REGION_TRIGGER_SNAPSHOT.
>
>A reviewer might notice that the devlink health API already has such support
>for handling a similar case. However, the health API does not make sense in
>cases where the data is not related to an error condition.
>
>In this case, using the health API only for the dumping feels incorrect.
>Regions make sense when the addressable content is not captured
>automatically on error conditions, but only upon request by the devlink API.
>
>The netdevsim driver is modified to support the new trigger_snapshot
>callback as an example of how this can be used.

I don't think that the netdevsim usecase is enough to merge this in. You
need a real-driver user as well.

Of course, netdevsim implementation is good to have to, but you have to
bundle selftests along with that.


>
>Jacob Keller (3):
>  devlink: add callback to trigger region snapshots
>  devlink: introduce command to trigger region snapshot
>  netdevsim: support triggering snapshot through devlink
>
> drivers/net/ethernet/mellanox/mlx4/crdump.c |  4 +-
> drivers/net/netdevsim/dev.c                 | 37 ++++++++++++-----
> include/net/devlink.h                       | 12 ++++--
> include/uapi/linux/devlink.h                |  2 +
> net/core/devlink.c                          | 45 +++++++++++++++++++--
> 5 files changed, 80 insertions(+), 20 deletions(-)
>
>-- 
>2.25.0.rc1
>
