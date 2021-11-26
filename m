Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E52D545F17F
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 17:14:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378370AbhKZQR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 11:17:56 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:53708 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1378382AbhKZQPz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 11:15:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/O0/XnQa2fD0jseKQTMcaeBA5/9gi8L520w070arv70=; b=t3/YPhgnfw3kQiBqHQjIILjtE4
        RfjsEMfnc11tJtuJ2WF+fzCCh5CmZFMot0Yi5gzAp3EnzJchyRlfc+R39Pz9YSzBsO6hyc4Hn3A95
        rZGtuo3NgVy5dROOZZfi4NDOteTHVlRbrNfzDE1Lp2cCibv9dVsQZmWNNZP0V+JN1ftM=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mqdq4-00Ei0f-Pp; Fri, 26 Nov 2021 17:12:40 +0100
Date:   Fri, 26 Nov 2021 17:12:40 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Holger Brunck <holger.brunck@hitachienergy.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 1/2] Docs/devicetree: add serdes-output-amplitude to
 marvell.txt
Message-ID: <YaEHePSipJPoC9yW@lunn.ch>
References: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211126154249.2958-1-holger.brunck@hitachienergy.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 26, 2021 at 04:42:48PM +0100, Holger Brunck wrote:
> This can be configured from the device tree. Add this property to the
> documentation accordingly.
> The eight different values added in the dt-bindings file correspond to
> the values we can configure on 88E6352, 88E6240 and 88E6176 switches
> according to the datasheet.

This should probably be a port property, not a switch property. It
applies to the SERDES, and the SERDES belongs to a port. What you have
now only works because there is a single SERDES for this switch
family, but other switch families have multiple SERDESes.

	Andrew
