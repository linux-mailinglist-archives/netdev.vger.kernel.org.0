Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCAC3C35B8
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 19:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229854AbhGJRLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 13:11:51 -0400
Received: from smtp-31-i2.italiaonline.it ([213.209.12.31]:33244 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229490AbhGJRLu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 13:11:50 -0400
Received: from oxapps-32-144.iol.local ([10.101.8.190])
        by smtp-31.iol.local with ESMTPA
        id 2GTPmknAEzHnR2GTPmas7u; Sat, 10 Jul 2021 19:09:04 +0200
x-libjamoibt: 1601
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=libero.it; s=s2021;
        t=1625936944; bh=uqI9SIsnCnd6Ofb8uDuNE/2o8B7OJBuOhzISZu0x8fc=;
        h=From;
        b=OmmNNqodCCUdvSMeafu0lLs4+ws98kdwkC/yunA8XT8d2Ohlc8DA9SreSGdYM6lxY
         Q7hAKm7vcrHfGh5lAdvrxqsTVOoVjaYvx0P1zkkHdRNlSvDxP6X/QF0JSMTaed5mQQ
         +rvu7YpLIfRRJpTjEoFgnmKV1DAL1GuxXgx5M+M0YdyzXF1Amwh3EQ58vF8dG5Hz7w
         WOEGO40iFhLYe8XxkKb8QOro1uOYMf/GutuIXCg1Uw4gsdPO7gIEaTGKPkcwWRJxGJ
         X0gweTX5Lc7k9AH3G285DUo6F2nqOskYlUEMQQWSDdMpFJUC/8207bOPYpcXGO3lCn
         NXDFEBw/PX8jg==
X-CNFS-Analysis: v=2.4 cv=L6DY/8f8 c=1 sm=1 tr=0 ts=60e9d430 cx=a_exe
 a=+LyvvGPX93CApvOVpnXrdQ==:117 a=f1OlDQwkpmUA:10 a=IkcTkHD0fZMA:10
 a=-Mcqfe5xleoA:10 a=pGLkceISAAAA:8 a=hkBsS0pVqe-EwAB7wmkA:9 a=QEXdDO2ut3YA:10
Date:   Sat, 10 Jul 2021 19:09:03 +0200 (CEST)
From:   dariobin@libero.it
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com, kernel-team@fb.com,
        netdev@vger.kernel.org
Message-ID: <1955846635.176787.1625936943895@mail1.libero.it>
In-Reply-To: <20210710165630.kfuo6ffgi7es37zy@bsd-mbp.dhcp.thefacebook.com>
References: <20210708180408.3930614-1-jonathan.lemon@gmail.com>
 <691638583.174057.1625922797445@mail1.libero.it>
 <20210710165630.kfuo6ffgi7es37zy@bsd-mbp.dhcp.thefacebook.com>
Subject: Re: [PATCH net] ptp: Relocate lookup cookie to correct block.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Priority: 3
Importance: Normal
X-Mailer: Open-Xchange Mailer v7.10.3-Rev34
X-Originating-IP: 79.54.92.92
X-Originating-Client: open-xchange-appsuite
x-libjamsun: Q2GzbCoMy2GP1OjRulM4eQc+F3dfelK1
x-libjamv: 67PGi317XbU=
X-CMAE-Envelope: MS4xfOMypEUcs/p1Fv8ecVoOwag8UDMZndKg0zbNswlbsGGzh1lZKuihy9f+8nD52qFVhJqo9NUPwxEbXaURDyFzAxzato9q8s7iqw6dqmZDO3w1WkY7EJZy
 4s+NE8TBVbv7xLmaRgtMRgjookf4Pa1K7u0Vn3hnxM5U3JPosVdSi1sM6aL9AJeco+D5T865DtjiKM/RW1mBsqwxXCew8736PnwSj0aL5i8oZMdOZkGOU9rN
 cq7C/CfvKPbd++KA3he7yagFUBDROuP3VFUNJ1zn6a6bFjKNt79eYnQjd2DwDot9OE+XPebOUdZ+kgCo/71LjXa2tnuQ7+gWrLSWy9dC2lA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Il 10/07/2021 18:56 Jonathan Lemon <jonathan.lemon@gmail.com> ha scritto:
> 
>  
> On Sat, Jul 10, 2021 at 03:13:17PM +0200, dariobin@libero.it wrote:
> > Hi Jonathan,
> > IMHO it is unfair that I am not the commit author of this patch.
> 
> Richard alerted me to the error, and I sent a fix on July 6th when
> I came back from vacation.  I saw your fix go by 2 days later - which
> was also for net-next, and tossed as well.
> 
> So when I respun my initial patch against -net, I added your
> signoff, since the two patches were identical.
> 
> No slight intended...


Okay, thanks for the clarification,
Regards,
Dario

> -- 
> Jonathan
