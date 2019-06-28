Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2ADEF5A234
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfF1RYG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:24:06 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:36483 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbfF1RYG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:24:06 -0400
Received: by mail-pg1-f193.google.com with SMTP id c13so2879644pgg.3
        for <netdev@vger.kernel.org>; Fri, 28 Jun 2019 10:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BeGgZf5/S2jGRQO/IvJxRzF6muKH5sphs9iEqtumrsA=;
        b=VzRsfw6A0wJV9v71IA5OPkK6VMqhdldZL3oHrxdex3p/hZEeJF3nmBrSvMPaK28y8j
         j1pfJ4TNhc3J9EiKdMaz99mnsKU7a7HvNDqCsURzRQHzb0Jp6FtybAIVAyOgwD1DeAzQ
         1knwfsJ3V2R2A8TUq5HCQBpW+sx1x4KSCw3BTeN+ELlenMNRhkHc8mGb/Gg6o57yVhCj
         upk0e05XZD9eY9OVPyqT1lmBZm3yXMTByoEzHadaGZ27eoai1A6yTzIISjCb1GnJChfE
         sl3JLGHUuqztqFbzAfRJqEzjcNHEZwC5R9hNjL/yjWkSPeOh9C0/uhOALfkzT33aduyZ
         PabQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=BeGgZf5/S2jGRQO/IvJxRzF6muKH5sphs9iEqtumrsA=;
        b=h7MhAut/LJneJLdX7u/56E50HcpCeVJ+knfunRWFsbG04F0KxtV1Lq8CYtqoA0Ifw+
         XaXh3vtGu7OdBlJfpR0jJ+4ef9t8A90Fu41m4RZVjDGlooOzUpk8ls0AAaxOwTy8xZ+p
         m8/JUB7gChQ5JpHen2tndXWNNF2q8JcR8T9S9dchhvGgqB4iTKgMBJWcldzdzfv0B/OJ
         94RyYIjAMoymsXSNZH9lcK07nCwYoF6grzR6BBGnHFNUs582psKjxM4b+1uPYI/0fLIo
         Qa/73rO/PcqbYRX6ngAxiqvxlHs2Jlncw4uFBGJXh4rJy2vEkUBPyuRFSt2CzK3eE3Yy
         Cdpw==
X-Gm-Message-State: APjAAAWnQHGDGreiN35waeKGzvwLIG57g9dCvJwAxznUcZ/Brr9C3IBt
        Crve2gWNa4BEVk8XIAXHgHk=
X-Google-Smtp-Source: APXvYqwkNRGCJsbxX3NI/cOZ4pwDXbeyQpN914Z+bqygqv0FPTvc5metNcANG7xgoxzB4CGbwYf0Wg==
X-Received: by 2002:a17:90a:3787:: with SMTP id v7mr14622726pjb.33.1561742645327;
        Fri, 28 Jun 2019 10:24:05 -0700 (PDT)
Received: from localhost ([192.55.54.42])
        by smtp.gmail.com with ESMTPSA id b11sm3230878pfd.18.2019.06.28.10.24.02
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 28 Jun 2019 10:24:05 -0700 (PDT)
Date:   Fri, 28 Jun 2019 19:23:51 +0200
From:   Maciej Fijalkowski <maciejromanfijalkowski@gmail.com>
To:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        jaswinder.singh@linaro.org, ard.biesheuvel@linaro.org,
        bjorn.topel@intel.com, magnus.karlsson@intel.com,
        daniel@iogearbox.net, ast@kernel.org,
        makita.toshiaki@lab.ntt.co.jp, jakub.kicinski@netronome.com,
        john.fastabend@gmail.com, davem@davemloft.net
Subject: Re: [PATCH 3/3, net-next] net: netsec: add XDP support
Message-ID: <20190628192351.00003555@gmail.com>
In-Reply-To: <20190628164741.GA27936@apalos>
References: <1561718355-13919-1-git-send-email-ilias.apalodimas@linaro.org>
        <1561718355-13919-4-git-send-email-ilias.apalodimas@linaro.org>
        <20190628153552.78a8c5ad@carbon>
        <20190628164741.GA27936@apalos>
X-Mailer: Claws Mail 3.17.1 (GTK+ 2.24.32; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 28 Jun 2019 19:47:41 +0300
Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:

> On Fri, Jun 28, 2019 at 03:35:52PM +0200, Jesper Dangaard Brouer wrote:
> > On Fri, 28 Jun 2019 13:39:15 +0300
> > Ilias Apalodimas <ilias.apalodimas@linaro.org> wrote:
> >   
> > > +static int netsec_xdp_setup(struct netsec_priv *priv, struct bpf_prog *prog,
> > > +			    struct netlink_ext_ack *extack)
> > > +{
> > > +	struct net_device *dev = priv->ndev;
> > > +	struct bpf_prog *old_prog;
> > > +
> > > +	/* For now just support only the usual MTU sized frames */
> > > +	if (prog && dev->mtu > 1500) {
> > > +		NL_SET_ERR_MSG_MOD(extack, "Jumbo frames not supported on XDP");
> > > +		return -EOPNOTSUPP;
> > > +	}
> > > +
> > > +	if (netif_running(dev))
> > > +		netsec_netdev_stop(dev);
> > > +
> > > +	/* Detach old prog, if any */
> > > +	old_prog = xchg(&priv->xdp_prog, prog);
> > > +	if (old_prog)
> > > +		bpf_prog_put(old_prog);
> > > +
> > > +	if (netif_running(dev))
> > > +		netsec_netdev_open(dev);  
> > 
> > Shouldn't the if-statement be if (!netif_running(dev))
> >   
> > > +  
> This is there to restart the device if it's up already (to rebuild the rings).
> This should be fine as-is

I think that Jesper's concern was about that you could have already stopped the
netdev earlier via netsec_netdev_stop (before the xchg)? So at this point
__LINK_STATE_START might be not set.

Maybe initially store what netif_running(dev) returns in stack variable and
act on it, so your stop/open are symmetric?

> 
> > > +	return 0;
> > > +}  
> 
> Thanks
> /Ilias

