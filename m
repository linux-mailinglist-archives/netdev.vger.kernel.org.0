Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 989A129E3D8
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 08:23:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726617AbgJ2HWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 03:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:42034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726151AbgJ2HV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 03:21:26 -0400
Received: from coco.lan (ip5f5ad5de.dynamic.kabel-deutschland.de [95.90.213.222])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D568206A1;
        Thu, 29 Oct 2020 07:21:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603956079;
        bh=ydKKLjnIGAQnlNnBFT/eI5WDiCpUdvgjw4RkqNPBoTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AXef/AhAlPh1hi9YsdIj4o1ixVYaGEAZM4H9T1mWHDD5hcqq9AHBGqQYLJm4zvkzm
         vDRNtmfz4vMaZ1nCDFiLdWyz0Wl7IBqlNL9mj+lYOyRgbN8ZBRkoI4V/HMDyMBFkDS
         A+Vrm0psmwUp0NppXp1qjXj8jB9uy8mTt+24KpoY=
Date:   Thu, 29 Oct 2020 08:21:00 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Javier =?UTF-8?B?R29uesOhbGV6?= <javier@javigon.com>,
        Jonathan Corbet <corbet@lwn.net>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        Benson Leung <bleung@chromium.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Bruno Meneguele <bmeneg@redhat.com>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Felipe Balbi <balbi@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Juergen Gross <jgross@suse.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Len Brown <lenb@kernel.org>,
        Leonid Maksymchuk <leonmaxx@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Orson Zhai <orsonzhai@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>, Petr Mladek <pmladek@suse.com>,
        Philippe Bergheaud <felix@linux.ibm.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org
Subject: Re: [PATCH 20/33] docs: ABI: testing: make the files compatible
 with ReST output
Message-ID: <20201029082100.4820072c@coco.lan>
In-Reply-To: <20201028174427.GE9364@hoboy.vegasvil.org>
References: <cover.1603893146.git.mchehab+huawei@kernel.org>
        <4ebaaa0320101479e392ce2db4b62e24fdf15ef1.1603893146.git.mchehab+huawei@kernel.org>
        <20201028174427.GE9364@hoboy.vegasvil.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Richard,

Em Wed, 28 Oct 2020 10:44:27 -0700
Richard Cochran <richardcochran@gmail.com> escreveu:

> On Wed, Oct 28, 2020 at 03:23:18PM +0100, Mauro Carvalho Chehab wrote:
> 
> > diff --git a/Documentation/ABI/testing/sysfs-uevent b/Documentation/ABI/testing/sysfs-uevent
> > index aa39f8d7bcdf..d0893dad3f38 100644
> > --- a/Documentation/ABI/testing/sysfs-uevent
> > +++ b/Documentation/ABI/testing/sysfs-uevent
> > @@ -19,7 +19,8 @@ Description:
> >                  a transaction identifier so it's possible to use the same UUID
> >                  value for one or more synthetic uevents in which case we
> >                  logically group these uevents together for any userspace
> > -                listeners. The UUID value appears in uevent as
> > +                listeners. The UUID value appears in uevent as:  
> 
> I know almost nothing about Sphinx, but why have one colon here ^^^ and ...

Good point. After re-reading the text, this ":" doesn't belong here.

> 
> > +
> >                  "SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment
> >                  variable.
> >  
> > @@ -30,18 +31,19 @@ Description:
> >                  It's possible to define zero or more pairs - each pair is then
> >                  delimited by a space character ' '. Each pair appears in
> >                  synthetic uevent as "SYNTH_ARG_KEY=VALUE". That means the KEY
> > -                name gains "SYNTH_ARG_" prefix to avoid possible collisions
> > +                name gains `SYNTH_ARG_` prefix to avoid possible collisions
> >                  with existing variables.
> >  
> > -                Example of valid sequence written to the uevent file:
> > +                Example of valid sequence written to the uevent file::  
> 
> ... two here?

The main issue that this patch wants to solve is here:

                This generates synthetic uevent including these variables::

                    ACTION=add
                    SYNTH_ARG_A=1
                    SYNTH_ARG_B=abc
                    SYNTH_UUID=fe4d7c9d-b8c6-4a70-9ef1-3d8a58d18eed

On Sphinx, consecutive lines with the same indent belongs to the same
paragraph. So, without "::", the above will be displayed on a single line,
which is undesired.

using "::" tells Sphinx to display as-is. It will also place it into a a 
box (colored for html output) and using a monospaced font.

The change at the "uevent file:" line was done just for coherency
purposes.

Yet, after re-reading the text, there are other things that are not
coherent. So, I guess the enclosed patch will work better for sys-uevent.

Thanks,
Mauro

docs: ABI: sysfs-uevent: make it compatible with ReST output

- Replace " by ``, in order to use monospaced fonts;
- mark literal blocks as such.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/Documentation/ABI/testing/sysfs-uevent b/Documentation/ABI/testing/sysfs-uevent
index aa39f8d7bcdf..0b6227706b35 100644
--- a/Documentation/ABI/testing/sysfs-uevent
+++ b/Documentation/ABI/testing/sysfs-uevent
@@ -6,42 +6,46 @@ Description:
                 Enable passing additional variables for synthetic uevents that
                 are generated by writing /sys/.../uevent file.
 
-                Recognized extended format is ACTION [UUID [KEY=VALUE ...].
+                Recognized extended format is::
 
-                The ACTION is compulsory - it is the name of the uevent action
-                ("add", "change", "remove"). There is no change compared to
-                previous functionality here. The rest of the extended format
-                is optional.
+			ACTION [UUID [KEY=VALUE ...]
+
+                The ACTION is compulsory - it is the name of the uevent
+                action (``add``, ``change``, ``remove``). There is no change
+                compared to previous functionality here. The rest of the
+                extended format is optional.
 
                 You need to pass UUID first before any KEY=VALUE pairs.
-                The UUID must be in "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
+                The UUID must be in ``xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx``
                 format where 'x' is a hex digit. The UUID is considered to be
                 a transaction identifier so it's possible to use the same UUID
                 value for one or more synthetic uevents in which case we
                 logically group these uevents together for any userspace
                 listeners. The UUID value appears in uevent as
-                "SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" environment
+                ``SYNTH_UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx`` environment
                 variable.
 
                 If UUID is not passed in, the generated synthetic uevent gains
-                "SYNTH_UUID=0" environment variable automatically.
+                ``SYNTH_UUID=0`` environment variable automatically.
 
                 The KEY=VALUE pairs can contain alphanumeric characters only.
+
                 It's possible to define zero or more pairs - each pair is then
                 delimited by a space character ' '. Each pair appears in
-                synthetic uevent as "SYNTH_ARG_KEY=VALUE". That means the KEY
-                name gains "SYNTH_ARG_" prefix to avoid possible collisions
+                synthetic uevent as ``SYNTH_ARG_KEY=VALUE``. That means the KEY
+                name gains ``SYNTH_ARG_`` prefix to avoid possible collisions
                 with existing variables.
 
-                Example of valid sequence written to the uevent file:
+                Example of valid sequence written to the uevent file::
 
                     add fe4d7c9d-b8c6-4a70-9ef1-3d8a58d18eed A=1 B=abc
 
-                This generates synthetic uevent including these variables:
+                This generates synthetic uevent including these variables::
 
                     ACTION=add
                     SYNTH_ARG_A=1
                     SYNTH_ARG_B=abc
                     SYNTH_UUID=fe4d7c9d-b8c6-4a70-9ef1-3d8a58d18eed
+
 Users:
                 udev, userspace tools generating synthetic uevents
