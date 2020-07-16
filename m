Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0113C222886
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 18:49:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729053AbgGPQta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 12:49:30 -0400
Received: from wtarreau.pck.nerim.net ([62.212.114.60]:38544 "EHLO 1wt.eu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgGPQt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 12:49:29 -0400
X-Greylist: delayed 551 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Jul 2020 12:49:29 EDT
Received: (from willy@localhost)
        by pcw.home.local (8.15.2/8.15.2/Submit) id 06GGeCrP022551;
        Thu, 16 Jul 2020 18:40:12 +0200
Date:   Thu, 16 Jul 2020 18:40:12 +0200
From:   Willy Tarreau <w@1wt.eu>
To:     Jeroen Baten <jbaten@i2rs.nl>
Cc:     netdev@vger.kernel.org
Subject: Re: newbie question on networking kernel panics.
Message-ID: <20200716164012.GB22540@1wt.eu>
References: <49a5eb70-3596-26b5-37bb-285bbdc75a95@i2rs.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49a5eb70-3596-26b5-37bb-285bbdc75a95@i2rs.nl>
User-Agent: Mutt/1.6.1 (2016-04-27)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jeroen,

On Thu, Jul 16, 2020 at 05:38:57PM +0200, Jeroen Baten wrote:
> Hi,
> 
> I have been working on a Linux desktop for the last 20 odd years.
> Currently running Ubuntu 20.04.
> 
> Yesterday I enabled the option "Flow control" on my TP-Link TL-SG1024DE.
> 
> Subsequently I was forced to enjoy 3 kernel panics in the timespan of 18
> hours.
> 
> After disabling the "Flow control" option my system seems to be stable
> again.
> 
> I do have 3 sets of "cut here" text if somebody would be interested.
> 
> Please let me know if this information is of interest to someone or if I
> am barking up the wrong majordomo tree.
> 
> Kind regards and thanks to all here for your immensely valuable work,

Since distro kernels contain some extra patches, may miss a significant
number of fixes, or even rely on different driver sources, you really
need to report this issue to your distro, who will ask for your exact
kernel version. It may be that this issue also affects the vanilla
kernel in the end, but in this case it will be reported by the distro's
maintainers once they've verified that it's not related to their kernel's
differences.

Hoping this helps,
Willy
