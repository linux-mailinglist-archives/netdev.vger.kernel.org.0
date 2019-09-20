Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A257BB8887
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394419AbfITAVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:21:53 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:36801 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390178AbfITAVv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:21:51 -0400
Received: by mail-qk1-f196.google.com with SMTP id y189so5444623qkc.3
        for <netdev@vger.kernel.org>; Thu, 19 Sep 2019 17:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=pro9C8zmq7NLgMwYhgr/6LGSa3Q7PkAjnibnN9csKE0=;
        b=p1MWiAA5FV5GBwt2EIlFX7PlfM/JFWtZLute0zB9YM/osQ/11szyWWaic3ZyQ/SZu0
         OaIeERsRiVOXxjZTRZHLJmQyAxo/c8IFFvCkTRmHb1sdpA+kVVk0KoyaIEVYpyup26K5
         8aWcL3YrjS5i9AmbE1j0wwip7zSi2eMDhrjRBRU5JdaJTrZYulLsGCtoAINRRy3XjiTV
         xYwJG57TEFA7gT7L0LxRvT0Ip0F+GdOmEhF5rw4i7vpn/VKhXQdLw6cr98ORRot5912x
         L429S8bA/t8FHPSd27P3ogpl3W6I76jDOmk+s8tuFL+HlbVTKBANkA+/RDrhrxeN/aOV
         hpZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=pro9C8zmq7NLgMwYhgr/6LGSa3Q7PkAjnibnN9csKE0=;
        b=LUY0lYYmHiwuY61KXztiT2C6gyqwYW17kRVja/YFc4HD4giopdEjbFOBqUXjz8IhN0
         B4j7KCD4vvOxRJJ0PpKrxvOZeYaXOFHrKEfmoBaTLJg0xXfie9JQ/KmZhczLelY6f2YK
         EYWRr4UzJTlbniLSg9dZwNlSIkDq6YIfmxVX47iRsyZspm57t+TAzk/WIXcf19fE7kA/
         r2CSz5BKRTe846DWijBRPT6lvHZGTwnyXRlp7l9tO3IJMTdIbx9/cW2LP/uGFS4nPx2o
         dT/nADIE/ue5cJiP2UuOeCeNtzLYvcKI2yhJiucxVRScrkssYBF8leXKDFsE0nA386+f
         JMvg==
X-Gm-Message-State: APjAAAUacoSd6m0vMMOQWCr4IHDQbpyAOe6QhzAFsgFXCow2T075KDso
        pis/NZsD7Vs5AEx7bZMwOdIeFg==
X-Google-Smtp-Source: APXvYqyzA42ktG/dDx6jAshGH/zvVqakR5TOxSDRcxunSBtsZ5MhzkJALycMc3DcCWG56RQKg+CuZw==
X-Received: by 2002:a37:c441:: with SMTP id h1mr589905qkm.16.1568938909826;
        Thu, 19 Sep 2019 17:21:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id e42sm127840qte.26.2019.09.19.17.21.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Sep 2019 17:21:49 -0700 (PDT)
Date:   Thu, 19 Sep 2019 17:21:45 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Pensando Drivers <drivers@pensando.io>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH] ionic: remove useless return code
Message-ID: <20190919172146.47bc95f4@cakuba.netronome.com>
In-Reply-To: <6cdb1e21-44d9-bba9-1931-78f7109bff2b@pensando.io>
References: <20190918195745.2158829-1-arnd@arndb.de>
        <6cdb1e21-44d9-bba9-1931-78f7109bff2b@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 13:46:34 -0700, Shannon Nelson wrote:
> On 9/18/19 12:57 PM, Arnd Bergmann wrote:
> > The debugfs function was apparently changed from returning an error code
> > to a void return, but the return code left in place, causing a warning
> > from clang:
> >
> > drivers/net/ethernet/pensando/ionic/ionic_debugfs.c:60:37: error: expression result unused [-Werror,-Wunused-value]
> >                              ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
> >                                                           ^~~~~~~~~~~
> >
> > Fixes: fbfb8031533c ("ionic: Add hardware init and device commands")
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >   drivers/net/ethernet/pensando/ionic/ionic_debugfs.c | 2 +-
> >   1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> > index 7afc4a365b75..bc03cecf80cc 100644
> > --- a/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> > +++ b/drivers/net/ethernet/pensando/ionic/ionic_debugfs.c
> > @@ -57,7 +57,7 @@ DEFINE_SHOW_ATTRIBUTE(identity);
> >   void ionic_debugfs_add_ident(struct ionic *ionic)
> >   {
> >   	debugfs_create_file("identity", 0400, ionic->dentry,
> > -			    ionic, &identity_fops) ? 0 : -EOPNOTSUPP;
> > +			    ionic, &identity_fops);
> >   }
> >   
> >   void ionic_debugfs_add_sizes(struct ionic *ionic)  
> 
> This has just recently been addressed by Nathan Chancellor 
> <natechancellor@gmail.com>

Yup, should be in the net tree now.

> Either way,
> 
> Acked-by: Shannon Nelson <snelson@pensando.io>

Thanks for quick reviews!
