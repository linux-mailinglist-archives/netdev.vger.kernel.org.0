Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6977822FED
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 11:12:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731624AbfETJLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 05:11:08 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45250 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730905AbfETJLI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 05:11:08 -0400
Received: by mail-wr1-f67.google.com with SMTP id b18so13617558wrq.12
        for <netdev@vger.kernel.org>; Mon, 20 May 2019 02:11:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=iY4bjmFlTOU+kWVhdgeuaCtlCIwIcKYJkRN4xoBuL9k=;
        b=ifu2MzurmOzynu/ICMLIcSkuvuAQbd897GSJqVWzgm3XShjERBZYAj4Y1Ve4DSGfcz
         SPwcFOcZgYG6DMitgEdtcmt+m/Jbf79eqaXJKHOF2KRKZkqW9C2jy2XHSZzrzvWWgOtq
         JMM1ZYqRVSCIzaiRVBwdNQiRI4YajZduxj1JsRep7Up3fXUiYq34h3GVDSMdtkZNZ4m9
         jBUu2PePFB4B8Ktow1i2E8/RTItnSEzYl4f5VFPbYuM9gpTyeaE4ycRbsDCqM5i3G5KK
         DFtZQDsn71yUc4/VTyOSoMqKRs4ABYIcaVJ7BZrzDBFNDHcK8pKv9PUek0HE2OJ2nSA/
         HvUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iY4bjmFlTOU+kWVhdgeuaCtlCIwIcKYJkRN4xoBuL9k=;
        b=M8SN2QKxUleGUzF7yDqWlp31NDi+RnX4A2sEMXPKhihMIhLLqtqG9WhNV1keai9QSa
         QbYLjLS7Y6M38f8LoS5CDvAWh+di7rx/eX2yvbknTq8s8q8aXvOUslGQc4ZgziTvQQBw
         cq4T3Nrv0MmhtpHJ9NiXJEMIc+YRWc87hfODwrexZRYfW7VNeHOEDAEvVd+bXn9/LRYE
         F+xRVW67m/aLu+qVflRuEijl6WwNlvaaYQnOMvdVNAd4JYgkz8vUlfFnKES4tPoLuUPX
         mphnr4aMqxw67Gq2T5zMownuXD71FbSs+WxtkuxT9U19Bk0Zr4O/n457X9phAmi+FUez
         Vyzg==
X-Gm-Message-State: APjAAAWEPZkHBsKeBf1aEpsq5wNaQ3AjjITa8VjgpxPZ/HSYtxZbwKeh
        r0rnEjQ1x8UbJM3wvPnvratXJg==
X-Google-Smtp-Source: APXvYqxLuUKh4+K19lqHo2rP6Vtuu/r9TgPMvae5Zvez0WEKspDuCUYCzvnYcSMwxk6FH+UzPuvh+w==
X-Received: by 2002:a5d:4d84:: with SMTP id b4mr1962859wru.102.1558343466709;
        Mon, 20 May 2019 02:11:06 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id s13sm14350662wmh.31.2019.05.20.02.11.05
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 May 2019 02:11:06 -0700 (PDT)
Date:   Mon, 20 May 2019 11:11:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        xdp-newbies@vger.kernel.org, bpf@vger.kernel.org,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Jason Wang <jasowang@redhat.com>
Subject: Re: [PATCH v2 net 2/2] net: core: generic XDP support for stacked
 device
Message-ID: <20190520091105.GA2142@nanopsycho>
References: <20190519031046.4049-1-sthemmin@microsoft.com>
 <20190519031046.4049-3-sthemmin@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190519031046.4049-3-sthemmin@microsoft.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, May 19, 2019 at 05:10:46AM CEST, stephen@networkplumber.org wrote:
>When a device is stacked like (team, bonding, failsafe or netvsc) the
>XDP generic program for the parent device is not called.  In these
>cases, the rx handler changes skb->dev to its own in the receive
>handler, and returns RX_HANDLER_ANOTHER.  Fix this by calling
>do_xdp_generic if necessary before starting another round.
>
>Review of all the places RX_HANDLER_ANOTHER is returned
>show that the current devices do correctly change skb->dev.
>
>There was an older patch that got abandoned that did the
>same thing, this is just a rewrite.
>
>Suggested-by: Jason Wang <jasowang@redhat.com>
>Fixes: d445516966dc ("net: xdp: support xdp generic on virtual devices")
>Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>Acked-by: Jason Wang <jasowang@redhat.com>
>---
> net/core/dev.c | 10 ++++++++++
> 1 file changed, 10 insertions(+)
>
>diff --git a/net/core/dev.c b/net/core/dev.c
>index b6b8505cfb3e..240d0b2de1a8 100644
>--- a/net/core/dev.c
>+++ b/net/core/dev.c
>@@ -4921,6 +4921,16 @@ static int __netif_receive_skb_core(struct sk_buff *skb, bool pfmemalloc,
> 			ret = NET_RX_SUCCESS;
> 			goto out;
> 		case RX_HANDLER_ANOTHER:
>+			if (static_branch_unlikely(&generic_xdp_needed_key)) {
>+				struct bpf_prog *xdp_prog;
>+
>+				xdp_prog = rcu_dereference(skb->dev->xdp_prog);
>+				ret = do_xdp_generic(xdp_prog, skb);
>+				if (ret != XDP_PASS) {
>+					ret = NET_RX_SUCCESS;
>+					goto out;
>+				}
>+			}

I'm always scarred of changes like this. The history tells us that this
codepaths are very fragile. It took us non-trivial efford to fix bonding
here, not to mention vlans (that was pain).

The reason for troubles was often fact that different flows were treated
differently (vlan accel/non-accel).

This patch calls do_xdp_generic for master device in different point in
the receive patch comparing to lower device. Would it be possible to
unify this? E.g. by moving do_xdp_generice() call from
netif_rx_internal()/netif_receive_skb_internal() here,
to the beginning of __netif_receive_skb_core()?



> 			goto another_round;
> 		case RX_HANDLER_EXACT:
> 			deliver_exact = true;
>-- 
>2.20.1
>
