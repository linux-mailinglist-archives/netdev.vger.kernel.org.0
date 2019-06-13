Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 35DA443CF8
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 17:38:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732051AbfFMPid (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 11:38:33 -0400
Received: from casper.infradead.org ([85.118.1.10]:33510 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731947AbfFMJ7G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jun 2019 05:59:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=X6go1h+qBvd8UqStxDka25oSP1lwn219vXM1njzftqM=; b=st/cCkCW17JvfhPcMMlIiWlWs7
        IjzbMHLeCgNGoALijV6IG+3mBu2hWh+zDF/ixgeztGRJFvKYWEb/k1hwDtOuJEM+LaN5VPyeL2Nyt
        pUW3p7YE7JRXzR5AqF9H3+IiwxYWckQCRps/QFoMco8bS1sS+v518UWrrJXO7ml5NcscdFDSXeQVX
        ZKduv2MoYrDVAMjIkypzrzv1fDu9De18EdqyKnVmVA/jtlt3lbqFtvB/kKq3/UdhRk448WORt2zGk
        vyVeBQhaltTvjNhKaj4bDz1fJNL7g5eIVBQzyzZatNVk3zR46pfOQJ6fi4X1Ul2gzhVbF7Xgp5Fcx
        8jdm6Tow==;
Received: from 201.86.169.251.dynamic.adsl.gvt.net.br ([201.86.169.251] helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hbMVS-0000iN-9Z; Thu, 13 Jun 2019 09:58:54 +0000
Date:   Thu, 13 Jun 2019 06:58:43 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sebastian Reichel <sre@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 18/28] docs: convert docs to ReST and rename to *.rst
Message-ID: <20190613065843.100f72dd@coco.lan>
In-Reply-To: <7dc94cb4-ebf1-22ab-29c9-fcb2b875a9ac@csail.mit.edu>
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
        <fac44e1fbab5ea755a93601a4fdfa34fcc57ae9e.1560361364.git.mchehab+samsung@kernel.org>
        <7dc94cb4-ebf1-22ab-29c9-fcb2b875a9ac@csail.mit.edu>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Wed, 12 Jun 2019 17:25:39 -0700
"Srivatsa S. Bhat" <srivatsa@csail.mit.edu> escreveu:

> On 6/12/19 10:52 AM, Mauro Carvalho Chehab wrote:
> > Convert the PM documents to ReST, in order to allow them to
> > build with Sphinx.
> > 
> > The conversion is actually:
> >   - add blank lines and identation in order to identify paragraphs;
> >   - fix tables markups;
> >   - add some lists markups;
> >   - mark literal blocks;
> >   - adjust title markups.
> > 
> > At its new index.rst, let's add a :orphan: while this is not linked to
> > the main index.rst file, in order to avoid build warnings.
> > 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Acked-by: Mark Brown <broonie@kernel.org>
> > ---  
> 
> [...]
> 
> > diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.rst
> > similarity index 90%
> > rename from Documentation/power/suspend-and-cpuhotplug.txt
> > rename to Documentation/power/suspend-and-cpuhotplug.rst
> > index a8751b8df10e..9df664f5423a 100644
> > --- a/Documentation/power/suspend-and-cpuhotplug.txt
> > +++ b/Documentation/power/suspend-and-cpuhotplug.rst
> > @@ -1,10 +1,15 @@
> > +====================================================================
> >  Interaction of Suspend code (S3) with the CPU hotplug infrastructure
> > +====================================================================
> >  
> > -     (C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> > +(C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> >  
> >  
> > -I. How does the regular CPU hotplug code differ from how the Suspend-to-RAM
> > -   infrastructure uses it internally? And where do they share common code?
> > +I. Differences between CPU hotplug and Suspend-to-RAM
> > +======================================================
> > +
> > +How does the regular CPU hotplug code differ from how the Suspend-to-RAM
> > +infrastructure uses it internally? And where do they share common code?
> >  
> >  Well, a picture is worth a thousand words... So ASCII art follows :-)
> >    
> 
> [...]
> 
> > @@ -101,7 +108,7 @@ execution during resume):
> >  
> >  It is to be noted here that the system_transition_mutex lock is acquired at the very
> >  beginning, when we are just starting out to suspend, and then released only
> > -after the entire cycle is complete (i.e., suspend + resume).
> > +after the entire cycle is complete (i.e., suspend + resume)::
> >    
> 
> I think that should be a period, not a colon, because it is clarifying
> the text above it (as opposed to referring to the example below it).
> 
> Other than that, for suspend-and-cpuhotplug.txt:
> 
> Acked-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

Ah, ok. I'll change it to:

	after the entire cycle is complete (i.e., suspend + resume).

	::

and add your acked-by.

>  
> Regards,
> Srivatsa
> VMware Photon OS



Thanks,
Mauro
