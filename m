Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 929721E24DB
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 17:01:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729731AbgEZPB3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 11:01:29 -0400
Received: from mail-ed1-f65.google.com ([209.85.208.65]:35727 "EHLO
        mail-ed1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729368AbgEZPBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 11:01:20 -0400
Received: by mail-ed1-f65.google.com with SMTP id be9so17927985edb.2;
        Tue, 26 May 2020 08:01:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/FQ3kSh6QRt/DhDlB1iVTGQKeiQZDzu9nHJXUdnImCk=;
        b=Z8t+0ViDna1GqYu0FuJehfRYS/Jcck7SOImRHZ2f5+vmElvDmKqdhGrbiza0PQFoTt
         nalsjBLJi9Q79s5g20dKy/e0n18q+Khn0/p8gZI9dZB80U15lLSz5qnhX5uFuzzbKZMn
         x4KQnDkvSIgBfa4AbLxdKL1EvjRfMBWoDNrluLDkp57sCOQeUdCYloCUmGkeI8BB/UiM
         BFijU6JOFX32772XYrmeN7bY3Van/jb3b2Cx4x+XfRsFWS45jAHdivc/2+2TpCLaRuUp
         SJGPZxO1vFMynhhnmaH0TetzpoXXnE++nOUcYcNNBGD/f3IluaaFR/rsXcd8W9rkqCX8
         oOgA==
X-Gm-Message-State: AOAM532oq7IL88Wpbca2U5c5H3ET+SSyEQZM5RVY+JNNatQj5lCvnEif
        xyEFbVHj1n4AUOfj+E6o9nCVPUlyq8qDssMj
X-Google-Smtp-Source: ABdhPJzUcDOK5LS647ncdAETZsJMJ8+0djAcX5w/EM0H6iRkO7YVRDADM+BVObYTE4LLegacDOPiCg==
X-Received: by 2002:a05:6402:31b5:: with SMTP id dj21mr21365281edb.160.1590505277038;
        Tue, 26 May 2020 08:01:17 -0700 (PDT)
Received: from rocinante ([95.155.85.46])
        by smtp.gmail.com with ESMTPSA id f13sm143194edk.36.2020.05.26.08.01.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 08:01:15 -0700 (PDT)
Date:   Tue, 26 May 2020 17:01:14 +0200
From:   Krzysztof =?utf-8?Q?Wilczy=C5=84ski?= <kw@linux.com>
To:     Alex Elder <elder@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-pci@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Pavel Machek <pavel@ucw.cz>, linux-s390@vger.kernel.org,
        linux-scsi@vger.kernel.org, Kevin Hilman <khilman@kernel.org>,
        Julian Wiedmann <jwi@linux.ibm.com>,
        linux-acpi@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Len Brown <lenb@kernel.org>, linux-pm@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Ursula Braun <ubraun@linux.ibm.com>,
        Johan Hovold <johan@kernel.org>, greybus-dev@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Felipe Balbi <balbi@kernel.org>, Alex Elder <elder@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [greybus-dev] [PATCH 1/8] driver core: Add helper for accessing
 Power Management callbacs
Message-ID: <20200526150114.GB75990@rocinante>
References: <20200525182608.1823735-1-kw@linux.com>
 <20200525182608.1823735-2-kw@linux.com>
 <20200526063334.GB2578492@kroah.com>
 <41c42552-0f4f-df6a-d587-5c62333aa6a8@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <41c42552-0f4f-df6a-d587-5c62333aa6a8@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Alex and Greg,

[...]
> This could just be:
> 
> 	if (drv)
> 		return drv->pm;
> 
> 	return NULL;
> 
> Or if you want to evoke passion in Greg:
> 
> 	return drv ? drv->pm : NULL;
> 
> 					-Alex
> 
> > I hate ? : lines with a passion, as they break normal pattern mattching
> > in my brain.  Please just spell this all out:
> > 	if (drv && drv->pm)
> > 		return drv->pm;
> > 	return NULL;
> > 
> > Much easier to read, and the compiler will do the exact same thing.
> > 
> > Only place ? : are ok to use in my opinion, are as function arguments.

I will steer away from the ternary operator next time.  Also, good to
learn about Greg's preference.

Thank you both!

Krzysztof
