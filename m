Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089F8221A47
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 04:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727912AbgGPCqW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 22:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbgGPCqV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 22:46:21 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9369C061755
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 19:46:21 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id d1so3226407plr.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 19:46:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ker+u3+qetq7nr5XUIwXh6EOuq2/hl+ecyIb3PP9T+w=;
        b=GQCsoKOvCkIQwb0V6FquyqEPBhJlumvO2a0XAd0RYngVq5wIogYMSFOxJHmLaUejgi
         fpJIH8Iu4PFGq1HUGDif2d806ZBS5y8uk+3p8CVQP34L2rwQhgCSDZ29YghYqcu9ROqB
         PvYIkc0I0XXtR3xFyhomQKRX9f5eyZ8avQjULWB+gNU913PHGwD947U6CBYeTdD/09BM
         XLlwKcr8NXrHGME50TRavAdV0qwe1V8wWm3Eo6ELO4cpciQsmYFX2p/0ORbm6npahvJK
         xbMLaVQPW5zppvjOtjPIBKw9W6XqmpRRtjqGpfOHINj4dtETc2/jgdLUuvRqQvOb2fbA
         4hzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ker+u3+qetq7nr5XUIwXh6EOuq2/hl+ecyIb3PP9T+w=;
        b=kPkmKmMTewnhNJeop80o6OmJ9FI4J7xltfcxONuQ3pNXB5tkcZt6yCekTzC6EjnE2S
         4WaV1p3mn8ZeRgqyCDsOn2b643FciEumI7Ozs6udKifARNepty++FbAo3KTFPLVVbLkS
         N/vZfppyQ/Z7ARIAtu84a53aJwJz6kkYFvE8jgOjFZrW/ezZla0XLfZrb0HzCJyixr77
         ZlHJqRV6k0DZ5gC7sE5wyg7Z23fMkjVAo7Hg/9TUiv8XlQ0SQNeySLCtUTNcTle4nhGV
         uD8Ae9Z5RHODiAJuTP9me2qq4/qvbmSIQEihHPjvymH+Jf3aXIHfmFMUvHM/i5yJ6o6s
         3vMQ==
X-Gm-Message-State: AOAM5325B+wfiZDQPJghDt5jdFIQZpzlHqeQRBmuN2CGM//4DFJgutpE
        LehsotZBaezirMo1mUuAlIYav7NR
X-Google-Smtp-Source: ABdhPJxAHe7oLMe/y3Ty4QX22QFGRwHW1M/BtR/pp1OFnHAHUgbFn2PvDeFPfNP41/6DWIFEZBK8aQ==
X-Received: by 2002:a17:90b:34c:: with SMTP id fh12mr2626620pjb.210.1594867580231;
        Wed, 15 Jul 2020 19:46:20 -0700 (PDT)
Received: from martin-VirtualBox ([157.46.185.70])
        by smtp.gmail.com with ESMTPSA id l17sm3355786pgn.48.2020.07.15.19.46.18
        (version=TLS1 cipher=ECDHE-ECDSA-AES128-SHA bits=128/128);
        Wed, 15 Jul 2020 19:46:19 -0700 (PDT)
Date:   Thu, 16 Jul 2020 08:16:16 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, gnault@redhat.com,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [PATCH net-next] bareudp: Reverted support to enable & disable
 rx metadata collection
Message-ID: <20200716024616.GA6525@martin-VirtualBox>
References: <1594782760-5245-1-git-send-email-martinvarghesenokia@gmail.com>
 <20200715134347.6a9324ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200715134347.6a9324ce@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 01:43:47PM -0700, Jakub Kicinski wrote:
> On Wed, 15 Jul 2020 08:42:40 +0530 Martin Varghese wrote:
> > From: Martin Varghese <martin.varghese@nokia.com>
> > 
> > The commit fe80536acf83 ("bareudp: Added attribute to enable & disable
> > rx metadata collection") breaks the the original(5.7) default behavior of
> > bareudp module to collect RX metadadata at the receive. It was added to
> > avoid the crash at the kernel neighbour subsytem when packet with metadata
> > from bareudp is processed. But it is no more needed as the
> > commit 394de110a733 ("net: Added pointer check for
> > dst->ops->neigh_lookup in dst_neigh_lookup_skb") solves this crash.
> > 
> > Fixes: fe80536acf83 ("bareudp: Added attribute to enable & disable rx metadata collection")
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> Looks like you didn't remove the mention of the RX_COLLECT_METADATA
> flag from the documentation - is this intentional?

No I missed it. Thanks for pointing it out.

Thanks
Martin 
