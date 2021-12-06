Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEF0446A3C6
	for <lists+netdev@lfdr.de>; Mon,  6 Dec 2021 19:04:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232901AbhLFSIX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Dec 2021 13:08:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:41068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229880AbhLFSIX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Dec 2021 13:08:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=xjm+olz6gFOyi28Wjq+XrJEy5pTq4scQgdP07/zJIfU=; b=uEAaUT7l/KcSCnm7hhrJ12tzv6
        itJymi91Mb7Kaix+q36l/Db6r7C8KltCK6Xk4wP3CpyUirOZmqjQZI3sGxX9Lf3HYUKb/sbvs7yDC
        5P2EAUUMdjYIRBb8QP1BrUWjyA80B4Y6jVTTq85daf1w+umjerttcXJ8KVzSp5Cl6RkU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1muIM8-00Fgie-Gt; Mon, 06 Dec 2021 19:04:52 +0100
Date:   Mon, 6 Dec 2021 19:04:52 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [v2 1/2] Docs/devicetree: add serdes-output-amplitude-mv to
 marvell.txt
Message-ID: <Ya5QxItYDNaxrE9m@lunn.ch>
References: <20211202080527.18520-1-holger.brunck@hitachienergy.com>
 <20211202102541.06b4e361@thinkpad>
 <YajrbIDZVvQNVWiJ@lunn.ch>
 <AM0PR0602MB3666E770AA7F096AFD71CB4FF76D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR0602MB3666E770AA7F096AFD71CB4FF76D9@AM0PR0602MB3666.eurprd06.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> so what is the conclusion here? Should I add it to marvell.txt for now or is there
> a better place?

I think a serdes.yaml would be a good idea.

  Andrew
