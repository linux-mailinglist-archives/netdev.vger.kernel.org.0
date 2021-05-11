Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61E237AEA6
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:48:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232047AbhEKSuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:50:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbhEKSuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 May 2021 14:50:04 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62DAEC061574;
        Tue, 11 May 2021 11:48:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=ZkOT+h7IwVrb/g/jzXBMqGF7GJVTbVn2CyQ5yD1dGC0=; b=ob16GH3+IUlXSVCRaH6KiTLg7W
        KVGr+qMse8+2g2wZdN5XpCzI8gx5fFedBPPM7a0rOUni9p45nSoKas8LoTGRgHGNdkGawym72lhqM
        wJbSskCAJ6pc2JLqZ19l1wZaFi+zkpp51vBlynJg4PBatQf22v1P4WdbiiA7PqNpj7tXatV247aE2
        21UgpSPrBZpRsGMfHIgOaz02Ys+BYCWvtFjxa9JaCK0gBNYJHLasByutmseHgF2XExtnxn+lpHG3w
        WA3D4PNCmFk+6mL1JXUn9rz1vDUXpsZ/V7mW3lf+BHtLXAPoZnwv53hS1vP1JcbO5oRf8GsV9VHsT
        j4deW4PQ==;
Received: from willy by casper.infradead.org with local (Exim 4.94 #2 (Red Hat Linux))
        id 1lgXQY-007ZFN-Mj; Tue, 11 May 2021 18:48:20 +0000
Date:   Tue, 11 May 2021 19:48:18 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: device_drivers: fix bad usage of
 UTF-8 chars
Message-ID: <YJrRcgmrqJLSOjR5@casper.infradead.org>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
 <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
 <YJq9abOeuBla3Jiw@lunn.ch>
 <8735utdt6z.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8735utdt6z.fsf@meer.lwn.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 11, 2021 at 12:24:52PM -0600, Jonathan Corbet wrote:
> Andrew Lunn <andrew@lunn.ch> writes:
> 
> >> -monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
> >> +monitoring tools such as `ifstat` or `sar -n DEV [interval] [number of samples]`
> >
> > ...
> >
> >>  For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
> >> -monitoring tools such as ifstat or sar –n DEV [interval] [number of samples]
> >> +monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [number of samples]``
> >
> > Is there a difference between ` and `` ? Does it make sense to be
> > consistent?
> 
> This is `just weird quotes`

umm ... `this` is supposed to be "interpreted text"
https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#inline-markup

Maybe we don't actually interpret it.

> This is ``literal text`` set in monospace in processed output.
> 
> There is a certain tension between those who want to see liberal use of
> literal-text markup, and those who would rather have less markup in the
> text overall; certainly, it's better not to go totally nuts with it.

I really appreciate the work you did to reduce the amount of
markup that's needed!
