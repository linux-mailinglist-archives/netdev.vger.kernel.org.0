Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 788D75B0B9
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 18:50:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbfF3Qut (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 Jun 2019 12:50:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:39014 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726605AbfF3Qus (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 30 Jun 2019 12:50:48 -0400
Received: by mail-wr1-f68.google.com with SMTP id x4so11190664wrt.6
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 09:50:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=Og8v0dJweDMAKLu08qf+JKf+lXRajrX9HXzjsmEJe8s=;
        b=kUXyjKVxHYTr6YZxlNJex73wAR2yvFz7rjs4t76vwIwe9mwD5GkNnEpGMZS1aN6qmS
         +iOxnIhTFb+1Tsfx+SFYFm4l/UT9ZNXwFUep90jSyOGcI3+yO+bF50xLi/JP0qBs0NYf
         4uA4FVDPbDhiZd2y+qf2ZBRRVWdYQQUjabhfSNb5ffKwszayoHi0JoZo+TKiBLHpNDbv
         Puxn//mAhC2aN1JkuffDOa7tkGIW3gc6v7KIdAZ9zNsRlyjGYouhxA9MPSX2pu/ux6pi
         jUmdXJ7XLOfrx6SC/kUQpikKBDDmYuHgNI7kI1ZXfuLDRRDn6CGHNIHJDft64Urq2krF
         CFcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=Og8v0dJweDMAKLu08qf+JKf+lXRajrX9HXzjsmEJe8s=;
        b=e16OYoKcUpLLpgopcEv8OU9CqCYbaUSV3vUXZ9owjAM/Z8QLRXgKmg2r5AXogp0R1r
         3tPumGJCTAZOmOl4gmfea3Gx6Kr3aJQxswSR+TTrJUBk7OO8OL+nbYgrFSwt52owpOxy
         8IbpOZzhIn0wiy0L9m0TSKH07RCToDFtB8xtEncFh77SWE/npnP0wVqLd5i+lLPd2T3g
         SLql+673xUJZiMTta7VviMKmbQGf52eg/NI1RZXg/bJsukGT0eA8KRUbbt21wVIePuNl
         hcMQxCE37lbgSpV+wN4Mytk3ZWJl/6S4724IG6Au0S3jK44gKWLuGprYq+VEiWQLw53j
         KPig==
X-Gm-Message-State: APjAAAU5L0X5Zhqfw3eWbBQnPeYLVdAnbjdEUZSOkDN7rcmnNyZJjvnv
        s90TUBSEqHMrhd2wuNWMMDrr3w==
X-Google-Smtp-Source: APXvYqxGn0Y1F2G21gdsD47dIFcPbT6LIE9ds/nkAVoa101m9FlpMOTmgF9pr0xLjCwm81IgTO+/qw==
X-Received: by 2002:adf:c706:: with SMTP id k6mr2734818wrg.40.1561913446207;
        Sun, 30 Jun 2019 09:50:46 -0700 (PDT)
Received: from apalos (athedsl-4461147.home.otenet.gr. [94.71.2.75])
        by smtp.gmail.com with ESMTPSA id 32sm17649612wra.35.2019.06.30.09.50.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 09:50:45 -0700 (PDT)
Date:   Sun, 30 Jun 2019 19:50:42 +0300
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        ard.biesheuvel@linaro.org, bjorn.topel@intel.com,
        magnus.karlsson@intel.com, brouer@redhat.com, daniel@iogearbox.net,
        ast@kernel.org, makita.toshiaki@lab.ntt.co.jp,
        jakub.kicinski@netronome.com, john.fastabend@gmail.com,
        davem@davemloft.net, maciejromanfijalkowski@gmail.com
Subject: Re: [net-next, PATCH 3/3, v2] net: netsec: add XDP support
Message-ID: <20190630165042.GB11278@apalos>
References: <1561785805-21647-1-git-send-email-ilias.apalodimas@linaro.org>
 <1561785805-21647-4-git-send-email-ilias.apalodimas@linaro.org>
 <20190630162042.GA12704@khorivan>
 <20190630163417.GB10484@apalos>
 <20190630164512.GD12704@khorivan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190630164512.GD12704@khorivan>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 30, 2019 at 07:45:13PM +0300, Ivan Khoronzhuk wrote:
> On Sun, Jun 30, 2019 at 07:34:17PM +0300, Ilias Apalodimas wrote:
> >Hi Ivan,
> >>
> >>[...]
> >>
> >>>+
> >>>+static int netsec_xdp(struct net_device *ndev, struct netdev_bpf *xdp)
> >>>+{
> >>>+	struct netsec_priv *priv = netdev_priv(ndev);
> >>>+
> >>>+	switch (xdp->command) {
> >>>+	case XDP_SETUP_PROG:
> >>>+		return netsec_xdp_setup(priv, xdp->prog, xdp->extack);
> >>>+	case XDP_QUERY_PROG:
> >>>+		xdp->prog_id = priv->xdp_prog ? priv->xdp_prog->aux->id : 0;
> >>xdp_attachment family to save bpf flags?
> >Sure why not. This can always be added later though since many drivers are
> >already doing it similarly no?
> yes.
> I can work w/o this ofc.
> But netronome and cpsw (me) added this.
Ok let's start using that

> What I've seen it allows to prevent prog update if flag doesn't allow it.
> Usually it doesn't allow, but can be forced with flag. In another case it can
> be updated any time w/o reason...and seems like in your case it's sensitive.
I intend to send a follow up patch anyway to remove the declaration on the top
of the file of netsec_set_tx_de(). I intentionally choose to add that to make
the review easier (since re-arranging would mess that up).

I'll just this optimization as well on the follow up patch since it doesn't
break anything

Thanks
/Ilias
