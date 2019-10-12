Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9230D51AD
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 20:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729466AbfJLSim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 14:38:42 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41513 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728636AbfJLSim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 14:38:42 -0400
Received: by mail-pg1-f195.google.com with SMTP id t3so7662688pga.8
        for <netdev@vger.kernel.org>; Sat, 12 Oct 2019 11:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=PYJCvQia0pn4Uc7MYvqlTl+JKad8tbHNffACvYNGz9k=;
        b=YbFafwXaQ3e0aSJl0kgMctLeYZPOsrSQjxl56JS30OWHSP1NSxgbiGOrDMiFOwYNuZ
         b1O51nEZwhxzI/m5b/0a4cm8VvNn/XH/v1qM8d2KlXlULmlHli+GXdvIbAXbuwEPOeRP
         LZFuHSujK0UAQUOqRW+CdnMgKoBCoOzxc5uZddQDne1PO73QI6j9kqwPufrR0WHn8BMW
         evBmHUrJzf07RNFa9b1VH+L9pth8y3B7TjlGhpXG+7UAmBj3+AAHG8wqPbvzOaMuf6Gv
         qyZDsr7XE3Jr6m/5a1ym0qytgJlh6U6zWBW3werw5y63Jeff9N1ky+WHocxSkA/XMNp5
         uyrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=PYJCvQia0pn4Uc7MYvqlTl+JKad8tbHNffACvYNGz9k=;
        b=OXTHVQvugh/IHyTjndR9ngUEruSeQfY/zwbODIyJpbN3ulZrc9nNBJAfVTux/NvGJt
         osEJHwsZvqfXD2p/pC8ks85Rpfp+cQWo6yF1GyTlJ5hUif8Q5BR/nNCwz1vgRMTNEFWY
         4P361nWTvW4IpvODWmGBEqVTSAH0YE0asJ1YWvFHIeyKHkl0iYAQOp3fb498Rc5kygEq
         tcydRtGhYhqy+eCpn0Sp0C1MpVJflc1znvz9kKLI1nQeaOa7i3S82bQgIF3p/s3ewnPu
         zglXMDodIUOFFqPhfNeczpKB+w7Dh9TvupoxoL8/mIL/5rqd5C48xzLs4cywyUWebL5Z
         61xA==
X-Gm-Message-State: APjAAAUQ/woF2FIQBAPdXe5OOr6gpWA/MAnrvsSPmTROBzHSBa0dHpFE
        /a769dtQv9G24m7hBcD12fo=
X-Google-Smtp-Source: APXvYqxNZ5AE78NYtuWPWCUTwQXLUEEZRD3IU/B1BrgDlp+FNfncY4JUODYEU2TuVO9Id2nKGvrIDQ==
X-Received: by 2002:a63:10d:: with SMTP id 13mr24138034pgb.173.1570905521475;
        Sat, 12 Oct 2019 11:38:41 -0700 (PDT)
Received: from localhost (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id z29sm13559880pff.23.2019.10.12.11.38.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 12 Oct 2019 11:38:40 -0700 (PDT)
Date:   Sat, 12 Oct 2019 11:38:38 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org,
        Intel Wired LAN <intel-wired-lan@lists.osuosl.org>,
        Jeffrey Kirsher <jeffrey.t.kirsher@intel.com>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [net-next v3 7/7] renesas: reject unsupported external timestamp
 flags
Message-ID: <20191012183838.GH3165@localhost>
References: <20190926181109.4871-1-jacob.e.keller@intel.com>
 <20190926181109.4871-8-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190926181109.4871-8-jacob.e.keller@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 26, 2019 at 11:11:09AM -0700, Jacob Keller wrote:
> Fix the renesas PTP support to explicitly reject any future flags that
> get added to the external timestamp request ioctl.
> 
> In order to maintain currently functioning code, this patch accepts all
> three current flags. This is because the PTP_RISING_EDGE and
> PTP_FALLING_EDGE flags have unclear semantics and each driver seems to
> have interpreted them slightly differently.

This driver doesn't check the flags. Not knowing this HW, I can't say
which edges are time stamped.
 
> Cc: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Richard Cochran <richardcochran@gmail.com>
