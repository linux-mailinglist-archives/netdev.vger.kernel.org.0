Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39BA22682D4
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 05:04:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726052AbgINDEn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Sep 2020 23:04:43 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbgINDEl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Sep 2020 23:04:41 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kHen3-00EXn4-NQ; Mon, 14 Sep 2020 05:04:25 +0200
Date:   Mon, 14 Sep 2020 05:04:25 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [RFC PATCH net-next v1 11/11] drivers/net/ethernet: clean up
 mis-targeted comments
Message-ID: <20200914030425.GG3463198@lunn.ch>
References: <20200911012337.14015-1-jesse.brandeburg@intel.com>
 <20200911012337.14015-12-jesse.brandeburg@intel.com>
 <227d2fe4-ddf8-89c9-b80b-142674c2cca0@solarflare.com>
 <20200911144207.00005619@intel.com>
 <e2e637ae-8cda-c9a4-91ce-93dbd475fc0c@solarflare.com>
 <20200911152642.62923ba2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <115bce2a-daaa-a7c5-3c48-44ce345ea008@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <115bce2a-daaa-a7c5-3c48-44ce345ea008@solarflare.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 12, 2020 at 12:11:20AM +0100, Edward Cree wrote:
> On 11/09/2020 23:26, Jakub Kicinski wrote:
> > "Toolchain" sounds a little grand in this context, the script that
> > parses kdoc does basic regexps to convert the standard kernel macros:
> > ...
> > IDK if we can expect it to understand random driver's macros..
> I wasn't suggesting it should _understand_ this macro, justrecognise
>  when something _is_ a macro it doesn't understand, and refrain from
>  warning about it in that case.

Is it possible to get the C preprocessor to expand the macros without
stripping the comments? Run the kerneldoc validator on that?

	  Andrew
