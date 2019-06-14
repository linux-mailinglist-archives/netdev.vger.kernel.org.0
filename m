Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7CAC46B9C
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 23:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfFNVOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 17:14:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:58562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726252AbfFNVOt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 17:14:49 -0400
Received: from localhost (unknown [69.71.4.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D0D921473;
        Fri, 14 Jun 2019 21:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560546889;
        bh=wQlzv9GXi+d6YxFDj5qp88AVZygc6aohbfVT4AQR70Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ks0AHcQ3CMMcp8lXmC5Q1q+mNRhg76nx20zz7WGQfrHmET+emzaWoOodcXQ82HPjk
         /Q0wzICC14gHKtUH/c0hiVkAbFD6SklBQgeWeDifIfILXybbVlrUgOA2LE9404heew
         9zZ4/WlS27thwm4E7UDC674PGe7hBqVr8gYg2J1U=
Date:   Fri, 14 Jun 2019 16:14:47 -0500
From:   Bjorn Helgaas <helgaas@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
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
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v5] docs: power: convert docs to ReST and rename to *.rst
Message-ID: <20190614211447.GU13533@google.com>
References: <7dc94cb4-ebf1-22ab-29c9-fcb2b875a9ac@csail.mit.edu>
 <72d1f8f360d395958dd0b49165fc51b58801f57e.1560420621.git.mchehab+samsung@kernel.org>
 <20190614143631.7c99719f@lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190614143631.7c99719f@lwn.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 14, 2019 at 02:36:31PM -0600, Jonathan Corbet wrote:
> On Thu, 13 Jun 2019 07:10:36 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
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
> > Acked-by: Mark Brown <broonie@kernel.org>
> > Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> > Acked-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
> 
> So I can't apply this one due to conflicts in include/linux/pci.h.  Bjorn,
> perhaps the easiest thing is for you to take this one through your tree?

OK, I applied this to pci/docs for v5.3.  I applied this entire patch,
but if you would prefer that I only apply the PCI-related parts, let
me know and I'll split those out.

Bjorn
