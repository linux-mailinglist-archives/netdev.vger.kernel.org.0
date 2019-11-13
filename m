Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68FEBFA3D2
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 03:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729491AbfKMCMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 21:12:37 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45421 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729970AbfKMB6M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 20:58:12 -0500
Received: by mail-pg1-f193.google.com with SMTP id w11so263829pga.12
        for <netdev@vger.kernel.org>; Tue, 12 Nov 2019 17:58:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ErICr6JI+G92Aq/PhmnRfpbf4tU7/Z3yZ1NnGPcjERY=;
        b=CWtnxh9/7QqPXSEXyDX9v6pJ6UVvvjfQ4SCp2/erTZyV2TVEpC8A9VDP0s8Ektm74L
         mE7EZxijYXuNnYVGO7uu7JXWa4Wu+aoZpG2bZjDpfLn5HgMey6/TOj5gLN3GtfdmR32B
         ceGpbeey/4PnRgNyWxgojbP1TWtdM3HXP040y38noPA+JSsJtakOkl1Ua1p22hwlMRDN
         2Hxf28MZVJEsd0l0wRcAjv97JYEJllC2GgaFxC/rTlyyVvfStFReViG1ksuPPStZRkdK
         Y7UVzJ0T+n35H6wViLnp7JqYGjBemUCd1ToDGn29O/YtotqGHDv5EWp3Ow0PQZ9N2Zq/
         jpig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ErICr6JI+G92Aq/PhmnRfpbf4tU7/Z3yZ1NnGPcjERY=;
        b=DoW6SqRgJYH1qQtg2OMIom5KL1eE6A7Nw71/NE7IO561AvS846MRqCmAzxkJ21k1rE
         6S7EV9rXblJIrXNWyBQWTQdolmGxHj7R8hON6BI5B/KniFjihdc6FdQF05evEb62Diqv
         HyyBuG8h9qDqnGrSAR04pGtoMl605cUHz07lJ0jJKO8C0YyU5bdC7TqrCEZQfCuOZHsF
         /Oftz0LxZs5n9ccVV5L/s32UwthLsSYTYOG9pJixs1OCExrh8gzQel+M7GluH3MQGRzl
         mDz56SP9Lpmgc5ojqdXSU+0hMgOstoQbo+JStK5HYrXo7wxg/2FgRqYMhyGhTNcKVD2I
         j7zA==
X-Gm-Message-State: APjAAAUpXmm8vX94UuU6HK78fvHi5yIg3HKPK62ao++EMz/CwRKyHWcf
        zZmbgmpVOcwgrhqXJzY3WN1N6Qrf
X-Google-Smtp-Source: APXvYqzwceHIeMv6Y3rNMELiKOVpraUyzWKVeKpGMb9TiQNocT8B0330Kn8SxE6Jr26F3baPS2kODQ==
X-Received: by 2002:a17:90a:3808:: with SMTP id w8mr1235837pjb.143.1573610292057;
        Tue, 12 Nov 2019 17:58:12 -0800 (PST)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id w69sm273741pfc.164.2019.11.12.17.58.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2019 17:58:11 -0800 (PST)
Date:   Tue, 12 Nov 2019 17:58:09 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [net-next v3 0/7] new PTP ioctl fixes
Message-ID: <20191113015809.GA8608@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-1-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jacob,

On Thu, Sep 26, 2019 at 11:11:02AM -0700, Jacob Keller wrote:
> Jacob Keller (7):
>   ptp: correctly disable flags on old ioctls

This patch made it into net, but ...

>   net: reject PTP periodic output requests with unsupported flags
>   mv88e6xxx: reject unsupported external timestamp flags
>   dp83640: reject unsupported external timestamp flags
>   igb: reject unsupported external timestamp flags
>   mlx5: reject unsupported external timestamp flags
>   renesas: reject unsupported external timestamp flags

.. these did not.

There is still time before v5.4 gets released.  Would you care to
re-submit the missing six patches?

Thanks,
Richard
