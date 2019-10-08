Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47C50D0109
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 21:15:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730144AbfJHTPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 15:15:11 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38941 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728465AbfJHTPL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 15:15:11 -0400
Received: by mail-qt1-f195.google.com with SMTP id n7so26910095qtb.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 12:15:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=dxAtTWPQp4TAeXr8xO4IQ/pBkwmVo6wQB+eXQ6x/TLY=;
        b=Dfe+1jeovnFdBVweXsJvOp5BXdxpHw9080gV/0Umo0I2a24FNdmFyl1kiPo4ge+iFa
         XSOQDtE+tqvSG2aazcK/svPTXJbhuIQ1OJ4yekFUkLJCTRR1tySDi5nDjqHuM0NfHc9t
         9jgXyZjdo4nmS8oyHaNOZB7JqN19UiGyG5HPs6wy6+Va5I3J9EynqE3QjgjVSADyXVQG
         /hjCL+IcFA8R6EGs+CdTjpe6rumTcwilrCVAhumrpaLOlv+F/W6Sd4SVNdweiUEpPFCa
         4utVrLXKeyetZXfxbGmeV6XZ7j9PTyjs9yBvdWDJ+YiY7FaHy2jIErDoC9kKpsVo5lF8
         G9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=dxAtTWPQp4TAeXr8xO4IQ/pBkwmVo6wQB+eXQ6x/TLY=;
        b=AC3hxAKOxVhwKihICHvLAPN/KLAwKHifGy5P5SC6wLaM4XuOH6qekP/A94g/dNNT7+
         s/I4dgnz8Bsw+0zJZQ66Tq7T7GHJnVLeSkF9JYSy2R6ay3zbbAK1q4Eve5S5Mvd2tRw0
         /x0iKrOtAD+FCccDjr9YkSxVvlus/v+W9tb9sZuvDzqyAR/R+3xT7PGrwPhVaQ45DY2f
         1RYEiM6GiFF8hqZN9cZkd0fLbV29n0RKzK6OYJdJ2jhRFWh5Cipwzqig15riMhz2zu00
         0YBblnDCsMeBxIH1/PxpAL4ZcZHrWXiQvSTIDw5Spl388asgmjB6jxqT7Pdp0kYZBYnD
         5L8A==
X-Gm-Message-State: APjAAAUXrbnWkJqOv6CebnFFi+A2fGY/vp8Q60hrihdxj/NRGSEq6wNX
        6HKvznDhayvMJW7aM2Svsf174A==
X-Google-Smtp-Source: APXvYqzS0pTRdoYgQCvIqtrfKJbCdPzqZle2A/oqLtOkZCOi7IR/U1Hy7/FKxRoxWdHyuUsA3VINxw==
X-Received: by 2002:a0c:a988:: with SMTP id a8mr7939928qvb.34.1570562110549;
        Tue, 08 Oct 2019 12:15:10 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id f21sm8763054qkl.51.2019.10.08.12.15.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 12:15:10 -0700 (PDT)
Date:   Tue, 8 Oct 2019 12:14:57 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     "Maciej W. Rozycki" <macro@linux-mips.org>,
        Colin King <colin.king@canonical.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] netdevsim: fix spelling mistake "forbidded" ->
 "forbid"
Message-ID: <20191008121457.34b570be@cakuba.netronome.com>
In-Reply-To: <alpine.LFD.2.21.1910080921350.25653@eddie.linux-mips.org>
References: <20191008081747.19431-1-colin.king@canonical.com>
        <alpine.LFD.2.21.1910080921350.25653@eddie.linux-mips.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Oct 2019 09:29:58 +0100 (BST), Maciej W. Rozycki wrote:
> On Tue, 8 Oct 2019, Colin King wrote:
> 
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index a3d7d39f231a..ff6ced5487b6 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -486,7 +486,7 @@ static int nsim_dev_reload_down(struct devlink *devlink, bool netns_change,
> >  		/* For testing purposes, user set debugfs dont_allow_reload
> >  		 * value to true. So forbid it.
> >  		 */
> > -		NL_SET_ERR_MSG_MOD(extack, "User forbidded reload for testing purposes");
> > +		NL_SET_ERR_MSG_MOD(extack, "User forbid the reload for testing purposes");  
> 
>  If nitpicking about grammar, then FWIW I believe it should actually be:
> 
> 		NL_SET_ERR_MSG_MOD(extack, "User forbade the reload for testing purposes");
> 
> (and then:
> 
> 		NL_SET_ERR_MSG_MOD(extack, "User set up the reload to fail for testing purposes");
> 
> elsewhere).

So I consulted with someone vaguely British, and they said they'd use
"forbid" here, therefore I've applied the patch to net-next.
