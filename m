Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27246B3F99
	for <lists+netdev@lfdr.de>; Mon, 16 Sep 2019 19:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfIPR3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Sep 2019 13:29:18 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:41601 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727719AbfIPR3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Sep 2019 13:29:18 -0400
Received: by mail-io1-f66.google.com with SMTP id r26so890555ioh.8
        for <netdev@vger.kernel.org>; Mon, 16 Sep 2019 10:29:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arroyo.io; s=google;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version;
        bh=rgE4dv/gJos5cwZ/zqdO92VrJ60CPHzI/hDFA5WdUM8=;
        b=OIHcbtALhsuox+WPdGy9vqli1CbDIXjxZ7JVb8TiQ1xZXfvz0/OQv27zbRbV/chUaY
         CtZqQBMa1LApzEWAM0yW0WmIeKauvhcxNgUqekAraT1RUDM2sBrIn/LfQSi1lVPUAgl9
         WQVbgPvSPhkeZB6ubxfxbvFXoiXkUruqc9ifeWA71i6hdF68DAR3sYRp1xgRcgDu6Q55
         hixKwHvyroo9nkGTDkyZtzhzZd8VMe/cV8NTyYUYTaqgfuHMCbYEduXMsc3nrhJeCmr0
         fTQR4W5+BFqRaqalvyAhV9ivueg7alS+VJWJ5F76tDsOgo7DMkgoxCu8mJcWrj8twA/L
         8zGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version;
        bh=rgE4dv/gJos5cwZ/zqdO92VrJ60CPHzI/hDFA5WdUM8=;
        b=Lfd24oisqKkKschK+51mf+Yji1SQQpkDmUfjLYu8DokFfyFswGwzdyfMPHDoMARNji
         +hGC3evFXNzmbgA3ENHbIdSqLeMA7ZlFfSWooME2Vrp8/Vt+NEgzFv4aSaYhPx6Hbyyt
         Nbc5vap7kcD4fealw9G8/slAME/gYr0IhXNjr+6f2PDP/wLRdObvQpVXhaWXRNvukPXv
         j4HjdD8Z5XeXhJHscIHVYxcnNbzePsrCvlPM7HdJb7LaqSsILBbycIC0CbTKTKkr5B6I
         qONSvWIH8kNnbvTILrM9isBnkZ508CDCqwPY5DTBRftDFLthpm3V32HSpthJXo1pnw/W
         uEZQ==
X-Gm-Message-State: APjAAAUIXaKV1qs9oRWrFEBw+hWpLQ5W7+txg4QFfX/xO8udrDs5B4Kj
        E66ZId35LwwlTYkyAry1i3itWMd2gqf2OveGKzwHq5o8pMukJ5kjrbJOlMUUByLoS452i9y1FFD
        edrTqOj+aCA==
X-Google-Smtp-Source: APXvYqzwJRGWkRcnXEX5Cs3mFnpZUDXmlXUQLUkSPGA1DFg8SSxc6sDPFHmO0bXdDO2716ab9J1sHQ==
X-Received: by 2002:a5d:951a:: with SMTP id d26mr12043iom.31.1568654954342;
        Mon, 16 Sep 2019 10:29:14 -0700 (PDT)
Received: from glacier.localdomain (047-006-040-041.res.spectrum.com. [47.6.40.41])
        by smtp.gmail.com with ESMTPSA id q74sm53711664iod.72.2019.09.16.10.29.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Sep 2019 10:29:14 -0700 (PDT)
Date:   Mon, 16 Sep 2019 13:29:11 -0400
From:   Matt Ellison <matt@arroyo.io>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     stephen@networkplumber.org, netdev@vger.kernel.org,
        dsahern@gmail.com, julien.floret@6wind.com
Subject: Re: [PATCH iproute2] link_xfrm: don't forcce to set phydev
Message-ID: <20190916132911.162b2817@glacier.localdomain>
In-Reply-To: <20190916153627.19458-1-nicolas.dichtel@6wind.com>
References: <20190916153627.19458-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Matt Ellison <matt@arroyo.io>

-- 



Please be advised that this email may contain confidential information. 
If you are not the intended recipient, please notify us by email by 
replying to the sender and delete this message. The sender disclaims that 
the content of this email constitutes an offer to enter into, or the 
acceptance of, any agreement; provided that the foregoing does not 
invalidate the binding effect of any digital or other electronic 
reproduction of a manual signature that is included in any attachment.


 
<https://twitter.com/arroyo_networks>   
<https://www.linkedin.com/company/arroyo-networks>   
<https://www.github.com/ArroyoNetworks>
