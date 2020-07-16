Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BCB8222B66
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 21:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729284AbgGPTCv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 15:02:51 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726986AbgGPTCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 15:02:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jw99a-005UZz-NH; Thu, 16 Jul 2020 21:02:46 +0200
Date:   Thu, 16 Jul 2020 21:02:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Willy Tarreau <w@1wt.eu>
Cc:     Jeroen Baten <jbaten@i2rs.nl>, netdev@vger.kernel.org
Subject: Re: newbie question on networking kernel panics.
Message-ID: <20200716190246.GB1308244@lunn.ch>
References: <49a5eb70-3596-26b5-37bb-285bbdc75a95@i2rs.nl>
 <20200716164012.GB22540@1wt.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200716164012.GB22540@1wt.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 06:40:12PM +0200, Willy Tarreau wrote:
> Hi Jeroen,
> 
> On Thu, Jul 16, 2020 at 05:38:57PM +0200, Jeroen Baten wrote:
> > Hi,
> > 
> > I have been working on a Linux desktop for the last 20 odd years.
> > Currently running Ubuntu 20.04.
> > 
> > Yesterday I enabled the option "Flow control" on my TP-Link TL-SG1024DE.
> > 
> > Subsequently I was forced to enjoy 3 kernel panics in the timespan of 18
> > hours.
> > 
> > After disabling the "Flow control" option my system seems to be stable
> > again.
> > 
> > I do have 3 sets of "cut here" text if somebody would be interested.
> > 
> > Please let me know if this information is of interest to someone or if I
> > am barking up the wrong majordomo tree.
> > 
> > Kind regards and thanks to all here for your immensely valuable work,
> 
> Since distro kernels contain some extra patches, may miss a significant
> number of fixes, or even rely on different driver sources, you really
> need to report this issue to your distro, who will ask for your exact
> kernel version. It may be that this issue also affects the vanilla
> kernel in the end, but in this case it will be reported by the distro's
> maintainers once they've verified that it's not related to their kernel's
> differences.

Hi Jeroen

If you are up for building your own kernel, you can build something
like mainline 5.8-rc5 and see if you can reproduce it. If you can
reproduce it with plain mainline, we would be interested in the "cut
here" text.

      Andrew
