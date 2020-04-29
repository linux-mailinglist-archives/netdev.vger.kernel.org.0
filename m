Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FE441BDB2A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 13:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726839AbgD2Lyf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 07:54:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:35600 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726519AbgD2Lye (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 07:54:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2662073E;
        Wed, 29 Apr 2020 11:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588161274;
        bh=JV15rKHmldWY4Vr5/UaeZ2WInQHgrX3coAE9xmBiKyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fUxl+MDz0ONwe4IJNAe/R9H1qgKt0BrGmKBCJYKx+vOB1bqv+c2KI49RaHMTG7JKU
         X0UXOunbGxyRO7TiRBBRAtBQs0Ky8Ffl+xB3f4SPGkai6xvYGdTjhDl07rHgGnhD/O
         u3sehQwaRtOEx4meWFtjY1QnZEzSB4x3tf6IeW2o=
Date:   Wed, 29 Apr 2020 13:54:32 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     "Badel, Laurent" <LaurentBadel@eaton.com>
Cc:     "fugang.duan@nxp.com" <fugang.duan@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        "richard.leitner@skidata.com" <richard.leitner@skidata.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "alexander.levin@microsoft.com" <alexander.levin@microsoft.com>,
        "Quette, Arnaud" <ArnaudQuette@eaton.com>
Subject: Re: [EXTERNAL]  Re: [PATCH 1/2] Revert commit
 1b0a83ac04e383e3bed21332962b90710fcf2828
Message-ID: <20200429115432.GA2119907@kroah.com>
References: <CH2PR17MB3542FD48AB01562BF812A948DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
 <20200429094010.GA2080576@kroah.com>
 <CH2PR17MB3542C31656800914A5D61977DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CH2PR17MB3542C31656800914A5D61977DFAD0@CH2PR17MB3542.namprd17.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 29, 2020 at 11:22:58AM +0000, Badel, Laurent wrote:
> ﻿Dear Greg, 
> 
> Thanks for your reply and sorry for my mistake.
> Looks to me like the issue is the commit hash which should be 12 chars.
> Does that mean I need to fix and resend the whole thing to everyone? 

Yes please, never force a maintainer to hand-edit a patch, they will not
do so :)

thanks,

greg k-h
