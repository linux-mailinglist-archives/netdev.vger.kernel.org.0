Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE75F2EB6C2
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbhAFAUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:20:20 -0500
Received: from mail-ot1-f48.google.com ([209.85.210.48]:44264 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbhAFAUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:20:19 -0500
Received: by mail-ot1-f48.google.com with SMTP id r9so1467714otk.11;
        Tue, 05 Jan 2021 16:20:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NVOiQBqHcBbx3nxlt1ktSopLPLaxynGLrkh6M/dIvoM=;
        b=e8yzltjeQ1G+dLRMnenc9m0KJZWjZ+8gCnIATJxJSflota7Gqa+ZMvegSLNdyz73ua
         EJR3dtuXNb/UqhSdhP9VvcM1zBdziuq3S35owsOQLWRfbBXGIXC4CRfE5T5KZ48MCKQO
         KKMe++uVeu22PT5j4TZ66kl9DtquQ2xJVA2C+4/dTrFZrRFE0NrtOqAvAnLQ9dqiSpJT
         KNOrE29tlEkO2YDkUKMrGoMs4PCH2l965Tq2HLnY12PztOunK/nqbvikFdkpVMVZsRAp
         eTE7mpTa7acE5zbSVdxsA6uwEd21pcJHqe40JQ4SlG5Kuwblws0q7Es+TwCmyyHzozli
         EMXw==
X-Gm-Message-State: AOAM533AZg5PLmGCDldC4Xnw6/sF25qjUNYGvwoLqq+i8JppfaAw8dfb
        l8OJWAsgFbvYRLTDSap0ywh8SgTexv5XhZ+vLC4shN6WX2Q=
X-Google-Smtp-Source: ABdhPJw8ASil+48k24xCFR+xzi/vvqX/8PzbLY6GCJIxxSdzlX4ps1OSrEMGmzHTPO+V2QeRHtCgcC5uiti2X5G8HFA=
X-Received: by 2002:a05:6830:1bc6:: with SMTP id v6mr1510048ota.135.1609892378594;
 Tue, 05 Jan 2021 16:19:38 -0800 (PST)
MIME-Version: 1.0
References: <20201222184926.35382198@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20201224032116.2453938-1-roland@kernel.org> <X+RJEI+1AR5E0z3z@kroah.com>
 <20201228133036.3a2e9fb5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAG4TOxNM8du=xadLeVwNU5Zq=MW7Kj74-1d9ThZ0q2OrXHE5qQ@mail.gmail.com>
 <24c6faa2a4f91c721d9a7f14bb7b641b89ae987d.camel@neukum.org>
 <CAG4TOxOc2OJnzJg9mwd2h+k0mj250S6NdNQmhK7BbHhT4_KdVA@mail.gmail.com>
 <12f345107c0832a00c43767ac6bb3aeda4241d4e.camel@suse.com> <CAG4TOxOOPgAqUtX14V7k-qPCbOm7+5gaHOqBvgWBYQwJkO6v8g@mail.gmail.com>
 <cebe1c1bf2fcbb6c39fd297e4a4a0ca52642fe18.camel@suse.com> <CAG4TOxM_Mq-Rcdi-pbY-KCMqqS5LmRD=PJszYkAjt7XGm8mc5Q@mail.gmail.com>
 <de23e12b8714cf97477ff149e6ebf323795f963d.camel@suse.com>
In-Reply-To: <de23e12b8714cf97477ff149e6ebf323795f963d.camel@suse.com>
From:   Roland Dreier <roland@kernel.org>
Date:   Tue, 5 Jan 2021 16:19:22 -0800
Message-ID: <CAG4TOxN9o1ga9dUHd9hUqMgkA+c_KUSwiYnXD_G2OtOXvB681Q@mail.gmail.com>
Subject: Re: [PATCH] CDC-NCM: remove "connected" log message
To:     Oliver Neukum <oneukum@suse.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> now that you put it that way, I get the merit of what you are saying.
> Very well. I will submit the first set of patches.
>
> May I add your "Tested-by"?

Yes, absolutely:

Tested-by: Roland Dreier <roland@kernel.org>
