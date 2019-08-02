Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28BB880258
	for <lists+netdev@lfdr.de>; Fri,  2 Aug 2019 23:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395199AbfHBVzJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Aug 2019 17:55:09 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43829 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395195AbfHBVzI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Aug 2019 17:55:08 -0400
Received: by mail-pl1-f193.google.com with SMTP id 4so27120203pld.10
        for <netdev@vger.kernel.org>; Fri, 02 Aug 2019 14:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3v959y3cG5ZVzOws7Yf1+skokBCt8eVG73f/LVI45bE=;
        b=V3Hpl9HrCUyugLTACvQdLDIAxuPF+z+eQixtnPJTDCaVCGqGU3IOij7fUVmLgwP7DC
         kQsEQblIgYdkFfFqFq4v2ktFDIaHIH/kCq1OBFMuF8o7rptFY8SBTg8EoRTkXEjlTurv
         KIZm3oKsVAnb4XyKjVGi+Hn+e5zG1vs7oLSePanBwPr0YzLP4aaBpuGQn8/fdTV7+6oe
         xKS1Pv+c4Ete30omsGWcP5Z3WeeZsfWBVvUefvXezmibpeBQsoFH5/4YukI8C6jrhkef
         Y+jacXlaIVVCM7PKXLNKr3dnRQPPNji4bTwvii5cKhoD05JsyLdacylOm5WB2LGGTOgI
         k4OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3v959y3cG5ZVzOws7Yf1+skokBCt8eVG73f/LVI45bE=;
        b=ns8IBrqEmpp9KPKpeAk61ondqB4gEB4rIZOLBuCl/3ZI2gRTUGOZGhO0379KpKjoPW
         OGfnimVJvEFJebZgFxFf27fsb9xe/XjGim5kfAvxHIMfzsDDJi2ppZLVI95n6htW5sk2
         MRzdl/1uunjpE+lAK3LjBXIiFGPL/8DRVSCHBHaR0t82DtLYsrTf1pA58fXqYWv8E3Ft
         j4kdwwupFVVBvKg1KoNrphAWiJie/3ck/OlVHs3cUVCnE/5zq6h1LMKVH37BX5VsnAmk
         JTkQSN7IwxyPaHiTCfd0c3y6xslYNKkLmSYupjW3CXLbw8+Kn0+BDXcIevGjidK6jP9Z
         0O+w==
X-Gm-Message-State: APjAAAVtswPFs6eH+fqYLEkVojANYnUKzQFJgeQ9LKqLKU5WpNkcslJP
        SL0EiCO0gUULYTm5FY4HLJE=
X-Google-Smtp-Source: APXvYqyQ65NF5GXQddSgKFl5futnv5t9QQ5mjPDSRTrAoLaT4aq/GyBekbHTh1tXi+6AxlMyrJ+RmQ==
X-Received: by 2002:a17:902:100a:: with SMTP id b10mr91768385pla.338.1564782908080;
        Fri, 02 Aug 2019 14:55:08 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r188sm121634800pfr.16.2019.08.02.14.55.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 02 Aug 2019 14:55:08 -0700 (PDT)
Date:   Fri, 2 Aug 2019 14:55:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jose Carlos Cazarin Filho <joseespiriki@gmail.com>
Cc:     isdn@linux-pingi.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isdn: hysdn: Fix error spaces around '*'
Message-ID: <20190802145506.168b576b@hermes.lan>
In-Reply-To: <20190802195602.28414-1-joseespiriki@gmail.com>
References: <20190802195602.28414-1-joseespiriki@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  2 Aug 2019 19:56:02 +0000
Jose Carlos Cazarin Filho <joseespiriki@gmail.com> wrote:

> Fix checkpath error:
> CHECK: spaces preferred around that '*' (ctx:WxV)
> +extern hysdn_card *card_root;        /* pointer to first card */
> 
> Signed-off-by: Jose Carlos Cazarin Filho <joseespiriki@gmail.com>


Read the TODO, these drivers are scheduled for removal, so changes
are not helpful at this time.
