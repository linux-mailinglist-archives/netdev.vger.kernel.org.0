Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D590B433F7E
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 21:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231895AbhJST6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 15:58:34 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231355AbhJST6d (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 15:58:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=KYw2SfLMcU2gw7nLslnrQsh1RMqe8/rod/eva5qCnIU=; b=vK
        h9AzVjHWY/yGSO/rfMU8BMZk/4R85odKGCZpkpNpI9RGqAMtKe1Wa624Ede5xvQ+ZaQ0FtUSyrNpP
        S5sitQXBcaqP+s6BLCLNjp4p8TudTZspWmiibhHQU+EPsyUGsw1QsG4ZAhs4rlafz/KeVAmR91vck
        1nPmnxO01g+3n/w=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mcvDa-00B7SM-UG; Tue, 19 Oct 2021 21:56:14 +0200
Date:   Tue, 19 Oct 2021 21:56:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Erik Ekman <erik@kryo.se>
Cc:     Edward Cree <ecree.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH] sfc: Export fibre-specific link modes for 1/10G
Message-ID: <YW8i3r9sqG17rzoJ@lunn.ch>
References: <20211018183709.124744-1-erik@kryo.se>
 <YW7k6JVh5LxMNP98@lunn.ch>
 <20211019155306.ibxzmsixwb5rd6wx@gmail.com>
 <CAGgu=sAUj4g3v7u4ibW53js5U3M+9rdjW+jfcDdF1_A4H8ytaw@mail.gmail.com>
 <YW8N9RlRD8/15GLP@lunn.ch>
 <CAGgu=sDh9DU+kUDgcZds5XRnRr=oLwGocQyQtMA-_Ta-mLp5fA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGgu=sDh9DU+kUDgcZds5XRnRr=oLwGocQyQtMA-_Ta-mLp5fA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >From the 'Solarflare Server Adapter User Guide': "SFP 1000BASE‐T
> module, Autonegotiation: No, Speed:  1G, Comment: These modules
> support only 1G and will not link up at 100Mbps"
> 10G SFP+ Base-T modules are not mentioned, maybe they did not exist
> back then. Do you think the 1000BaseT_Full should be used because of
> this?

With a MAC connected to an SFP cage, i would list the T modes
supported, since you have no idea what SFP module the user will
install, copper or fibre.

	 Andrew
