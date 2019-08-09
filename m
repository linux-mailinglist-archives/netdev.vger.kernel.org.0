Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9D108823B
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 20:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406439AbfHISUn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 14:20:43 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:36880 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbfHISUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 14:20:43 -0400
Received: by mail-qt1-f195.google.com with SMTP id y26so96731334qto.4;
        Fri, 09 Aug 2019 11:20:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wLXt1wKoYGElfNIOoe/f7Yp/KfXnxPXx1/N7nq8c3go=;
        b=WtZZDMTVmcKQdsCpYdlF1dvFBc1AELP+oTuigRvcYRtVPzE1H4j9DgXzP52WU1PVIM
         eelmzD4dJbOsRfhb2+ATh8Ecluu01hViVPaE52dBAN0Vs8BQOwd87wSt4VCYhoQIz2H0
         vb+xiQYO9jjUC1PMfL3Ao9DLXPiQwiPesoxjBINoh86aN20MMd6ywUF0TzQtmDq87DJ7
         0l9ZePTuwYX2aq1gGE5JccdiDTYON9IUrns76R/cShiViuVe7hFNLSjmEino6+Mpr8sN
         PkwfrL5xCkSxohLbFOz8Kj8f19eZgDCxOI0vpSNGgOmqCf4dPjPq5cTR6ZLpNJkCbYau
         OyNw==
X-Gm-Message-State: APjAAAUzZKw7CkSnjWsXOhYhGAmUpNITvczFxNsSh4UeWXM910fr3keZ
        buF+H0JCaJCWCVubsgIGyTOfz8wVUIEjBxSBPD0=
X-Google-Smtp-Source: APXvYqxKLDXX87FcpQL2TgyMJLEjcIeNCrqNlbfTX64dCbqulfBr4FXPj0VAQFHyeFp8gszFBs/o1nNq1ZSEbmesRLw=
X-Received: by 2002:a0c:dd86:: with SMTP id v6mr19475380qvk.176.1565374842194;
 Fri, 09 Aug 2019 11:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <20190809144043.476786-1-arnd@arndb.de> <20190809144043.476786-10-arnd@arndb.de>
 <dc0de0cd9a1e24477b20d563199e800b98d933f6.camel@perches.com>
In-Reply-To: <dc0de0cd9a1e24477b20d563199e800b98d933f6.camel@perches.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 9 Aug 2019 20:20:26 +0200
Message-ID: <CAK8P3a2_B+gxqPUtCbfn9oR39DWGH2xQ-z3rCEh36f7jbaS+hA@mail.gmail.com>
Subject: Re: [PATCH v2 09/13] net: lpc-enet: fix printk format strings
To:     Joe Perches <joe@perches.com>
Cc:     soc@kernel.org, Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        kbuild test robot <lkp@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 6:30 PM Joe Perches <joe@perches.com> wrote:
> > @@ -1333,13 +1333,14 @@ static int lpc_eth_drv_probe(struct platform_device *pdev)
> >       pldat->dma_buff_base_p = dma_handle;
> >
> >       netdev_dbg(ndev, "IO address space     :%pR\n", res);
> > -     netdev_dbg(ndev, "IO address size      :%d\n", resource_size(res));
> > +     netdev_dbg(ndev, "IO address size      :%zd\n",
> > +                     (size_t)resource_size(res));
>
> Ideally all these would use %zu not %zd

Ok, changed now.

       Arnd
