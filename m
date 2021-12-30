Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 295FD4820A2
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 23:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242256AbhL3W1t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 17:27:49 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:45846 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242253AbhL3W1s (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Dec 2021 17:27:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=zf0yIa2lvfnap0hGKL/WfTKmVu4ulC8jQt2zzfr6YLU=; b=h2e+ExLEf2GTtIEtZ7uVh79YXh
        unE8lN9ziLJ6uFod4z4dl/Bov+grwjGNzrnc/KVhh4ZjO2bt6mG0BC3vGc5juMEHUHSQ/NioOiHuh
        5vqkIpL8s5Pj/A4oondig4qQf7750RDIU8dMa8T4Snm1gLEEsPqigypFCqhHimLqlnoY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1n33th-000CAD-GK; Thu, 30 Dec 2021 23:27:45 +0100
Date:   Thu, 30 Dec 2021 23:27:45 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 8/8] net/fungible: Kconfig, Makefiles, and
 MAINTAINERS
Message-ID: <Yc4yYWWHb4o+W3Zu@lunn.ch>
References: <20211230163909.160269-1-dmichail@fungible.com>
 <20211230163909.160269-9-dmichail@fungible.com>
 <20211230094327.69429188@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
 <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOkoqZ=18H6CAE8scCV7DWzu9sQDLJHUiVgZi3tmutUNPPE2=A@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 30, 2021 at 12:54:07PM -0800, Dimitris Michailidis wrote:
> On Thu, Dec 30, 2021 at 9:43 AM Jakub Kicinski <kuba@kernel.org> wrote:
> >
> > On Thu, 30 Dec 2021 08:39:09 -0800 Dimitris Michailidis wrote:
> > > Hook up the new driver to configuration and build.
> > >
> > > Signed-off-by: Dimitris Michailidis <dmichail@fungible.com>
> >
> > New drivers must build cleanly with W=1 C=1. This one doesn't build at all:
> >
> > drivers/net/ethernet/fungible/funeth/funeth.h:10:10: fatal error: fun_dev.h: No such file or directory
> >    10 | #include "fun_dev.h"
> >       |          ^~~~~~~~~~~
> 
> Hmm, I don't get this error. What I run is
> 
> make W=1 C=1 drivers/net/ethernet/fungible/

C=1 implies you need sparse installed. Do you?

    Andrew
