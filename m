Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6077E224610
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 23:57:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727873AbgGQV5Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 17:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727857AbgGQV5X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 17:57:23 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF7BEC0619D2;
        Fri, 17 Jul 2020 14:57:22 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id n26so12376536ejx.0;
        Fri, 17 Jul 2020 14:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ji0Wx/ccmvmTUNYjIjEJ4U30tV1+HxA1vsWw8hizX9s=;
        b=aXWgt4ZppDxINh4Qar1Xj6NuJU7rkvFFXtQ0RRXnbLuPtagc2bG+W5/kUv+Lhj9fpz
         Wv9hvZDtZIHDHj19cBteTFIpcff+kL4Qw7xL1lZwQhesWiXSW/Ap0/YwO4M3eXR8N7H4
         5pSMX9HxlPET4XjgX3KY8/p6wW4gdcTA1l8GKRpAxxr1ocfyYRGjkM78E1gYf/0CNCao
         panFCHuDM9xXzq4+RRqMUg8PbXPMprHFSdye1amYuHRZPmKVWH4PlDouOgOS3IDOFs+Q
         9+IvPh0e31tS/Hh1TpBXsE9jwThOx4Glq/DjI1socjwg2wj6M6IxOdCtPwml5sin85Ku
         uWRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ji0Wx/ccmvmTUNYjIjEJ4U30tV1+HxA1vsWw8hizX9s=;
        b=jUgkiH/eUIGp8meztk6/irfujO/M/E7/QO3ivFqdZwNw9IZKk3Pqe1JF3TC47k5Qgp
         iWVo/z220V7LjFyzzy8VBmxhrNDJrPMc701Nzt6QG5N9KtMkCL1u29PHYIdQsJGIKPvU
         3K+HxDhxd+0D4FmD4ukTgK4OBaVTV8HZuXfnmT+2UMAbtKMKkMWI7DRIgYn6hgEn/7Vl
         cqw2a5t9qGXFy+y3DvNs39RU/wlv478RkCA06MSEE4uMWVXbP3tePzCsdGLq6uTKqHgk
         nFgxBvYUyFfiWBIba5hAcwSUn0xx+14oH7qh2V75tn1grW5DpQPr+owladG7T+BqWXT1
         ecFQ==
X-Gm-Message-State: AOAM530CM25Lsr4JtuuI3UWCbqFboA374TjIi0QLKZKlTPGBERojUxEQ
        G/TJ4uVAHL5oPQy2Se8QUPM=
X-Google-Smtp-Source: ABdhPJzWi9P5cxj0TnZ2koUFNy03dn3j4LzuVe/jHXXGrBYSBVXP4uCCd/sgZ0dOvQbJ54i0lnLqeQ==
X-Received: by 2002:a17:906:40cb:: with SMTP id a11mr10121195ejk.340.1595023041627;
        Fri, 17 Jul 2020 14:57:21 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id cc9sm9728571edb.14.2020.07.17.14.57.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 14:57:21 -0700 (PDT)
Date:   Sat, 18 Jul 2020 00:57:19 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Sergey Organov <sorganov@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        richardcochran@gmail.com, linux-doc@vger.kernel.org
Subject: Re: [PATCH net-next 0/3] Document more PTP timestamping known quirks
Message-ID: <20200717215719.nhuaak2xu4fwebqp@skbuf>
References: <20200717161027.1408240-1-olteanv@gmail.com>
 <87imelj14p.fsf@osv.gnss.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87imelj14p.fsf@osv.gnss.ru>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 12:13:42AM +0300, Sergey Organov wrote:
> Vladimir Oltean <olteanv@gmail.com> writes:
> 
> > I've tried to collect and summarize the conclusions of these discussions:
> > https://patchwork.ozlabs.org/project/netdev/patch/20200711120842.2631-1-sorganov@gmail.com/
> > https://patchwork.ozlabs.org/project/netdev/patch/20200710113611.3398-5-kurt@linutronix.de/
> > which were a bit surprising to me. Make sure they are present in the
> > documentation.
> 
> As one of participants of these discussions, I'm afraid I incline to
> alternative approach to solving the issues current design has than the one
> you advocate in these patch series.
> 
> I believe its upper-level that should enforce common policies like
> handling hw time stamping at outermost capable device, not random MAC
> driver out there.
> 
> I'd argue that it's then upper-level that should check PHY features, and
> then do not bother MAC with ioctl() requests that MAC should not handle
> in given configuration. This way, the checks for phy_has_hwtstamp()
> won't be spread over multiple MAC drivers and will happily sit in the
> upper-level ioctl() handler.
> 
> In other words, I mean that it's approach taken in ethtool that I tend
> to consider being the right one.
> 
> Thanks,
> -- Sergey

Concretely speaking, what are you going to do for
skb_defer_tx_timestamp() and skb_defer_rx_timestamp()? Not to mention
subtle bugs like SKBTX_IN_PROGRESS. If you don't address those, it's
pointless to move the phy_has_hwtstamp() check to net/core/dev_ioctl.c.

The only way I see to fix the bug is to introduce a new netdev flag,
NETIF_F_PHY_HWTSTAMP or something like that. Then I'd grep for all
occurrences of phy_has_hwtstamp() in the kernel (which currently amount
to a whopping 2 users, 3 with your FEC "fix"), and declare this
netdevice flag in their list of features. Then, phy_has_hwtstamp() and
phy_has_tsinfo() and what not can be moved to generic places (or at
least, I think they can), and those places could proceed to advertise
and enable PHY timestamping only if the MAC declared itself ready. But,
it is a bit strange to introduce a netdev flag just to fix a bug, I
think.

Thanks,
-Vladimir
