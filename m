Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C652646A18
	for <lists+netdev@lfdr.de>; Fri, 14 Jun 2019 22:36:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728427AbfFNUgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Jun 2019 16:36:37 -0400
Received: from ms.lwn.net ([45.79.88.28]:54110 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727091AbfFNUge (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 Jun 2019 16:36:34 -0400
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 731B91427;
        Fri, 14 Jun 2019 20:36:32 +0000 (UTC)
Date:   Fri, 14 Jun 2019 14:36:31 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
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
        Bjorn Helgaas <bhelgaas@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-pci@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org,
        "Srivatsa S . Bhat" <srivatsa@csail.mit.edu>
Subject: Re: [PATCH v5] docs: power: convert docs to ReST and rename to
 *.rst
Message-ID: <20190614143631.7c99719f@lwn.net>
In-Reply-To: <72d1f8f360d395958dd0b49165fc51b58801f57e.1560420621.git.mchehab+samsung@kernel.org>
References: <7dc94cb4-ebf1-22ab-29c9-fcb2b875a9ac@csail.mit.edu>
        <72d1f8f360d395958dd0b49165fc51b58801f57e.1560420621.git.mchehab+samsung@kernel.org>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jun 2019 07:10:36 -0300
Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:

> Convert the PM documents to ReST, in order to allow them to
> build with Sphinx.
> 
> The conversion is actually:
>   - add blank lines and identation in order to identify paragraphs;
>   - fix tables markups;
>   - add some lists markups;
>   - mark literal blocks;
>   - adjust title markups.
> 
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> Acked-by: Mark Brown <broonie@kernel.org>
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>

So I can't apply this one due to conflicts in include/linux/pci.h.  Bjorn,
perhaps the easiest thing is for you to take this one through your tree?

Thanks,

jon
