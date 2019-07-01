Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE0D5BD3E
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 15:46:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727536AbfGANqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 09:46:52 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45652 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727397AbfGANqw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Jul 2019 09:46:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XmzQ1OqKXvP8DVrfufoLKrTLMjLZvx796OsgHMSOyac=; b=YVAKHVL1DZYyQASo9ypLzmJdy1
        DfYprLHSA9ryH2Sa9vP51XikNRe8bi2EjMjtiWtjveaq7ThcEBBW+yv64fkGlUk6lnKzz3Uog+gu+
        DeQvrJI7S3AnBi8rc5oT71xahB/jO0PPCr0UAGieBErUQmxZMqYwOUH5LbuFKb5zuZQ8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hhwdr-0007Es-NB; Mon, 01 Jul 2019 15:46:47 +0200
Date:   Mon, 1 Jul 2019 15:46:47 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sergej Benilov <sergej.benilov@googlemail.com>
Cc:     venza@brownhat.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sis900: add ethtool tests (link, eeprom)
Message-ID: <20190701134647.GC25795@lunn.ch>
References: <20190701090333.25277-1-sergej.benilov@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190701090333.25277-1-sergej.benilov@googlemail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 01, 2019 at 11:03:33AM +0200, Sergej Benilov wrote:
> Add tests for ethtool: link test, EEPROM read test.
> Correct a few typos, too.

Hi Sergej

Please split this up into two patches. The first one should fixing the
typos.

Rather than implementing a test for the EEPROM, add support for
ethtool --eeprom-dump. That is much more useful.

The link test does not show you anything which you cannot get via ip
link show. If there is no carrier, the link is down. So drop that.

The patch also has white space issues. Spaces where there should be
tabs. Please run ./scripts/checkpatch.pl.

     Andrew
