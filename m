Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D53B150EAC
	for <lists+netdev@lfdr.de>; Mon,  3 Feb 2020 18:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728652AbgBCRfK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Feb 2020 12:35:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:51014 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727311AbgBCRfK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Feb 2020 12:35:10 -0500
Received: from cakuba.hsd1.ca.comcast.net (unknown [199.201.64.133])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337D32087E;
        Mon,  3 Feb 2020 17:35:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580751309;
        bh=PsJDQUyi0JLQlZI5vpyz1NKTsCsKEyMs9vzZqjH1Q0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GhUb0nL4Z4xPJ1kJJF85byuHbuCSvaL9B6R3n3FIlvcbNxJVvr0SfnVwJKu3CKaBT
         k+/N19s52YWX9RBVv2j65bQ2v0PJq0q4n1QjW7l8c1lVUxexRL1VsgIWA2+bw2Yk0b
         4MudVTyxpbKLKz1BNGn9HxanbtTIYunNHS/Aa3KQ=
Date:   Mon, 3 Feb 2020 09:35:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
Message-ID: <20200203093508.37346542@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
        <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
        <CAHp75VdVXqz7fab4MKH2jZozx4NGGkQnJyTWHDKCdgSwD2AtpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 3 Feb 2020 12:13:23 +0200, Andy Shevchenko wrote:
> > Applied to net, thanks!  
> 
> I'm not sure it's ready. I think parse-maintainers.pl will change few
> lines here.

Please send follow up patches. It seems like further work will be 
a larger clean up, but Kconfig and Makefile should be covered by
MAINTAINERS already.
