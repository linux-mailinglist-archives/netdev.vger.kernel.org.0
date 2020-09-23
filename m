Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59FD5274D8F
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:01:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726993AbgIWAB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:01:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbgIWAB2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:01:28 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA59BC0613D0
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:01:28 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id l71so13243560pge.4
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:01:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zCzet71T0DTkaVJKD74uRfQOUvTA6fuxWbEiPIVm6E8=;
        b=SwhruGZPJWXUFTSoLEOYcIZg7eJuuW27uXsEhgEw3jnStd01TC+Ne5rg/aFvTx0v/9
         IzhXjoc62AWOUKNum84yikEf1uIm2oaRyWxmxhj6Ijq/Gprvm9qJQxdLef3Az+F+AetT
         K4pRJmUf8puuK7N5tgnF680B6ZmZWDN+TO4O2Og9SUb8RIA1bfNSJHS8JcGZpTFdkn8G
         XndnFxT22EfiNdPkv5EIE84kb8DzXr3l5Yb1VgqzPfAZ4v3uuuQ8/fKfQIiq+uZO12D2
         823PYjSPnuGPlErKp7SeDP553g65lQu/ChU0+lskWrj/nYLb818Q0GxsQvjLtq1brIYv
         FAOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zCzet71T0DTkaVJKD74uRfQOUvTA6fuxWbEiPIVm6E8=;
        b=JfhVcIs/jF54o4xodrlMXv5zeYiIHps/ebut22xuTGI59yfmrmyvSI/PAh0ixh415Z
         uQpD99krrL+so7jaRl4IgoQuybzqXRGlc2S1t8dKvMQGkbyl4kTsc5g7v1CDA8RGiG8C
         g8Q8cWn3W0s8LgUD+NuN+u3Vk0+1Bm7we0eI5jL8Z/2Z7UH+ysru1Ao5bKCHDbkjMMSF
         fJ4wCCn5UgyTTTXeFQTF104NlRv87elY3dpBxIi3NGyotj4X2jybxyBVWawUEzgmvfWk
         /ZiZ8y3Q3FIZvK9j86hNeNp2RBUL+egm5xo22waKuXwiiKZp0kiAucKzlQ2haFmXv0tt
         qjPA==
X-Gm-Message-State: AOAM533HpTL9xmABySJvzw/TptpiaVEZfO+htnS1FNI6w8dQ5cDuti6n
        RhKjaWpDWgT7lpvAezMXlNEVIQ==
X-Google-Smtp-Source: ABdhPJxIPs65by9ZDnbt0crzTKqvVAuKP9Fj1E4gGS2thAfOOflLwxNNLhGV7OLx36UAj3o1msJLLw==
X-Received: by 2002:a62:2985:0:b029:142:2501:34d6 with SMTP id p127-20020a6229850000b0290142250134d6mr6117808pfp.47.1600819288177;
        Tue, 22 Sep 2020 17:01:28 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id mh8sm3009664pjb.32.2020.09.22.17.01.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Sep 2020 17:01:27 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:01:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jay Vosburgh <jay.vosburgh@canonical.com>
Cc:     Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 4/5] bonding: make Kconfig toggle to disable
 legacy interfaces
Message-ID: <20200922170119.079fe32f@hermes.lan>
In-Reply-To: <17374.1600818427@famine>
References: <20200922133731.33478-1-jarod@redhat.com>
        <20200922133731.33478-5-jarod@redhat.com>
        <20200922162459.3f0cf0a8@hermes.lan>
        <17374.1600818427@famine>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 16:47:07 -0700
Jay Vosburgh <jay.vosburgh@canonical.com> wrote:

> Stephen Hemminger <stephen@networkplumber.org> wrote:
> 
> >On Tue, 22 Sep 2020 09:37:30 -0400
> >Jarod Wilson <jarod@redhat.com> wrote:
> >  
> >> By default, enable retaining all user-facing API that includes the use of
> >> master and slave, but add a Kconfig knob that allows those that wish to
> >> remove it entirely do so in one shot.
> >> 
> >> Cc: Jay Vosburgh <j.vosburgh@gmail.com>
> >> Cc: Veaceslav Falico <vfalico@gmail.com>
> >> Cc: Andy Gospodarek <andy@greyhouse.net>
> >> Cc: "David S. Miller" <davem@davemloft.net>
> >> Cc: Jakub Kicinski <kuba@kernel.org>
> >> Cc: Thomas Davis <tadavis@lbl.gov>
> >> Cc: netdev@vger.kernel.org
> >> Signed-off-by: Jarod Wilson <jarod@redhat.com>  
> >
> >Why not just have a config option to remove all the /proc and sysfs options
> >in bonding (and bridging) and only use netlink? New tools should be only able
> >to use netlink only.  
> 
> 	I agree that new tooling should be netlink, but what value is
> provided by such an option that distros are unlikely to enable, and
> enabling will break the UAPI?
> 
> >Then you might convince maintainers to update documentation as well.
> >Last I checked there were still references to ifenslave.  
> 
> 	Distros still include ifenslave, but it's now a shell script
> that uses sysfs.  I see it used in scripts from time to time.

Some bleeding edge distros have already dropped ifenslave and even ifconfig.
The Enterprise ones never will.

The one motivation would be for the embedded folks which are always looking
to trim out the fat. Although not sure if the minimal versions of commands
in busybox are pure netlink yet.
