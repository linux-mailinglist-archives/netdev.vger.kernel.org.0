Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DB5221FD3
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 11:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbgGPJj3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 05:39:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbgGPJj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 05:39:28 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB5BC061755;
        Thu, 16 Jul 2020 02:39:28 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id bm28so4295592edb.2;
        Thu, 16 Jul 2020 02:39:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=js2i5Cy8OpD9LgEjTR7eWiimO5ZCh1NUG2GhbGVCsuY=;
        b=Ov5Gd79DOoJHAsnRhVMl2HI5bWUyLpgLFy5ODIGrXyjDHG6IsrBpkpSDLIjL41M1CZ
         M0YeLyEt+kkyzIAJ8fRuUZm5ddd4ViXIytQAZlwb6qmNY0mBit9wq3KzGuGZXkDxvUtu
         WcFQXafYY7I0eDxHgwSw0m+LgCVjay59bYAgsOqQSGKk3ajIvdxjlPM5C2J8NKiusTQY
         gR6rRIZlIIRB1PHi1rBcj0jkN7azeQDe93axp5cxtoTdYvHj4BNEdsq6/S4W18rynaAC
         MP2LZZl/uTEEHd5W7AYUHNRTlmn/qCxrNFhbYWrKSmCBLzBhc3pIxyWowMsVCX7IPp+g
         Fhvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=js2i5Cy8OpD9LgEjTR7eWiimO5ZCh1NUG2GhbGVCsuY=;
        b=tAhm/HjWEMttJpsL8fTMS3RKyro5hVPzSaCs8QIuF9md3/CgXwqrRFXsT1nmQbBtZL
         2/OaJ0VxOgB4xhzzZZhBq7hpCseeO3AwmvL/VAVqILYzcnFgrKFKQlj9WlOFfMjUKfjP
         sPg6Ji7Ad0Aw1sYakS8dhGL4hZEDpZCIyV47YtmPq00deCNojUiRlEoaa8seu0PO4NYx
         WbRlPfpgDGyCVjpvqK7dS7uN8wtDrRlbs6M0/tAqkQrODKMdJwLTvSFcYK1Xy1SCcv5v
         WhTP1IITMvIVk5idCcn/mXpl4ZXd+qdDUEX1sAe5w0RCdCyEKcpaZTMKLxAlF4iNiula
         kPxA==
X-Gm-Message-State: AOAM533n9Wzeh1anlmN3d3L+rvdydv8msbWFbUTno4FNSRa8A2Q8QiEw
        ErB50iSoE9eVfaOSRo9Erz8=
X-Google-Smtp-Source: ABdhPJzN+0ojeiMcCy/EowIs69Kgc+Hz0d1vuCQwwVq5yPcmPrXz+vO9/kILCH6rDbu8PsGxAV3mmQ==
X-Received: by 2002:a05:6402:204e:: with SMTP id bc14mr3734435edb.128.1594892366919;
        Thu, 16 Jul 2020 02:39:26 -0700 (PDT)
Received: from skbuf ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id p9sm4487463ejd.50.2020.07.16.02.39.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 02:39:26 -0700 (PDT)
Date:   Thu, 16 Jul 2020 12:39:24 +0300
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Kamil Alkhouri <kamil.alkhouri@hs-offenburg.de>,
        ilias.apalodimas@linaro.org
Subject: Re: [PATCH v1 2/8] net: dsa: Add DSA driver for Hirschmann Hellcreek
 switches
Message-ID: <20200716093924.ueszkwokaer42vjh@skbuf>
References: <20200710113611.3398-1-kurt@linutronix.de>
 <20200710113611.3398-3-kurt@linutronix.de>
 <def49ff6-72fe-7ca0-9e00-863c314c1c3d@gmail.com>
 <87v9islyf2.fsf@kurt>
 <20200716082935.snokd33kn52ixk5h@skbuf>
 <87h7u7x181.fsf@kurt>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87h7u7x181.fsf@kurt>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 11:23:26AM +0200, Kurt Kanzenbach wrote:
> 
> As far as I know there is no port forwarding matrix. Traffic is
> forwarded between the ports when they're members of the same
> vlan. That's why I created them by default.
> 

And your hardware doesn't have ACL support, does it (from the fact that
you're installing PTP traps via the FDB, I would say no)? You could have
added a match-all entry on all traffic coming from a certain source
port, and a 'redirect-to-cpu' action. This would have also achieved port
separation in standalone mode.

-Vladimir
