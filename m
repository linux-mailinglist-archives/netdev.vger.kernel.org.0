Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5C123D9D76
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 08:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234112AbhG2GFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 02:05:34 -0400
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:53763 "EHLO
        relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbhG2GFd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 02:05:33 -0400
Received: (Authenticated sender: ralf@linux-mips.org)
        by relay5-d.mail.gandi.net (Postfix) with ESMTPSA id A438F1C0004;
        Thu, 29 Jul 2021 06:05:27 +0000 (UTC)
Date:   Thu, 29 Jul 2021 08:05:25 +0200
From:   Ralf Baechle DL5RB <ralf@linux-mips.org>
To:     "Alejandro Colomar (man-pages)" <alx.manpages@gmail.com>
Cc:     netdev@vger.kernel.org, linux-hams@vger.kernel.org,
        Thomas Osterried <thomas@osterried.de>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        linux-man@vger.kernel.org
Subject: Re: [PATCH] packet.7: Describe SOCK_PACKET netif name length issues
 and workarounds.
Message-ID: <YQJFJWP5MnWrJr34@linux-mips.org>
References: <YP/Jcc4AFIcvgXls@linux-mips.org>
 <a050e248-af45-0678-b25c-27e249fb5565@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a050e248-af45-0678-b25c-27e249fb5565@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 10:52:15PM +0200, Alejandro Colomar (man-pages) wrote:

> Hello Ralf,
> 
> On 7/27/21 10:53 AM, Ralf Baechle wrote:
> > Describe the issues with SOCK_PACKET possibly truncating network interface
> > names in results, solutions and possible workarounds.
> > 
> > While the issue is know for a long time it appears to have never been
> > documented properly and is has started to bite software antiques badly since
> > the introduction of Predictable Network Interface Names.  So let's document
> > it.
> > 
> > Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
> 
> Thanks for the patch!
> Please see a few comments below.

I'll make an updated version in a week or so.  Until then I'm goning to be
offline on civil defence duty in German's flood disaster region ...

  Ralf
