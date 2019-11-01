Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A27F2EC543
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 16:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbfKAPD1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 11:03:27 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:44918 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727365AbfKAPD0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 11:03:26 -0400
Received: by mail-wr1-f67.google.com with SMTP id f2so1039908wrs.11
        for <netdev@vger.kernel.org>; Fri, 01 Nov 2019 08:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=wKqXfvZWrQz1n3ascw58fy8Akh2y/FtmDPOkWTyzyfY=;
        b=ws3zZ5Uicol7T0q//uQT40qivLqP3f2fSdmlHh40z6ocWNYtoy6MCOuLfdKYWZfMKS
         cue1kCFtM3ary0ryAqMUSgnv1P5XeKnCLUIyzJWGgsFRCtbRybeVQWnx9IY2370sD4Zh
         2LZYw7plqDqnDIOMkDA8hUimU3yjLM8Hpt2SdeA3TF1Ws6orHjbR5HweCkuQ0+wjr7um
         n5VrpzIwxpMHY3J/D/saidTIa7uV5HK4xgL+EMfdNXpNsq/RJR35BTO7Kq8zPfGwDAxj
         NSPd0tcNeZ6QG11x2CURNg+9JjgUEFLoQuqnfVGOI549ZjmqPzCqoThtSfw4P+aU56BM
         xETQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wKqXfvZWrQz1n3ascw58fy8Akh2y/FtmDPOkWTyzyfY=;
        b=kHQWRGj773prLAd4xEj8HJX8EXi0U1ucTAlNsr+kp18uDCy8Vx3l+v3U84KM3jE6fr
         zhfTeAJ7IAx4XwdhDARJOVkKL2fsuwV9yGnIgEjmCLaTvUScxTzqQpdSzG+2jF3BQUS9
         P7A3chI/qUjGgbrfyVoOU0o/JnjTrfbfzhsxgsGLkXxDaCb7X+7SwWp3und/3EaLb4EA
         SzILPowR08b+waLmKx9wZapDkJm0V/MWMV2LwiKresjW4Ks+6cqbIDaAgaap/L2xpBqM
         yKuvIaqOL88MJVp0SH1rpoCF5hl9s1KiBZFj0VjeULUfQNu4vPPFjCHWl6MJju8KxORI
         O9TA==
X-Gm-Message-State: APjAAAUy5olNfw2MmS41+/8CJNmJ4ZG/CinrkqZuOTrGKpnGNGhq8wfm
        gaR0+EyOMg0B9+ZcPI85KNvoig==
X-Google-Smtp-Source: APXvYqxusNCycKMoEK+7x9WjnNtpLqHubFpyz72J9sNYtu1+osdcL+xW/I9kefVQr2Pa3hmkfZERoA==
X-Received: by 2002:adf:9486:: with SMTP id 6mr10593224wrr.28.1572620604647;
        Fri, 01 Nov 2019 08:03:24 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id c21sm6365647wmb.46.2019.11.01.08.03.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Nov 2019 08:03:24 -0700 (PDT)
Date:   Fri, 1 Nov 2019 16:03:23 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Michael Walle <michael@walle.cc>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC PATCH 2/3] dt-bindings: net: phy: Add support for AT803X
Message-ID: <20191101150322.GB5859@netronome.com>
References: <20191030224251.21578-1-michael@walle.cc>
 <20191030224251.21578-3-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191030224251.21578-3-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 30, 2019 at 11:42:50PM +0100, Michael Walle wrote:
> Document the Atheros AR803x PHY bindings.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  .../bindings/net/atheros,at803x.yaml          | 58 +++++++++++++++++++
>  include/dt-bindings/net/atheros-at803x.h      | 13 +++++
>  2 files changed, 71 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/atheros,at803x.yaml
>  create mode 100644 include/dt-bindings/net/atheros-at803x.h

Hi Michael,

please run the schema past dtbs_check as per the instructions in
Documentation/devicetree/writing-schema.rst
