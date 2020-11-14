Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6C22B2DF9
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 16:28:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727000AbgKNP2Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 10:28:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:47012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726356AbgKNP2P (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 10:28:15 -0500
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E56322265;
        Sat, 14 Nov 2020 15:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605367694;
        bh=w6GRHv1XESMtvaagowpL5feljKeJs2fwDrGdLJ9/tG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vQCvFBuAiwuauA3XjLeP+mCvOpc17dcwecF56gxntp9RKPC8CFObV6cOL7g1sMVGV
         WUs9y45I0DfoBWSVYS/kE6LiWfrPHsf01BnwcP7bRzi13PODYfJfI6KsRUci1zunac
         cmQCjGJd52D71VNOyOTEClERKlOIYrQhYJXA8hj8=
Date:   Sat, 14 Nov 2020 15:27:57 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
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
        Felipe Balbi <balbi@kernel.org>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Guenter Roeck <groeck@chromium.org>,
        Hanjun Guo <guohanjun@huawei.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        Juergen Gross <jgross@suse.com>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lakshmi Ramasubramanian <nramas@linux.microsoft.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Len Brown <lenb@kernel.org>,
        Leonid Maksymchuk <leonmaxx@gmail.com>,
        Ludovic Desroches <ludovic.desroches@microchip.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mark Gross <mgross@linux.intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Orson Zhai <orsonzhai@gmail.com>, Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        Peter Rosin <peda@axentia.se>, Petr Mladek <pmladek@suse.com>,
        Philippe Bergheaud <felix@linux.ibm.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Sebastian Reichel <sre@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Thinh Nguyen <Thinh.Nguyen@synopsys.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Rix <trix@redhat.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Vishal Verma <vishal.l.verma@intel.com>,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-pm@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-usb@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, xen-devel@lists.xenproject.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: Re: Duplicated ABI entries - Was: Re: [PATCH v2 20/39] docs: ABI:
 testing: make the files compatible with ReST output
Message-ID: <20201114152757.6d8b3b7d@archlinux>
In-Reply-To: <20201110082658.2edc1ab5@coco.lan>
References: <cover.1604042072.git.mchehab+huawei@kernel.org>
        <58cf3c2d611e0197fb215652719ebd82ca2658db.1604042072.git.mchehab+huawei@kernel.org>
        <5326488b-4185-9d67-fc09-79b911fbb3b8@st.com>
        <20201030110925.3e09d59e@coco.lan>
        <cb586ea3-b6e6-4e48-2344-2bd641e5323f@st.com>
        <20201102124641.GA881895@kroah.com>
        <20201102154250.45bee17f@coco.lan>
        <20201108165621.4d0da3f4@archlinux>
        <20201110082658.2edc1ab5@coco.lan>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:26:58 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> Hi Jonathan,
> 
> Em Sun, 8 Nov 2020 16:56:21 +0000
> Jonathan Cameron <jic23@kernel.org> escreveu:
> 
> > > PS.: the IIO subsystem is the one that currently has more duplicated
> > > ABI entries:  
> > > $ ./scripts/get_abi.pl validate 2>&1|grep iio
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_accel_x_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:0  Documentation/ABI/testing/sysfs-bus-iio:394
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_accel_y_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:1  Documentation/ABI/testing/sysfs-bus-iio:395
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_accel_z_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:2  Documentation/ABI/testing/sysfs-bus-iio:396
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_anglvel_x_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:3  Documentation/ABI/testing/sysfs-bus-iio:397
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_anglvel_y_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:4  Documentation/ABI/testing/sysfs-bus-iio:398
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_anglvel_z_calibbias is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-icm42600:5  Documentation/ABI/testing/sysfs-bus-iio:399
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_count0_preset is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-timer-stm32:100  Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32:0
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_count0_quadrature_mode is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-timer-stm32:117  Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32:14
> > > Warning: /sys/bus/iio/devices/iio:deviceX/in_count_quadrature_mode_available is defined 3 times:  Documentation/ABI/testing/sysfs-bus-iio-counter-104-quad-8:2  Documentation/ABI/testing/sysfs-bus-iio-timer-stm32:111  Documentation/ABI/testing/sysfs-bus-iio-lptimer-stm32:8
> > > Warning: /sys/bus/iio/devices/iio:deviceX/out_altvoltageY_frequency is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371:0  Documentation/ABI/testing/sysfs-bus-iio:599
> > > Warning: /sys/bus/iio/devices/iio:deviceX/out_altvoltageY_powerdown is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371:36  Documentation/ABI/testing/sysfs-bus-iio:588
> > > Warning: /sys/bus/iio/devices/iio:deviceX/out_currentY_raw is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als:43  Documentation/ABI/testing/sysfs-bus-iio-health-afe440x:38
> > > Warning: /sys/bus/iio/devices/iio:deviceX/out_current_heater_raw is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-humidity-hdc2010:0  Documentation/ABI/testing/sysfs-bus-iio-humidity-hdc100x:0
> > > Warning: /sys/bus/iio/devices/iio:deviceX/out_current_heater_raw_available is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-humidity-hdc2010:1  Documentation/ABI/testing/sysfs-bus-iio-humidity-hdc100x:1
> > > Warning: /sys/bus/iio/devices/iio:deviceX/sensor_sensitivity is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-distance-srf08:0  Documentation/ABI/testing/sysfs-bus-iio-proximity-as3935:8
> > > Warning: /sys/bus/iio/devices/triggerX/sampling_frequency is defined 2 times:  Documentation/ABI/testing/sysfs-bus-iio-timer-stm32:92  Documentation/ABI/testing/sysfs-bus-iio:45    
> 
> > 
> > That was intentional.  Often these provide more information on the
> > ABI for a particular device than is present in the base ABI doc.  
> 
> FYI, right now, there are 20 duplicated entries, being 16 of them
> from IIO, on those files:
> 
> 	$ ./scripts/get_abi.pl validate 2>&1|perl -ne 'if (m,(Documentation/\S+)\:,g) { print "$1\n" }'|sort|uniq
> 	Documentation/ABI/stable/sysfs-driver-w1_ds28e04
> 	Documentation/ABI/testing/sysfs-bus-iio-counter-104-quad-8
> 	Documentation/ABI/testing/sysfs-bus-iio-distance-srf08
> 	Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371
> 	Documentation/ABI/testing/sysfs-bus-iio-humidity-hdc2010
> 	Documentation/ABI/testing/sysfs-bus-iio-icm42600
> 	Documentation/ABI/testing/sysfs-bus-iio-light-lm3533-als
> 	Documentation/ABI/testing/sysfs-bus-iio-timer-stm32
> 	Documentation/ABI/testing/sysfs-class-backlight-adp8860
> 	Documentation/ABI/testing/sysfs-class-led-trigger-pattern
> 	Documentation/ABI/testing/sysfs-kernel-iommu_groups
> 
> > 
> > A bit like when we have additional description for dt binding properties
> > for a particular device, even though they are standard properties.
> > 
> > Often a standard property allows for more values than the specific
> > one for a particular device.  There can also be obscuring coupling
> > between sysfs attributes due to hardware restrictions that we would
> > like to provide some explanatory info on.
> > 
> > I suppose we could add all this information to the parent doc but
> > that is pretty ugly and will make that doc very nasty to read.  
> 
> I understand what you meant to do, but right now, it is is actually
> a lot uglier than merging into a single entry ;-)
> 
> Let's view ABI from the PoV of a system admin that doesn't know
> yet about a certain ABI symbol.

I'd be surprised if a sys admin is looking at these at all. They
tend to be used only by userspace software writers.  But I guess the
point stands.

> 
> He'll try to seek for the symbol, more likely using the HTML 
> documentation. Only very senior system admins might try to take
> a look at the Kernel.

Sad truth here is that before these were in the html docs, they'd
have grepped and the right option would fairly obvious as it
would be the more specific file.  Ah well, sometimes progress bites :)

> 
> This is what happens when one would seek for a duplicated symbol
> via command line:
> 
> 	$ ./scripts/get_abi.pl search /sys/bus/iio/devices/iio:deviceX/out_altvoltageY_frequency$
> 	
> 	/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_frequency
> 	----------------------------------------------------------
> 	
> 	Kernel version:		3.4.0
> 	Contact:		linux-iio@vger.kernel.org
> 	Defined on file(s):	Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371 Documentation/ABI/testing/sysfs-bus-iio
> 	
> 	Description:
> 	
> 	Stores the PLL frequency in Hz for channel Y.
> 	Reading returns the actual frequency in Hz.
> 	The ADF4371 has an integrated VCO with fundamendal output
> 	frequency ranging from 4000000000 Hz 8000000000 Hz.
> 	
> 	out_altvoltage0_frequency:
> 	        A divide by 1, 2, 4, 8, 16, 32 or circuit generates
> 	        frequencies from 62500000 Hz to 8000000000 Hz.
> 	out_altvoltage1_frequency:
> 	        This channel duplicates the channel 0 frequency
> 	out_altvoltage2_frequency:
> 	        A frequency doubler generates frequencies from
> 	        8000000000 Hz to 16000000000 Hz.
> 	out_altvoltage3_frequency:
> 	        A frequency quadrupler generates frequencies from
> 	        16000000000 Hz to 32000000000 Hz.
> 	
> 	Note: writes to one of the channels will affect the frequency of
> 	all the other channels, since it involves changing the VCO
> 	fundamental output frequency.
> 	
> 	Output frequency for channel Y in Hz. The number must always be
> 	specified and unique if the output corresponds to a single
> 	channel.
> 
> As the "What:" field is identical on both sysfs-bus-iio-frequency-adf4371
> and sysfs-bus-iio, those entries are merged, which produces an ABI
> documentation mixing both the generic one and the board specific one
> into a single output.
> 
> Worse than that, the "generic" content is at the end.
> 
> The same happens when generating the HTML output.
> 
> See, entries at the HTML output are ordered by the What: field,
> which is considered within the script as an unique key, as it is
> unique (except for IIO and a couple of other cases).
> 
> -
> 
> As I commented on an e-mail I sent to Greg, I see a few ways
> to solve it.
> 
> The most trivial one (which I used to solve a few conflicts on
> other places), is to place driver-specific details on a separate
> file under Documentation/driver-api, and mention it at the
> generic entries. The docs building system will generate cross
> references for Documentation/.../foo.rst files, so, everything
> should be OK.

Hmm. That might work out OK.  These devices tend to be weird enough
that they probably could do with some additional explanation anyway. 

> 
> The second alternative that I also used on a couple of places
> is to modify the generic entry for it to contain the generic
> definition first, followed by per-device details.

I'll do an audit of what we actually have here. Perhaps we end
up with a mixture of these two options.

Might take a little while though.

> 
> There is a third possible alternative: add a new optional field
> (something like Scope:) which would be part of the unique key,
> if present. Implementing support for it could be tricky, as the
> produced output would likely need to create cross-references
> between the generic field (if present) and the per-device details.
That would be lovely but probably not worth the effort for something
that occurs so rarely currently.

Jonathan

> 
> Thanks,
> Mauro
> 
> PS.: I'm taking a few days of PTO during this week. So, it
> could take a while for me to reply again to this thread.

