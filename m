Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7D4E4475E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 18:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404280AbfFMQ7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 12:59:12 -0400
Received: from outgoing-stata.csail.mit.edu ([128.30.2.210]:53158 "EHLO
        outgoing-stata.csail.mit.edu" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729848AbfFMAeY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 20:34:24 -0400
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jun 2019 20:34:23 EDT
Received: from [4.30.142.84] (helo=srivatsab-a01.vmware.com)
        by outgoing-stata.csail.mit.edu with esmtpsa (TLS1.2:RSA_AES_128_CBC_SHA1:128)
        (Exim 4.82)
        (envelope-from <srivatsa@csail.mit.edu>)
        id 1hbDYq-000Xfo-J5; Wed, 12 Jun 2019 20:25:48 -0400
Subject: Re: [PATCH v4 18/28] docs: convert docs to ReST and rename to *.rst
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@infradead.org>,
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
References: <cover.1560361364.git.mchehab+samsung@kernel.org>
 <fac44e1fbab5ea755a93601a4fdfa34fcc57ae9e.1560361364.git.mchehab+samsung@kernel.org>
From:   "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
Message-ID: <7dc94cb4-ebf1-22ab-29c9-fcb2b875a9ac@csail.mit.edu>
Date:   Wed, 12 Jun 2019 17:25:39 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:60.0)
 Gecko/20100101 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <fac44e1fbab5ea755a93601a4fdfa34fcc57ae9e.1560361364.git.mchehab+samsung@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/12/19 10:52 AM, Mauro Carvalho Chehab wrote:
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
> Acked-by: Bjorn Helgaas <bhelgaas@google.com>
> Acked-by: Mark Brown <broonie@kernel.org>
> ---

[...]

> diff --git a/Documentation/power/suspend-and-cpuhotplug.txt b/Documentation/power/suspend-and-cpuhotplug.rst
> similarity index 90%
> rename from Documentation/power/suspend-and-cpuhotplug.txt
> rename to Documentation/power/suspend-and-cpuhotplug.rst
> index a8751b8df10e..9df664f5423a 100644
> --- a/Documentation/power/suspend-and-cpuhotplug.txt
> +++ b/Documentation/power/suspend-and-cpuhotplug.rst
> @@ -1,10 +1,15 @@
> +====================================================================
>  Interaction of Suspend code (S3) with the CPU hotplug infrastructure
> +====================================================================
>  
> -     (C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> +(C) 2011 - 2014 Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
>  
>  
> -I. How does the regular CPU hotplug code differ from how the Suspend-to-RAM
> -   infrastructure uses it internally? And where do they share common code?
> +I. Differences between CPU hotplug and Suspend-to-RAM
> +======================================================
> +
> +How does the regular CPU hotplug code differ from how the Suspend-to-RAM
> +infrastructure uses it internally? And where do they share common code?
>  
>  Well, a picture is worth a thousand words... So ASCII art follows :-)
>  

[...]

> @@ -101,7 +108,7 @@ execution during resume):
>  
>  It is to be noted here that the system_transition_mutex lock is acquired at the very
>  beginning, when we are just starting out to suspend, and then released only
> -after the entire cycle is complete (i.e., suspend + resume).
> +after the entire cycle is complete (i.e., suspend + resume)::
>  

I think that should be a period, not a colon, because it is clarifying
the text above it (as opposed to referring to the example below it).

Other than that, for suspend-and-cpuhotplug.txt:

Acked-by: Srivatsa S. Bhat (VMware) <srivatsa@csail.mit.edu>
 
Regards,
Srivatsa
VMware Photon OS
