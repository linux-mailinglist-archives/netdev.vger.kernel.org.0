Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E550174AC0
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 03:12:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727350AbgCACMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 21:12:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:36008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727228AbgCACMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 Feb 2020 21:12:17 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6882B222C4;
        Sun,  1 Mar 2020 02:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583028736;
        bh=MRMvXCkL8RbzEVxNXMIWAO6JqQowOaG8ov5gVmOxNoc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vlUFIq7pEn15C2MGxkQHG7UKZNEdWQTpvQlN6zT+ovieONrrBo/D7L4sZIUBko9e6
         teLlaYar9FMZfp6ucMKAr3Jwl6eKDhmRNOjbC3pyUTbVz8N8ojVNgQh32IGcdn43Um
         u0HrhQH3Ws/zPCjd6kCpn9Kcl9cLGUOm6sWeHc9k=
Date:   Sat, 29 Feb 2020 18:12:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>,
        Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>
Subject: Re: [RFC net-next 2/3] net: marvell: prestera: Add PCI interface
 support
Message-ID: <20200229181214.46c2a495@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200229075802.GO26061@nanopsycho>
References: <20200225163025.9430-1-vadym.kochan@plvision.eu>
        <20200225163025.9430-3-vadym.kochan@plvision.eu>
        <20200227110507.GE26061@nanopsycho>
        <20200228165429.GB8409@plvision.eu>
        <20200229075802.GO26061@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 Feb 2020 08:58:02 +0100 Jiri Pirko wrote:
> Fri, Feb 28, 2020 at 05:54:32PM CET, vadym.kochan@plvision.eu wrote:
> >> >+
> >> >+module_init(mvsw_pr_pci_init);
> >> >+module_exit(mvsw_pr_pci_exit);
> >> >+
> >> >+MODULE_AUTHOR("Marvell Semi.");  
> >> 
> >> Again, wrong author.
> >
> >PLVision developing the driver for Marvell and upstreaming it on behalf
> >of Marvell. This is a long term cooperation that aim to expose Marvell
> >devices to the Linux community.  
> 
> Okay. If you grep the code, most of the time, the MODULE_AUTHOR is a
> person. That was my point:
> /*
>  * Author(s), use "Name <email>" or just "Name", for multiple
>  * authors use multiple MODULE_AUTHOR() statements/lines.
>  */
> #define MODULE_AUTHOR(_author) MODULE_INFO(author, _author)

+1

> But I see that for example "Intel" uses the company name too. So I guess
> it is fine.

FWIW I agree with Jiri's original comment. Copyright != authorship.
I'm not a lawyer, but at least in the European law I was exposed to -
company can _own_ code, but it can never _author_ it.

I think authorship as a moral right is inalienable, unlike material/
economic rights (copyright).

So to me company being an author makes no sense at all, Copyrights are
on all your files, that's sufficient, put human names in MODULE_AUTHOR,
or just skip using the macro..
