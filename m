Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76A2B29EE95
	for <lists+netdev@lfdr.de>; Thu, 29 Oct 2020 15:43:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727865AbgJ2OnM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Oct 2020 10:43:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:56768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727708AbgJ2OnI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Oct 2020 10:43:08 -0400
Received: from archlinux (cpc149474-cmbg20-2-0-cust94.5-4.cable.virginm.net [82.4.196.95])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB639206D4;
        Thu, 29 Oct 2020 14:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603982572;
        bh=gmZkwxj3ggiXcuewqKtlIbB3KBFOMnpXfuZxmH58hPU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j3pLkq46eXrErMhHAcjswJRec84nFoscWYO9axA4dv+encxIgK724kueuVpiXMKoC
         dudXnCgVzt0i736jOgLS7+2On3FNrz6Hn8aeunQ08HqGpTaVqmLUQfB8N1EmJ8wEqt
         alcQoQ8pGKsP/EC/7kCO6RLVjUrfBcjsHkSLXVKE=
Date:   Thu, 29 Oct 2020 14:42:25 +0000
From:   Jonathan Cameron <jic23@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        "Jonathan Corbet" <corbet@lwn.net>,
        Marek =?UTF-8?B?QmVow7pu?= <marek.behun@nic.cz>,
        Marek =?UTF-8?B?TWFyY3p5a293c2tpLUfDs3JlY2tp?= 
        <marmarek@invisiblethingslab.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Pali =?UTF-8?B?Um9o?= =?UTF-8?B?w6Fy?= <pali@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Roger Pau =?UTF-8?B?TW9ubsOp?= <roger.pau@citrix.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andreas Klinger <ak@it-klinger.de>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Boris Brezillon <bbrezillon@kernel.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>,
        Chao Yu <chao@kernel.org>,
        Christian Gromm <christian.gromm@microchip.com>,
        Colin Cross <ccross@android.com>, Dan Murphy <dmurphy@ti.com>,
        Dan Williams <dan.j.williams@intel.com>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        Danil Kipnis <danil.kipnis@cloud.ionos.com>,
        David Sterba <dsterba@suse.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Dongsheng Yang <dongsheng.yang@easystack.cn>,
        Enric Balletbo i Serra <enric.balletbo@collabora.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frederic Barrat <fbarrat@linux.ibm.com>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Hanjun Guo <guohanjun@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jonas Meurer <jonas@freesources.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Kees Cook <keescook@chromium.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Madhavan Srinivasan <maddy@linux.ibm.com>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mark Brown <broonie@kernel.org>,
        Mark Gross <mgross@linux.intel.com>,
        Mathieu Malaterre <malat@debian.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Leach <mike.leach@linaro.org>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>,
        Paul Cercueil <paul@crapouillou.net>,
        Pavel Machek <pavel@ucw.cz>,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Peter Chen <peter.chen@nxp.com>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>,
        PrasannaKumar Muralidharan <prasannatsmkumar@gmail.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Roman Sudarikov <roman.sudarikov@linux.intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Samuel Thibault <samuel.thibault@ens-lyon.org>,
        Saravana Kannan <saravanak@google.com>,
        Sebastian Reichel <sre@kernel.org>,
        Simon Gaiser <simon@invisiblethingslab.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Rix <trix@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Wu Hao <hao.wu@intel.com>, ceph-devel@vger.kernel.org,
        coresight@lists.linaro.org, dri-devel@lists.freedesktop.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org
Subject: Re: [PATCH 30/33] docs: ABI: cleanup several ABI documents
Message-ID: <20201029144225.62f59c10@archlinux>
In-Reply-To: <95ef2cf3a58f4e50f17d9e58e0d9440ad14d0427.1603893146.git.mchehab+huawei@kernel.org>
References: <cover.1603893146.git.mchehab+huawei@kernel.org>
        <95ef2cf3a58f4e50f17d9e58e0d9440ad14d0427.1603893146.git.mchehab+huawei@kernel.org>
X-Mailer: Claws Mail 3.17.7 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 15:23:28 +0100
Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:

> There are some ABI documents that, while they don't generate
> any warnings, they have issues when parsed by get_abi.pl script
> on its output result.
>=20
> Address them, in order to provide a clean output.
>=20
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

All the IIO ones look sensible.  Thanks

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for IIO

> ---
>  Documentation/ABI/obsolete/sysfs-class-dax    |   8 +-
>  .../ABI/obsolete/sysfs-driver-hid-roccat-pyra |   3 +
>  Documentation/ABI/removed/devfs               |   1 +
>  Documentation/ABI/removed/raw1394             |   1 +
>  Documentation/ABI/removed/sysfs-class-rfkill  |   2 +-
>  Documentation/ABI/removed/video1394           |   1 +
>  Documentation/ABI/stable/firewire-cdev        |  63 ++---
>  Documentation/ABI/stable/sysfs-acpi-pmprofile |   4 +-
>  Documentation/ABI/stable/sysfs-bus-w1         |   1 +
>  Documentation/ABI/stable/sysfs-class-tpm      |   4 +-
>  Documentation/ABI/stable/sysfs-driver-speakup |   4 +
>  Documentation/ABI/testing/configfs-most       | 135 +++++++----
>  .../ABI/testing/configfs-usb-gadget-ecm       |  12 +-
>  .../ABI/testing/configfs-usb-gadget-eem       |  10 +-
>  .../ABI/testing/configfs-usb-gadget-loopback  |   6 +-
>  .../testing/configfs-usb-gadget-mass-storage  |  18 +-
>  .../ABI/testing/configfs-usb-gadget-midi      |  14 +-
>  .../ABI/testing/configfs-usb-gadget-printer   |   6 +-
>  .../testing/configfs-usb-gadget-sourcesink    |  18 +-
>  .../ABI/testing/configfs-usb-gadget-subset    |  10 +-
>  .../ABI/testing/configfs-usb-gadget-uac2      |  14 +-
>  .../ABI/testing/configfs-usb-gadget-uvc       |   2 +-
>  .../ABI/testing/debugfs-cec-error-inj         |   2 +-
>  .../ABI/testing/debugfs-driver-habanalabs     |  12 +-
>  .../ABI/testing/debugfs-pfo-nx-crypto         |  28 +--
>  Documentation/ABI/testing/debugfs-pktcdvd     |   2 +-
>  .../ABI/testing/debugfs-turris-mox-rwtm       |  10 +-
>  Documentation/ABI/testing/debugfs-wilco-ec    |  21 +-
>  Documentation/ABI/testing/dell-smbios-wmi     |  32 +--
>  Documentation/ABI/testing/gpio-cdev           |  13 +-
>  Documentation/ABI/testing/procfs-diskstats    |   6 +-
>  Documentation/ABI/testing/procfs-smaps_rollup |  48 ++--
>  Documentation/ABI/testing/pstore              |  19 +-
>  Documentation/ABI/testing/sysfs-block-rnbd    |   4 +-
>  Documentation/ABI/testing/sysfs-bus-acpi      |   1 +
>  .../testing/sysfs-bus-coresight-devices-etb10 |   5 +-
>  Documentation/ABI/testing/sysfs-bus-css       |   3 +
>  Documentation/ABI/testing/sysfs-bus-dfl       |   2 +
>  .../sysfs-bus-event_source-devices-hv_24x7    |   6 +-
>  .../sysfs-bus-event_source-devices-hv_gpci    |   7 +-
>  Documentation/ABI/testing/sysfs-bus-fcoe      |  68 ++++--
>  Documentation/ABI/testing/sysfs-bus-fsl-mc    |  12 +-
>  .../ABI/testing/sysfs-bus-i2c-devices-fsa9480 |  26 +-
>  Documentation/ABI/testing/sysfs-bus-i3c       |   2 +
>  Documentation/ABI/testing/sysfs-bus-iio       |  19 +-
>  .../ABI/testing/sysfs-bus-iio-adc-hi8435      |   5 +
>  .../ABI/testing/sysfs-bus-iio-adc-stm32       |   3 +
>  .../ABI/testing/sysfs-bus-iio-distance-srf08  |   7 +-
>  .../testing/sysfs-bus-iio-frequency-ad9523    |   2 +
>  .../testing/sysfs-bus-iio-frequency-adf4371   |  10 +-
>  .../ABI/testing/sysfs-bus-iio-health-afe440x  |  12 +-
>  .../ABI/testing/sysfs-bus-iio-light-isl29018  |   6 +-
>  .../testing/sysfs-bus-intel_th-devices-gth    |  11 +-
>  Documentation/ABI/testing/sysfs-bus-papr-pmem |  23 +-
>  Documentation/ABI/testing/sysfs-bus-pci       |  22 +-
>  .../ABI/testing/sysfs-bus-pci-devices-catpt   |   1 +
>  .../testing/sysfs-bus-pci-drivers-ehci_hcd    |   4 +-
>  Documentation/ABI/testing/sysfs-bus-rbd       |  37 ++-
>  Documentation/ABI/testing/sysfs-bus-siox      |   3 +
>  .../ABI/testing/sysfs-bus-thunderbolt         |  18 +-
>  Documentation/ABI/testing/sysfs-bus-usb       |   2 +
>  .../sysfs-class-backlight-driver-lm3533       |  26 +-
>  Documentation/ABI/testing/sysfs-class-bdi     |   1 -
>  .../ABI/testing/sysfs-class-chromeos          |  15 +-
>  Documentation/ABI/testing/sysfs-class-cxl     |   8 +-
>  Documentation/ABI/testing/sysfs-class-devlink |  30 ++-
>  Documentation/ABI/testing/sysfs-class-extcon  |  34 +--
>  .../ABI/testing/sysfs-class-fpga-manager      |   5 +-
>  Documentation/ABI/testing/sysfs-class-gnss    |   2 +
>  Documentation/ABI/testing/sysfs-class-led     |   1 +
>  .../testing/sysfs-class-led-driver-el15203000 |  30 +--
>  .../ABI/testing/sysfs-class-led-driver-lm3533 |  44 ++--
>  .../ABI/testing/sysfs-class-led-flash         |  27 ++-
>  .../testing/sysfs-class-led-trigger-netdev    |   7 +
>  .../testing/sysfs-class-led-trigger-usbport   |   1 +
>  .../ABI/testing/sysfs-class-leds-gt683r       |   8 +-
>  Documentation/ABI/testing/sysfs-class-net     |  61 +++--
>  .../ABI/testing/sysfs-class-net-cdc_ncm       |   6 +-
>  .../ABI/testing/sysfs-class-net-phydev        |   2 +
>  Documentation/ABI/testing/sysfs-class-pktcdvd |  36 +--
>  Documentation/ABI/testing/sysfs-class-power   |  12 +-
>  .../ABI/testing/sysfs-class-power-mp2629      |   1 +
>  .../ABI/testing/sysfs-class-power-twl4030     |   4 +-
>  Documentation/ABI/testing/sysfs-class-rapidio |  46 ++--
>  .../ABI/testing/sysfs-class-regulator         |  36 +--
>  .../ABI/testing/sysfs-class-remoteproc        |  14 +-
>  ...ysfs-class-rtc-rtc0-device-rtc_calibration |   1 +
>  Documentation/ABI/testing/sysfs-class-uwb_rc  |  13 +-
>  .../ABI/testing/sysfs-class-watchdog          |   7 +-
>  Documentation/ABI/testing/sysfs-dev           |   7 +-
>  .../ABI/testing/sysfs-devices-mapping         |  41 ++--
>  .../ABI/testing/sysfs-devices-memory          |  15 +-
>  .../sysfs-devices-platform-_UDC_-gadget       |  10 +-
>  .../ABI/testing/sysfs-devices-platform-ipmi   |  52 ++--
>  .../ABI/testing/sysfs-devices-system-cpu      |   4 +-
>  .../ABI/testing/sysfs-driver-hid-lenovo       |  10 +
>  .../ABI/testing/sysfs-driver-hid-ntrig        |  13 +-
>  .../ABI/testing/sysfs-driver-hid-roccat-kone  |  19 ++
>  .../ABI/testing/sysfs-driver-hid-wiimote      |   1 +
>  .../ABI/testing/sysfs-driver-input-exc3000    |   2 +
>  .../ABI/testing/sysfs-driver-jz4780-efuse     |   6 +-
>  .../ABI/testing/sysfs-driver-pciback          |   6 +-
>  Documentation/ABI/testing/sysfs-driver-ufs    | 228 ++++++++++++++----
>  .../ABI/testing/sysfs-driver-w1_ds28e17       |   3 +
>  Documentation/ABI/testing/sysfs-firmware-acpi |  16 +-
>  .../ABI/testing/sysfs-firmware-efi-esrt       |  28 ++-
>  .../testing/sysfs-firmware-efi-runtime-map    |  14 +-
>  .../ABI/testing/sysfs-firmware-qemu_fw_cfg    |  20 +-
>  Documentation/ABI/testing/sysfs-firmware-sfi  |   6 +-
>  .../ABI/testing/sysfs-firmware-sgi_uv         |   6 +-
>  Documentation/ABI/testing/sysfs-fs-f2fs       |  48 ++--
>  Documentation/ABI/testing/sysfs-kernel-mm-ksm |   5 +-
>  Documentation/ABI/testing/sysfs-kernel-slab   |   3 +
>  Documentation/ABI/testing/sysfs-module        |  17 +-
>  .../ABI/testing/sysfs-platform-dell-laptop    |  10 +-
>  .../ABI/testing/sysfs-platform-dell-smbios    |   4 +-
>  .../testing/sysfs-platform-i2c-demux-pinctrl  |   4 +-
>  Documentation/ABI/testing/sysfs-platform-kim  |   1 +
>  .../testing/sysfs-platform-phy-rcar-gen3-usb2 |  10 +-
>  .../ABI/testing/sysfs-platform-renesas_usb3   |  10 +-
>  Documentation/ABI/testing/sysfs-power         |  21 +-
>  Documentation/ABI/testing/sysfs-profiling     |   2 +-
>  Documentation/ABI/testing/sysfs-wusb_cbaf     |   3 +-
>  Documentation/ABI/testing/usb-charger-uevent  |  82 ++++---
>  Documentation/ABI/testing/usb-uevent          |  32 +--
>  scripts/get_abi.pl                            |   2 -
>  126 files changed, 1323 insertions(+), 767 deletions(-)
>=20
> diff --git a/Documentation/ABI/obsolete/sysfs-class-dax b/Documentation/A=
BI/obsolete/sysfs-class-dax
> index 2cb9fc5e8bd1..0faf1354cd05 100644
> --- a/Documentation/ABI/obsolete/sysfs-class-dax
> +++ b/Documentation/ABI/obsolete/sysfs-class-dax
> @@ -8,11 +8,11 @@ Description:	Device DAX is the device-centric analogue =
of Filesystem
>  		system.  Device DAX is strict, precise and predictable.
>  		Specifically this interface:
> =20
> -		1/ Guarantees fault granularity with respect to a given
> -		page size (pte, pmd, or pud) set at configuration time.
> +		1. Guarantees fault granularity with respect to a given
> +		   page size (pte, pmd, or pud) set at configuration time.
> =20
> -		2/ Enforces deterministic behavior by being strict about
> -		what fault scenarios are supported.
> +		2. Enforces deterministic behavior by being strict about
> +		   what fault scenarios are supported.
> =20
>  		The /sys/class/dax/ interface enumerates all the
>  		device-dax instances in the system. The ABI is
> diff --git a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra b/Do=
cumentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
> index 5d41ebadf15e..66545c587a64 100644
> --- a/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
> +++ b/Documentation/ABI/obsolete/sysfs-driver-hid-roccat-pyra
> @@ -7,10 +7,13 @@ Description:	It is possible to switch the cpi setting o=
f the mouse with the
>  		setting reported by the mouse. This number has to be further
>  		processed to receive the real dpi value:
> =20
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D
>  		VALUE DPI
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D
>  		1     400
>  		2     800
>  		4     1600
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D
> =20
>  		This file is readonly.
>  		Has never been used. If bookkeeping is done, it's done in userland too=
ls.
> diff --git a/Documentation/ABI/removed/devfs b/Documentation/ABI/removed/=
devfs
> index 0020c49933c4..24fb35adf277 100644
> --- a/Documentation/ABI/removed/devfs
> +++ b/Documentation/ABI/removed/devfs
> @@ -5,6 +5,7 @@ Description:
>  	devfs has been unmaintained for a number of years, has unfixable
>  	races, contains a naming policy within the kernel that is
>  	against the LSB, and can be replaced by using udev.
> +
>  	The files fs/devfs/*, include/linux/devfs_fs*.h were removed,
>  	along with the assorted devfs function calls throughout the
>  	kernel tree.
> diff --git a/Documentation/ABI/removed/raw1394 b/Documentation/ABI/remove=
d/raw1394
> index ec333e676322..9ec7ec493920 100644
> --- a/Documentation/ABI/removed/raw1394
> +++ b/Documentation/ABI/removed/raw1394
> @@ -7,6 +7,7 @@ Description:
>  	to implement sensible device security policies, and its low level
>  	of abstraction that required userspace clients to duplicate much
>  	of the kernel's ieee1394 core functionality.
> +
>  	Replaced by /dev/fw*, i.e. the <linux/firewire-cdev.h> ABI of
>  	firewire-core.
> =20
> diff --git a/Documentation/ABI/removed/sysfs-class-rfkill b/Documentation=
/ABI/removed/sysfs-class-rfkill
> index 9c08c7f98ffb..f25174eafd55 100644
> --- a/Documentation/ABI/removed/sysfs-class-rfkill
> +++ b/Documentation/ABI/removed/sysfs-class-rfkill
> @@ -10,4 +10,4 @@ Description:	This file was deprecated because there no =
longer was a way to
>  		claim just control over a single rfkill instance.
>  		This file was scheduled to be removed in 2012, and was removed
>  		in 2016.
> -Values: 	0: Kernel handles events
> +Values:		0: Kernel handles events
> diff --git a/Documentation/ABI/removed/video1394 b/Documentation/ABI/remo=
ved/video1394
> index c39c25aee77b..1905d35a6619 100644
> --- a/Documentation/ABI/removed/video1394
> +++ b/Documentation/ABI/removed/video1394
> @@ -8,6 +8,7 @@ Description:
>  	performance issues in its first generation.  Any video1394 user had
>  	to use raw1394 + libraw1394 too because video1394 did not provide
>  	asynchronous I/O for device discovery and configuration.
> +
>  	Replaced by /dev/fw*, i.e. the <linux/firewire-cdev.h> ABI of
>  	firewire-core.
> =20
> diff --git a/Documentation/ABI/stable/firewire-cdev b/Documentation/ABI/s=
table/firewire-cdev
> index c9e8ff026154..261f85b13154 100644
> --- a/Documentation/ABI/stable/firewire-cdev
> +++ b/Documentation/ABI/stable/firewire-cdev
> @@ -16,6 +16,7 @@ Description:
>  		different scope:
> =20
>  		  - The 1394 node which is associated with the file:
> +
>  			  - Asynchronous request transmission
>  			  - Get the Configuration ROM
>  			  - Query node ID
> @@ -23,6 +24,7 @@ Description:
>  			    and local node
> =20
>  		  - The 1394 bus (i.e. "card") to which the node is attached to:
> +
>  			  - Isochronous stream transmission and reception
>  			  - Asynchronous stream transmission and reception
>  			  - Asynchronous broadcast request transmission
> @@ -35,6 +37,7 @@ Description:
>  			  - Bus reset initiation, bus reset event reception
> =20
>  		  - All 1394 buses:
> +
>  			  - Allocation of IEEE 1212 address ranges on the local
>  			    link layers, reception of inbound requests to such
>  			    an address range, asynchronous response transmission
> @@ -59,50 +62,50 @@ Description:
>  		The following file operations are supported:
> =20
>  		open(2)
> -		Currently the only useful flags are O_RDWR.
> +		    Currently the only useful flags are O_RDWR.
> =20
>  		ioctl(2)
> -		Initiate various actions.  Some take immediate effect, others
> -		are performed asynchronously while or after the ioctl returns.
> -		See the inline documentation in <linux/firewire-cdev.h> for
> -		descriptions of all ioctls.
> +		    Initiate various actions.  Some take immediate effect, others
> +		    are performed asynchronously while or after the ioctl returns.
> +		    See the inline documentation in <linux/firewire-cdev.h> for
> +		    descriptions of all ioctls.
> =20
>  		poll(2), select(2), epoll_wait(2) etc.
> -		Watch for events to become available to be read.
> +		    Watch for events to become available to be read.
> =20
>  		read(2)
> -		Receive various events.  There are solicited events like
> -		outbound asynchronous transaction completion or isochronous
> -		buffer completion, and unsolicited events such as bus resets,
> -		request reception, or PHY packet reception.  Always use a read
> -		buffer which is large enough to receive the largest event that
> -		could ever arrive.  See <linux/firewire-cdev.h> for descriptions
> -		of all event types and for which ioctls affect reception of
> -		events.
> +		    Receive various events.  There are solicited events like
> +		    outbound asynchronous transaction completion or isochronous
> +		    buffer completion, and unsolicited events such as bus resets,
> +		    request reception, or PHY packet reception.  Always use a read
> +		    buffer which is large enough to receive the largest event that
> +		    could ever arrive.  See <linux/firewire-cdev.h> for descriptions
> +		    of all event types and for which ioctls affect reception of
> +		    events.
> =20
>  		mmap(2)
> -		Allocate a DMA buffer for isochronous reception or transmission
> -		and map it into the process address space.  The arguments should
> -		be used as follows:  addr =3D NULL, length =3D the desired buffer
> -		size, i.e. number of packets times size of largest packet,
> -		prot =3D at least PROT_READ for reception and at least PROT_WRITE
> -		for transmission, flags =3D MAP_SHARED, fd =3D the handle to the
> -		/dev/fw*, offset =3D 0.
> +		    Allocate a DMA buffer for isochronous reception or transmission
> +		    and map it into the process address space.  The arguments should
> +		    be used as follows:  addr =3D NULL, length =3D the desired buffer
> +		    size, i.e. number of packets times size of largest packet,
> +		    prot =3D at least PROT_READ for reception and at least PROT_WRITE
> +		    for transmission, flags =3D MAP_SHARED, fd =3D the handle to the
> +		    /dev/fw*, offset =3D 0.
> =20
>  		Isochronous reception works in packet-per-buffer fashion except
>  		for multichannel reception which works in buffer-fill mode.
> =20
>  		munmap(2)
> -		Unmap the isochronous I/O buffer from the process address space.
> +		    Unmap the isochronous I/O buffer from the process address space.
> =20
>  		close(2)
> -		Besides stopping and freeing I/O contexts that were associated
> -		with the file descriptor, back out any changes to the local
> -		nodes' Configuration ROM.  Deallocate isochronous channels and
> -		bandwidth at the IRM that were marked for kernel-assisted
> -		re- and deallocation.
> +		    Besides stopping and freeing I/O contexts that were associated
> +		    with the file descriptor, back out any changes to the local
> +		    nodes' Configuration ROM.  Deallocate isochronous channels and
> +		    bandwidth at the IRM that were marked for kernel-assisted
> +		    re- and deallocation.
> =20
> -Users:		libraw1394
> -		libdc1394
> -		libhinawa
> +Users:		libraw1394;
> +		libdc1394;
> +		libhinawa;
>  		tools like linux-firewire-utils, fwhack, ...
> diff --git a/Documentation/ABI/stable/sysfs-acpi-pmprofile b/Documentatio=
n/ABI/stable/sysfs-acpi-pmprofile
> index fd97d22b677f..2d6314f0e4e4 100644
> --- a/Documentation/ABI/stable/sysfs-acpi-pmprofile
> +++ b/Documentation/ABI/stable/sysfs-acpi-pmprofile
> @@ -1,8 +1,8 @@
> -What: 		/sys/firmware/acpi/pm_profile
> +What:		/sys/firmware/acpi/pm_profile
>  Date:		03-Nov-2011
>  KernelVersion:	v3.2
>  Contact:	linux-acpi@vger.kernel.org
> -Description: 	The ACPI pm_profile sysfs interface exports the platform
> +Description:	The ACPI pm_profile sysfs interface exports the platform
>  		power management (and performance) requirement expectations
>  		as provided by BIOS. The integer value is directly passed as
>  		retrieved from the FADT ACPI table.
> diff --git a/Documentation/ABI/stable/sysfs-bus-w1 b/Documentation/ABI/st=
able/sysfs-bus-w1
> index 992dfb183ed0..5cd5e872bcae 100644
> --- a/Documentation/ABI/stable/sysfs-bus-w1
> +++ b/Documentation/ABI/stable/sysfs-bus-w1
> @@ -6,6 +6,7 @@ Description:	Bus scanning interval, microseconds componen=
t.
>  		control systems are attached/generate presence for as short as
>  		100 ms - hence the tens-to-hundreds milliseconds scan intervals
>  		are required.
> +
>  		see Documentation/w1/w1-generic.rst for detailed information.
>  Users:		any user space application which wants to know bus scanning
>  		interval
> diff --git a/Documentation/ABI/stable/sysfs-class-tpm b/Documentation/ABI=
/stable/sysfs-class-tpm
> index ec464cf7861a..91ca63ec7581 100644
> --- a/Documentation/ABI/stable/sysfs-class-tpm
> +++ b/Documentation/ABI/stable/sysfs-class-tpm
> @@ -191,6 +191,6 @@ Contact:	linux-integrity@vger.kernel.org
>  Description:	The "tpm_version_major" property shows the TCG spec major v=
ersion
>  		implemented by the TPM device.
> =20
> -		Example output:
> +		Example output::
> =20
> -		2
> +		  2
> diff --git a/Documentation/ABI/stable/sysfs-driver-speakup b/Documentatio=
n/ABI/stable/sysfs-driver-speakup
> index c6a32c434ce9..792f58ba327d 100644
> --- a/Documentation/ABI/stable/sysfs-driver-speakup
> +++ b/Documentation/ABI/stable/sysfs-driver-speakup
> @@ -69,6 +69,7 @@ Description:	Controls if typing interrupts output from =
speakup. With
>  		speakup if for example
>  		the say screen command is used before the
>  		entire screen  is read.
> +
>  		With no_interrupt set to one, if the say
>  		screen command is used, and one then types on the keyboard,
>  		speakup will continue to say the whole screen regardless until
> @@ -215,8 +216,10 @@ Description:	This file contains names for key states.
>  		Again, these are part of the help system.  For instance, if you
>  		had pressed speakup + keypad 3, you would hear:
>  		"speakup keypad 3 is go to bottom edge."
> +
>  		The speakup key is depressed, so the name of the key state is
>  		speakup.
> +
>  		This part of the message comes from the states collection.
> =20
>  What:		/sys/accessibility/speakup/i18n/characters
> @@ -297,6 +300,7 @@ KernelVersion:	2.6
>  Contact:	speakup@linux-speakup.org
>  Description:	Controls if punctuation is spoken by speakup, or by the
>  		synthesizer.
> +
>  		For example, speakup speaks ">" as "greater", while
>  		the espeak synthesizer used by the soft driver speaks "greater
>  		than". Zero lets speakup speak the punctuation. One lets the
> diff --git a/Documentation/ABI/testing/configfs-most b/Documentation/ABI/=
testing/configfs-most
> index ed67a4d9f6d6..bc6b8bd18da4 100644
> --- a/Documentation/ABI/testing/configfs-most
> +++ b/Documentation/ABI/testing/configfs-most
> @@ -15,22 +15,28 @@ KernelVersion:  5.2
>  Description:
>  		The attributes:
> =20
> -		buffer_size	configure the buffer size for this channel
> +		buffer_size
> +				configure the buffer size for this channel
> =20
> -		subbuffer_size	configure the sub-buffer size for this channel
> +		subbuffer_size
> +				configure the sub-buffer size for this channel
>  				(needed for synchronous and isochrnous data)
> =20
> =20
> -		num_buffers	configure number of buffers used for this
> +		num_buffers
> +				configure number of buffers used for this
>  				channel
> =20
> -		datatype	configure type of data that will travel over
> +		datatype
> +				configure type of data that will travel over
>  				this channel
> =20
> -		direction	configure whether this link will be an input
> +		direction
> +				configure whether this link will be an input
>  				or output
> =20
> -		dbr_size	configure DBR data buffer size (this is used
> +		dbr_size
> +				configure DBR data buffer size (this is used
>  				for MediaLB communication only)
> =20
>  		packets_per_xact
> @@ -39,18 +45,23 @@ Description:
>  				transmitted via USB (this is used for USB
>  				communication only)
> =20
> -		device		name of the device the link is to be attached to
> +		device
> +				name of the device the link is to be attached to
> =20
> -		channel		name of the channel the link is to be attached to
> +		channel
> +				name of the channel the link is to be attached to
> =20
> -		comp_params	pass parameters needed by some components
> +		comp_params
> +				pass parameters needed by some components
> =20
> -		create_link	write '1' to this attribute to trigger the
> +		create_link
> +				write '1' to this attribute to trigger the
>  				creation of the link. In case of speculative
>  				configuration, the creation is post-poned until
>  				a physical device is being attached to the bus.
> =20
> -		destroy_link	write '1' to this attribute to destroy an
> +		destroy_link
> +				write '1' to this attribute to destroy an
>  				active link
> =20
>  What: 		/sys/kernel/config/most_video/<link>
> @@ -59,22 +70,28 @@ KernelVersion:  5.2
>  Description:
>  		The attributes:
> =20
> -		buffer_size	configure the buffer size for this channel
> +		buffer_size
> +				configure the buffer size for this channel
> =20
> -		subbuffer_size	configure the sub-buffer size for this channel
> +		subbuffer_size
> +				configure the sub-buffer size for this channel
>  				(needed for synchronous and isochrnous data)
> =20
> =20
> -		num_buffers	configure number of buffers used for this
> +		num_buffers
> +				configure number of buffers used for this
>  				channel
> =20
> -		datatype	configure type of data that will travel over
> +		datatype
> +				configure type of data that will travel over
>  				this channel
> =20
> -		direction	configure whether this link will be an input
> +		direction
> +				configure whether this link will be an input
>  				or output
> =20
> -		dbr_size	configure DBR data buffer size (this is used
> +		dbr_size
> +				configure DBR data buffer size (this is used
>  				for MediaLB communication only)
> =20
>  		packets_per_xact
> @@ -83,18 +100,23 @@ Description:
>  				transmitted via USB (this is used for USB
>  				communication only)
> =20
> -		device		name of the device the link is to be attached to
> +		device
> +				name of the device the link is to be attached to
> =20
> -		channel		name of the channel the link is to be attached to
> +		channel
> +				name of the channel the link is to be attached to
> =20
> -		comp_params	pass parameters needed by some components
> +		comp_params
> +				pass parameters needed by some components
> =20
> -		create_link	write '1' to this attribute to trigger the
> +		create_link
> +				write '1' to this attribute to trigger the
>  				creation of the link. In case of speculative
>  				configuration, the creation is post-poned until
>  				a physical device is being attached to the bus.
> =20
> -		destroy_link	write '1' to this attribute to destroy an
> +		destroy_link
> +				write '1' to this attribute to destroy an
>  				active link
> =20
>  What: 		/sys/kernel/config/most_net/<link>
> @@ -103,22 +125,28 @@ KernelVersion:  5.2
>  Description:
>  		The attributes:
> =20
> -		buffer_size	configure the buffer size for this channel
> +		buffer_size
> +				configure the buffer size for this channel
> =20
> -		subbuffer_size	configure the sub-buffer size for this channel
> +		subbuffer_size
> +				configure the sub-buffer size for this channel
>  				(needed for synchronous and isochrnous data)
> =20
> =20
> -		num_buffers	configure number of buffers used for this
> +		num_buffers
> +				configure number of buffers used for this
>  				channel
> =20
> -		datatype	configure type of data that will travel over
> +		datatype
> +				configure type of data that will travel over
>  				this channel
> =20
> -		direction	configure whether this link will be an input
> +		direction
> +				configure whether this link will be an input
>  				or output
> =20
> -		dbr_size	configure DBR data buffer size (this is used
> +		dbr_size
> +				configure DBR data buffer size (this is used
>  				for MediaLB communication only)
> =20
>  		packets_per_xact
> @@ -127,18 +155,23 @@ Description:
>  				transmitted via USB (this is used for USB
>  				communication only)
> =20
> -		device		name of the device the link is to be attached to
> +		device
> +				name of the device the link is to be attached to
> =20
> -		channel		name of the channel the link is to be attached to
> +		channel
> +				name of the channel the link is to be attached to
> =20
> -		comp_params	pass parameters needed by some components
> +		comp_params
> +				pass parameters needed by some components
> =20
> -		create_link	write '1' to this attribute to trigger the
> +		create_link
> +				write '1' to this attribute to trigger the
>  				creation of the link. In case of speculative
>  				configuration, the creation is post-poned until
>  				a physical device is being attached to the bus.
> =20
> -		destroy_link	write '1' to this attribute to destroy an
> +		destroy_link
> +				write '1' to this attribute to destroy an
>  				active link
> =20
>  What: 		/sys/kernel/config/most_sound/<card>
> @@ -147,7 +180,8 @@ KernelVersion:  5.2
>  Description:
>  		The attributes:
> =20
> -		create_card	write '1' to this attribute to trigger the
> +		create_card
> +				write '1' to this attribute to trigger the
>                                  registration of the sound card with the =
ALSA
>  				subsystem.
> =20
> @@ -157,22 +191,28 @@ KernelVersion:  5.2
>  Description:
>  		The attributes:
> =20
> -		buffer_size	configure the buffer size for this channel
> +		buffer_size
> +				configure the buffer size for this channel
> =20
> -		subbuffer_size	configure the sub-buffer size for this channel
> +		subbuffer_size
> +				configure the sub-buffer size for this channel
>  				(needed for synchronous and isochrnous data)
> =20
> =20
> -		num_buffers	configure number of buffers used for this
> +		num_buffers
> +				configure number of buffers used for this
>  				channel
> =20
> -		datatype	configure type of data that will travel over
> +		datatype
> +				configure type of data that will travel over
>  				this channel
> =20
> -		direction	configure whether this link will be an input
> +		direction
> +				configure whether this link will be an input
>  				or output
> =20
> -		dbr_size	configure DBR data buffer size (this is used
> +		dbr_size
> +				configure DBR data buffer size (this is used
>  				for MediaLB communication only)
> =20
>  		packets_per_xact
> @@ -181,16 +221,21 @@ Description:
>  				transmitted via USB (this is used for USB
>  				communication only)
> =20
> -		device		name of the device the link is to be attached to
> +		device
> +				name of the device the link is to be attached to
> =20
> -		channel		name of the channel the link is to be attached to
> +		channel
> +				name of the channel the link is to be attached to
> =20
> -		comp_params	pass parameters needed by some components
> +		comp_params
> +				pass parameters needed by some components
> =20
> -		create_link	write '1' to this attribute to trigger the
> +		create_link
> +				write '1' to this attribute to trigger the
>  				creation of the link. In case of speculative
>  				configuration, the creation is post-poned until
>  				a physical device is being attached to the bus.
> =20
> -		destroy_link	write '1' to this attribute to destroy an
> +		destroy_link
> +				write '1' to this attribute to destroy an
>  				active link
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-ecm b/Document=
ation/ABI/testing/configfs-usb-gadget-ecm
> index 0addf7704b4c..272bc1e4ce2e 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-ecm
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-ecm
> @@ -4,13 +4,17 @@ KernelVersion:	3.11
>  Description:
>  		The attributes:
> =20
> -		ifname		- network device interface name associated with
> +		ifname
> +			      - network device interface name associated with
>  				this function instance
> -		qmult		- queue length multiplier for high and
> +		qmult=09
> +			      - queue length multiplier for high and
>  				super speed
> -		host_addr	- MAC address of host's end of this
> +		host_addr
> +			      - MAC address of host's end of this
>  				Ethernet over USB link
> -		dev_addr	- MAC address of device's end of this
> +		dev_addr
> +			      - MAC address of device's end of this
>  				Ethernet over USB link
> =20
> =20
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-eem b/Document=
ation/ABI/testing/configfs-usb-gadget-eem
> index a4c57158fcde..178c3d5fb647 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-eem
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-eem
> @@ -4,11 +4,13 @@ KernelVersion:	3.11
>  Description:
>  		The attributes:
> =20
> -		ifname		- network device interface name associated with
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		ifname		network device interface name associated with
>  				this function instance
> -		qmult		- queue length multiplier for high and
> +		qmult		queue length multiplier for high and
>  				super speed
> -		host_addr	- MAC address of host's end of this
> +		host_addr	MAC address of host's end of this
>  				Ethernet over USB link
> -		dev_addr	- MAC address of device's end of this
> +		dev_addr	MAC address of device's end of this
>  				Ethernet over USB link
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-loopback b/Doc=
umentation/ABI/testing/configfs-usb-gadget-loopback
> index 06beefbcf061..e6c6ba5ac7ff 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-loopback
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-loopback
> @@ -4,5 +4,7 @@ KernelVersion:	3.13
>  Description:
>  		The attributes:
> =20
> -		qlen		- depth of loopback queue
> -		buflen		- buffer length
> +		=3D=3D=3D=3D=3D=3D=3D		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		qlen		depth of loopback queue
> +		buflen		buffer length
> +		=3D=3D=3D=3D=3D=3D=3D		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage b=
/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> index 9931fb0d63ba..c86b63a7bb43 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-mass-storage
> @@ -4,12 +4,14 @@ KernelVersion:	3.13
>  Description:
>  		The attributes:
> =20
> -		stall		- Set to permit function to halt bulk endpoints.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		stall		Set to permit function to halt bulk endpoints.
>  				Disabled on some USB devices known not to work
>  				correctly. You should set it to true.
> -		num_buffers	- Number of pipeline buffers. Valid numbers
> +		num_buffers	Number of pipeline buffers. Valid numbers
>  				are 2..4. Available only if
>  				CONFIG_USB_GADGET_DEBUG_FILES is set.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/config/usb-gadget/gadget/functions/mass_storage.name/lun.name
>  Date:		Oct 2013
> @@ -17,15 +19,17 @@ KernelVersion:	3.13
>  Description:
>  		The attributes:
> =20
> -		file		- The path to the backing file for the LUN.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		file		The path to the backing file for the LUN.
>  				Required if LUN is not marked as removable.
> -		ro		- Flag specifying access to the LUN shall be
> +		ro		Flag specifying access to the LUN shall be
>  				read-only. This is implied if CD-ROM emulation
>  				is enabled as well as when it was impossible
>  				to open "filename" in R/W mode.
> -		removable	- Flag specifying that LUN shall be indicated as
> +		removable	Flag specifying that LUN shall be indicated as
>  				being removable.
> -		cdrom		- Flag specifying that LUN shall be reported as
> +		cdrom		Flag specifying that LUN shall be reported as
>  				being a CD-ROM.
> -		nofua		- Flag specifying that FUA flag
> +		nofua		Flag specifying that FUA flag
>  				in SCSI WRITE(10,12)
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-midi b/Documen=
tation/ABI/testing/configfs-usb-gadget-midi
> index 6b341df7249c..07389cddd51a 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-midi
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-midi
> @@ -4,9 +4,11 @@ KernelVersion:	3.19
>  Description:
>  		The attributes:
> =20
> -		index		- index value for the USB MIDI adapter
> -		id		- ID string for the USB MIDI adapter
> -		buflen		- MIDI buffer length
> -		qlen		- USB read request queue length
> -		in_ports	- number of MIDI input ports
> -		out_ports	- number of MIDI output ports
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		index		index value for the USB MIDI adapter
> +		id		ID string for the USB MIDI adapter
> +		buflen		MIDI buffer length
> +		qlen		USB read request queue length
> +		in_ports	number of MIDI input ports
> +		out_ports	number of MIDI output ports
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-printer b/Docu=
mentation/ABI/testing/configfs-usb-gadget-printer
> index 6b0714e3c605..7aa731bac2da 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-printer
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-printer
> @@ -4,6 +4,8 @@ KernelVersion:	4.1
>  Description:
>  		The attributes:
> =20
> -		pnp_string	- Data to be passed to the host in pnp string
> -		q_len		- Number of requests per endpoint
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		pnp_string	Data to be passed to the host in pnp string
> +		q_len		Number of requests per endpoint
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> =20
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink b/D=
ocumentation/ABI/testing/configfs-usb-gadget-sourcesink
> index f56335af2d88..1f3d31b607b7 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-sourcesink
> @@ -4,11 +4,13 @@ KernelVersion:	3.13
>  Description:
>  		The attributes:
> =20
> -		pattern		- 0 (all zeros), 1 (mod63), 2 (none)
> -		isoc_interval	- 1..16
> -		isoc_maxpacket	- 0 - 1023 (fs), 0 - 1024 (hs/ss)
> -		isoc_mult	- 0..2 (hs/ss only)
> -		isoc_maxburst	- 0..15 (ss only)
> -		buflen		- buffer length
> -		bulk_qlen	- depth of queue for bulk
> -		iso_qlen	- depth of queue for iso
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +		pattern		  0 (all zeros), 1 (mod63), 2 (none)
> +		isoc_interval	  1..16
> +		isoc_maxpacket	  0 - 1023 (fs), 0 - 1024 (hs/ss)
> +		isoc_mult	  0..2 (hs/ss only)
> +		isoc_maxburst	  0..15 (ss only)
> +		buflen		  buffer length
> +		bulk_qlen	  depth of queue for bulk
> +		iso_qlen	  depth of queue for iso
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D    =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-subset b/Docum=
entation/ABI/testing/configfs-usb-gadget-subset
> index 9373e2c51ea4..0061b864351f 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-subset
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-subset
> @@ -4,11 +4,13 @@ KernelVersion:	3.11
>  Description:
>  		The attributes:
> =20
> -		ifname		- network device interface name associated with
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		ifname		network device interface name associated with
>  				this function instance
> -		qmult		- queue length multiplier for high and
> +		qmult		queue length multiplier for high and
>  				super speed
> -		host_addr	- MAC address of host's end of this
> +		host_addr	MAC address of host's end of this
>  				Ethernet over USB link
> -		dev_addr	- MAC address of device's end of this
> +		dev_addr	MAC address of device's end of this
>  				Ethernet over USB link
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uac2 b/Documen=
tation/ABI/testing/configfs-usb-gadget-uac2
> index 2bfdd4efa9bd..d4356c8b8cd6 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-uac2
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-uac2
> @@ -4,9 +4,11 @@ KernelVersion:	3.18
>  Description:
>  		The attributes:
> =20
> -		c_chmask - capture channel mask
> -		c_srate - capture sampling rate
> -		c_ssize - capture sample size (bytes)
> -		p_chmask - playback channel mask
> -		p_srate - playback sampling rate
> -		p_ssize - playback sample size (bytes)
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		c_chmask   capture channel mask
> +		c_srate    capture sampling rate
> +		c_ssize    capture sample size (bytes)
> +		p_chmask   playback channel mask
> +		p_srate    playback sampling rate
> +		p_ssize    playback sample size (bytes)
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/configfs-usb-gadget-uvc b/Document=
ation/ABI/testing/configfs-usb-gadget-uvc
> index cee81b0347bb..ac5e11af79a8 100644
> --- a/Documentation/ABI/testing/configfs-usb-gadget-uvc
> +++ b/Documentation/ABI/testing/configfs-usb-gadget-uvc
> @@ -55,7 +55,7 @@ Description:	Default output terminal descriptors
> =20
>  		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  		iTerminal	index of string descriptor
> -		bSourceID 	id of the terminal to which this terminal
> +		bSourceID	id of the terminal to which this terminal
>  				is connected
>  		bAssocTerminal	id of the input terminal to which this output
>  				terminal is associated
> diff --git a/Documentation/ABI/testing/debugfs-cec-error-inj b/Documentat=
ion/ABI/testing/debugfs-cec-error-inj
> index 5afcd78fbdb7..8debcb08a3b5 100644
> --- a/Documentation/ABI/testing/debugfs-cec-error-inj
> +++ b/Documentation/ABI/testing/debugfs-cec-error-inj
> @@ -23,7 +23,7 @@ error injections without having to know the details of =
the driver-specific
>  commands.
> =20
>  Note that the output of 'error-inj' shall be valid as input to 'error-in=
j'.
> -So this must work:
> +So this must work::
> =20
>  	$ cat error-inj >einj.txt
>  	$ cat einj.txt >error-inj
> diff --git a/Documentation/ABI/testing/debugfs-driver-habanalabs b/Docume=
ntation/ABI/testing/debugfs-driver-habanalabs
> index 2e9ae311e02d..c5d678d39144 100644
> --- a/Documentation/ABI/testing/debugfs-driver-habanalabs
> +++ b/Documentation/ABI/testing/debugfs-driver-habanalabs
> @@ -20,9 +20,13 @@ Description:    Allow the root user to disable/enable =
in runtime the clock
>                  The user can supply a bitmask value, each bit represents
>                  a different engine to disable/enable its clock gating fe=
ature.
>                  The bitmask is composed of 20 bits:
> -                0  -  7 : DMA channels
> -                8  - 11 : MME engines
> -                12 - 19 : TPC engines
> +
> +		=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +                0  -  7   DMA channels
> +                8  - 11   MME engines
> +                12 - 19   TPC engines
> +		=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                  The bit's location of a specific engine can be determined
>                  using (1 << GAUDI_ENGINE_ID_*). GAUDI_ENGINE_ID_* values
>                  are defined in uapi habanalabs.h file in enum gaudi_engi=
ne_id
> @@ -59,6 +63,7 @@ Description:    Allows the root user to read or write d=
irectly through the
>                  the generic Linux user-space PCI mapping) because the DD=
R bar
>                  is very small compared to the DDR memory and only the dr=
iver can
>                  move the bar before and after the transaction.
> +
>                  If the IOMMU is disabled, it also allows the root user t=
o read
>                  or write from the host a device VA of a host mapped memo=
ry
> =20
> @@ -73,6 +78,7 @@ Description:    Allows the root user to read or write 6=
4 bit data directly
>                  the generic Linux user-space PCI mapping) because the DD=
R bar
>                  is very small compared to the DDR memory and only the dr=
iver can
>                  move the bar before and after the transaction.
> +
>                  If the IOMMU is disabled, it also allows the root user t=
o read
>                  or write from the host a device VA of a host mapped memo=
ry
> =20
> diff --git a/Documentation/ABI/testing/debugfs-pfo-nx-crypto b/Documentat=
ion/ABI/testing/debugfs-pfo-nx-crypto
> index 685d5a448423..f75a655c1531 100644
> --- a/Documentation/ABI/testing/debugfs-pfo-nx-crypto
> +++ b/Documentation/ABI/testing/debugfs-pfo-nx-crypto
> @@ -4,42 +4,42 @@ KernelVersion:	3.4
>  Contact:	Kent Yoder <key@linux.vnet.ibm.com>
>  Description:
> =20
> -  These debugfs interfaces are built by the nx-crypto driver, built in
> +These debugfs interfaces are built by the nx-crypto driver, built in
>  arch/powerpc/crypto/nx.
> =20
>  Error Detection
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  errors:
> -- A u32 providing a total count of errors since the driver was loaded. T=
he
> -only errors counted here are those returned from the hcall, H_COP_OP.
> +  A u32 providing a total count of errors since the driver was loaded. T=
he
> +  only errors counted here are those returned from the hcall, H_COP_OP.
> =20
>  last_error:
> -- The most recent non-zero return code from the H_COP_OP hcall. -EBUSY i=
s not
> -recorded here (the hcall will retry until -EBUSY goes away).
> +  The most recent non-zero return code from the H_COP_OP hcall. -EBUSY i=
s not
> +  recorded here (the hcall will retry until -EBUSY goes away).
> =20
>  last_error_pid:
> -- The process ID of the process who received the most recent error from =
the
> -hcall.
> +  The process ID of the process who received the most recent error from =
the
> +  hcall.
> =20
>  Device Use
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  aes_bytes:
> -- The total number of bytes encrypted using AES in any of the driver's
> -supported modes.
> +  The total number of bytes encrypted using AES in any of the driver's
> +  supported modes.
> =20
>  aes_ops:
> -- The total number of AES operations submitted to the hardware.
> +  The total number of AES operations submitted to the hardware.
> =20
>  sha256_bytes:
> -- The total number of bytes hashed by the hardware using SHA-256.
> +  The total number of bytes hashed by the hardware using SHA-256.
> =20
>  sha256_ops:
> -- The total number of SHA-256 operations submitted to the hardware.
> +  The total number of SHA-256 operations submitted to the hardware.
> =20
>  sha512_bytes:
> -- The total number of bytes hashed by the hardware using SHA-512.
> +  The total number of bytes hashed by the hardware using SHA-512.
> =20
>  sha512_ops:
> -- The total number of SHA-512 operations submitted to the hardware.
> +  The total number of SHA-512 operations submitted to the hardware.
> diff --git a/Documentation/ABI/testing/debugfs-pktcdvd b/Documentation/AB=
I/testing/debugfs-pktcdvd
> index 787907d70462..f6f65a4faea0 100644
> --- a/Documentation/ABI/testing/debugfs-pktcdvd
> +++ b/Documentation/ABI/testing/debugfs-pktcdvd
> @@ -10,7 +10,7 @@ these files in debugfs:
>  /sys/kernel/debug/pktcdvd/pktcdvd[0-7]/
> =20
>      =3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> -    info            (0444) Lots of driver statistics and infos.
> +    info            0444   Lots of driver statistics and infos.
>      =3D=3D=3D=3D            =3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> =20
>  Example::
> diff --git a/Documentation/ABI/testing/debugfs-turris-mox-rwtm b/Document=
ation/ABI/testing/debugfs-turris-mox-rwtm
> index c8f7dadd591c..ad08f535af3b 100644
> --- a/Documentation/ABI/testing/debugfs-turris-mox-rwtm
> +++ b/Documentation/ABI/testing/debugfs-turris-mox-rwtm
> @@ -2,10 +2,12 @@ What:		/sys/kernel/debug/turris-mox-rwtm/do_sign
>  Date:		Jun 2020
>  KernelVersion:	5.8
>  Contact:	Marek Beh=C3=BAn <marek.behun@nic.cz>
> -Description:	(W)
> -		    Message to sign with the ECDSA private key stored in
> +Description:
> +
> +		=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		(W) Message to sign with the ECDSA private key stored in
>  		    device's OTP. The message must be exactly 64 bytes (since
>  		    this is intended for SHA-512 hashes).
> -		(R)
> -		    The resulting signature, 136 bytes. This contains the R and
> +		(R) The resulting signature, 136 bytes. This contains the R and
>  		    S values of the ECDSA signature, both in big-endian format.
> +		=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/debugfs-wilco-ec b/Documentation/A=
BI/testing/debugfs-wilco-ec
> index 9d8d9d2def5b..682e3c09ef4d 100644
> --- a/Documentation/ABI/testing/debugfs-wilco-ec
> +++ b/Documentation/ABI/testing/debugfs-wilco-ec
> @@ -27,16 +27,17 @@ Description:
>  		for writing, two for the type and at least a single byte of
>  		data.
> =20
> -		Example:
> -		// Request EC info type 3 (EC firmware build date)
> -		// Corresponds with sending type 0x00f0 with
> -		// MBOX =3D [38, 00, 03, 00]
> -		$ echo 00 f0 38 00 03 00 > /sys/kernel/debug/wilco_ec/raw
> -		// View the result. The decoded ASCII result "12/21/18" is
> -		// included after the raw hex.
> -		// Corresponds with MBOX =3D [00, 00, 31, 32, 2f, 32, 31, 38, ...]
> -		$ cat /sys/kernel/debug/wilco_ec/raw
> -		00 00 31 32 2f 32 31 2f 31 38 00 38 00 01 00 2f 00  ..12/21/18.8...
> +		Example::
> +
> +		    // Request EC info type 3 (EC firmware build date)
> +		    // Corresponds with sending type 0x00f0 with
> +		    // MBOX =3D [38, 00, 03, 00]
> +		    $ echo 00 f0 38 00 03 00 > /sys/kernel/debug/wilco_ec/raw
> +		    // View the result. The decoded ASCII result "12/21/18" is
> +		    // included after the raw hex.
> +		    // Corresponds with MBOX =3D [00, 00, 31, 32, 2f, 32, 31, 38, ...]
> +		    $ cat /sys/kernel/debug/wilco_ec/raw
> +		    00 00 31 32 2f 32 31 2f 31 38 00 38 00 01 00 2f 00  ..12/21/18.8...
> =20
>  		Note that the first 16 bytes of the received MBOX[] will be
>  		printed, even if some of the data is junk, and skipping bytes
> diff --git a/Documentation/ABI/testing/dell-smbios-wmi b/Documentation/AB=
I/testing/dell-smbios-wmi
> index fc919ce16008..5f3a0dc67050 100644
> --- a/Documentation/ABI/testing/dell-smbios-wmi
> +++ b/Documentation/ABI/testing/dell-smbios-wmi
> @@ -10,29 +10,29 @@ Description:
>  		<uapi/linux/wmi.h>
> =20
>  		1) To perform an SMBIOS call from userspace, you'll need to
> -		first determine the minimum size of the calling interface
> -		buffer for your machine.
> -		Platforms that contain larger buffers can return larger
> -		objects from the system firmware.
> -		Commonly this size is either 4k or 32k.
> +		   first determine the minimum size of the calling interface
> +		   buffer for your machine.
> +		   Platforms that contain larger buffers can return larger
> +		   objects from the system firmware.
> +		   Commonly this size is either 4k or 32k.
> =20
> -		To determine the size of the buffer read() a u64 dword from
> -		the WMI character device /dev/wmi/dell-smbios.
> +		   To determine the size of the buffer read() a u64 dword from
> +		   the WMI character device /dev/wmi/dell-smbios.
> =20
>  		2) After you've determined the minimum size of the calling
> -		interface buffer, you can allocate a structure that represents
> -		the structure documented above.
> +		   interface buffer, you can allocate a structure that represents
> +		   the structure documented above.
> =20
>  		3) In the 'length' object store the size of the buffer you
> -		determined above and allocated.
> +		   determined above and allocated.
> =20
>  		4) In this buffer object, prepare as necessary for the SMBIOS
> -		call you're interested in.  Typically SMBIOS buffers have
> -		"class", "select", and "input" defined to values that coincide
> -		with the data you are interested in.
> -		Documenting class/select/input values is outside of the scope
> -		of this documentation. Check with the libsmbios project for
> -		further documentation on these values.
> +		   call you're interested in.  Typically SMBIOS buffers have
> +		   "class", "select", and "input" defined to values that coincide
> +		   with the data you are interested in.
> +		   Documenting class/select/input values is outside of the scope
> +		   of this documentation. Check with the libsmbios project for
> +		   further documentation on these values.
> =20
>  		6) Run the call by using ioctl() as described in the header.
> =20
> diff --git a/Documentation/ABI/testing/gpio-cdev b/Documentation/ABI/test=
ing/gpio-cdev
> index 7b265fbb47e3..66bdcd188b6c 100644
> --- a/Documentation/ABI/testing/gpio-cdev
> +++ b/Documentation/ABI/testing/gpio-cdev
> @@ -12,15 +12,16 @@ Description:
>  		The following file operations are supported:
> =20
>  		open(2)
> -		Currently the only useful flags are O_RDWR.
> +		  Currently the only useful flags are O_RDWR.
> =20
>  		ioctl(2)
> -		Initiate various actions.
> -		See the inline documentation in [include/uapi]<linux/gpio.h>
> -		for descriptions of all ioctls.
> +		  Initiate various actions.
> +
> +		  See the inline documentation in [include/uapi]<linux/gpio.h>
> +		  for descriptions of all ioctls.
> =20
>  		close(2)
> -		Stops and free up the I/O contexts that was associated
> -		with the file descriptor.
> +		  Stops and free up the I/O contexts that was associated
> +		  with the file descriptor.
> =20
>  Users:		TBD
> diff --git a/Documentation/ABI/testing/procfs-diskstats b/Documentation/A=
BI/testing/procfs-diskstats
> index df5a3a8c1edf..e58d641443d3 100644
> --- a/Documentation/ABI/testing/procfs-diskstats
> +++ b/Documentation/ABI/testing/procfs-diskstats
> @@ -35,7 +35,9 @@ Description:
> =20
>  		Kernel 5.5+ appends two more fields for flush requests:
> =20
> -		19 - flush requests completed successfully
> -		20 - time spent flushing
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		19  flush requests completed successfully
> +		20  time spent flushing
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		For more details refer to Documentation/admin-guide/iostats.rst
> diff --git a/Documentation/ABI/testing/procfs-smaps_rollup b/Documentatio=
n/ABI/testing/procfs-smaps_rollup
> index 046978193368..a4e31c465194 100644
> --- a/Documentation/ABI/testing/procfs-smaps_rollup
> +++ b/Documentation/ABI/testing/procfs-smaps_rollup
> @@ -14,28 +14,28 @@ Description:
>  		For more details, see Documentation/filesystems/proc.rst
>  		and the procfs man page.
> =20
> -		Typical output looks like this:
> +		Typical output looks like this::
> =20
> -		00100000-ff709000 ---p 00000000 00:00 0		 [rollup]
> -		Size:               1192 kB
> -		KernelPageSize:        4 kB
> -		MMUPageSize:           4 kB
> -		Rss:		     884 kB
> -		Pss:		     385 kB
> -		Pss_Anon:	     301 kB
> -		Pss_File:	      80 kB
> -		Pss_Shmem:	       4 kB
> -		Shared_Clean:	     696 kB
> -		Shared_Dirty:	       0 kB
> -		Private_Clean:	     120 kB
> -		Private_Dirty:	      68 kB
> -		Referenced:	     884 kB
> -		Anonymous:	      68 kB
> -		LazyFree:	       0 kB
> -		AnonHugePages:	       0 kB
> -		ShmemPmdMapped:	       0 kB
> -		Shared_Hugetlb:	       0 kB
> -		Private_Hugetlb:       0 kB
> -		Swap:		       0 kB
> -		SwapPss:	       0 kB
> -		Locked:		     385 kB
> +			00100000-ff709000 ---p 00000000 00:00 0		 [rollup]
> +			Size:               1192 kB
> +			KernelPageSize:        4 kB
> +			MMUPageSize:           4 kB
> +			Rss:		     884 kB
> +			Pss:		     385 kB
> +			Pss_Anon:	     301 kB
> +			Pss_File:	      80 kB
> +			Pss_Shmem:	       4 kB
> +			Shared_Clean:	     696 kB
> +			Shared_Dirty:	       0 kB
> +			Private_Clean:	     120 kB
> +			Private_Dirty:	      68 kB
> +			Referenced:	     884 kB
> +			Anonymous:	      68 kB
> +			LazyFree:	       0 kB
> +			AnonHugePages:	       0 kB
> +			ShmemPmdMapped:	       0 kB
> +			Shared_Hugetlb:	       0 kB
> +			Private_Hugetlb:       0 kB
> +			Swap:		       0 kB
> +			SwapPss:	       0 kB
> +			Locked:		     385 kB
> diff --git a/Documentation/ABI/testing/pstore b/Documentation/ABI/testing=
/pstore
> index d45209abdb1b..5b02540781a2 100644
> --- a/Documentation/ABI/testing/pstore
> +++ b/Documentation/ABI/testing/pstore
> @@ -9,25 +9,25 @@ Description:	Generic interface to platform dependent pe=
rsistent storage.
>  		provide a generic interface to show records captured in
>  		the dying moments.  In the case of a panic the last part
>  		of the console log is captured, but other interesting
> -		data can also be saved.
> +		data can also be saved::
> =20
> -		# mount -t pstore -o kmsg_bytes=3D8000 - /sys/fs/pstore
> +		    # mount -t pstore -o kmsg_bytes=3D8000 - /sys/fs/pstore
> =20
> -		$ ls -l /sys/fs/pstore/
> -		total 0
> -		-r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-erst-1
> +		    $ ls -l /sys/fs/pstore/
> +		    total 0
> +		    -r--r--r-- 1 root root 7896 Nov 30 15:38 dmesg-erst-1
> =20
>  		Different users of this interface will result in different
>  		filename prefixes.  Currently two are defined:
> =20
> -		"dmesg"	- saved console log
> -		"mce"	- architecture dependent data from fatal h/w error
> +		- "dmesg" - saved console log
> +		- "mce"   - architecture dependent data from fatal h/w error
> =20
>  		Once the information in a file has been read, removing
>  		the file will signal to the underlying persistent storage
> -		device that it can reclaim the space for later re-use.
> +		device that it can reclaim the space for later re-use::
> =20
> -		$ rm /sys/fs/pstore/dmesg-erst-1
> +		    $ rm /sys/fs/pstore/dmesg-erst-1
> =20
>  		The expectation is that all files in /sys/fs/pstore/
>  		will be saved elsewhere and erased from persistent store
> @@ -44,4 +44,3 @@ Description:	Generic interface to platform dependent pe=
rsistent storage.
>  		backends are available, the preferred backend may be
>  		set by passing the pstore.backend=3D argument to the kernel at
>  		boot time.
> -
> diff --git a/Documentation/ABI/testing/sysfs-block-rnbd b/Documentation/A=
BI/testing/sysfs-block-rnbd
> index 8f070b47f361..14a6fe9422b3 100644
> --- a/Documentation/ABI/testing/sysfs-block-rnbd
> +++ b/Documentation/ABI/testing/sysfs-block-rnbd
> @@ -9,9 +9,9 @@ Description:	To unmap a volume, "normal" or "force" has t=
o be written to:
>  		is using the device.  When "force" is used, the device is also unmapped
>  		when device is in use.  All I/Os that are in progress will fail.
> =20
> -		Example:
> +		Example::
> =20
> -		# echo "normal" > /sys/block/rnbd0/rnbd/unmap_device
> +		  # echo "normal" > /sys/block/rnbd0/rnbd/unmap_device
> =20
>  What:		/sys/block/rnbd<N>/rnbd/state
>  Date:		Feb 2020
> diff --git a/Documentation/ABI/testing/sysfs-bus-acpi b/Documentation/ABI=
/testing/sysfs-bus-acpi
> index c78603497b97..58abacf59b2a 100644
> --- a/Documentation/ABI/testing/sysfs-bus-acpi
> +++ b/Documentation/ABI/testing/sysfs-bus-acpi
> @@ -5,6 +5,7 @@ Description:
>  		This attribute indicates the full path of ACPI namespace
>  		object associated with the device object.  For example,
>  		\_SB_.PCI0.
> +
>  		This file is not present for device objects representing
>  		fixed ACPI hardware features (like power and sleep
>  		buttons).
> diff --git a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10 =
b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
> index b5f526081711..3e92cbd3fd83 100644
> --- a/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
> +++ b/Documentation/ABI/testing/sysfs-bus-coresight-devices-etb10
> @@ -4,7 +4,10 @@ KernelVersion:	3.19
>  Contact:	Mathieu Poirier <mathieu.poirier@linaro.org>
>  Description:	(RW) Add/remove a sink from a trace path.  There can be mul=
tiple
>  		source for a single sink.
> -		ex: echo 1 > /sys/bus/coresight/devices/20010000.etb/enable_sink
> +
> +		ex::
> +
> +		  echo 1 > /sys/bus/coresight/devices/20010000.etb/enable_sink
> =20
>  What:		/sys/bus/coresight/devices/<memory_map>.etb/trigger_cntr
>  Date:		November 2014
> diff --git a/Documentation/ABI/testing/sysfs-bus-css b/Documentation/ABI/=
testing/sysfs-bus-css
> index 966f8504bd7b..12a733fe357f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-css
> +++ b/Documentation/ABI/testing/sysfs-bus-css
> @@ -20,6 +20,7 @@ Contact:	Cornelia Huck <cornelia.huck@de.ibm.com>
>  Description:	Contains the ids of the channel paths used by this
>  		subchannel, as reported by the channel subsystem
>  		during subchannel recognition.
> +
>  		Note: This is an I/O-subchannel specific attribute.
>  Users:		s390-tools, HAL
> =20
> @@ -31,6 +32,7 @@ Description:	Contains the PIM/PAM/POM values, as report=
ed by the
>  		channel subsystem when last queried by the common I/O
>  		layer (this implies that this attribute is not necessarily
>  		in sync with the values current in the channel subsystem).
> +
>  		Note: This is an I/O-subchannel specific attribute.
>  Users:		s390-tools, HAL
> =20
> @@ -53,6 +55,7 @@ Description:	This file allows the driver for a device t=
o be specified. When
>  		opt-out of driver binding using a driver_override name such as
>  		"none".  Only a single driver may be specified in the override,
>  		there is no support for parsing delimiters.
> +
>  		Note that unlike the mechanism of the same name for pci, this
>  		file does not allow to override basic matching rules. I.e.,
>  		the driver must still match the subchannel type of the device.
> diff --git a/Documentation/ABI/testing/sysfs-bus-dfl b/Documentation/ABI/=
testing/sysfs-bus-dfl
> index 23543be904f2..b0265ab17200 100644
> --- a/Documentation/ABI/testing/sysfs-bus-dfl
> +++ b/Documentation/ABI/testing/sysfs-bus-dfl
> @@ -4,6 +4,7 @@ KernelVersion:	5.10
>  Contact:	Xu Yilun <yilun.xu@intel.com>
>  Description:	Read-only. It returns type of DFL FIU of the device. Now DFL
>  		supports 2 FIU types, 0 for FME, 1 for PORT.
> +
>  		Format: 0x%x
> =20
>  What:		/sys/bus/dfl/devices/dfl_dev.X/feature_id
> @@ -12,4 +13,5 @@ KernelVersion:	5.10
>  Contact:	Xu Yilun <yilun.xu@intel.com>
>  Description:	Read-only. It returns feature identifier local to its DFL F=
IU
>  		type.
> +
>  		Format: 0x%x
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_=
24x7 b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> index 2273627df190..de390a010af8 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7
> @@ -7,7 +7,7 @@ Description:    Read-only. Attribute group to describe th=
e magic bits
> =20
>                  Each attribute under this group defines a bit range of t=
he
>                  perf_event_attr.config. All supported attributes are lis=
ted
> -                below.
> +                below::
> =20
>  				chip =3D "config:16-31"
>  				core  =3D "config:16-31"
> @@ -16,9 +16,9 @@ Description:    Read-only. Attribute group to describe =
the magic bits
>  				offset =3D "config:32-63"
>  				vcpu =3D "config:16-31"
> =20
> -               For example,
> +                For example::
> =20
> -		PM_PB_CYC =3D  "domain=3D1,offset=3D0x80,chip=3D?,lpar=3D0x0"
> +		  PM_PB_CYC =3D  "domain=3D1,offset=3D0x80,chip=3D?,lpar=3D0x0"
> =20
>  		In this event, '?' after chip specifies that
>  		this value will be provided by user while running this event.
> diff --git a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_=
gpci b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
> index 6a023b42486c..12e2bf92783f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
> +++ b/Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_gpci
> @@ -7,7 +7,7 @@ Description:    Read-only. Attribute group to describe th=
e magic bits
> =20
>                  Each attribute under this group defines a bit range of t=
he
>                  perf_event_attr.config. All supported attributes are lis=
ted
> -                below.
> +                below::
> =20
>  				counter_info_version  =3D "config:16-23"
>  				length  =3D "config:24-31"
> @@ -20,9 +20,9 @@ Description:    Read-only. Attribute group to describe =
the magic bits
>  				secondary_index =3D "config:0-15"
>  				starting_index =3D "config:32-63"
> =20
> -               For example,
> +                For example::
> =20
> -		processor_core_utilization_instructions_completed =3D "request=3D0x94,
> +		  processor_core_utilization_instructions_completed =3D "request=3D0x9=
4,
>  					phys_processor_idx=3D?,counter_info_version=3D0x8,
>  					length=3D8,offset=3D0x18"
> =20
> @@ -36,6 +36,7 @@ Description:
>  		'0' if the hypervisor is configured to forbid access to event
>  		counters being accumulated by other guests and to physical
>  		domain event counters.
> +
>  		'1' if that access is allowed.
> =20
>  What:		/sys/bus/event_source/devices/hv_gpci/interface/ga
> diff --git a/Documentation/ABI/testing/sysfs-bus-fcoe b/Documentation/ABI=
/testing/sysfs-bus-fcoe
> index 657df13b100d..8fe787cc4ab7 100644
> --- a/Documentation/ABI/testing/sysfs-bus-fcoe
> +++ b/Documentation/ABI/testing/sysfs-bus-fcoe
> @@ -3,16 +3,19 @@ Date:		August 2012
>  KernelVersion:	TBD
>  Contact:	Robert Love <robert.w.love@intel.com>, devel@open-fcoe.org
>  Description:	The FCoE bus. Attributes in this directory are control inte=
rfaces.
> +
>  Attributes:
> =20
> -	ctlr_create: 'FCoE Controller' instance creation interface. Writing an
> +	ctlr_create:
> +		     'FCoE Controller' instance creation interface. Writing an
>  		     <ifname> to this file will allocate and populate sysfs with a
>  		     fcoe_ctlr_device (ctlr_X). The user can then configure any
>  		     per-port settings and finally write to the fcoe_ctlr_device's
>  		     'start' attribute to begin the kernel's discovery and login
>  		     process.
> =20
> -	ctlr_destroy: 'FCoE Controller' instance removal interface. Writing a
> +	ctlr_destroy:
> +		       'FCoE Controller' instance removal interface. Writing a
>  		       fcoe_ctlr_device's sysfs name to this file will log the
>  		       fcoe_ctlr_device out of the fabric or otherwise connected
>  		       FCoE devices. It will also free all kernel memory allocated
> @@ -32,11 +35,13 @@ Description:	'FCoE Controller' instances on the fcoe =
bus.
> =20
>  Attributes:
> =20
> -	fcf_dev_loss_tmo: Device loss timeout period (see below). Changing
> +	fcf_dev_loss_tmo:
> +			  Device loss timeout period (see below). Changing
>  			  this value will change the dev_loss_tmo for all
>  			  FCFs discovered by this controller.
> =20
> -	mode:		  Display or change the FCoE Controller's mode. Possible
> +	mode:
> +			  Display or change the FCoE Controller's mode. Possible
>  			  modes are 'Fabric' and 'VN2VN'. If a FCoE Controller
>  			  is started in 'Fabric' mode then FIP FCF discovery is
>  			  initiated and ultimately a fabric login is attempted.
> @@ -44,23 +49,30 @@ Attributes:
>  			  FIP VN2VN discovery and login is performed. A FCoE
>  			  Controller only supports one mode at a time.
> =20
> -	enabled:	  Whether an FCoE controller is enabled or disabled.
> +	enabled:
> +			  Whether an FCoE controller is enabled or disabled.
>  			  0 if disabled, 1 if enabled. Writing either 0 or 1
>  			  to this file will enable or disable the FCoE controller.
> =20
> -	lesb/link_fail:   Link Error Status Block (LESB) link failure count.
> +	lesb/link_fail:
> +			  Link Error Status Block (LESB) link failure count.
> =20
> -	lesb/vlink_fail:  Link Error Status Block (LESB) virtual link
> +	lesb/vlink_fail:
> +		          Link Error Status Block (LESB) virtual link
>  			  failure count.
> =20
> -	lesb/miss_fka:    Link Error Status Block (LESB) missed FCoE
> +	lesb/miss_fka:
> +			  Link Error Status Block (LESB) missed FCoE
>  			  Initialization Protocol (FIP) Keep-Alives (FKA).
> =20
> -	lesb/symb_err:    Link Error Status Block (LESB) symbolic error count.
> +	lesb/symb_err:
> +			  Link Error Status Block (LESB) symbolic error count.
> =20
> -	lesb/err_block:   Link Error Status Block (LESB) block error count.
> +	lesb/err_block:
> +			  Link Error Status Block (LESB) block error count.
> =20
> -	lesb/fcs_error:   Link Error Status Block (LESB) Fibre Channel
> +	lesb/fcs_error:
> +			  Link Error Status Block (LESB) Fibre Channel
>  			  Services error count.
> =20
>  Notes: ctlr_X (global increment starting at 0)
> @@ -75,31 +87,41 @@ Description:	'FCoE FCF' instances on the fcoe bus. A =
FCF is a Fibre Channel
>  		Fibre Channel frames into a FC fabric. It can also take
>  		outbound FC frames and pack them in Ethernet packets to
>  		be sent to their destination on the Ethernet segment.
> +
>  Attributes:
> =20
> -	fabric_name: Identifies the fabric that the FCF services.
> +	fabric_name:
> +		     Identifies the fabric that the FCF services.
> =20
> -	switch_name: Identifies the FCF.
> +	switch_name:
> +		     Identifies the FCF.
> =20
> -	priority:    The switch's priority amongst other FCFs on the same
> +	priority:
> +		     The switch's priority amongst other FCFs on the same
>  		     fabric.
> =20
> -	selected:    1 indicates that the switch has been selected for use;
> +	selected:
> +		     1 indicates that the switch has been selected for use;
>  		     0 indicates that the switch will not be used.
> =20
> -	fc_map:      The Fibre Channel MAP
> +	fc_map:
> +		     The Fibre Channel MAP
> =20
> -	vfid:	     The Virtual Fabric ID
> +	vfid:
> +		     The Virtual Fabric ID
> =20
> -	mac:         The FCF's MAC address
> +	mac:
> +		     The FCF's MAC address
> =20
> -	fka_period:  The FIP Keep-Alive period
> +	fka_period:
> +		     The FIP Keep-Alive period
> =20
>  	fabric_state: The internal kernel state
> -		      "Unknown" - Initialization value
> -		      "Disconnected" - No link to the FCF/fabric
> -		      "Connected" - Host is connected to the FCF
> -		      "Deleted" - FCF is being removed from the system
> +
> +		      - "Unknown" - Initialization value
> +		      - "Disconnected" - No link to the FCF/fabric
> +		      - "Connected" - Host is connected to the FCF
> +		      - "Deleted" - FCF is being removed from the system
> =20
>  	dev_loss_tmo: The device loss timeout period for this FCF.
> =20
> diff --git a/Documentation/ABI/testing/sysfs-bus-fsl-mc b/Documentation/A=
BI/testing/sysfs-bus-fsl-mc
> index 80256b8b4f26..bf3c6af6ad89 100644
> --- a/Documentation/ABI/testing/sysfs-bus-fsl-mc
> +++ b/Documentation/ABI/testing/sysfs-bus-fsl-mc
> @@ -6,8 +6,10 @@ Description:
>  		the driver to attempt to bind to the device found at
>  		this location. The format for the location is Object.Id
>  		and is the same as found in /sys/bus/fsl-mc/devices/.
> -                For example:
> -		# echo dpni.2 > /sys/bus/fsl-mc/drivers/fsl_dpaa2_eth/bind
> +
> +                For example::
> +
> +		  # echo dpni.2 > /sys/bus/fsl-mc/drivers/fsl_dpaa2_eth/bind
> =20
>  What:		/sys/bus/fsl-mc/drivers/.../unbind
>  Date:		December 2016
> @@ -17,5 +19,7 @@ Description:
>  		driver to attempt to unbind from the device found at
>  		this location. The format for the location is Object.Id
>  		and is the same as found in /sys/bus/fsl-mc/devices/.
> -                For example:
> -		# echo dpni.2 > /sys/bus/fsl-mc/drivers/fsl_dpaa2_eth/unbind
> +
> +                For example::
> +
> +		  # echo dpni.2 > /sys/bus/fsl-mc/drivers/fsl_dpaa2_eth/unbind
> diff --git a/Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480 b/Do=
cumentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480
> index 9de269bb0ae5..42dfc9399d2d 100644
> --- a/Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480
> +++ b/Documentation/ABI/testing/sysfs-bus-i2c-devices-fsa9480
> @@ -3,19 +3,25 @@ Date:		February 2011
>  Contact:	Minkyu Kang <mk7.kang@samsung.com>
>  Description:
>  		show what device is attached
> -		NONE - no device
> -		USB - USB device is attached
> -		UART - UART is attached
> -		CHARGER - Charger is attaced
> -		JIG - JIG is attached
> +
> +		=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		NONE     no device
> +		USB      USB device is attached
> +		UART     UART is attached
> +		CHARGER  Charger is attaced
> +		JIG      JIG is attached
> +		=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/i2c/devices/.../switch
>  Date:		February 2011
>  Contact:	Minkyu Kang <mk7.kang@samsung.com>
>  Description:
>  		show or set the state of manual switch
> -		VAUDIO - switch to VAUDIO path
> -		UART - switch to UART path
> -		AUDIO - switch to AUDIO path
> -		DHOST - switch to DHOST path
> -		AUTO - switch automatically by device
> +
> +		=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		VAUDIO   switch to VAUDIO path
> +		UART     switch to UART path
> +		AUDIO    switch to AUDIO path
> +		DHOST    switch to DHOST path
> +		AUTO     switch automatically by device
> +		=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-bus-i3c b/Documentation/ABI/=
testing/sysfs-bus-i3c
> index 2f332ec36f82..1f4a2662335b 100644
> --- a/Documentation/ABI/testing/sysfs-bus-i3c
> +++ b/Documentation/ABI/testing/sysfs-bus-i3c
> @@ -84,6 +84,7 @@ Description:
>  		by space. Modes can be "hdr-ddr", "hdr-tsp" and "hdr-tsl".
>  		See the I3C specification for more details about these HDR
>  		modes.
> +
>  		This entry describes the HDRCAP of the master controller
>  		driving the bus.
> =20
> @@ -135,6 +136,7 @@ Description:
>  		Expose the HDR (High Data Rate) capabilities of a device.
>  		Returns a list of supported HDR mode, each element is separated
>  		by space. Modes can be "hdr-ddr", "hdr-tsp" and "hdr-tsl".
> +
>  		See the I3C specification for more details about these HDR
>  		modes.
> =20
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio b/Documentation/ABI/=
testing/sysfs-bus-iio
> index e3df71987eff..df42bed09f25 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio
> +++ b/Documentation/ABI/testing/sysfs-bus-iio
> @@ -15,6 +15,7 @@ Description:
>  		based on hardware generated events (e.g. data ready) or
>  		provided by a separate driver for other hardware (e.g.
>  		periodic timer, GPIO or high resolution timer).
> +
>  		Contains trigger type specific elements. These do not
>  		generalize well and hence are not documented in this file.
>  		X is the IIO index of the trigger.
> @@ -666,6 +667,7 @@ Description:
>  		<type>[Y][_name]_<raw|input>_thresh_falling_value may take
>  		different values, but the device can only enable both thresholds
>  		or neither.
> +
>  		Note the driver will assume the last p events requested are
>  		to be enabled where p is how many it supports (which may vary
>  		depending on the exact set requested. So if you want to be
> @@ -720,6 +722,7 @@ Description:
>  		<type>[Y][_name]_<raw|input>_roc_falling_value may take
>  		different values, but the device can only enable both rate of
>  		change thresholds or neither.
> +
>  		Note the driver will assume the last p events requested are
>  		to be enabled where p is however many it supports (which may
>  		vary depending on the exact set requested. So if you want to be
> @@ -775,9 +778,11 @@ Description:
>  		Specifies the value of threshold that the device is comparing
>  		against for the events enabled by
>  		<type>Y[_name]_thresh[_rising|falling]_en.
> +
>  		If separate attributes exist for the two directions, but
>  		direction is not specified for this attribute, then a single
>  		threshold value applies to both directions.
> +
>  		The raw or input element of the name indicates whether the
>  		value is in raw device units or in processed units (as _raw
>  		and _input do on sysfs direct channel read attributes).
> @@ -860,6 +865,7 @@ Description:
>  		If separate attributes exist for the two directions, but
>  		direction is not specified for this attribute, then a single
>  		hysteresis value applies to both directions.
> +
>  		For falling events the hysteresis is added to the _value attribute for
>  		this event to get the upper threshold for when the event goes back to
>  		normal, for rising events the hysteresis is subtracted from the _value
> @@ -906,6 +912,7 @@ Description:
>  		Specifies the value of rate of change threshold that the
>  		device is comparing against for the events enabled by
>  		<type>[Y][_name]_roc[_rising|falling]_en.
> +
>  		If separate attributes exist for the two directions,
>  		but direction is not specified for this attribute,
>  		then a single threshold value applies to both directions.
> @@ -1305,6 +1312,7 @@ Description:
>  		Proximity measurement indicating that some
>  		object is near the sensor, usually by observing
>  		reflectivity of infrared or ultrasound emitted.
> +
>  		Often these sensors are unit less and as such conversion
>  		to SI units is not possible. Higher proximity measurements
>  		indicate closer objects, and vice versa. Units after
> @@ -1450,9 +1458,12 @@ Contact:	linux-iio@vger.kernel.org
>  Description:
>  		A single positive integer specifying the maximum number of scan
>  		elements to wait for.
> +
>  		Poll will block until the watermark is reached.
> +
>  		Blocking read will wait until the minimum between the requested
>  		read amount or the low water mark is available.
> +
>  		Non-blocking read will retrieve the available samples from the
>  		buffer even if there are less samples then watermark level. This
>  		allows the application to block on poll with a timeout and read
> @@ -1481,11 +1492,13 @@ Description:
>  		device settings allows it (e.g. if a trigger is set that samples
>  		data differently that the hardware fifo does then hardware fifo
>  		will not enabled).
> +
>  		If the hardware fifo is enabled and the level of the hardware
>  		fifo reaches the hardware fifo watermark level the device will
>  		flush its hardware fifo to the device buffer. Doing a non
>  		blocking read on the device when no samples are present in the
>  		device buffer will also force a flush.
> +
>  		When the hardware fifo is enabled there is no need to use a
>  		trigger to use buffer mode since the watermark settings
>  		guarantees that the hardware fifo is flushed to the device
> @@ -1523,6 +1536,7 @@ Description:
>  		A single positive integer specifying the minimum watermark level
>  		for the hardware fifo of this device. If the device does not
>  		have a hardware fifo this entry is not present.
> +
>  		If the user sets buffer/watermark to a value less than this one,
>  		then the hardware watermark will remain unset.
> =20
> @@ -1533,6 +1547,7 @@ Description:
>  		A single positive integer specifying the maximum watermark level
>  		for the hardware fifo of this device. If the device does not
>  		have a hardware fifo this entry is not present.
> +
>  		If the user sets buffer/watermark to a value greater than this
>  		one, then the hardware watermark will be capped at this value.
> =20
> @@ -1544,6 +1559,7 @@ Description:
>  		levels for the hardware fifo. This entry is optional and if it
>  		is not present it means that all the values between
>  		hwfifo_watermark_min and hwfifo_watermark_max are supported.
> +
>  		If the user sets buffer/watermark to a value greater than
>  		hwfifo_watermak_min but not equal to any of the values in this
>  		list, the driver will chose an appropriate value for the
> @@ -1605,7 +1621,8 @@ KernelVersion:	4.1.0
>  Contact:	linux-iio@vger.kernel.org
>  Description:
>  		'1' (enable) or '0' (disable) specifying the enable
> -		of heater function. Same reading values apply
> +		of heater function. Same reading values apply.
> +
>  		This ABI is especially applicable for humidity sensors
>  		to heatup the device and get rid of any condensation
>  		in some humidity environment
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-adc-hi8435 b/Documen=
tation/ABI/testing/sysfs-bus-iio-adc-hi8435
> index f30b4c424fb6..4b01150af397 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-adc-hi8435
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-adc-hi8435
> @@ -19,9 +19,11 @@ Description:
>  		is separately set for "GND-Open" and "Supply-Open" modes.
>  		Channels 0..31 have common low threshold values, but could have differ=
ent
>  		sensing_modes.
> +
>  		The low voltage threshold range is between 2..21V.
>  		Hysteresis between low and high thresholds can not be lower then 2 and
>  		can not be odd.
> +
>  		If falling threshold results hysteresis to odd value then rising
>  		threshold is automatically subtracted by one.
> =20
> @@ -34,10 +36,13 @@ Description:
>  		this value then the threshold rising event is pushed.
>  		Depending on in_voltageY_sensing_mode the high voltage threshold
>  		is separately set for "GND-Open" and "Supply-Open" modes.
> +
>  		Channels 0..31 have common high threshold values, but could have diffe=
rent
>  		sensing_modes.
> +
>  		The high voltage threshold range is between 3..22V.
>  		Hysteresis between low and high thresholds can not be lower then 2 and
>  		can not be odd.
> +
>  		If rising threshold results hysteresis to odd value then falling
>  		threshold is automatically appended by one.
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-adc-stm32 b/Document=
ation/ABI/testing/sysfs-bus-iio-adc-stm32
> index efe4c85e3c8b..1975c7a1af34 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-adc-stm32
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-adc-stm32
> @@ -5,10 +5,13 @@ Description:
>  		The STM32 ADC can be configured to use external trigger sources
>  		(e.g. timers, pwm or exti gpio). Then, it can be tuned to start
>  		conversions on external trigger by either:
> +
>  		- "rising-edge"
>  		- "falling-edge"
>  		- "both-edges".
> +
>  		Reading returns current trigger polarity.
> +
>  		Writing value before enabling conversions sets trigger polarity.
> =20
>  What:		/sys/bus/iio/devices/triggerX/trigger_polarity_available
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-distance-srf08 b/Doc=
umentation/ABI/testing/sysfs-bus-iio-distance-srf08
> index a133fd8d081a..40df5c9fef99 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-distance-srf08
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-distance-srf08
> @@ -15,8 +15,11 @@ Description:
>  		first object echoed in meters. Default value is 6.020.
>  		This setting limits the time the driver is waiting for a
>  		echo.
> +
>  		Showing the range of available values is represented as the
>  		minimum value, the step and the maximum value, all enclosed
>  		in square brackets.
> -		Example:
> -		[0.043 0.043 11.008]
> +
> +		Example::
> +
> +			[0.043 0.043 11.008]
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-frequency-ad9523 b/D=
ocumentation/ABI/testing/sysfs-bus-iio-frequency-ad9523
> index a91aeabe7b24..d065cda7dd96 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-frequency-ad9523
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-frequency-ad9523
> @@ -8,7 +8,9 @@ KernelVersion:	3.4.0
>  Contact:	linux-iio@vger.kernel.org
>  Description:
>  		Reading returns either '1' or '0'.
> +
>  		'1' means that the clock in question is present.
> +
>  		'0' means that the clock is missing.
> =20
>  What:		/sys/bus/iio/devices/iio:deviceX/pllY_locked
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371 b/=
Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371
> index 302de64cb424..544548ee794c 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-frequency-adf4371
> @@ -27,12 +27,12 @@ What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltag=
eY_name
>  KernelVersion:
>  Contact:	linux-iio@vger.kernel.org
>  Description:
> -		Reading returns the datasheet name for channel Y:
> +		Reading returns the datasheet name for channel Y::
> =20
> -		out_altvoltage0_name: RF8x
> -		out_altvoltage1_name: RFAUX8x
> -		out_altvoltage2_name: RF16x
> -		out_altvoltage3_name: RF32x
> +		  out_altvoltage0_name: RF8x
> +		  out_altvoltage1_name: RFAUX8x
> +		  out_altvoltage2_name: RF16x
> +		  out_altvoltage3_name: RF32x
> =20
>  What:		/sys/bus/iio/devices/iio:deviceX/out_altvoltageY_powerdown
>  KernelVersion:
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x b/Doc=
umentation/ABI/testing/sysfs-bus-iio-health-afe440x
> index 6adba9058b22..66b621f10223 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-health-afe440x
> @@ -6,10 +6,14 @@ Description:
>  		Get measured values from the ADC for these stages. Y is the
>  		specific stage number corresponding to datasheet stage names
>  		as follows:
> -		1 -> LED2
> -		2 -> ALED2/LED3
> -		3 -> LED1
> -		4 -> ALED1/LED4
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		1  LED2
> +		2  ALED2/LED3
> +		3  LED1
> +		4  ALED1/LED4
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  		Note that channels 5 and 6 represent LED2-ALED2 and LED1-ALED1
>  		respectively which simply helper channels containing the
>  		calculated difference in the value of stage 1 - 2 and 3 - 4.
> diff --git a/Documentation/ABI/testing/sysfs-bus-iio-light-isl29018 b/Doc=
umentation/ABI/testing/sysfs-bus-iio-light-isl29018
> index f0ce0a0476ea..220206a20d98 100644
> --- a/Documentation/ABI/testing/sysfs-bus-iio-light-isl29018
> +++ b/Documentation/ABI/testing/sysfs-bus-iio-light-isl29018
> @@ -15,5 +15,7 @@ Description:
>  		Scheme 0 has wider dynamic range, Scheme 1 proximity detection
>  		is less affected by the ambient IR noise variation.
> =20
> -		0 Sensing IR from LED and ambient
> -		1 Sensing IR from LED with ambient IR rejection
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  Sensing IR from LED and ambient
> +		1  Sensing IR from LED with ambient IR rejection
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-bus-intel_th-devices-gth b/D=
ocumentation/ABI/testing/sysfs-bus-intel_th-devices-gth
> index 22d0843849a8..b7b2278fe042 100644
> --- a/Documentation/ABI/testing/sysfs-bus-intel_th-devices-gth
> +++ b/Documentation/ABI/testing/sysfs-bus-intel_th-devices-gth
> @@ -10,10 +10,13 @@ Date:		June 2015
>  KernelVersion:	4.3
>  Contact:	Alexander Shishkin <alexander.shishkin@linux.intel.com>
>  Description:	(RO) Output port type:
> -		  0: not present,
> -		  1: MSU (Memory Storage Unit)
> -		  2: CTP (Common Trace Port)
> -		  4: PTI (MIPI PTI).
> +
> +		 =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +		  0  not present,
> +		  1  MSU (Memory Storage Unit)
> +		  2  CTP (Common Trace Port)
> +		  4  PTI (MIPI PTI).
> +		 =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/intel_th/devices/<intel_th_id>-gth/outputs/[0-7]_drop
>  Date:		June 2015
> diff --git a/Documentation/ABI/testing/sysfs-bus-papr-pmem b/Documentatio=
n/ABI/testing/sysfs-bus-papr-pmem
> index c1a67275c43f..8316c33862a0 100644
> --- a/Documentation/ABI/testing/sysfs-bus-papr-pmem
> +++ b/Documentation/ABI/testing/sysfs-bus-papr-pmem
> @@ -11,19 +11,26 @@ Description:
>  		at 'Documentation/powerpc/papr_hcalls.rst' . Below are
>  		the flags reported in this sysfs file:
> =20
> -		* "not_armed"	: Indicates that NVDIMM contents will not
> +		* "not_armed"
> +				  Indicates that NVDIMM contents will not
>  				  survive a power cycle.
> -		* "flush_fail"	: Indicates that NVDIMM contents
> +		* "flush_fail"
> +				  Indicates that NVDIMM contents
>  				  couldn't be flushed during last
>  				  shut-down event.
> -		* "restore_fail": Indicates that NVDIMM contents
> +		* "restore_fail"
> +				  Indicates that NVDIMM contents
>  				  couldn't be restored during NVDIMM
>  				  initialization.
> -		* "encrypted"	: NVDIMM contents are encrypted.
> -		* "smart_notify": There is health event for the NVDIMM.
> -		* "scrubbed"	: Indicating that contents of the
> +		* "encrypted"
> +				  NVDIMM contents are encrypted.
> +		* "smart_notify"
> +				  There is health event for the NVDIMM.
> +		* "scrubbed"
> +				  Indicating that contents of the
>  				  NVDIMM have been scrubbed.
> -		* "locked"	: Indicating that NVDIMM contents cant
> +		* "locked"
> +				  Indicating that NVDIMM contents cant
>  				  be modified until next power cycle.
> =20
>  What:		/sys/bus/nd/devices/nmemX/papr/perf_stats
> @@ -51,4 +58,4 @@ Description:
>  		* "MedWDur " : Media Write Duration
>  		* "CchRHCnt" : Cache Read Hit Count
>  		* "CchWHCnt" : Cache Write Hit Count
> -		* "FastWCnt" : Fast Write Count
> \ No newline at end of file
> +		* "FastWCnt" : Fast Write Count
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci b/Documentation/ABI/=
testing/sysfs-bus-pci
> index 450296cc7948..77ad9ec3c801 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci
> +++ b/Documentation/ABI/testing/sysfs-bus-pci
> @@ -7,8 +7,10 @@ Description:
>  		this location.	This is useful for overriding default
>  		bindings.  The format for the location is: DDDD:BB:DD.F.
>  		That is Domain:Bus:Device.Function and is the same as
> -		found in /sys/bus/pci/devices/.  For example:
> -		# echo 0000:00:19.0 > /sys/bus/pci/drivers/foo/bind
> +		found in /sys/bus/pci/devices/.  For example::
> +
> +		  # echo 0000:00:19.0 > /sys/bus/pci/drivers/foo/bind
> +
>  		(Note: kernels before 2.6.28 may require echo -n).
> =20
>  What:		/sys/bus/pci/drivers/.../unbind
> @@ -20,8 +22,10 @@ Description:
>  		this location.	This may be useful when overriding default
>  		bindings.  The format for the location is: DDDD:BB:DD.F.
>  		That is Domain:Bus:Device.Function and is the same as
> -		found in /sys/bus/pci/devices/. For example:
> -		# echo 0000:00:19.0 > /sys/bus/pci/drivers/foo/unbind
> +		found in /sys/bus/pci/devices/. For example::
> +
> +		  # echo 0000:00:19.0 > /sys/bus/pci/drivers/foo/unbind
> +
>  		(Note: kernels before 2.6.28 may require echo -n).
> =20
>  What:		/sys/bus/pci/drivers/.../new_id
> @@ -38,8 +42,9 @@ Description:
>  		Class, Class Mask, and Private Driver Data.  The Vendor ID
>  		and Device ID fields are required, the rest are optional.
>  		Upon successfully adding an ID, the driver will probe
> -		for the device and attempt to bind to it.  For example:
> -		# echo "8086 10f5" > /sys/bus/pci/drivers/foo/new_id
> +		for the device and attempt to bind to it.  For example::
> +
> +		  # echo "8086 10f5" > /sys/bus/pci/drivers/foo/new_id
> =20
>  What:		/sys/bus/pci/drivers/.../remove_id
>  Date:		February 2009
> @@ -54,8 +59,9 @@ Description:
>  		required, the rest are optional.  After successfully
>  		removing an ID, the driver will no longer support the
>  		device.  This is useful to ensure auto probing won't
> -		match the driver to the device.  For example:
> -		# echo "8086 10f5" > /sys/bus/pci/drivers/foo/remove_id
> +		match the driver to the device.  For example::
> +
> +		  # echo "8086 10f5" > /sys/bus/pci/drivers/foo/remove_id
> =20
>  What:		/sys/bus/pci/rescan
>  Date:		January 2009
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci-devices-catpt b/Docu=
mentation/ABI/testing/sysfs-bus-pci-devices-catpt
> index 8a200f4eefbd..f85db86d63e8 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci-devices-catpt
> +++ b/Documentation/ABI/testing/sysfs-bus-pci-devices-catpt
> @@ -4,6 +4,7 @@ Contact:	Cezary Rojewski <cezary.rojewski@intel.com>
>  Description:
>  		Version of AudioDSP firmware ASoC catpt driver is
>  		communicating with.
> +
>  		Format: %d.%d.%d.%d, type:major:minor:build.
> =20
>  What:		/sys/devices/pci0000:00/<dev>/fw_info
> diff --git a/Documentation/ABI/testing/sysfs-bus-pci-drivers-ehci_hcd b/D=
ocumentation/ABI/testing/sysfs-bus-pci-drivers-ehci_hcd
> index 60c60fa624b2..c90d97a80855 100644
> --- a/Documentation/ABI/testing/sysfs-bus-pci-drivers-ehci_hcd
> +++ b/Documentation/ABI/testing/sysfs-bus-pci-drivers-ehci_hcd
> @@ -21,11 +21,11 @@ Description:
>  		number returns the port to normal operation.
> =20
>  		For example: To force the high-speed device attached to
> -		port 4 on bus 2 to run at full speed:
> +		port 4 on bus 2 to run at full speed::
> =20
>  			echo 4 >/sys/bus/usb/devices/usb2/../companion
> =20
> -		To return the port to high-speed operation:
> +		To return the port to high-speed operation::
> =20
>  			echo -4 >/sys/bus/usb/devices/usb2/../companion
> =20
> diff --git a/Documentation/ABI/testing/sysfs-bus-rbd b/Documentation/ABI/=
testing/sysfs-bus-rbd
> index cc30bee8b5f4..417a2fe21be1 100644
> --- a/Documentation/ABI/testing/sysfs-bus-rbd
> +++ b/Documentation/ABI/testing/sysfs-bus-rbd
> @@ -7,6 +7,8 @@ Description:
> =20
>  		Usage: <mon ip addr> <options> <pool name> <rbd image name> [<snap nam=
e>]
> =20
> +		Example::
> +
>  		 $ echo "192.168.0.1 name=3Dadmin rbd foo" > /sys/bus/rbd/add
> =20
>  		The snapshot name can be "-" or omitted to map the image
> @@ -23,6 +25,8 @@ Description:
> =20
>  		Usage: <dev-id> [force]
> =20
> +		Example::
> +
>  		 $ echo 2 > /sys/bus/rbd/remove
> =20
>  		Optional "force" argument which when passed will wait for
> @@ -80,26 +84,29 @@ Date:		Oct, 2010
>  KernelVersion:	v2.6.37
>  Contact:	Sage Weil <sage@newdream.net>
>  Description:
> -		size:		(RO) The size (in bytes) of the mapped block
> +
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		size		(RO) The size (in bytes) of the mapped block
>  				device.
> =20
> -		major:		(RO) The block device major number.
> +		major		(RO) The block device major number.
> =20
> -		client_id:	(RO) The ceph unique client id that was assigned
> +		client_id	(RO) The ceph unique client id that was assigned
>  				for this specific session.
> =20
> -		pool:		(RO) The name of the storage pool where this rbd
> +		pool		(RO) The name of the storage pool where this rbd
>  				image resides. An rbd image name is unique
>  				within its pool.
> =20
> -		name:		(RO) The name of the rbd image.
> +		name		(RO) The name of the rbd image.
> =20
> -		refresh:	(WO) Writing to this file will reread the image
> +		refresh		(WO) Writing to this file will reread the image
>  				header data and set all relevant data structures
>  				accordingly.
> =20
> -		current_snap:	(RO) The current snapshot for which the device
> +		current_snap	(RO) The current snapshot for which the device
>  				is mapped.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
>  What:		/sys/bus/rbd/devices/<dev-id>/pool_id
> @@ -117,11 +124,13 @@ Date:		Oct, 2012
>  KernelVersion:	v3.7
>  Contact:	Sage Weil <sage@newdream.net>
>  Description:
> -		image_id:	(RO) The unique id for the rbd image. (For rbd
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		image_id	(RO) The unique id for the rbd image. (For rbd
>  				image format 1 this is empty.)
> =20
> -		features:	(RO) A hexadecimal encoding of the feature bits
> +		features	(RO) A hexadecimal encoding of the feature bits
>  				for this image.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
>  What:		/sys/bus/rbd/devices/<dev-id>/parent
> @@ -149,14 +158,16 @@ Date:		Aug, 2016
>  KernelVersion:	v4.9
>  Contact:	Sage Weil <sage@newdream.net>
>  Description:
> -		snap_id:	(RO) The current snapshot's id.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		snap_id		(RO) The current snapshot's id.
> =20
> -		config_info:	(RO) The string written into
> +		config_info	(RO) The string written into
>  				/sys/bus/rbd/add{,_single_major}.
> =20
> -		cluster_fsid:	(RO) The ceph cluster UUID.
> +		cluster_fsid	(RO) The ceph cluster UUID.
> =20
> -		client_addr:	(RO) The ceph unique client
> +		client_addr	(RO) The ceph unique client
>  				entity_addr_t (address + nonce). The format is
>  				<address>:<port>/<nonce>: '1.2.3.4:1234/5678' or
>  				'[1:2:3:4:5:6:7:8]:1234/5678'.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-bus-siox b/Documentation/ABI=
/testing/sysfs-bus-siox
> index c2a403f20b90..50e80238f30d 100644
> --- a/Documentation/ABI/testing/sysfs-bus-siox
> +++ b/Documentation/ABI/testing/sysfs-bus-siox
> @@ -8,6 +8,7 @@ Description:
>  		When the file contains a "1" the bus is operated and periodically
>  		does a push-pull cycle to write and read data from the
>  		connected devices.
> +
>  		When writing a "0" or "1" the bus moves to the described state.
> =20
>  What:		/sys/bus/siox/devices/siox-X/device_add
> @@ -21,8 +22,10 @@ Description:
>  		to add a new device dynamically. <type> is the name that is used to ma=
tch
>  		to a driver (similar to the platform bus). <inbytes> and <outbytes> de=
fine
>  		the length of the input and output shift register in bytes respectivel=
y.
> +
>  		<statustype> defines the 4 bit device type that is check to identify c=
onnection
>  		problems.
> +
>  		The new device is added to the end of the existing chain.
> =20
>  What:		/sys/bus/siox/devices/siox-X/device_remove
> diff --git a/Documentation/ABI/testing/sysfs-bus-thunderbolt b/Documentat=
ion/ABI/testing/sysfs-bus-thunderbolt
> index 171127294674..0b4ab9e4b8f4 100644
> --- a/Documentation/ABI/testing/sysfs-bus-thunderbolt
> +++ b/Documentation/ABI/testing/sysfs-bus-thunderbolt
> @@ -193,10 +193,11 @@ Description:	When new NVM image is written to the n=
on-active NVM
>  		verification fails an error code is returned instead.
> =20
>  		This file will accept writing values "1" or "2"
> +
>  		- Writing "1" will flush the image to the storage
> -		area and authenticate the image in one action.
> +		  area and authenticate the image in one action.
>  		- Writing "2" will run some basic validation on the image
> -		and flush it to the storage area.
> +		  and flush it to the storage area.
> =20
>  		When read holds status of the last authentication
>  		operation if an error occurred during the process. This
> @@ -213,9 +214,11 @@ Description:	This contains name of the property dire=
ctory the XDomain
>  		question. Following directories are already reserved by
>  		the Apple XDomain specification:
> =20
> -		network:  IP/ethernet over Thunderbolt
> -		targetdm: Target disk mode protocol over Thunderbolt
> -		extdisp:  External display mode protocol over Thunderbolt
> +		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		network   IP/ethernet over Thunderbolt
> +		targetdm  Target disk mode protocol over Thunderbolt
> +		extdisp   External display mode protocol over Thunderbolt
> +		=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/thunderbolt/devices/<xdomain>.<service>/modalias
>  Date:		Jan 2018
> @@ -293,7 +296,8 @@ Description:	For supported devices, automatically aut=
henticate the new Thunderbo
>  		image when the device is disconnected from the host system.
> =20
>  		This file will accept writing values "1" or "2"
> +
>  		- Writing "1" will flush the image to the storage
> -		area and prepare the device for authentication on disconnect.
> +		  area and prepare the device for authentication on disconnect.
>  		- Writing "2" will run some basic validation on the image
> -		and flush it to the storage area.
> +		  and flush it to the storage area.
> diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/=
testing/sysfs-bus-usb
> index e449b8374f6a..bf2c1968525f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-usb
> +++ b/Documentation/ABI/testing/sysfs-bus-usb
> @@ -9,6 +9,7 @@ Description:
>  		by writing INTERFACE to /sys/bus/usb/drivers_probe
>  		This allows to avoid side-effects with drivers
>  		that need multiple interfaces.
> +
>  		A deauthorized interface cannot be probed or claimed.
> =20
>  What:		/sys/bus/usb/devices/usbX/interface_authorized_default
> @@ -216,6 +217,7 @@ Description:
>  		 - Bit 0 of this field selects the "old" enumeration scheme,
>  		   as it is considerably faster (it only causes one USB reset
>  		   instead of 2).
> +
>  		   The old enumeration scheme can also be selected globally
>  		   using /sys/module/usbcore/parameters/old_scheme_first, but
>  		   it is often not desirable as the new scheme was introduced to
> diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm353=
3 b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> index c0e0a9ae7b3d..8251e78abc49 100644
> --- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> +++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> @@ -6,8 +6,10 @@ Description:
>  		Get the ALS output channel used as input in
>  		ALS-current-control mode (0, 1), where:
> =20
> -		0 - out_current0 (backlight 0)
> -		1 - out_current1 (backlight 1)
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +		0   out_current0 (backlight 0)
> +		1   out_current1 (backlight 1)
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/backlight/<backlight>/als_en
>  Date:		May 2012
> @@ -30,8 +32,10 @@ Contact:	Johan Hovold <jhovold@gmail.com>
>  Description:
>  		Set the brightness-mapping mode (0, 1), where:
> =20
> -		0 - exponential mode
> -		1 - linear mode
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0   exponential mode
> +		1   linear mode
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/backlight/<backlight>/pwm
>  Date:		April 2012
> @@ -40,9 +44,11 @@ Contact:	Johan Hovold <jhovold@gmail.com>
>  Description:
>  		Set the PWM-input control mask (5 bits), where:
> =20
> -		bit 5 - PWM-input enabled in Zone 4
> -		bit 4 - PWM-input enabled in Zone 3
> -		bit 3 - PWM-input enabled in Zone 2
> -		bit 2 - PWM-input enabled in Zone 1
> -		bit 1 - PWM-input enabled in Zone 0
> -		bit 0 - PWM-input enabled
> +		=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		bit 5   PWM-input enabled in Zone 4
> +		bit 4   PWM-input enabled in Zone 3
> +		bit 3   PWM-input enabled in Zone 2
> +		bit 2   PWM-input enabled in Zone 1
> +		bit 1   PWM-input enabled in Zone 0
> +		bit 0   PWM-input enabled
> +		=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/AB=
I/testing/sysfs-class-bdi
> index d773d5697cf5..5402bd74ba43 100644
> --- a/Documentation/ABI/testing/sysfs-class-bdi
> +++ b/Documentation/ABI/testing/sysfs-class-bdi
> @@ -24,7 +24,6 @@ default
>  	filesystems which do not provide their own BDI.
> =20
>  Files under /sys/class/bdi/<bdi>/
> ----------------------------------
> =20
>  read_ahead_kb (read-write)
> =20
> diff --git a/Documentation/ABI/testing/sysfs-class-chromeos b/Documentati=
on/ABI/testing/sysfs-class-chromeos
> index 5819699d66ec..74ece942722e 100644
> --- a/Documentation/ABI/testing/sysfs-class-chromeos
> +++ b/Documentation/ABI/testing/sysfs-class-chromeos
> @@ -17,13 +17,14 @@ Date:		August 2015
>  KernelVersion:	4.2
>  Description:
>  		Tell the EC to reboot in various ways. Options are:
> -		"cancel": Cancel a pending reboot.
> -		"ro": Jump to RO without rebooting.
> -		"rw": Jump to RW without rebooting.
> -		"cold": Cold reboot.
> -		"disable-jump": Disable jump until next reboot.
> -		"hibernate": Hibernate the EC.
> -		"at-shutdown": Reboot after an AP shutdown.
> +
> +		- "cancel": Cancel a pending reboot.
> +		- "ro": Jump to RO without rebooting.
> +		- "rw": Jump to RW without rebooting.
> +		- "cold": Cold reboot.
> +		- "disable-jump": Disable jump until next reboot.
> +		- "hibernate": Hibernate the EC.
> +		- "at-shutdown": Reboot after an AP shutdown.
> =20
>  What:		/sys/class/chromeos/<ec-device-name>/version
>  Date:		August 2015
> diff --git a/Documentation/ABI/testing/sysfs-class-cxl b/Documentation/AB=
I/testing/sysfs-class-cxl
> index a6f51a104c44..818f55970efb 100644
> --- a/Documentation/ABI/testing/sysfs-class-cxl
> +++ b/Documentation/ABI/testing/sysfs-class-cxl
> @@ -217,6 +217,7 @@ Description:    read/write
>                  card.  A power cycle is required to load the image.
>                  "none" could be useful for debugging because the trace a=
rrays
>                  are preserved.
> +
>                  "user" and "factory" means PERST will cause either the u=
ser or
>                  user or factory image to be loaded.
>                  Default is to reload on PERST whichever image the card h=
as
> @@ -240,8 +241,11 @@ Contact:	linuxppc-dev@lists.ozlabs.org
>  Description:	read/write
>  		Trust that when an image is reloaded via PERST, it will not
>  		have changed.
> -		0 =3D don't trust, the image may be different (default)
> -		1 =3D trust that the image will not change.
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
> +		0   don't trust, the image may be different (default)
> +		1   trust that the image will not change.
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>  Users:		https://github.com/ibm-capi/libcxl
> =20
>  What:           /sys/class/cxl/<card>/psl_timebase_synced
> diff --git a/Documentation/ABI/testing/sysfs-class-devlink b/Documentatio=
n/ABI/testing/sysfs-class-devlink
> index 64791b65c9a3..b662f747c83e 100644
> --- a/Documentation/ABI/testing/sysfs-class-devlink
> +++ b/Documentation/ABI/testing/sysfs-class-devlink
> @@ -18,9 +18,9 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -		'consumer unbind'
> -		'supplier unbind'
> -		'never'
> +		- 'consumer unbind'
> +		- 'supplier unbind'
> +		- 'never'
> =20
>  		'consumer unbind' means the device link will be removed when
>  		the consumer's driver is unbound from the consumer device.
> @@ -49,8 +49,10 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -		'0' - Does not affect runtime power management
> -		'1' - Affects runtime power management
> +		=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		'0'   Does not affect runtime power management
> +		'1'   Affects runtime power management
> +		=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/devlink/.../status
>  Date:		May 2020
> @@ -68,13 +70,13 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -		'not tracked'
> -		'dormant'
> -		'available'
> -		'consumer probing'
> -		'active'
> -		'supplier unbinding'
> -		'unknown'
> +		- 'not tracked'
> +		- 'dormant'
> +		- 'available'
> +		- 'consumer probing'
> +		- 'active'
> +		- 'supplier unbinding'
> +		- 'unknown'
> =20
>  		'not tracked' means this device link does not track the status
>  		and has no impact on the binding, unbinding and syncing the
> @@ -114,8 +116,10 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  		'0'
> -		'1' - Affects runtime power management
> +		'1'  Affects runtime power management
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		'0' means the device link can affect other device behaviors
>  		like binding/unbinding, suspend/resume, runtime power
> diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation=
/ABI/testing/sysfs-class-extcon
> index 57a726232912..fde0fecd5de9 100644
> --- a/Documentation/ABI/testing/sysfs-class-extcon
> +++ b/Documentation/ABI/testing/sysfs-class-extcon
> @@ -39,19 +39,22 @@ Description:
>  		callback.
> =20
>  		If the default callback for showing function is used, the
> -		format is like this:
> -		# cat state
> -		USB_OTG=3D1
> -		HDMI=3D0
> -		TA=3D1
> -		EAR_JACK=3D0
> -		#
> +		format is like this::
> +
> +		    # cat state
> +		    USB_OTG=3D1
> +		    HDMI=3D0
> +		    TA=3D1
> +		    EAR_JACK=3D0
> +		    #
> +
>  		In this example, the extcon device has USB_OTG and TA
>  		cables attached and HDMI and EAR_JACK cables detached.
> =20
>  		In order to update the state of an extcon device, enter a hex
> -		state number starting with 0x:
> -		# echo 0xHEX > state
> +		state number starting with 0x::
> +
> +		    # echo 0xHEX > state
> =20
>  		This updates the whole state of the extcon device.
>  		Inputs of all the methods are required to meet the
> @@ -84,12 +87,13 @@ Contact:	MyungJoo Ham <myungjoo.ham@samsung.com>
>  Description:
>  		Shows the relations of mutually exclusiveness. For example,
>  		if the mutually_exclusive array of extcon device is
> -		{0x3, 0x5, 0xC, 0x0}, then the output is:
> -		# ls mutually_exclusive/
> -		0x3
> -		0x5
> -		0xc
> -		#
> +		{0x3, 0x5, 0xC, 0x0}, then the output is::
> +
> +		    # ls mutually_exclusive/
> +		    0x3
> +		    0x5
> +		    0xc
> +		    #
> =20
>  		Note that mutually_exclusive is a sub-directory of the extcon
>  		device and the file names under the mutually_exclusive
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documen=
tation/ABI/testing/sysfs-class-fpga-manager
> index 5284fa33d4c5..d78689c357a5 100644
> --- a/Documentation/ABI/testing/sysfs-class-fpga-manager
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
> @@ -28,8 +28,7 @@ Description:	Read fpga manager state as a string.
>  		* firmware request	=3D firmware class request in progress
>  		* firmware request error =3D firmware request failed
>  		* write init		=3D preparing FPGA for programming
> -		* write init error	=3D Error while preparing FPGA for
> -					  programming
> +		* write init error	=3D Error while preparing FPGA for programming
>  		* write			=3D FPGA ready to receive image data
>  		* write error		=3D Error while programming
>  		* write complete	=3D Doing post programming steps
> @@ -47,7 +46,7 @@ Description:	Read fpga manager status as a string.
>  		programming errors to userspace. This is a list of strings for
>  		the supported status.
> =20
> -		* reconfig operation error 	- invalid operations detected by
> +		* reconfig operation error	- invalid operations detected by
>  						  reconfiguration hardware.
>  						  e.g. start reconfiguration
>  						  with errors not cleared
> diff --git a/Documentation/ABI/testing/sysfs-class-gnss b/Documentation/A=
BI/testing/sysfs-class-gnss
> index 2467b6900eae..c8553d972edd 100644
> --- a/Documentation/ABI/testing/sysfs-class-gnss
> +++ b/Documentation/ABI/testing/sysfs-class-gnss
> @@ -6,9 +6,11 @@ Description:
>  		The GNSS receiver type. The currently identified types reflect
>  		the protocol(s) supported by the receiver:
> =20
> +			=3D=3D=3D=3D=3D=3D		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  			"NMEA"		NMEA 0183
>  			"SiRF"		SiRF Binary
>  			"UBX"		UBX
> +			=3D=3D=3D=3D=3D=3D		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		Note that also non-"NMEA" type receivers typically support a
>  		subset of NMEA 0183 with vendor extensions (e.g. to allow
> diff --git a/Documentation/ABI/testing/sysfs-class-led b/Documentation/AB=
I/testing/sysfs-class-led
> index 65e040978f73..0ed5c2629c6f 100644
> --- a/Documentation/ABI/testing/sysfs-class-led
> +++ b/Documentation/ABI/testing/sysfs-class-led
> @@ -47,6 +47,7 @@ Contact:	Richard Purdie <rpurdie@rpsys.net>
>  Description:
>  		Set the trigger for this LED. A trigger is a kernel based source
>  		of LED events.
> +
>  		You can change triggers in a similar manner to the way an IO
>  		scheduler is chosen. Trigger specific parameters can appear in
>  		/sys/class/leds/<led> once a given trigger is selected. For
> diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-el15203000 =
b/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> index 69befe947d7e..da546e86deb5 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> +++ b/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> @@ -27,23 +27,23 @@ Description:
> =20
>  			^
>  			|
> -		    0 On -|----+                   +----+                   +---
> +		  0 On -|----+                   +----+                   +---
>  			|    |                   |    |                   |
>  		    Off-|    +-------------------+    +-------------------+
>  			|
> -		    1 On -|    +----+                   +----+
> +		  1 On -|    +----+                   +----+
>  			|    |    |                   |    |
>  		    Off |----+    +-------------------+    +------------------
>  			|
> -		    2 On -|         +----+                   +----+
> +		  2 On -|         +----+                   +----+
>  			|         |    |                   |    |
>  		    Off-|---------+    +-------------------+    +-------------
>  			|
> -		    3 On -|              +----+                   +----+
> +		  3 On -|              +----+                   +----+
>  			|              |    |                   |    |
>  		    Off-|--------------+    +-------------------+    +--------
>  			|
> -		    4 On -|                   +----+                   +----+
> +		  4 On -|                   +----+                   +----+
>  			|                   |    |                   |    |
>  		    Off-|-------------------+    +-------------------+    +---
>  			|
> @@ -55,23 +55,23 @@ Description:
> =20
>  			^
>  			|
> -		    0 On -|    +-------------------+    +-------------------+
> +		  0 On -|    +-------------------+    +-------------------+
>  			|    |                   |    |                   |
>  		    Off-|----+                   +----+                   +---
>  			|
> -		    1 On -|----+    +-------------------+    +------------------
> +		  1 On -|----+    +-------------------+    +------------------
>  			|    |    |                   |    |
>  		    Off |    +----+                   +----+
>  			|
> -		    2 On -|---------+    +-------------------+    +-------------
> +		  2 On -|---------+    +-------------------+    +-------------
>  			|         |    |                   |    |
>  		    Off-|         +----+                   +----+
>  			|
> -		    3 On -|--------------+    +-------------------+    +--------
> +		  3 On -|--------------+    +-------------------+    +--------
>  			|              |    |                   |    |
>  		    Off-|              +----+                   +----+
>  			|
> -		    4 On -|-------------------+    +-------------------+    +---
> +		  4 On -|-------------------+    +-------------------+    +---
>  			|                   |    |                   |    |
>  		    Off-|                   +----+                   +----+
>  			|
> @@ -83,23 +83,23 @@ Description:
> =20
>  			^
>  			|
> -		    0 On -|----+                                       +--------
> +		  0 On -|----+                                       +--------
>  			|    |                                       |
>  		    Off-|    +---------------------------------------+
>  			|
> -		    1 On -|    +----+                             +----+
> +		  1 On -|    +----+                             +----+
>  			|    |    |                             |    |
>  		    Off |----+    +-----------------------------+    +--------
>  			|
> -		    2 On -|         +----+                   +----+
> +		  2 On -|         +----+                   +----+
>  			|         |    |                   |    |
>  		    Off-|---------+    +-------------------+    +-------------
>  			|
> -		    3 On -|              +----+         +----+
> +		  3 On -|              +----+         +----+
>  			|              |    |         |    |
>  		    Off-|--------------+    +---------+    +------------------
>  			|
> -		    4 On -|                   +---------+
> +		  4 On -|                   +---------+
>  			|                   |         |
>  		    Off-|-------------------+         +-----------------------
>  			|
> diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533 b/Do=
cumentation/ABI/testing/sysfs-class-led-driver-lm3533
> index e4c89b261546..e38a835d0a85 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
> +++ b/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
> @@ -6,8 +6,10 @@ Description:
>  		Set the ALS output channel to use as input in
>  		ALS-current-control mode (1, 2), where:
> =20
> -		1 - out_current1
> -		2 - out_current2
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		1   out_current1
> +		2   out_current2
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/leds/<led>/als_en
>  Date:		May 2012
> @@ -24,14 +26,16 @@ Contact:	Johan Hovold <jhovold@gmail.com>
>  Description:
>  		Set the pattern generator fall and rise times (0..7), where:
> =20
> -		0 - 2048 us
> -		1 - 262 ms
> -		2 - 524 ms
> -		3 - 1.049 s
> -		4 - 2.097 s
> -		5 - 4.194 s
> -		6 - 8.389 s
> -		7 - 16.78 s
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D
> +		0   2048 us
> +		1   262 ms
> +		2   524 ms
> +		3   1.049 s
> +		4   2.097 s
> +		5   4.194 s
> +		6   8.389 s
> +		7   16.78 s
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/leds/<led>/id
>  Date:		April 2012
> @@ -47,8 +51,10 @@ Contact:	Johan Hovold <jhovold@gmail.com>
>  Description:
>  		Set the brightness-mapping mode (0, 1), where:
> =20
> -		0 - exponential mode
> -		1 - linear mode
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0   exponential mode
> +		1   linear mode
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/leds/<led>/pwm
>  Date:		April 2012
> @@ -57,9 +63,11 @@ Contact:	Johan Hovold <jhovold@gmail.com>
>  Description:
>  		Set the PWM-input control mask (5 bits), where:
> =20
> -		bit 5 - PWM-input enabled in Zone 4
> -		bit 4 - PWM-input enabled in Zone 3
> -		bit 3 - PWM-input enabled in Zone 2
> -		bit 2 - PWM-input enabled in Zone 1
> -		bit 1 - PWM-input enabled in Zone 0
> -		bit 0 - PWM-input enabled
> +		=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		bit 5  PWM-input enabled in Zone 4
> +		bit 4  PWM-input enabled in Zone 3
> +		bit 3  PWM-input enabled in Zone 2
> +		bit 2  PWM-input enabled in Zone 1
> +		bit 1  PWM-input enabled in Zone 0
> +		bit 0  PWM-input enabled
> +		=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-class-led-flash b/Documentat=
ion/ABI/testing/sysfs-class-led-flash
> index 220a0270b47b..11e5677c3672 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-flash
> +++ b/Documentation/ABI/testing/sysfs-class-led-flash
> @@ -55,26 +55,35 @@ Description:	read only
>  		Flash faults are re-read after strobing the flash. Possible
>  		flash faults:
> =20
> -		* led-over-voltage - flash controller voltage to the flash LED
> +		* led-over-voltage
> +			flash controller voltage to the flash LED
>  			has exceeded the limit specific to the flash controller
> -		* flash-timeout-exceeded - the flash strobe was still on when
> +		* flash-timeout-exceeded
> +			the flash strobe was still on when
>  			the timeout set by the user has expired; not all flash
>  			controllers may set this in all such conditions
> -		* controller-over-temperature - the flash controller has
> +		* controller-over-temperature
> +			the flash controller has
>  			overheated
> -		* controller-short-circuit - the short circuit protection
> +		* controller-short-circuit
> +			the short circuit protection
>  			of the flash controller has been triggered
> -		* led-power-supply-over-current - current in the LED power
> +		* led-power-supply-over-current
> +			current in the LED power
>  			supply has exceeded the limit specific to the flash
>  			controller
> -		* indicator-led-fault - the flash controller has detected
> +		* indicator-led-fault
> +			the flash controller has detected
>  			a short or open circuit condition on the indicator LED
> -		* led-under-voltage - flash controller voltage to the flash
> +		* led-under-voltage
> +			flash controller voltage to the flash
>  			LED has been below the minimum limit specific to
>  			the flash
> -		* controller-under-voltage - the input voltage of the flash
> +		* controller-under-voltage
> +			the input voltage of the flash
>  			controller is below the limit under which strobing the
>  			flash at full current will not be possible;
>  			the condition persists until this flag is no longer set
> -		* led-over-temperature - the temperature of the LED has exceeded
> +		* led-over-temperature
> +			the temperature of the LED has exceeded
>  			its allowed upper limit
> diff --git a/Documentation/ABI/testing/sysfs-class-led-trigger-netdev b/D=
ocumentation/ABI/testing/sysfs-class-led-trigger-netdev
> index 451af6d6768c..646540950e38 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-trigger-netdev
> +++ b/Documentation/ABI/testing/sysfs-class-led-trigger-netdev
> @@ -19,18 +19,23 @@ KernelVersion:	4.16
>  Contact:	linux-leds@vger.kernel.org
>  Description:
>  		Signal the link state of the named network device.
> +
>  		If set to 0 (default), the LED's normal state is off.
> +
>  		If set to 1, the LED's normal state reflects the link state
>  		of the named network device.
>  		Setting this value also immediately changes the LED state.
> =20
> +
>  What:		/sys/class/leds/<led>/tx
>  Date:		Dec 2017
>  KernelVersion:	4.16
>  Contact:	linux-leds@vger.kernel.org
>  Description:
>  		Signal transmission of data on the named network device.
> +
>  		If set to 0 (default), the LED will not blink on transmission.
> +
>  		If set to 1, the LED will blink for the milliseconds specified
>  		in interval to signal transmission.
> =20
> @@ -40,6 +45,8 @@ KernelVersion:	4.16
>  Contact:	linux-leds@vger.kernel.org
>  Description:
>  		Signal reception of data on the named network device.
> +
>  		If set to 0 (default), the LED will not blink on reception.
> +
>  		If set to 1, the LED will blink for the milliseconds specified
>  		in interval to signal reception.
> diff --git a/Documentation/ABI/testing/sysfs-class-led-trigger-usbport b/=
Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> index f440e690daef..eb81152b8348 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> +++ b/Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> @@ -8,5 +8,6 @@ Description:
>  		selected for the USB port trigger. Selecting ports makes trigger
>  		observing them for any connected devices and lighting on LED if
>  		there are any.
> +
>  		Echoing "1" value selects USB port. Echoing "0" unselects it.
>  		Current state can be also read.
> diff --git a/Documentation/ABI/testing/sysfs-class-leds-gt683r b/Document=
ation/ABI/testing/sysfs-class-leds-gt683r
> index 6adab27f646e..b57ffb26e722 100644
> --- a/Documentation/ABI/testing/sysfs-class-leds-gt683r
> +++ b/Documentation/ABI/testing/sysfs-class-leds-gt683r
> @@ -7,9 +7,11 @@ Description:
>  		of one LED will update the mode of its two sibling devices as
>  		well. Possible values are:
> =20
> -		0 - normal
> -		1 - audio
> -		2 - breathing
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0   normal
> +		1   audio
> +		2   breathing
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		Normal: LEDs are fully on when enabled
>  		Audio:  LEDs brightness depends on sound level
> diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/AB=
I/testing/sysfs-class-net
> index 3b404577f380..7670012ae9b6 100644
> --- a/Documentation/ABI/testing/sysfs-class-net
> +++ b/Documentation/ABI/testing/sysfs-class-net
> @@ -4,10 +4,13 @@ KernelVersion:	3.17
>  Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates the name assignment type. Possible values are:
> -		1: enumerated by the kernel, possibly in an unpredictable way
> -		2: predictably named by the kernel
> -		3: named by userspace
> -		4: renamed
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		1  enumerated by the kernel, possibly in an unpredictable way
> +		2  predictably named by the kernel
> +		3  named by userspace
> +		4  renamed
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/net/<iface>/addr_assign_type
>  Date:		July 2010
> @@ -15,10 +18,13 @@ KernelVersion:	3.2
>  Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates the address assignment type. Possible values are:
> -		0: permanent address
> -		1: randomly generated
> -		2: stolen from another device
> -		3: set using dev_set_mac_address
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  permanent address
> +		1  randomly generated
> +		2  stolen from another device
> +		3  set using dev_set_mac_address
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/net/<iface>/addr_len
>  Date:		April 2005
> @@ -51,9 +57,12 @@ Description:
>  		Default value 0 does not forward any link local frames.
> =20
>  		Restricted bits:
> -		0: 01-80-C2-00-00-00 Bridge Group Address used for STP
> -		1: 01-80-C2-00-00-01 (MAC Control) 802.3 used for MAC PAUSE
> -		2: 01-80-C2-00-00-02 (Link Aggregation) 802.3ad
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  01-80-C2-00-00-00 Bridge Group Address used for STP
> +		1  01-80-C2-00-00-01 (MAC Control) 802.3 used for MAC PAUSE
> +		2  01-80-C2-00-00-02 (Link Aggregation) 802.3ad
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		Any values not setting these bits can be used. Take special
>  		care when forwarding control frames e.g. 802.1X-PAE or LLDP.
> @@ -74,8 +83,11 @@ Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates the current physical link state of the interface.
>  		Posssible values are:
> -		0: physical link is down
> -		1: physical link is up
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  physical link is down
> +		1  physical link is up
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		Note: some special devices, e.g: bonding and team drivers will
>  		allow this attribute to be written to force a link state for
> @@ -131,8 +143,11 @@ Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates whether the interface is under test. Possible
>  		values are:
> -		0: interface is not being tested
> -		1: interface is being tested
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  interface is not being tested
> +		1  interface is being tested
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		When an interface is under test, it cannot be expected
>  		to pass packets as normal.
> @@ -144,8 +159,11 @@ Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates the interface latest or current duplex value. Possible
>  		values are:
> -		half: half duplex
> -		full: full duplex
> +
> +		=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		half  half duplex
> +		full  full duplex
> +		=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  		Note: This attribute is only valid for interfaces that implement
>  		the ethtool get_link_ksettings method (mostly Ethernet).
> @@ -196,8 +214,11 @@ Description:
>  		Indicates the interface link mode, as a decimal number. This
>  		attribute should be used in conjunction with 'dormant' attribute
>  		to determine the interface usability. Possible values:
> -		0: default link mode
> -		1: dormant link mode
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0   default link mode
> +		1   dormant link mode
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/class/net/<iface>/mtu
>  Date:		April 2005
> @@ -226,7 +247,9 @@ KernelVersion:	2.6.17
>  Contact:	netdev@vger.kernel.org
>  Description:
>  		Indicates the interface RFC2863 operational state as a string.
> +
>  		Possible values are:
> +
>  		"unknown", "notpresent", "down", "lowerlayerdown", "testing",
>  		"dormant", "up".
> =20
> diff --git a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm b/Document=
ation/ABI/testing/sysfs-class-net-cdc_ncm
> index f7be0e88b139..06416d0e163d 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
> +++ b/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
> @@ -91,9 +91,9 @@ Date:		May 2014
>  KernelVersion:	3.16
>  Contact:	Bj=C3=B8rn Mork <bjorn@mork.no>
>  Description:
> -		Bit 0: 16-bit NTB supported (set to 1)
> -		Bit 1: 32-bit NTB supported
> -		Bits 2 =E2=80=93 15: reserved (reset to zero; must be ignored by host)
> +		- Bit 0: 16-bit NTB supported (set to 1)
> +		- Bit 1: 32-bit NTB supported
> +		- Bits 2 =E2=80=93 15: reserved (reset to zero; must be ignored by hos=
t)
> =20
>  What:		/sys/class/net/<iface>/cdc_ncm/dwNtbInMaxSize
>  Date:		May 2014
> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documenta=
tion/ABI/testing/sysfs-class-net-phydev
> index 206cbf538b59..40ced0ea4316 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
> @@ -35,7 +35,9 @@ Description:
>  		Ethernet driver during bus enumeration, encoded in string.
>  		This interface mode is used to configure the Ethernet MAC with the
>  		appropriate mode for its data lines to the PHY hardware.
> +
>  		Possible values are:
> +
>  		<empty> (not available), mii, gmii, sgmii, tbi, rev-mii,
>  		rmii, rgmii, rgmii-id, rgmii-rxid, rgmii-txid, rtbi, smii
>  		xgmii, moca, qsgmii, trgmii, 1000base-x, 2500base-x, rxaui,
> diff --git a/Documentation/ABI/testing/sysfs-class-pktcdvd b/Documentatio=
n/ABI/testing/sysfs-class-pktcdvd
> index dde4f26d0780..ba1ce626591d 100644
> --- a/Documentation/ABI/testing/sysfs-class-pktcdvd
> +++ b/Documentation/ABI/testing/sysfs-class-pktcdvd
> @@ -11,15 +11,17 @@ KernelVersion:	2.6.20
>  Contact:	Thomas Maier <balagi@justmail.de>
>  Description:
> =20
> -		add:		(WO) Write a block device id (major:minor) to
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +		add		(WO) Write a block device id (major:minor) to
>  				create a new pktcdvd device and map it to the
>  				block device.
> =20
> -		remove:		(WO) Write the pktcdvd device id (major:minor)
> +		remove		(WO) Write the pktcdvd device id (major:minor)
>  				to remove the pktcdvd device.
> =20
> -		device_map:	(RO) Shows the device mapping in format:
> +		device_map	(RO) Shows the device mapping in format:
>  				pktcdvd[0-7] <pktdevid> <blkdevid>
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
>  What:		/sys/class/pktcdvd/pktcdvd[0-7]/dev
> @@ -65,29 +67,31 @@ Date:		Oct. 2006
>  KernelVersion:	2.6.20
>  Contact:	Thomas Maier <balagi@justmail.de>
>  Description:
> -		size:		(RO) Contains the size of the bio write queue.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		size		(RO) Contains the size of the bio write queue.
> =20
> -		congestion_off:	(RW) If bio write queue size is below this mark,
> +		congestion_off	(RW) If bio write queue size is below this mark,
>  				accept new bio requests from the block layer.
> =20
> -		congestion_on:	(RW) If bio write queue size is higher as this
> +		congestion_on	(RW) If bio write queue size is higher as this
>  				mark, do no longer accept bio write requests
>  				from the block layer and wait till the pktcdvd
>  				device has processed enough bio's so that bio
>  				write queue size is below congestion off mark.
>  				A value of <=3D 0 disables congestion control.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
>  Example:
>  --------
> -To use the pktcdvd sysfs interface directly, you can do:
> +To use the pktcdvd sysfs interface directly, you can do::
> =20
> -# create a new pktcdvd device mapped to /dev/hdc
> -echo "22:0" >/sys/class/pktcdvd/add
> -cat /sys/class/pktcdvd/device_map
> -# assuming device pktcdvd0 was created, look at stat's
> -cat /sys/class/pktcdvd/pktcdvd0/stat/kb_written
> -# print the device id of the mapped block device
> -fgrep pktcdvd0 /sys/class/pktcdvd/device_map
> -# remove device, using pktcdvd0 device id   253:0
> -echo "253:0" >/sys/class/pktcdvd/remove
> +    # create a new pktcdvd device mapped to /dev/hdc
> +    echo "22:0" >/sys/class/pktcdvd/add
> +    cat /sys/class/pktcdvd/device_map
> +    # assuming device pktcdvd0 was created, look at stat's
> +    cat /sys/class/pktcdvd/pktcdvd0/stat/kb_written
> +    # print the device id of the mapped block device
> +    fgrep pktcdvd0 /sys/class/pktcdvd/device_map
> +    # remove device, using pktcdvd0 device id   253:0
> +    echo "253:0" >/sys/class/pktcdvd/remove
> diff --git a/Documentation/ABI/testing/sysfs-class-power b/Documentation/=
ABI/testing/sysfs-class-power
> index d4319a04c302..d68ad528a8e5 100644
> --- a/Documentation/ABI/testing/sysfs-class-power
> +++ b/Documentation/ABI/testing/sysfs-class-power
> @@ -43,7 +43,9 @@ Date:		May 2007
>  Contact:	linux-pm@vger.kernel.org
>  Description:
>  		Fine grain representation of battery capacity.
> +
>  		Access: Read
> +
>  		Valid values: 0 - 100 (percent)
> =20
>  What:		/sys/class/power_supply/<supply_name>/capacity_alert_max
> @@ -58,6 +60,7 @@ Description:
>  		low).
> =20
>  		Access: Read, Write
> +
>  		Valid values: 0 - 100 (percent)
> =20
>  What:		/sys/class/power_supply/<supply_name>/capacity_alert_min
> @@ -88,6 +91,7 @@ Description:
>  		completely useless.
> =20
>  		Access: Read
> +
>  		Valid values: 0 - 100 (percent)
> =20
>  What:		/sys/class/power_supply/<supply_name>/capacity_level
> @@ -111,6 +115,7 @@ Description:
>  		which they average readings to smooth out the reported value.
> =20
>  		Access: Read
> +
>  		Valid values: Represented in microamps. Negative values are used
>  		for discharging batteries, positive values for charging batteries.
> =20
> @@ -131,6 +136,7 @@ Description:
>  		This value is not averaged/smoothed.
> =20
>  		Access: Read
> +
>  		Valid values: Represented in microamps. Negative values are used
>  		for discharging batteries, positive values for charging batteries.
> =20
> @@ -383,7 +389,7 @@ Description:
> =20
>  **USB Properties**
> =20
> -What: 		/sys/class/power_supply/<supply_name>/current_avg
> +What:		/sys/class/power_supply/<supply_name>/current_avg
>  Date:		May 2007
>  Contact:	linux-pm@vger.kernel.org
>  Description:
> @@ -449,6 +455,7 @@ Description:
>  		solved using power limit use input_voltage_limit.
> =20
>  		Access: Read, Write
> +
>  		Valid values: Represented in microvolts
> =20
>  What:		/sys/class/power_supply/<supply_name>/input_power_limit
> @@ -462,6 +469,7 @@ Description:
>  		limit only for problems that can be solved using power limit.
> =20
>  		Access: Read, Write
> +
>  		Valid values: Represented in microwatts
> =20
>  What:		/sys/class/power_supply/<supply_name>/online,
> @@ -747,6 +755,7 @@ Description:
>  		manufactured.
> =20
>  		Access: Read
> +
>  		Valid values: Reported as integer
> =20
>  What:		/sys/class/power_supply/<supply_name>/manufacture_month
> @@ -756,6 +765,7 @@ Description:
>  		Reports the month when the device has been manufactured.
> =20
>  		Access: Read
> +
>  		Valid values: 1-12
> =20
>  What:		/sys/class/power_supply/<supply_name>/manufacture_day
> diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documen=
tation/ABI/testing/sysfs-class-power-mp2629
> index 327a07e22805..914d67caac0d 100644
> --- a/Documentation/ABI/testing/sysfs-class-power-mp2629
> +++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
> @@ -5,4 +5,5 @@ Description:
>  		Represents a battery impedance compensation to accelerate charging.
> =20
>                  Access: Read, Write
> +
>                  Valid values: Represented in milli-ohms. Valid range is =
[0, 140].
> diff --git a/Documentation/ABI/testing/sysfs-class-power-twl4030 b/Docume=
ntation/ABI/testing/sysfs-class-power-twl4030
> index 7ac36dba87bc..b52f7023f8ba 100644
> --- a/Documentation/ABI/testing/sysfs-class-power-twl4030
> +++ b/Documentation/ABI/testing/sysfs-class-power-twl4030
> @@ -6,9 +6,9 @@ Description:
>  	Possible values are:
> =20
>  		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> -		"auto" 		draw power as appropriate for detected
> +		"auto"		draw power as appropriate for detected
>  				power source and battery status.
> -		"off"  		do not draw any power.
> +		"off"		do not draw any power.
>  		"continuous"	activate mode described as "linear" in
>  				TWL data sheets.  This uses whatever
>  				current is available and doesn't switch off
> diff --git a/Documentation/ABI/testing/sysfs-class-rapidio b/Documentatio=
n/ABI/testing/sysfs-class-rapidio
> index 8716beeb16c1..19aefb21b639 100644
> --- a/Documentation/ABI/testing/sysfs-class-rapidio
> +++ b/Documentation/ABI/testing/sysfs-class-rapidio
> @@ -6,6 +6,7 @@ Description:
>  		The /sys/class/rapidio_port subdirectory contains individual
>  		subdirectories named as "rapidioN" where N =3D mport ID registered
>  		with RapidIO subsystem.
> +
>  		NOTE: An mport ID is not a RapidIO destination ID assigned to a
>  		given local mport device.
> =20
> @@ -16,7 +17,9 @@ Contact:	Matt Porter <mporter@kernel.crashing.org>,
>  		Alexandre Bounine <alexandre.bounine@idt.com>
>  Description:
>  		(RO) reports RapidIO common transport system size:
> +
>  		0 =3D small (8-bit destination ID, max. 256 devices),
> +
>  		1 =3D large (16-bit destination ID, max. 65536 devices).
> =20
>  What:		/sys/class/rapidio_port/rapidioN/port_destid
> @@ -25,31 +28,32 @@ KernelVersion:	v3.15
>  Contact:	Matt Porter <mporter@kernel.crashing.org>,
>  		Alexandre Bounine <alexandre.bounine@idt.com>
>  Description:
> -		(RO) reports RapidIO destination ID assigned to the given
> -		RapidIO mport device. If value 0xFFFFFFFF is returned this means
> -		that no valid destination ID have been assigned to the mport
> -		(yet). Normally, before enumeration/discovery have been executed
> -		only fabric enumerating mports have a valid destination ID
> -		assigned to them using "hdid=3D..." rapidio module parameter.
> +
> +(RO) reports RapidIO destination ID assigned to the given
> +RapidIO mport device. If value 0xFFFFFFFF is returned this means
> +that no valid destination ID have been assigned to the mport
> +(yet). Normally, before enumeration/discovery have been executed
> +only fabric enumerating mports have a valid destination ID
> +assigned to them using "hdid=3D..." rapidio module parameter.
> =20
>  After enumeration or discovery was performed for a given mport device,
>  the corresponding subdirectory will also contain subdirectories for each
>  child RapidIO device connected to the mport.
> =20
>  The example below shows mport device subdirectory with several child Rap=
idIO
> -devices attached to it.
> +devices attached to it::
> =20
> -[rio@rapidio ~]$ ls /sys/class/rapidio_port/rapidio0/ -l
> -total 0
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0001
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0004
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0007
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0002
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0003
> -drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0005
> -lrwxrwxrwx 1 root root    0 Feb 11 15:11 device -> ../../../0000:01:00.0
> --r--r--r-- 1 root root 4096 Feb 11 15:11 port_destid
> -drwxr-xr-x 2 root root    0 Feb 11 15:11 power
> -lrwxrwxrwx 1 root root    0 Feb 11 15:04 subsystem -> ../../../../../../=
class/rapidio_port
> --r--r--r-- 1 root root 4096 Feb 11 15:11 sys_size
> --rw-r--r-- 1 root root 4096 Feb 11 15:04 uevent
> +    [rio@rapidio ~]$ ls /sys/class/rapidio_port/rapidio0/ -l
> +    total 0
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0001
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0004
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:e:0007
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0002
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0003
> +    drwxr-xr-x 3 root root    0 Feb 11 15:10 00:s:0005
> +    lrwxrwxrwx 1 root root    0 Feb 11 15:11 device -> ../../../0000:01:=
00.0
> +    -r--r--r-- 1 root root 4096 Feb 11 15:11 port_destid
> +    drwxr-xr-x 2 root root    0 Feb 11 15:11 power
> +    lrwxrwxrwx 1 root root    0 Feb 11 15:04 subsystem -> ../../../../..=
/../class/rapidio_port
> +    -r--r--r-- 1 root root 4096 Feb 11 15:11 sys_size
> +    -rw-r--r-- 1 root root 4096 Feb 11 15:04 uevent
> diff --git a/Documentation/ABI/testing/sysfs-class-regulator b/Documentat=
ion/ABI/testing/sysfs-class-regulator
> index bc578bc60628..8516f08806dd 100644
> --- a/Documentation/ABI/testing/sysfs-class-regulator
> +++ b/Documentation/ABI/testing/sysfs-class-regulator
> @@ -35,13 +35,13 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -			off
> -			on
> -			error
> -			fast
> -			normal
> -			idle
> -			standby
> +			- off
> +			- on
> +			- error
> +			- fast
> +			- normal
> +			- idle
> +			- standby
> =20
>  		"off" means the regulator is not supplying power to the
>  		system.
> @@ -74,9 +74,9 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -		'voltage'
> -		'current'
> -		'unknown'
> +		- 'voltage'
> +		- 'current'
> +		- 'unknown'
> =20
>  		'voltage' means the regulator output voltage can be controlled
>  		by software.
> @@ -129,11 +129,11 @@ Description:
> =20
>  		The opmode value can be one of the following strings:
> =20
> -		'fast'
> -		'normal'
> -		'idle'
> -		'standby'
> -		'unknown'
> +		- 'fast'
> +		- 'normal'
> +		- 'idle'
> +		- 'standby'
> +		- 'unknown'
> =20
>  		The modes are described in include/linux/regulator/consumer.h
> =20
> @@ -360,9 +360,9 @@ Description:
> =20
>  		This will be one of the following strings:
> =20
> -		'enabled'
> -		'disabled'
> -		'unknown'
> +		- 'enabled'
> +		- 'disabled'
> +		- 'unknown'
> =20
>  		'enabled' means the regulator is in bypass mode.
> =20
> diff --git a/Documentation/ABI/testing/sysfs-class-remoteproc b/Documenta=
tion/ABI/testing/sysfs-class-remoteproc
> index 066b9b6f4924..0c9ee55098b8 100644
> --- a/Documentation/ABI/testing/sysfs-class-remoteproc
> +++ b/Documentation/ABI/testing/sysfs-class-remoteproc
> @@ -16,11 +16,11 @@ Description:	Remote processor state
> =20
>  		Reports the state of the remote processor, which will be one of:
> =20
> -		"offline"
> -		"suspended"
> -		"running"
> -		"crashed"
> -		"invalid"
> +		- "offline"
> +		- "suspended"
> +		- "running"
> +		- "crashed"
> +		- "invalid"
> =20
>  		"offline" means the remote processor is powered off.
> =20
> @@ -38,8 +38,8 @@ Description:	Remote processor state
>  		Writing this file controls the state of the remote processor.
>  		The following states can be written:
> =20
> -		"start"
> -		"stop"
> +		- "start"
> +		- "stop"
> =20
>  		Writing "start" will attempt to start the processor running the
>  		firmware indicated by, or written to,
> diff --git a/Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_ca=
libration b/Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calib=
ration
> index ec950c93e5c6..ee8ed6494a01 100644
> --- a/Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calibrati=
on
> +++ b/Documentation/ABI/testing/sysfs-class-rtc-rtc0-device-rtc_calibrati=
on
> @@ -7,6 +7,7 @@ Description:    Attribute for calibrating ST-Ericsson AB8=
500 Real Time Clock
>                  calibrate the AB8500.s 32KHz Real Time Clock.
>                  Every 60 seconds the AB8500 will correct the RTC's value
>                  by adding to it the value of this attribute.
> +
>                  The range of the attribute is -127 to +127 in units of
>                  30.5 micro-seconds (half-parts-per-million of the 32KHz =
clock)
>  Users:          The /vendor/st-ericsson/base_utilities/core/rtc_calibrat=
ion
> diff --git a/Documentation/ABI/testing/sysfs-class-uwb_rc b/Documentation=
/ABI/testing/sysfs-class-uwb_rc
> index a0578751c1e3..6c5dcad21e19 100644
> --- a/Documentation/ABI/testing/sysfs-class-uwb_rc
> +++ b/Documentation/ABI/testing/sysfs-class-uwb_rc
> @@ -66,11 +66,14 @@ Description:
>                  <channel> <type> [<bpst offset>]
> =20
>                  to start (or stop) scanning on a channel.  <type> is one=
 of:
> -                    0 - scan
> -                    1 - scan outside BP
> -                    2 - scan while inactive
> -                    3 - scanning disabled
> -                    4 - scan (with start time of <bpst offset>)
> +
> +		   =3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +                    0   scan
> +                    1   scan outside BP
> +                    2   scan while inactive
> +                    3   scanning disabled
> +                    4   scan (with start time of <bpst offset>)
> +		   =3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:           /sys/class/uwb_rc/uwbN/mac_address
>  Date:           July 2008
> diff --git a/Documentation/ABI/testing/sysfs-class-watchdog b/Documentati=
on/ABI/testing/sysfs-class-watchdog
> index 9860a8b2ba75..585caecda3a5 100644
> --- a/Documentation/ABI/testing/sysfs-class-watchdog
> +++ b/Documentation/ABI/testing/sysfs-class-watchdog
> @@ -91,10 +91,13 @@ Description:
>  		h/w strapping (for WDT2 only).
> =20
>  		At alternate flash the 'access_cs0' sysfs node provides:
> -			ast2400: a way to get access to the primary SPI flash
> +
> +			ast2400:
> +				a way to get access to the primary SPI flash
>  				chip at CS0 after booting from the alternate
>  				chip at CS1.
> -			ast2500: a way to restore the normal address mapping
> +			ast2500:
> +				a way to restore the normal address mapping
>  				from (CS0->CS1, CS1->CS0) to (CS0->CS0,
>  				CS1->CS1).
> =20
> diff --git a/Documentation/ABI/testing/sysfs-dev b/Documentation/ABI/test=
ing/sysfs-dev
> index a9f2b8b0530f..d1739063e762 100644
> --- a/Documentation/ABI/testing/sysfs-dev
> +++ b/Documentation/ABI/testing/sysfs-dev
> @@ -9,9 +9,10 @@ Description:	The /sys/dev tree provides a method to look=
 up the sysfs
>  		the form "<major>:<minor>".  These links point to the
>  		corresponding sysfs path for the given device.
> =20
> -		Example:
> -		$ readlink /sys/dev/block/8:32
> -		../../block/sdc
> +		Example::
> +
> +		  $ readlink /sys/dev/block/8:32
> +		  ../../block/sdc
> =20
>  		Entries in /sys/dev/char and /sys/dev/block will be
>  		dynamically created and destroyed as devices enter and
> diff --git a/Documentation/ABI/testing/sysfs-devices-mapping b/Documentat=
ion/ABI/testing/sysfs-devices-mapping
> index 490ccfd67f12..8d202bac9394 100644
> --- a/Documentation/ABI/testing/sysfs-devices-mapping
> +++ b/Documentation/ABI/testing/sysfs-devices-mapping
> @@ -8,26 +8,27 @@ Description:
>                  block.
>                  For example, on 4-die Xeon platform with up to 6 IIO sta=
cks per
>                  die and, therefore, 6 IIO PMON blocks per die, the mappi=
ng of
> -                IIO PMON block 0 exposes as the following:
> +                IIO PMON block 0 exposes as the following::
> =20
> -                $ ls /sys/devices/uncore_iio_0/die*
> -                -r--r--r-- /sys/devices/uncore_iio_0/die0
> -                -r--r--r-- /sys/devices/uncore_iio_0/die1
> -                -r--r--r-- /sys/devices/uncore_iio_0/die2
> -                -r--r--r-- /sys/devices/uncore_iio_0/die3
> +		    $ ls /sys/devices/uncore_iio_0/die*
> +		    -r--r--r-- /sys/devices/uncore_iio_0/die0
> +		    -r--r--r-- /sys/devices/uncore_iio_0/die1
> +		    -r--r--r-- /sys/devices/uncore_iio_0/die2
> +		    -r--r--r-- /sys/devices/uncore_iio_0/die3
> =20
> -                $ tail /sys/devices/uncore_iio_0/die*
> -                =3D=3D> /sys/devices/uncore_iio_0/die0 <=3D=3D =20
> -                0000:00
> -                =3D=3D> /sys/devices/uncore_iio_0/die1 <=3D=3D =20
> -                0000:40
> -                =3D=3D> /sys/devices/uncore_iio_0/die2 <=3D=3D =20
> -                0000:80
> -                =3D=3D> /sys/devices/uncore_iio_0/die3 <=3D=3D =20
> -                0000:c0
> +		    $ tail /sys/devices/uncore_iio_0/die*
> +		    =3D=3D> /sys/devices/uncore_iio_0/die0 <=3D=3D
> +		    0000:00
> +		    =3D=3D> /sys/devices/uncore_iio_0/die1 <=3D=3D
> +		    0000:40
> +		    =3D=3D> /sys/devices/uncore_iio_0/die2 <=3D=3D
> +		    0000:80
> +		    =3D=3D> /sys/devices/uncore_iio_0/die3 <=3D=3D
> +		    0000:c0
> =20
> -                Which means:
> -                IIO PMU 0 on die 0 belongs to PCI RP on bus 0x00, domain=
 0x0000
> -                IIO PMU 0 on die 1 belongs to PCI RP on bus 0x40, domain=
 0x0000
> -                IIO PMU 0 on die 2 belongs to PCI RP on bus 0x80, domain=
 0x0000
> -                IIO PMU 0 on die 3 belongs to PCI RP on bus 0xc0, domain=
 0x0000
> +                Which means::
> +
> +		    IIO PMU 0 on die 0 belongs to PCI RP on bus 0x00, domain 0x0000
> +		    IIO PMU 0 on die 1 belongs to PCI RP on bus 0x40, domain 0x0000
> +		    IIO PMU 0 on die 2 belongs to PCI RP on bus 0x80, domain 0x0000
> +		    IIO PMU 0 on die 3 belongs to PCI RP on bus 0xc0, domain 0x0000
> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentati=
on/ABI/testing/sysfs-devices-memory
> index deef3b5723cf..2da2b1fba2c1 100644
> --- a/Documentation/ABI/testing/sysfs-devices-memory
> +++ b/Documentation/ABI/testing/sysfs-devices-memory
> @@ -47,16 +47,19 @@ Description:
>  		online/offline state of the memory section.  When written,
>  		root can toggle the the online/offline state of a removable
>  		memory section (see removable file description above)
> -		using the following commands.
> -		# echo online > /sys/devices/system/memory/memoryX/state
> -		# echo offline > /sys/devices/system/memory/memoryX/state
> +		using the following commands::
> +
> +		  # echo online > /sys/devices/system/memory/memoryX/state
> +		  # echo offline > /sys/devices/system/memory/memoryX/state
> =20
>  		For example, if /sys/devices/system/memory/memory22/removable
>  		contains a value of 1 and
>  		/sys/devices/system/memory/memory22/state contains the
>  		string "online" the following command can be executed by
> -		by root to offline that section.
> -		# echo offline > /sys/devices/system/memory/memory22/state
> +		by root to offline that section::
> +
> +		  # echo offline > /sys/devices/system/memory/memory22/state
> +
>  Users:		hotplug memory remove tools
>  		http://www.ibm.com/developerworks/wikis/display/LinuxP/powerpc-utils
> =20
> @@ -78,6 +81,7 @@ Description:
> =20
>  		For example, the following symbolic link is created for
>  		memory section 9 on node0:
> +
>  		/sys/devices/system/memory/memory9/node0 -> ../../node/node0
> =20
> =20
> @@ -90,4 +94,5 @@ Description:
>  		points to the corresponding /sys/devices/system/memory/memoryY
>  		memory section directory.  For example, the following symbolic
>  		link is created for memory section 9 on node0.
> +
>  		/sys/devices/system/node/node0/memory9 -> ../../memory/memory9
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadge=
t b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> index d548eaac230a..40f29a01fd14 100644
> --- a/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> @@ -3,8 +3,9 @@ Date:		April 2010
>  Contact:	Fabien Chouteau <fabien.chouteau@barco.com>
>  Description:
>  		Show the suspend state of an USB composite gadget.
> -		1 -> suspended
> -		0 -> resumed
> +
> +		- 1 -> suspended
> +		- 0 -> resumed
> =20
>  		(_UDC_ is the name of the USB Device Controller driver)
> =20
> @@ -17,5 +18,6 @@ Description:
>  		Storage mode.
> =20
>  		Possible values are:
> -			1 -> ignore the FUA flag
> -			0 -> obey the FUA flag
> +
> +			- 1 -> ignore the FUA flag
> +			- 0 -> obey the FUA flag
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-ipmi b/Docu=
mentation/ABI/testing/sysfs-devices-platform-ipmi
> index afb5db856e1c..07df0ddc0b69 100644
> --- a/Documentation/ABI/testing/sysfs-devices-platform-ipmi
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-ipmi
> @@ -123,38 +123,40 @@ KernelVersion:	v4.15
>  Contact:	openipmi-developer@lists.sourceforge.net
>  Description:
> =20
> -		idles:			(RO) Number of times the interface was
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		idles			(RO) Number of times the interface was
>  					idle while being polled.
> =20
> -		watchdog_pretimeouts:	(RO) Number of watchdog pretimeouts.
> +		watchdog_pretimeouts	(RO) Number of watchdog pretimeouts.
> =20
> -		complete_transactions:	(RO) Number of completed messages.
> +		complete_transactions	(RO) Number of completed messages.
> =20
> -		events:			(RO) Number of IPMI events received from
> +		events			(RO) Number of IPMI events received from
>  					the hardware.
> =20
> -		interrupts:		(RO) Number of interrupts the driver
> +		interrupts		(RO) Number of interrupts the driver
>  					handled.
> =20
> -		hosed_count:		(RO) Number of times the hardware didn't
> +		hosed_count		(RO) Number of times the hardware didn't
>  					follow the state machine.
> =20
> -		long_timeouts:		(RO) Number of times the driver
> +		long_timeouts		(RO) Number of times the driver
>  					requested a timer while nothing was in
>  					progress.
> =20
> -		flag_fetches:		(RO) Number of times the driver
> +		flag_fetches		(RO) Number of times the driver
>  					requested flags from the hardware.
> =20
> -		attentions:		(RO) Number of time the driver got an
> +		attentions		(RO) Number of time the driver got an
>  					ATTN from the hardware.
> =20
> -		incoming_messages:	(RO) Number of asynchronous messages
> +		incoming_messages	(RO) Number of asynchronous messages
>  					received.
> =20
> -		short_timeouts:		(RO) Number of times the driver
> +		short_timeouts		(RO) Number of times the driver
>  					requested a timer while an operation was
>  					in progress.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> =20
>  What:		/sys/devices/platform/ipmi_si.*/interrupts_enabled
> @@ -201,38 +203,40 @@ Date:		Sep, 2017
>  KernelVersion:	v4.15
>  Contact:	openipmi-developer@lists.sourceforge.net
>  Description:
> -		hosed:			(RO) Number of times the hardware didn't
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		hosed			(RO) Number of times the hardware didn't
>  					follow the state machine.
> =20
> -		alerts:			(RO) Number of alerts received.
> +		alerts			(RO) Number of alerts received.
> =20
> -		sent_messages:		(RO) Number of total messages sent.
> +		sent_messages		(RO) Number of total messages sent.
> =20
> -		sent_message_parts:	(RO) Number of message parts sent.
> +		sent_message_parts	(RO) Number of message parts sent.
>  					Messages may be broken into parts if
>  					they are long.
> =20
> -		received_messages:	(RO) Number of message responses
> +		received_messages	(RO) Number of message responses
>  					received.
> =20
> -		received_message_parts: (RO) Number of message fragments
> +		received_message_parts	(RO) Number of message fragments
>  					received.
> =20
> -		events:			(RO) Number of received events.
> +		events			(RO) Number of received events.
> =20
> -		watchdog_pretimeouts:	(RO) Number of watchdog pretimeouts.
> +		watchdog_pretimeouts	(RO) Number of watchdog pretimeouts.
> =20
> -		flag_fetches:		(RO) Number of times a flag fetch was
> +		flag_fetches		(RO) Number of times a flag fetch was
>  					requested.
> =20
> -		send_retries:		(RO) Number of time a message was
> +		send_retries		(RO) Number of time a message was
>  					retried.
> =20
> -		receive_retries:	(RO) Number of times the receive of a
> +		receive_retries		(RO) Number of times the receive of a
>  					message was retried.
> =20
> -		send_errors:		(RO) Number of times the send of a
> +		send_errors		(RO) Number of times the send of a
>  					message failed.
> =20
> -		receive_errors:		(RO) Number of errors in receiving
> +		receive_errors		(RO) Number of errors in receiving
>  					messages.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documen=
tation/ABI/testing/sysfs-devices-system-cpu
> index 274c337ec6a9..1a04ca8162ad 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -169,7 +169,7 @@ Description:
>  			      observed CPU idle duration was too short for it
>  			      (a count).
> =20
> -		below: 	 (RO) Number of times this state was entered, but the
> +		below:	 (RO) Number of times this state was entered, but the
>  			      observed CPU idle duration was too long for it
>  			      (a count).
>  		=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> @@ -601,7 +601,7 @@ Description:	Secure Virtual Machine
>  		Facility in POWER9 and newer processors. i.e., it is a Secure
>  		Virtual Machine.
> =20
> -What: 		/sys/devices/system/cpu/cpuX/purr
> +What:		/sys/devices/system/cpu/cpuX/purr
>  Date:		Apr 2005
>  Contact:	Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
>  Description:	PURR ticks for this CPU since the system boot.
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-lenovo b/Document=
ation/ABI/testing/sysfs-driver-hid-lenovo
> index 53a0725962e1..aee85ca1f6be 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-lenovo
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-lenovo
> @@ -3,14 +3,18 @@ Date:		July 2011
>  Contact:	linux-input@vger.kernel.org
>  Description:	This controls if mouse clicks should be generated if the tr=
ackpoint is quickly pressed. How fast this press has to be
>  		is being controlled by press_speed.
> +
>  		Values are 0 or 1.
> +
>  		Applies to Thinkpad USB Keyboard with TrackPoint.
> =20
>  What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface nu=
m>/<hid-bus>:<vendor-id>:<product-id>.<num>/dragging
>  Date:		July 2011
>  Contact:	linux-input@vger.kernel.org
>  Description:	If this setting is enabled, it is possible to do dragging b=
y pressing the trackpoint. This requires press_to_select to be enabled.
> +
>  		Values are 0 or 1.
> +
>  		Applies to Thinkpad USB Keyboard with TrackPoint.
> =20
>  What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface nu=
m>/<hid-bus>:<vendor-id>:<product-id>.<num>/release_to_select
> @@ -25,7 +29,9 @@ Date:		July 2011
>  Contact:	linux-input@vger.kernel.org
>  Description:	This setting controls if the mouse click events generated b=
y pressing the trackpoint (if press_to_select is enabled) generate
>  		a left or right mouse button click.
> +
>  		Values are 0 or 1.
> +
>  		Applies to Thinkpad USB Keyboard with TrackPoint.
> =20
>  What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface nu=
m>/<hid-bus>:<vendor-id>:<product-id>.<num>/sensitivity
> @@ -39,12 +45,16 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config=
 num>.<interface num>/<hid-
>  Date:		July 2011
>  Contact:	linux-input@vger.kernel.org
>  Description:	This setting controls how fast the trackpoint needs to be p=
ressed to generate a mouse click if press_to_select is enabled.
> +
>  		Values are decimal integers from 1 (slowest) to 255 (fastest).
> +
>  		Applies to Thinkpad USB Keyboard with TrackPoint.
> =20
>  What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface nu=
m>/<hid-bus>:<vendor-id>:<product-id>.<num>/fn_lock
>  Date:		July 2014
>  Contact:	linux-input@vger.kernel.org
>  Description:	This setting controls whether Fn Lock is enabled on the key=
board (i.e. if F1 is Mute or F1)
> +
>  		Values are 0 or 1
> +
>  		Applies to ThinkPad Compact (USB|Bluetooth) Keyboard with TrackPoint.
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-ntrig b/Documenta=
tion/ABI/testing/sysfs-driver-hid-ntrig
> index e574a5625efe..0e323a5cec6c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-ntrig
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-ntrig
> @@ -29,12 +29,13 @@ Contact:	linux-input@vger.kernel.org
>  Description:
>  		Threholds to override activation slack.
> =20
> -		activation_width:	(RW) Width threshold to immediately
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +		activation_width	(RW) Width threshold to immediately
>  					start processing touch events.
> =20
> -		activation_height:	(RW) Height threshold to immediately
> +		activation_height	(RW) Height threshold to immediately
>  					start processing touch events.
> -
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/hid/drivers/ntrig/<dev>/min_width
>  What:		/sys/bus/hid/drivers/ntrig/<dev>/min_height
> @@ -44,11 +45,13 @@ Contact:	linux-input@vger.kernel.org
>  Description:
>  		Minimum size contact accepted.
> =20
> -		min_width:	(RW) Minimum touch contact width to decide
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +		min_width	(RW) Minimum touch contact width to decide
>  				activation and activity.
> =20
> -		min_height:	(RW) Minimum touch contact height to decide
> +		min_height	(RW) Minimum touch contact height to decide
>  				activation and activity.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D	=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> =20
> =20
>  What:		/sys/bus/hid/drivers/ntrig/<dev>/sensor_physical_width
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Doc=
umentation/ABI/testing/sysfs-driver-hid-roccat-kone
> index 8f7982c70d72..11cd9bf0ad18 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
> @@ -3,17 +3,21 @@ Date:		March 2010
>  Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:	It is possible to switch the dpi setting of the mouse with =
the
>  		press of a button.
> +
>  		When read, this file returns the raw number of the actual dpi
>  		setting reported by the mouse. This number has to be further
>  		processed to receive the real dpi value:
> =20
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
>  		VALUE DPI
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
>  		1     800
>  		2     1200
>  		3     1600
>  		4     2000
>  		5     2400
>  		6     3200
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
> =20
>  		This file is readonly.
>  Users:		http://roccat.sourceforge.net
> @@ -22,6 +26,7 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config n=
um>.<interface num>/<hid-
>  Date:		March 2010
>  Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:	When read, this file returns the number of the actual profi=
le.
> +
>  		This file is readonly.
>  Users:		http://roccat.sourceforge.net
> =20
> @@ -33,6 +38,7 @@ Description:	When read, this file returns the raw integ=
er version number of the
>  		further usage in other programs. To receive the real version
>  		number the decimal point has to be shifted 2 positions to the
>  		left. E.g. a returned value of 138 means 1.38
> +
>  		This file is readonly.
>  Users:		http://roccat.sourceforge.net
> =20
> @@ -43,10 +49,13 @@ Description:	The mouse can store 5 profiles which can=
 be switched by the
>                  press of a button. A profile holds information like butt=
on
>                  mappings, sensitivity, the colors of the 5 leds and light
>                  effects.
> +
>                  When read, these files return the respective profile. The
>                  returned data is 975 bytes in size.
> +
>  		When written, this file lets one write the respective profile
>  		data back to the mouse. The data has to be 975 bytes long.
> +
>  		The mouse will reject invalid data, whereas the profile number
>  		stored in the profile doesn't need to fit the number of the
>  		store.
> @@ -58,6 +67,7 @@ Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:	When read, this file returns the settings stored in the mou=
se.
>  		The size of the data is 36 bytes and holds information like the
>  		startup_profile, tcu state and calibration_data.
> +
>  		When written, this file lets write settings back to the mouse.
>  		The data has to be 36 bytes long. The mouse will reject invalid
>  		data.
> @@ -67,8 +77,10 @@ What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config =
num>.<interface num>/<hid-
>  Date:		March 2010
>  Contact:	Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:	The integer value of this attribute ranges from 1 to 5.
> +
>                  When read, this attribute returns the number of the prof=
ile
>                  that's active when the mouse is powered on.
> +
>  		When written, this file sets the number of the startup profile
>  		and the mouse activates this profile immediately.
>  Users:		http://roccat.sourceforge.net
> @@ -80,9 +92,12 @@ Description:	The mouse has a "Tracking Control Unit" w=
hich lets the user
>  		calibrate the laser power to fit the mousepad surface.
>  		When read, this file returns the current state of the TCU,
>  		where 0 means off and 1 means on.
> +
>  		Writing 0 in this file will switch the TCU off.
> +
>  		Writing 1 in this file will start the calibration which takes
>  		around 6 seconds to complete and activates the TCU.
> +
>  Users:		http://roccat.sourceforge.net
> =20
>  What:		/sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<interface nu=
m>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/weight
> @@ -93,14 +108,18 @@ Description:	The mouse can be equipped with one of f=
our supplied weights
>  		and its value can be read out. When read, this file returns the
>  		raw value returned by the mouse which eases further processing
>  		in other software.
> +
>  		The values map to the weights as follows:
> =20
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
>  		VALUE WEIGHT
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
>  		0     none
>  		1     5g
>  		2     10g
>  		3     15g
>  		4     20g
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
> =20
>  		This file is readonly.
>  Users:		http://roccat.sourceforge.net
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-wiimote b/Documen=
tation/ABI/testing/sysfs-driver-hid-wiimote
> index cd7b82a5c27d..3bf43d9dcdfe 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-wiimote
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-wiimote
> @@ -20,6 +20,7 @@ Description:	This file contains the currently connected=
 and initialized
>  		the official Nintendo Nunchuck extension and classic is the
>  		Nintendo Classic Controller extension. The motionp extension can
>  		be combined with the other two.
> +
>  		Starting with kernel-version 3.11 Motion Plus hotplugging is
>  		supported and if detected, it's no longer reported as static
>  		extension. You will get uevent notifications for the motion-plus
> diff --git a/Documentation/ABI/testing/sysfs-driver-input-exc3000 b/Docum=
entation/ABI/testing/sysfs-driver-input-exc3000
> index 3d316d54f81c..cd7c578aef2c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-input-exc3000
> +++ b/Documentation/ABI/testing/sysfs-driver-input-exc3000
> @@ -4,6 +4,7 @@ Contact:	linux-input@vger.kernel.org
>  Description:    Reports the firmware version provided by the touchscreen=
, for example "00_T6" on a EXC80H60
> =20
>  		Access: Read
> +
>  		Valid values: Represented as string
> =20
>  What:		/sys/bus/i2c/devices/xxx/model
> @@ -12,4 +13,5 @@ Contact:	linux-input@vger.kernel.org
>  Description:    Reports the model identification provided by the touchsc=
reen, for example "Orion_1320" on a EXC80H60
> =20
>  		Access: Read
> +
>  		Valid values: Represented as string
> diff --git a/Documentation/ABI/testing/sysfs-driver-jz4780-efuse b/Docume=
ntation/ABI/testing/sysfs-driver-jz4780-efuse
> index bb6f5d6ceea0..4cf595d681e6 100644
> --- a/Documentation/ABI/testing/sysfs-driver-jz4780-efuse
> +++ b/Documentation/ABI/testing/sysfs-driver-jz4780-efuse
> @@ -4,7 +4,9 @@ Contact:	PrasannaKumar Muralidharan <prasannatsmkumar@gma=
il.com>
>  Description:	read-only access to the efuse on the Ingenic JZ4780 SoC
>  		The SoC has a one time programmable 8K efuse that is
>  		split into segments. The driver supports read only.
> -		The segments are
> +		The segments are:
> +
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>  		0x000   64 bit Random Number
>  		0x008  128 bit Ingenic Chip ID
>  		0x018  128 bit Customer ID
> @@ -12,5 +14,7 @@ Description:	read-only access to the efuse on the Ingen=
ic JZ4780 SoC
>  		0x1E0    8 bit Protect Segment
>  		0x1E1 2296 bit HDMI Key
>  		0x300 2048 bit Security boot key
> +		=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  Users:		any user space application which wants to read the Chip
>  		and Customer ID
> diff --git a/Documentation/ABI/testing/sysfs-driver-pciback b/Documentati=
on/ABI/testing/sysfs-driver-pciback
> index 73308c2b81b0..49f5fd0c8bbd 100644
> --- a/Documentation/ABI/testing/sysfs-driver-pciback
> +++ b/Documentation/ABI/testing/sysfs-driver-pciback
> @@ -7,8 +7,10 @@ Description:
>                  the format of DDDD:BB:DD.F-REG:SIZE:MASK will allow the =
guest
>                  to write and read from the PCI device. That is Domain:Bu=
s:
>                  Device.Function-Register:Size:Mask (Domain is optional).
> -                For example:
> -                #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/qui=
rks
> +                For example::
> +
> +                  #echo 00:19.0-E0:2:FF > /sys/bus/pci/drivers/pciback/q=
uirks
> +
>                  will allow the guest to read and write to the configurat=
ion
>                  register 0x0E.
> =20
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/A=
BI/testing/sysfs-driver-ufs
> index d1a352194d2e..adc0d0e91607 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -18,6 +18,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows the device type. This is one of the UFS
>  		device descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_class
> @@ -26,6 +27,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows the device class. This is one of the UFS
>  		device descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_sub_c=
lass
> @@ -34,6 +36,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows the UFS storage subclass. This is one of
>  		the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/protocol
> @@ -43,6 +46,7 @@ Description:	This file shows the protocol supported by =
an UFS device.
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_lu=
ns
> @@ -51,6 +55,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows number of logical units. This is one of
>  		the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_wl=
uns
> @@ -60,6 +65,7 @@ Description:	This file shows number of well known logic=
al units.
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/boot_enable
> @@ -69,6 +75,7 @@ Description:	This file shows value that indicates wheth=
er the device is
>  		enabled for boot. This is one of the UFS device descriptor
>  		parameters. The full information about the descriptor could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/descriptor_a=
ccess_enable
> @@ -79,6 +86,7 @@ Description:	This file shows value that indicates wheth=
er the device
>  		of the boot sequence. This is one of the UFS device descriptor
>  		parameters. The full information about the descriptor could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_powe=
r_mode
> @@ -88,6 +96,7 @@ Description:	This file shows value that defines the pow=
er mode after
>  		device initialization or hardware reset. This is one of
>  		the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/high_priorit=
y_lun
> @@ -96,6 +105,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.co=
m>
>  Description:	This file shows the high priority lun. This is one of
>  		the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/secure_remov=
al_type
> @@ -104,6 +114,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the secure removal type. This is one of
>  		the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/support_secu=
rity_lun
> @@ -113,6 +124,7 @@ Description:	This file shows whether the security lun=
 is supported.
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/bkops_termin=
ation_latency
> @@ -122,6 +134,7 @@ Description:	This file shows the background operation=
s termination
>  		latency. This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/initial_acti=
ve_icc_level
> @@ -130,6 +143,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the initial active ICC level. This is one
>  		of the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/specificatio=
n_version
> @@ -138,6 +152,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the specification version. This is one
>  		of the UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturin=
g_date
> @@ -147,6 +162,7 @@ Description:	This file shows the manufacturing date i=
n BCD format.
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/manufacturer=
_id
> @@ -155,6 +171,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the manufacturee ID. This is one of the
>  		UFS device descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtt_capabili=
ty
> @@ -164,6 +181,7 @@ Description:	This file shows the maximum number of ou=
tstanding RTTs
>  		supported by the device. This is one of the UFS device
>  		descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtc_update
> @@ -173,6 +191,7 @@ Description:	This file shows the frequency and method=
 of the realtime
>  		clock update. This is one of the UFS device descriptor
>  		parameters. The full information about the descriptor
>  		could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ufs_features
> @@ -182,6 +201,7 @@ Description:	This file shows which features are suppo=
rted by the device.
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be
>  		found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/ffu_timeout
> @@ -190,6 +210,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the FFU timeout. This is one of the
>  		UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/queue_depth
> @@ -198,6 +219,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the device queue depth. This is one of the
>  		UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/device_versi=
on
> @@ -206,6 +228,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the device version. This is one of the
>  		UFS device descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/number_of_se=
cure_wpa
> @@ -215,6 +238,7 @@ Description:	This file shows number of secure write p=
rotect areas
>  		supported by the device. This is one of the UFS device
>  		descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_max_data=
_size
> @@ -225,6 +249,7 @@ Description:	This file shows the maximum amount of da=
ta that may be
>  		This is one of the UFS device descriptor parameters.
>  		The full information about the descriptor could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_state_ti=
meout
> @@ -234,6 +259,7 @@ Description:	This file shows the command maximum time=
out for a change
>  		in PSA state. This is one of the UFS device descriptor
>  		parameters. The full information about the descriptor could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -244,6 +270,7 @@ Description:	This file shows the MIPI UniPro version =
number in BCD format.
>  		This is one of the UFS interconnect descriptor parameters.
>  		The full information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/interconnect_descriptor/mphy_v=
ersion
> @@ -253,6 +280,7 @@ Description:	This file shows the MIPI M-PHY version n=
umber in BCD format.
>  		This is one of the UFS interconnect descriptor parameters.
>  		The full information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -264,6 +292,7 @@ Description:	This file shows the total memory quantit=
y available to
>  		of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_number=
_of_luns
> @@ -273,6 +302,7 @@ Description:	This file shows the maximum number of lo=
gical units
>  		supported by the UFS device. This is one of the UFS
>  		geometry descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/segment_si=
ze
> @@ -281,6 +311,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the segment size. This is one of the UFS
>  		geometry descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/allocation=
_unit_size
> @@ -289,6 +320,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the allocation unit size. This is one of
>  		the UFS geometry descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/min_addres=
sable_block_size
> @@ -298,6 +330,7 @@ Description:	This file shows the minimum addressable =
block size. This
>  		is one of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at UFS
>  		specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/optimal_re=
ad_block_size
> @@ -307,6 +340,7 @@ Description:	This file shows the optimal read block s=
ize. This is one
>  		of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at UFS
>  		specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/optimal_wr=
ite_block_size
> @@ -316,6 +350,7 @@ Description:	This file shows the optimal write block =
size. This is one
>  		of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at UFS
>  		specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_in_buf=
fer_size
> @@ -325,6 +360,7 @@ Description:	This file shows the maximum data-in buff=
er size. This
>  		is one of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at UFS
>  		specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_out_bu=
ffer_size
> @@ -334,6 +370,7 @@ Description:	This file shows the maximum data-out buf=
fer size. This
>  		is one of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at UFS
>  		specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/rpmb_rw_si=
ze
> @@ -343,6 +380,7 @@ Description:	This file shows the maximum number of RP=
MB frames allowed
>  		in Security Protocol In/Out. This is one of the UFS geometry
>  		descriptor parameters. The full information about the
>  		descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/dyn_capaci=
ty_resource_policy
> @@ -352,6 +390,7 @@ Description:	This file shows the dynamic capacity res=
ource policy. This
>  		is one of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/data_order=
ing
> @@ -361,6 +400,7 @@ Description:	This file shows support for out-of-order=
 data transfer.
>  		This is one of the UFS geometry descriptor parameters.
>  		The full information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/max_number=
_of_contexts
> @@ -370,6 +410,7 @@ Description:	This file shows maximum available number=
 of contexts which
>  		are supported by the device. This is one of the UFS geometry
>  		descriptor parameters. The full information about the
>  		descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sys_data_t=
ag_unit_size
> @@ -378,6 +419,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows system data tag unit size. This is one of
>  		the UFS geometry descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sys_data_t=
ag_resource_size
> @@ -388,6 +430,7 @@ Description:	This file shows maximum storage area siz=
e allocated by
>  		This is one of the UFS geometry descriptor parameters.
>  		The full information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/secure_rem=
oval_types
> @@ -397,6 +440,7 @@ Description:	This file shows supported secure removal=
 types. This is
>  		one of the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/memory_typ=
es
> @@ -406,6 +450,7 @@ Description:	This file shows supported memory types. =
This is one of
>  		the UFS geometry descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_memory_m=
ax_alloc_units
> @@ -416,6 +461,7 @@ Description:	This file shows the maximum number of al=
location units for
>  		enhanced type 1-4). This is one of the UFS geometry
>  		descriptor parameters. The full information about the
>  		descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_memory_c=
apacity_adjustment_factor
> @@ -426,6 +472,7 @@ Description:	This file shows the memory capacity adju=
stment factor for
>  		enhanced type 1-4). This is one of the UFS geometry
>  		descriptor parameters. The full information about the
>  		descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -436,6 +483,7 @@ Description:	This file shows preend of life informati=
on. This is one
>  		of the UFS health descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/health_descriptor/life_time_es=
timation_a
> @@ -445,6 +493,7 @@ Description:	This file shows indication of the device=
 life time
>  		(method a). This is one of the UFS health descriptor
>  		parameters. The full information about the descriptor
>  		could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/health_descriptor/life_time_es=
timation_b
> @@ -454,6 +503,7 @@ Description:	This file shows indication of the device=
 life time
>  		(method b). This is one of the UFS health descriptor
>  		parameters. The full information about the descriptor
>  		could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -464,6 +514,7 @@ Description:	This file shows maximum VCC, VCCQ and VC=
CQ2 value for
>  		active ICC levels from 0 to 15. This is one of the UFS
>  		power descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -473,6 +524,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file contains a device manufactureer name string.
>  		The full information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_name
> @@ -480,6 +532,7 @@ Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file contains a product name string. The full informat=
ion
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem_id
> @@ -487,6 +540,7 @@ Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file contains a OEM ID string. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/serial_numb=
er
> @@ -495,6 +549,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file contains a device serial number string. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/string_descriptors/product_rev=
ision
> @@ -503,6 +558,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file contains a product revision string. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -512,6 +568,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows boot LUN information. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_write_protect
> @@ -520,6 +577,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows LUN write protection status. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_queue_depth
> @@ -528,6 +586,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows LUN queue depth. This is one of the UFS
>  		unit descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/psa_sensitive
> @@ -536,6 +595,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows PSA sensitivity. This is one of the UFS
>  		unit descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/lun_memory_type
> @@ -544,6 +604,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows LUN memory type. This is one of the UFS
>  		unit descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/data_reliability
> @@ -553,6 +614,7 @@ Description:	This file defines the device behavior wh=
en a power failure
>  		occurs during a write operation. This is one of the UFS
>  		unit descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/logical_block_size
> @@ -562,6 +624,7 @@ Description:	This file shows the size of addressable =
logical blocks
>  		(calculated as an exponent with base 2). This is one of
>  		the UFS unit descriptor parameters. The full information about
>  		the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/logical_block_cou=
nt
> @@ -571,6 +634,7 @@ Description:	This file shows total number of addressa=
ble logical blocks.
>  		This is one of the UFS unit descriptor parameters. The full
>  		information about the descriptor could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/erase_block_size
> @@ -579,6 +643,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the erase block size. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/provisioning_type
> @@ -587,6 +652,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the thin provisioning type. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/physical_memory_r=
esourse_count
> @@ -595,6 +661,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the total physical memory resources. This is
>  		one of the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/context_capabilit=
ies
> @@ -603,6 +670,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the context capabilities. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/large_unit_granul=
arity
> @@ -611,6 +679,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the granularity of the LUN. This is one of
>  		the UFS unit descriptor parameters. The full information
>  		about the descriptor could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -619,6 +688,7 @@ Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file shows the device init status. The full information
>  		about the flag could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/permanent_wpe
> @@ -627,6 +697,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether permanent write protection is enabl=
ed.
>  		The full information about the flag could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/power_on_wpe
> @@ -636,6 +707,7 @@ Description:	This file shows whether write protection=
 is enabled on all
>  		logical units configured as power on write protected. The
>  		full information about the flag could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/bkops_enable
> @@ -644,6 +716,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether the device background operations are
>  		enabled. The full information about the flag could be
>  		found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/life_span_mode_enable
> @@ -652,6 +725,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether the device life span mode is enable=
d.
>  		The full information about the flag could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/phy_resource_removal
> @@ -660,6 +734,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether physical resource removal is enable.
>  		The full information about the flag could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/busy_rtc
> @@ -668,6 +743,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether the device is executing internal
>  		operation related to real time clock. The full information
>  		about the flag could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/disable_fw_update
> @@ -676,6 +752,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows whether the device FW update is permanently
>  		disabled. The full information about the flag could be found
>  		at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -685,6 +762,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the boot lun enabled UFS device attribut=
e.
>  		The full information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/current_power_mode
> @@ -693,6 +771,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the current power mode UFS device attrib=
ute.
>  		The full information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_level
> @@ -701,6 +780,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the active icc level UFS device attribut=
e.
>  		The full information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_enabled
> @@ -709,6 +789,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the out of order data transfer enabled U=
FS
>  		device attribute. The full information about the attribute
>  		could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/bkops_status
> @@ -717,6 +798,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the background operations status UFS dev=
ice
>  		attribute. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/purge_status
> @@ -725,6 +807,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the purge operation status UFS device
>  		attribute. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in_size
> @@ -733,6 +816,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the maximum data size in a DATA IN
>  		UPIU. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/max_data_out_size
> @@ -741,6 +825,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file shows the maximum number of bytes that can be
>  		requested with a READY TO TRANSFER UPIU. The full information
>  		about the attribute could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/reference_clock_fre=
quency
> @@ -749,6 +834,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the reference clock frequency UFS device
>  		attribute. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/configuration_descr=
iptor_lock
> @@ -765,6 +851,7 @@ Description:	This file provides the maximum current n=
umber of
>  		outstanding RTTs in device that is allowed. The full
>  		information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_con=
trol
> @@ -773,6 +860,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the exception event control UFS device
>  		attribute. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/exception_event_sta=
tus
> @@ -781,6 +869,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the exception event status UFS device
>  		attribute. The full information about the attribute could
>  		be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
> @@ -789,6 +878,7 @@ Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.c=
om>
>  Description:	This file provides the ffu status UFS device attribute.
>  		The full information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_state
> @@ -796,6 +886,7 @@ Date:		February 2018
>  Contact:	Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:	This file show the PSA feature status. The full information
>  		about the attribute could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/psa_data_size
> @@ -805,6 +896,7 @@ Description:	This file shows the amount of data that =
the host plans to
>  		load to all logical units in pre-soldering state.
>  		The full information about the attribute could be found at
>  		UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -815,6 +907,7 @@ Description:	This file shows the The amount of physic=
al memory needed
>  		to be removed from the physical memory resources pool of
>  		the particular logical unit. The full information about
>  		the attribute could be found at UFS specifications 2.1.
> +
>  		The file is read only.
> =20
> =20
> @@ -824,24 +917,28 @@ Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		runtime power management level. The current driver
>  		implementation supports 6 levels with next target states:
> -		0 - an UFS device will stay active, an UIC link will
> -		stay active
> -		1 - an UFS device will stay active, an UIC link will
> -		hibernate
> -		2 - an UFS device will moved to sleep, an UIC link will
> -		stay active
> -		3 - an UFS device will moved to sleep, an UIC link will
> -		hibernate
> -		4 - an UFS device will be powered off, an UIC link will
> -		hibernate
> -		5 - an UFS device will be powered off, an UIC link will
> -		be powered off
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		0   an UFS device will stay active, an UIC link will
> +		    stay active
> +		1   an UFS device will stay active, an UIC link will
> +		    hibernate
> +		2   an UFS device will moved to sleep, an UIC link will
> +		    stay active
> +		3   an UFS device will moved to sleep, an UIC link will
> +		    hibernate
> +		4   an UFS device will be powered off, an UIC link will
> +		    hibernate
> +		5   an UFS device will be powered off, an UIC link will
> +		    be powered off
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
>  Date:		February 2018
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry shows the target power mode of an UFS device
>  		for the chosen runtime power management level.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/rpm_target_link_state
> @@ -849,6 +946,7 @@ Date:		February 2018
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry shows the target state of an UFS UIC link
>  		for the chosen runtime power management level.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_lvl
> @@ -857,24 +955,28 @@ Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry could be used to set or show the UFS device
>  		system power management level. The current driver
>  		implementation supports 6 levels with next target states:
> -		0 - an UFS device will stay active, an UIC link will
> -		stay active
> -		1 - an UFS device will stay active, an UIC link will
> -		hibernate
> -		2 - an UFS device will moved to sleep, an UIC link will
> -		stay active
> -		3 - an UFS device will moved to sleep, an UIC link will
> -		hibernate
> -		4 - an UFS device will be powered off, an UIC link will
> -		hibernate
> -		5 - an UFS device will be powered off, an UIC link will
> -		be powered off
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		0   an UFS device will stay active, an UIC link will
> +		    stay active
> +		1   an UFS device will stay active, an UIC link will
> +		    hibernate
> +		2   an UFS device will moved to sleep, an UIC link will
> +		    stay active
> +		3   an UFS device will moved to sleep, an UIC link will
> +		    hibernate
> +		4   an UFS device will be powered off, an UIC link will
> +		    hibernate
> +		5   an UFS device will be powered off, an UIC link will
> +		    be powered off
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
>  Date:		February 2018
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry shows the target power mode of an UFS device
>  		for the chosen system power management level.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/spm_target_link_state
> @@ -882,18 +984,21 @@ Date:		February 2018
>  Contact:	Subhash Jadavani <subhashj@codeaurora.org>
>  Description:	This entry shows the target state of an UFS UIC link
>  		for the chosen system power management level.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_presv_us_=
en
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows if preserve user-space was configured
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_shared_al=
loc_units
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the shared allocated units of WB buffer
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_type
> @@ -901,6 +1006,7 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the configured WB type.
>  		0x1 for shared buffer mode. 0x0 for dedicated buffer mode.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_buff_ca=
p_adj
> @@ -910,6 +1016,7 @@ Description:	This entry shows the total user-space d=
ecrease in shared
>  		buffer mode.
>  		The value of this parameter is 3 for TLC NAND when SLC mode
>  		is used as WriteBooster Buffer. 2 for MLC NAND.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_all=
oc_units
> @@ -917,6 +1024,7 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the Maximum total WriteBooster Buffer size
>  		which is supported by the entire device.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_max_wb_=
luns
> @@ -924,6 +1032,7 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the maximum number of luns that can support
>  		WriteBooster.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_red=
_type
> @@ -937,46 +1046,59 @@ Description:	The supportability of user space redu=
ction mode
>  		preserve user space type.
>  		02h: Device can be configured in either user space
>  		reduction type or preserve user space type.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb_sup_wb_=
type
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	The supportability of WriteBooster Buffer type.
> -		00h: LU based WriteBooster Buffer configuration
> -		01h: Single shared WriteBooster Buffer
> -		configuration
> -		02h: Supporting both LU based WriteBooster
> -		Buffer and Single shared WriteBooster Buffer
> -		configuration
> +
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		00h  LU based WriteBooster Buffer configuration
> +		01h  Single shared WriteBooster Buffer configuration
> +		02h  Supporting both LU based WriteBooster.
> +		     Buffer and Single shared WriteBooster Buffer configuration
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the status of WriteBooster.
> -		0: WriteBooster is not enabled.
> -		1: WriteBooster is enabled
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +		0  WriteBooster is not enabled.
> +		1  WriteBooster is enabled
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_en
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows if flush is enabled.
> -		0: Flush operation is not performed.
> -		1: Flush operation is performed.
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0  Flush operation is not performed.
> +		1  Flush operation is performed.
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_during_h8
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	Flush WriteBooster Buffer during hibernate state.
> -		0: Device is not allowed to flush the
> -		WriteBooster Buffer during link hibernate
> -		state.
> -		1: Device is allowed to flush the
> -		WriteBooster Buffer during link hibernate
> -		state
> +
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +		0  Device is not allowed to flush the
> +		   WriteBooster Buffer during link hibernate state.
> +		1  Device is allowed to flush the
> +		   WriteBooster Buffer during link hibernate state.
> +		=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_avail_buf
> @@ -984,23 +1106,30 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the amount of unused WriteBooster buffer
>  		available.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_buf
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the amount of unused current buffer.
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_flush_status
>  Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the flush operation status.
> -		00h: idle
> -		01h: Flush operation in progress
> -		02h: Flush operation stopped prematurely.
> -		03h: Flush operation completed successfully
> -		04h: Flush operation general failure
> +
> +
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		00h  idle
> +		01h  Flush operation in progress
> +		02h  Flush operation stopped prematurely.
> +		03h  Flush operation completed successfully
> +		04h  Flush operation general failure
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/bus/platform/drivers/ufshcd/*/attributes/wb_life_time_est
> @@ -1008,9 +1137,13 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows an indication of the WriteBooster Buffer
>  		lifetime based on the amount of performed program/erase cycles
> -		01h: 0% - 10% WriteBooster Buffer life time used
> +
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +		01h  0% - 10% WriteBooster Buffer life time used
>  		...
> -		0Ah: 90% - 100% WriteBooster Buffer life time used
> +		0Ah  90% - 100% WriteBooster Buffer life time used
> +		=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +
>  		The file is read only.
> =20
>  What:		/sys/class/scsi_device/*/device/unit_descriptor/wb_buf_alloc_units
> @@ -1018,4 +1151,5 @@ Date:		June 2020
>  Contact:	Asutosh Das <asutoshd@codeaurora.org>
>  Description:	This entry shows the configured size of WriteBooster buffer.
>  		0400h corresponds to 4GB.
> +
>  		The file is read only.
> diff --git a/Documentation/ABI/testing/sysfs-driver-w1_ds28e17 b/Document=
ation/ABI/testing/sysfs-driver-w1_ds28e17
> index d301e7017afe..e92aba4eb594 100644
> --- a/Documentation/ABI/testing/sysfs-driver-w1_ds28e17
> +++ b/Documentation/ABI/testing/sysfs-driver-w1_ds28e17
> @@ -5,7 +5,9 @@ Contact:	Jan Kandziora <jjj@gmx.de>
>  Description:	When written, this file sets the I2C speed on the connected
>  		DS28E17 chip. When read, it reads the current setting from
>  		the DS28E17 chip.
> +
>  		Valid values: 100, 400, 900 [kBaud].
> +
>  		Default 100, can be set by w1_ds28e17.speed=3D module parameter.
>  Users:		w1_ds28e17 driver
> =20
> @@ -17,5 +19,6 @@ Description:	When written, this file sets the multiplie=
r used to calculate
>  		the busy timeout for I2C operations on the connected DS28E17
>  		chip. When read, returns the current setting.
>  		Valid values: 1 to 9.
> +
>  		Default 1, can be set by w1_ds28e17.stretch=3D module parameter.
>  Users:		w1_ds28e17 driver
> diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentatio=
n/ABI/testing/sysfs-firmware-acpi
> index e4afc2538210..b16d30a71709 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-acpi
> +++ b/Documentation/ABI/testing/sysfs-firmware-acpi
> @@ -81,11 +81,11 @@ Description:
>  		  $ cd /sys/firmware/acpi/interrupts
>  		  $ grep . *
>  		  error:	     0
> -		  ff_gbl_lock:	   0   enable
> -		  ff_pmtimer:	  0  invalid
> -		  ff_pwr_btn:	  0   enable
> -		  ff_rt_clk:	 2  disable
> -		  ff_slp_btn:	  0  invalid
> +		  ff_gbl_lock:	     0   enable
> +		  ff_pmtimer:	     0  invalid
> +		  ff_pwr_btn:	     0   enable
> +		  ff_rt_clk:	     2  disable
> +		  ff_slp_btn:	     0  invalid
>  		  gpe00:	     0	invalid
>  		  gpe01:	     0	 enable
>  		  gpe02:	   108	 enable
> @@ -118,9 +118,9 @@ Description:
>  		  gpe1D:	     0	invalid
>  		  gpe1E:	     0	invalid
>  		  gpe1F:	     0	invalid
> -		  gpe_all:    1192
> -		  sci:	1194
> -		  sci_not:     0
> +		  gpe_all:	  1192
> +		  sci:		  1194
> +		  sci_not:	     0
> =20
>  		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>  		sci	     The number of times the ACPI SCI
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-esrt b/Document=
ation/ABI/testing/sysfs-firmware-efi-esrt
> index 6e431d1a4e79..31b57676d4ad 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-efi-esrt
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-esrt
> @@ -35,10 +35,13 @@ What:		/sys/firmware/efi/esrt/entries/entry$N/fw_type
>  Date:		February 2015
>  Contact:	Peter Jones <pjones@redhat.com>
>  Description:	What kind of firmware entry this is:
> -		0 - Unknown
> -		1 - System Firmware
> -		2 - Device Firmware
> -		3 - UEFI Driver
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0   Unknown
> +		1   System Firmware
> +		2   Device Firmware
> +		3   UEFI Driver
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/firmware/efi/esrt/entries/entry$N/fw_class
>  Date:		February 2015
> @@ -71,11 +74,14 @@ Date:		February 2015
>  Contact:	Peter Jones <pjones@redhat.com>
>  Description:	The result of the last firmware update attempt for the
>  		firmware resource entry.
> -		0 - Success
> -		1 - Insufficient resources
> -		2 - Incorrect version
> -		3 - Invalid format
> -		4 - Authentication error
> -		5 - AC power event
> -		6 - Battery power event
> +
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> +		0   Success
> +		1   Insufficient resources
> +		2   Incorrect version
> +		3   Invalid format
> +		4   Authentication error
> +		5   AC power event
> +		6   Battery power event
> +		=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D
> =20
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/D=
ocumentation/ABI/testing/sysfs-firmware-efi-runtime-map
> index c61b9b348e99..9c4d581be396 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> @@ -14,7 +14,7 @@ Description:	Switching efi runtime services to virtual =
mode requires
>  		/sys/firmware/efi/runtime-map/ is the directory the kernel
>  		exports that information in.
> =20
> -		subdirectories are named with the number of the memory range:
> +		subdirectories are named with the number of the memory range::
> =20
>  			/sys/firmware/efi/runtime-map/0
>  			/sys/firmware/efi/runtime-map/1
> @@ -24,11 +24,13 @@ Description:	Switching efi runtime services to virtua=
l mode requires
> =20
>  		Each subdirectory contains five files:
> =20
> -		attribute : The attributes of the memory range.
> -		num_pages : The size of the memory range in pages.
> -		phys_addr : The physical address of the memory range.
> -		type      : The type of the memory range.
> -		virt_addr : The virtual address of the memory range.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +		attribute   The attributes of the memory range.
> +		num_pages   The size of the memory range in pages.
> +		phys_addr   The physical address of the memory range.
> +		type        The type of the memory range.
> +		virt_addr   The virtual address of the memory range.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> =20
>  		Above values are all hexadecimal numbers with the '0x' prefix.
>  Users:		Kexec
> diff --git a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg b/Docum=
entation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> index 011dda4f8e8a..ee0d6dbc810e 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> +++ b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> @@ -15,7 +15,7 @@ Description:
>  		to the fw_cfg device can be found in "docs/specs/fw_cfg.txt"
>  		in the QEMU source tree.
> =20
> -		=3D=3D=3D SysFS fw_cfg Interface =3D=3D=3D
> +		**SysFS fw_cfg Interface**
> =20
>  		The fw_cfg sysfs interface described in this document is only
>  		intended to display discoverable blobs (i.e., those registered
> @@ -31,7 +31,7 @@ Description:
> =20
>  			/sys/firmware/qemu_fw_cfg/rev
> =20
> -		--- Discoverable fw_cfg blobs by selector key ---
> +		**Discoverable fw_cfg blobs by selector key**
> =20
>  		All discoverable blobs listed in the fw_cfg file directory are
>  		displayed as entries named after their unique selector key
> @@ -45,24 +45,26 @@ Description:
>  		Each such fw_cfg sysfs entry has the following values exported
>  		as attributes:
> =20
> -		name  	: The 56-byte nul-terminated ASCII string used as the
> +		=3D=3D=3D=3D	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		name	  The 56-byte nul-terminated ASCII string used as the
>  			  blob's 'file name' in the fw_cfg directory.
> -		size  	: The length of the blob, as given in the fw_cfg
> +		size	  The length of the blob, as given in the fw_cfg
>  			  directory.
> -		key	: The value of the blob's selector key as given in the
> +		key	  The value of the blob's selector key as given in the
>  			  fw_cfg directory. This value is the same as used in
>  			  the parent directory name.
> -		raw	: The raw bytes of the blob, obtained by selecting the
> +		raw	  The raw bytes of the blob, obtained by selecting the
>  			  entry via the control register, and reading a number
>  			  of bytes equal to the blob size from the data
>  			  register.
> +		=3D=3D=3D=3D	  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
> -		--- Listing fw_cfg blobs by file name ---
> +		**Listing fw_cfg blobs by file name**
> =20
>  		While the fw_cfg device does not impose any specific naming
>  		convention on the blobs registered in the file directory,
>  		QEMU developers have traditionally used path name semantics
> -		to give each blob a descriptive name. For example:
> +		to give each blob a descriptive name. For example::
> =20
>  			"bootorder"
>  			"genroms/kvmvapic.bin"
> @@ -81,7 +83,7 @@ Description:
>  		of directories matching the path name components of fw_cfg
>  		blob names, ending in symlinks to the by_key entry for each
>  		"basename", as illustrated below (assume current directory is
> -		/sys/firmware):
> +		/sys/firmware)::
> =20
>  		    qemu_fw_cfg/by_name/bootorder -> ../by_key/38
>  		    qemu_fw_cfg/by_name/etc/e820 -> ../../by_key/35
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sfi b/Documentation=
/ABI/testing/sysfs-firmware-sfi
> index 4be7d44aeacf..5210e0f06ddb 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-sfi
> +++ b/Documentation/ABI/testing/sysfs-firmware-sfi
> @@ -9,7 +9,7 @@ Description:
>  		http://simplefirmware.org/documentation
> =20
>  		While the tables are used by the kernel, user-space
> -		can observe them this way:
> +		can observe them this way::
> =20
> -		# cd /sys/firmware/sfi/tables
> -		# cat $TABLENAME > $TABLENAME.bin
> +		  # cd /sys/firmware/sfi/tables
> +		  # cat $TABLENAME > $TABLENAME.bin
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sgi_uv b/Documentat=
ion/ABI/testing/sysfs-firmware-sgi_uv
> index 4573fd4b7876..66800baab096 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-sgi_uv
> +++ b/Documentation/ABI/testing/sysfs-firmware-sgi_uv
> @@ -5,7 +5,7 @@ Description:
>  		The /sys/firmware/sgi_uv directory contains information
>  		about the SGI UV platform.
> =20
> -		Under that directory are a number of files:
> +		Under that directory are a number of files::
> =20
>  			partition_id
>  			coherence_id
> @@ -14,7 +14,7 @@ Description:
>  		SGI UV systems can be partitioned into multiple physical
>  		machines, which each partition running a unique copy
>  		of the operating system.  Each partition will have a unique
> -		partition id.  To display the partition id, use the command:
> +		partition id.  To display the partition id, use the command::
> =20
>  			cat /sys/firmware/sgi_uv/partition_id
> =20
> @@ -22,6 +22,6 @@ Description:
>  		A partitioned SGI UV system can have one or more coherence
>  		domain.  The coherence id indicates which coherence domain
>  		this partition is in.  To display the coherence id, use the
> -		command:
> +		command::
> =20
>  			cat /sys/firmware/sgi_uv/coherence_id
> diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/=
testing/sysfs-fs-f2fs
> index 834d0becae6d..67b3ed8e8c2f 100644
> --- a/Documentation/ABI/testing/sysfs-fs-f2fs
> +++ b/Documentation/ABI/testing/sysfs-fs-f2fs
> @@ -20,10 +20,13 @@ What:		/sys/fs/f2fs/<disk>/gc_idle
>  Date:		July 2013
>  Contact:	"Namjae Jeon" <namjae.jeon@samsung.com>
>  Description:	Controls the victim selection policy for garbage collection.
> -		Setting gc_idle =3D 0(default) will disable this option. Setting
> -		gc_idle =3D 1 will select the Cost Benefit approach & setting
> -		gc_idle =3D 2 will select the greedy approach & setting
> -		gc_idle =3D 3 will select the age-threshold based approach.
> +		Setting gc_idle =3D 0(default) will disable this option. Setting:
> +
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		gc_idle =3D 1  will select the Cost Benefit approach & setting
> +		gc_idle =3D 2  will select the greedy approach & setting
> +		gc_idle =3D 3  will select the age-threshold based approach.
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> =20
>  What:		/sys/fs/f2fs/<disk>/reclaim_segments
>  Date:		October 2013
> @@ -46,10 +49,17 @@ Date:		November 2013
>  Contact:	"Jaegeuk Kim" <jaegeuk.kim@samsung.com>
>  Description:	Controls the in-place-update policy.
>  		updates in f2fs. User can set:
> -		0x01: F2FS_IPU_FORCE, 0x02: F2FS_IPU_SSR,
> -		0x04: F2FS_IPU_UTIL,  0x08: F2FS_IPU_SSR_UTIL,
> -		0x10: F2FS_IPU_FSYNC, 0x20: F2FS_IPU_ASYNC,
> -		0x40: F2FS_IPU_NOCACHE.
> +
> +		=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +		0x01  F2FS_IPU_FORCE
> +		0x02  F2FS_IPU_SSR
> +		0x04  F2FS_IPU_UTIL
> +		0x08  F2FS_IPU_SSR_UTIL
> +		0x10  F2FS_IPU_FSYNC
> +		0x20  F2FS_IPU_ASYNC,
> +		0x40  F2FS_IPU_NOCACHE
> +		=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  		Refer segment.h for details.
> =20
>  What:		/sys/fs/f2fs/<disk>/min_ipu_util
> @@ -332,18 +342,28 @@ Date:		April 2020
>  Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
>  Description:	Give a way to attach REQ_META|FUA to data writes
>  		given temperature-based bits. Now the bits indicate:
> -		*      REQ_META     |      REQ_FUA      |
> -		*    5 |    4 |   3 |    2 |    1 |   0 |
> -		* Cold | Warm | Hot | Cold | Warm | Hot |
> +
> +		+-------------------+-------------------+
> +		|      REQ_META     |      REQ_FUA      |
> +		+------+------+-----+------+------+-----+
> +		|    5 |    4 |   3 |    2 |    1 |   0 |
> +		+------+------+-----+------+------+-----+
> +		| Cold | Warm | Hot | Cold | Warm | Hot |
> +		+------+------+-----+------+------+-----+
> =20
>  What:		/sys/fs/f2fs/<disk>/node_io_flag
>  Date:		June 2020
>  Contact:	"Jaegeuk Kim" <jaegeuk@kernel.org>
>  Description:	Give a way to attach REQ_META|FUA to node writes
>  		given temperature-based bits. Now the bits indicate:
> -		*      REQ_META     |      REQ_FUA      |
> -		*    5 |    4 |   3 |    2 |    1 |   0 |
> -		* Cold | Warm | Hot | Cold | Warm | Hot |
> +
> +		+-------------------+-------------------+
> +		|      REQ_META     |      REQ_FUA      |
> +		+------+------+-----+------+------+-----+
> +		|    5 |    4 |   3 |    2 |    1 |   0 |
> +		+------+------+-----+------+------+-----+
> +		| Cold | Warm | Hot | Cold | Warm | Hot |
> +		+------+------+-----+------+------+-----+
> =20
>  What:		/sys/fs/f2fs/<disk>/iostat_period_ms
>  Date:		April 2020
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-ksm b/Documentatio=
n/ABI/testing/sysfs-kernel-mm-ksm
> index dfc13244cda3..1c9bed5595f5 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-ksm
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-ksm
> @@ -34,8 +34,9 @@ Description:	Kernel Samepage Merging daemon sysfs inter=
face
>  		in a tree.
> =20
>  		run: write 0 to disable ksm, read 0 while ksm is disabled.
> -			write 1 to run ksm, read 1 while ksm is running.
> -			write 2 to disable ksm and unmerge all its pages.
> +
> +			- write 1 to run ksm, read 1 while ksm is running.
> +			- write 2 to disable ksm and unmerge all its pages.
> =20
>  		sleep_millisecs: how many milliseconds ksm should sleep between
>  		scans.
> diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/=
ABI/testing/sysfs-kernel-slab
> index ed35833ad7f0..c9f12baf8baa 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-slab
> +++ b/Documentation/ABI/testing/sysfs-kernel-slab
> @@ -346,6 +346,7 @@ Description:
>  		number of objects per slab.  If a slab cannot be allocated
>  		because of fragmentation, SLUB will retry with the minimum order
>  		possible depending on its characteristics.
> +
>  		When debug_guardpage_minorder=3DN (N > 0) parameter is specified
>  		(see Documentation/admin-guide/kernel-parameters.rst), the minimum pos=
sible
>  		order is used and this sysfs entry can not be used to change
> @@ -361,6 +362,7 @@ Description:
>  		new slab has not been possible at the cache's order and instead
>  		fallen back to its minimum possible order.  It can be written to
>  		clear the current count.
> +
>  		Available when CONFIG_SLUB_STATS is enabled.
> =20
>  What:		/sys/kernel/slab/cache/partial
> @@ -410,6 +412,7 @@ Description:
>  		slab from a remote node as opposed to allocating a new slab on
>  		the local node.  This reduces the amount of wasted memory over
>  		the entire system but can be expensive.
> +
>  		Available when CONFIG_NUMA is enabled.
> =20
>  What:		/sys/kernel/slab/cache/sanity_checks
> diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/t=
esting/sysfs-module
> index 0aac02e7fb0e..353c0db5bc1f 100644
> --- a/Documentation/ABI/testing/sysfs-module
> +++ b/Documentation/ABI/testing/sysfs-module
> @@ -17,14 +17,15 @@ KernelVersion:	3.1
>  Contact:	Kirill Smelkov <kirr@mns.spb.ru>
>  Description:	Maximum time allowed for periodic transfers per microframe =
(=CE=BCs)
> =20
> -		[ USB 2.0 sets maximum allowed time for periodic transfers per
> +		Note:
> +		  USB 2.0 sets maximum allowed time for periodic transfers per
>  		  microframe to be 80%, that is 100 microseconds out of 125
>  		  microseconds (full microframe).
> =20
>  		  However there are cases, when 80% max isochronous bandwidth is
>  		  too limiting. For example two video streams could require 110
>  		  microseconds of isochronous bandwidth per microframe to work
> -		  together. ]
> +		  together.=20
> =20
>  		Through this setting it is possible to raise the limit so that
>  		the host controller would allow allocating more than 100
> @@ -45,8 +46,10 @@ Date:		Jan 2012
>  KernelVersion:=C2=BB=C2=B73.3
>  Contact:	Kay Sievers <kay.sievers@vrfy.org>
>  Description:	Module taint flags:
> -			P - proprietary module
> -			O - out-of-tree module
> -			F - force-loaded module
> -			C - staging driver module
> -			E - unsigned module
> +			=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +			P   proprietary module
> +			O   out-of-tree module
> +			F   force-loaded module
> +			C   staging driver module
> +			E   unsigned module
> +			=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Docum=
entation/ABI/testing/sysfs-platform-dell-laptop
> index 9b917c7453de..82bcfe9df66e 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dell-laptop
> +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> @@ -34,9 +34,12 @@ Description:
>  		this file. To disable a trigger, write its name preceded
>  		by '-' instead.
> =20
> -		For example, to enable the keyboard as trigger run:
> +		For example, to enable the keyboard as trigger run::
> +
>  		    echo +keyboard > /sys/class/leds/dell::kbd_backlight/start_triggers
> -		To disable it:
> +
> +		To disable it::
> +
>  		    echo -keyboard > /sys/class/leds/dell::kbd_backlight/start_triggers
> =20
>  		Note that not all the available triggers can be configured.
> @@ -57,7 +60,8 @@ Description:
>  		with any the above units. If no unit is specified, the value
>  		is assumed to be expressed in seconds.
> =20
> -		For example, to set the timeout to 10 minutes run:
> +		For example, to set the timeout to 10 minutes run::
> +
>  		    echo 10m > /sys/class/leds/dell::kbd_backlight/stop_timeout
> =20
>  		Note that when this file is read, the returned value might be
> diff --git a/Documentation/ABI/testing/sysfs-platform-dell-smbios b/Docum=
entation/ABI/testing/sysfs-platform-dell-smbios
> index 205d3b6361e0..e6e0f7f834a7 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dell-smbios
> +++ b/Documentation/ABI/testing/sysfs-platform-dell-smbios
> @@ -13,8 +13,8 @@ Description:
>  		For example the token ID "5" would be available
>  		as the following attributes:
> =20
> -		0005_location
> -		0005_value
> +		- 0005_location
> +		- 0005_value
> =20
>  		Tokens will vary from machine to machine, and
>  		only tokens available on that machine will be
> diff --git a/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl b=
/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> index c394b808be19..b6a138b50d99 100644
> --- a/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> +++ b/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> @@ -5,9 +5,9 @@ Contact:	Wolfram Sang <wsa+renesas@sang-engineering.com>
>  Description:
>  		Reading the file will give you a list of masters which can be
>  		selected for a demultiplexed bus. The format is
> -		"<index>:<name>". Example from a Renesas Lager board:
> +		"<index>:<name>". Example from a Renesas Lager board::
> =20
> -		0:/i2c@e6500000 1:/i2c@e6508000
> +		  0:/i2c@e6500000 1:/i2c@e6508000
> =20
>  What:		/sys/devices/platform/<i2c-demux-name>/current_master
>  Date:		January 2016
> diff --git a/Documentation/ABI/testing/sysfs-platform-kim b/Documentation=
/ABI/testing/sysfs-platform-kim
> index c1653271872a..a7f81de68046 100644
> --- a/Documentation/ABI/testing/sysfs-platform-kim
> +++ b/Documentation/ABI/testing/sysfs-platform-kim
> @@ -5,6 +5,7 @@ Contact:	"Pavan Savoy" <pavan_savoy@ti.com>
>  Description:
>  		Name of the UART device at which the WL128x chip
>  		is connected. example: "/dev/ttyS0".
> +
>  		The device name flows down to architecture specific board
>  		initialization file from the SFI/ATAGS bootloader
>  		firmware. The name exposed is read from the user-space
> diff --git a/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2 =
b/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> index 6212697bbf6f..bc510ccc37a7 100644
> --- a/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> +++ b/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> @@ -7,9 +7,11 @@ Description:
>  		The file can show/change the phy mode for role swap of usb.
> =20
>  		Write the following strings to change the mode:
> -		 "host" - switching mode from peripheral to host.
> -		 "peripheral" - switching mode from host to peripheral.
> +
> +		 - "host" - switching mode from peripheral to host.
> +		 - "peripheral" - switching mode from host to peripheral.
> =20
>  		Read the file, then it shows the following strings:
> -		 "host" - The mode is host now.
> -		 "peripheral" - The mode is peripheral now.
> +
> +		 - "host" - The mode is host now.
> +		 - "peripheral" - The mode is peripheral now.
> diff --git a/Documentation/ABI/testing/sysfs-platform-renesas_usb3 b/Docu=
mentation/ABI/testing/sysfs-platform-renesas_usb3
> index 5621c15d5dc0..8af5b9c3fabb 100644
> --- a/Documentation/ABI/testing/sysfs-platform-renesas_usb3
> +++ b/Documentation/ABI/testing/sysfs-platform-renesas_usb3
> @@ -7,9 +7,11 @@ Description:
>  		The file can show/change the drd mode of usb.
> =20
>  		Write the following string to change the mode:
> -		 "host" - switching mode from peripheral to host.
> -		 "peripheral" - switching mode from host to peripheral.
> +
> +		- "host" - switching mode from peripheral to host.
> +		- "peripheral" - switching mode from host to peripheral.
> =20
>  		Read the file, then it shows the following strings:
> -		 "host" - The mode is host now.
> -		 "peripheral" - The mode is peripheral now.
> +	=09
> +		- "host" - The mode is host now.
> +		- "peripheral" - The mode is peripheral now.
> diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/te=
sting/sysfs-power
> index 5e6ead29124c..51c0f578bfce 100644
> --- a/Documentation/ABI/testing/sysfs-power
> +++ b/Documentation/ABI/testing/sysfs-power
> @@ -47,14 +47,18 @@ Description:
>  		suspend-to-disk mechanism.  Reading from this file returns
>  		the name of the method by which the system will be put to
>  		sleep on the next suspend.  There are four methods supported:
> +
>  		'firmware' - means that the memory image will be saved to disk
>  		by some firmware, in which case we also assume that the
>  		firmware will handle the system suspend.
> +
>  		'platform' - the memory image will be saved by the kernel and
>  		the system will be put to sleep by the platform driver (e.g.
>  		ACPI or other PM registers).
> +
>  		'shutdown' - the memory image will be saved by the kernel and
>  		the system will be powered off.
> +
>  		'reboot' - the memory image will be saved by the kernel and
>  		the system will be rebooted.
> =20
> @@ -74,12 +78,12 @@ Description:
>  		The suspend-to-disk method may be chosen by writing to this
>  		file one of the accepted strings:
> =20
> -		'firmware'
> -		'platform'
> -		'shutdown'
> -		'reboot'
> -		'testproc'
> -		'test'
> +		- 'firmware'
> +		- 'platform'
> +		- 'shutdown'
> +		- 'reboot'
> +		- 'testproc'
> +		- 'test'
> =20
>  		It will only change to 'firmware' or 'platform' if the system
>  		supports that.
> @@ -114,9 +118,9 @@ Description:
>  		string representing a nonzero integer into it.
> =20
>  		To use this debugging feature you should attempt to suspend
> -		the machine, then reboot it and run
> +		the machine, then reboot it and run::
> =20
> -		dmesg -s 1000000 | grep 'hash matches'
> +		  dmesg -s 1000000 | grep 'hash matches'
> =20
>  		If you do not get any matches (or they appear to be false
>  		positives), it is possible that the last PM event point
> @@ -244,6 +248,7 @@ Description:
>  		wakeup sources created with the help of /sys/power/wake_lock.
>  		When a string is written to /sys/power/wake_unlock, it will be
>  		assumed to represent the name of a wakeup source to deactivate.
> +
>  		If a wakeup source object of that name exists and is active at
>  		the moment, it will be deactivated.
> =20
> diff --git a/Documentation/ABI/testing/sysfs-profiling b/Documentation/AB=
I/testing/sysfs-profiling
> index 8a8e466eb2c0..e39dd3a0ceef 100644
> --- a/Documentation/ABI/testing/sysfs-profiling
> +++ b/Documentation/ABI/testing/sysfs-profiling
> @@ -5,7 +5,7 @@ Description:
>  		/sys/kernel/profiling is the runtime equivalent
>  		of the boot-time profile=3D option.
> =20
> -		You can get the same effect running:
> +		You can get the same effect running::
> =20
>  			echo 2 > /sys/kernel/profiling
> =20
> diff --git a/Documentation/ABI/testing/sysfs-wusb_cbaf b/Documentation/AB=
I/testing/sysfs-wusb_cbaf
> index a99c5f86a37a..2969d3694ec0 100644
> --- a/Documentation/ABI/testing/sysfs-wusb_cbaf
> +++ b/Documentation/ABI/testing/sysfs-wusb_cbaf
> @@ -45,7 +45,8 @@ Description:
>                  7. Device is unplugged.
> =20
>                  References:
> -                  [WUSB-AM] Association Models Supplement to the
> +                  [WUSB-AM]
> +			    Association Models Supplement to the
>                              Certified Wireless Universal Serial Bus
>                              Specification, version 1.0.
> =20
> diff --git a/Documentation/ABI/testing/usb-charger-uevent b/Documentation=
/ABI/testing/usb-charger-uevent
> index 419a92dd0d86..1db89b0cf80f 100644
> --- a/Documentation/ABI/testing/usb-charger-uevent
> +++ b/Documentation/ABI/testing/usb-charger-uevent
> @@ -3,44 +3,52 @@ Date:		2020-01-14
>  KernelVersion:	5.6
>  Contact:	linux-usb@vger.kernel.org
>  Description:	There are two USB charger states:
> -		USB_CHARGER_ABSENT
> -		USB_CHARGER_PRESENT
> +
> +		- USB_CHARGER_ABSENT
> +		- USB_CHARGER_PRESENT
> +
>  		There are five USB charger types:
> -		USB_CHARGER_UNKNOWN_TYPE: Charger type is unknown
> -		USB_CHARGER_SDP_TYPE: Standard Downstream Port
> -		USB_CHARGER_CDP_TYPE: Charging Downstream Port
> -		USB_CHARGER_DCP_TYPE: Dedicated Charging Port
> -		USB_CHARGER_ACA_TYPE: Accessory Charging Adapter
> +
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +		USB_CHARGER_UNKNOWN_TYPE  Charger type is unknown
> +		USB_CHARGER_SDP_TYPE      Standard Downstream Port
> +		USB_CHARGER_CDP_TYPE      Charging Downstream Port
> +		USB_CHARGER_DCP_TYPE      Dedicated Charging Port
> +		USB_CHARGER_ACA_TYPE      Accessory Charging Adapter
> +		=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
>  		https://www.usb.org/document-library/battery-charging-v12-spec-and-ado=
pters-agreement
> =20
> -		Here are two examples taken using udevadm monitor -p when
> -		USB charger is online:
> -		UDEV  change   /devices/soc0/usbphynop1 (platform)
> -		ACTION=3Dchange
> -		DEVPATH=3D/devices/soc0/usbphynop1
> -		DRIVER=3Dusb_phy_generic
> -		MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> -		OF_COMPATIBLE_0=3Dusb-nop-xceiv
> -		OF_COMPATIBLE_N=3D1
> -		OF_FULLNAME=3D/usbphynop1
> -		OF_NAME=3Dusbphynop1
> -		SEQNUM=3D2493
> -		SUBSYSTEM=3Dplatform
> -		USB_CHARGER_STATE=3DUSB_CHARGER_PRESENT
> -		USB_CHARGER_TYPE=3DUSB_CHARGER_SDP_TYPE
> -		USEC_INITIALIZED=3D227422826
> +		Here are two examples taken using ``udevadm monitor -p`` when
> +		USB charger is online::
> =20
> -		USB charger is offline:
> -		KERNEL change   /devices/soc0/usbphynop1 (platform)
> -		ACTION=3Dchange
> -		DEVPATH=3D/devices/soc0/usbphynop1
> -		DRIVER=3Dusb_phy_generic
> -		MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> -		OF_COMPATIBLE_0=3Dusb-nop-xceiv
> -		OF_COMPATIBLE_N=3D1
> -		OF_FULLNAME=3D/usbphynop1
> -		OF_NAME=3Dusbphynop1
> -		SEQNUM=3D2494
> -		SUBSYSTEM=3Dplatform
> -		USB_CHARGER_STATE=3DUSB_CHARGER_ABSENT
> -		USB_CHARGER_TYPE=3DUSB_CHARGER_UNKNOWN_TYPE
> +		    UDEV  change   /devices/soc0/usbphynop1 (platform)
> +		    ACTION=3Dchange
> +		    DEVPATH=3D/devices/soc0/usbphynop1
> +		    DRIVER=3Dusb_phy_generic
> +		    MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> +		    OF_COMPATIBLE_0=3Dusb-nop-xceiv
> +		    OF_COMPATIBLE_N=3D1
> +		    OF_FULLNAME=3D/usbphynop1
> +		    OF_NAME=3Dusbphynop1
> +		    SEQNUM=3D2493
> +		    SUBSYSTEM=3Dplatform
> +		    USB_CHARGER_STATE=3DUSB_CHARGER_PRESENT
> +		    USB_CHARGER_TYPE=3DUSB_CHARGER_SDP_TYPE
> +		    USEC_INITIALIZED=3D227422826
> +
> +		USB charger is offline::
> +
> +		    KERNEL change   /devices/soc0/usbphynop1 (platform)
> +		    ACTION=3Dchange
> +		    DEVPATH=3D/devices/soc0/usbphynop1
> +		    DRIVER=3Dusb_phy_generic
> +		    MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> +		    OF_COMPATIBLE_0=3Dusb-nop-xceiv
> +		    OF_COMPATIBLE_N=3D1
> +		    OF_FULLNAME=3D/usbphynop1
> +		    OF_NAME=3Dusbphynop1
> +		    SEQNUM=3D2494
> +		    SUBSYSTEM=3Dplatform
> +		    USB_CHARGER_STATE=3DUSB_CHARGER_ABSENT
> +		    USB_CHARGER_TYPE=3DUSB_CHARGER_UNKNOWN_TYPE
> diff --git a/Documentation/ABI/testing/usb-uevent b/Documentation/ABI/tes=
ting/usb-uevent
> index d35c3cad892c..2b8eca4bf2b1 100644
> --- a/Documentation/ABI/testing/usb-uevent
> +++ b/Documentation/ABI/testing/usb-uevent
> @@ -6,22 +6,22 @@ Description:	When the USB Host Controller has entered a=
 state where it is no
>  		longer functional a uevent will be raised. The uevent will
>  		contain ACTION=3Doffline and ERROR=3DDEAD.
> =20
> -		Here is an example taken using udevadm monitor -p:
> +		Here is an example taken using udevadm monitor -p::
> =20
> -		KERNEL[130.428945] offline  /devices/pci0000:00/0000:00:10.0/usb2 (usb)
> -		ACTION=3Doffline
> -		BUSNUM=3D002
> -		DEVNAME=3D/dev/bus/usb/002/001
> -		DEVNUM=3D001
> -		DEVPATH=3D/devices/pci0000:00/0000:00:10.0/usb2
> -		DEVTYPE=3Dusb_device
> -		DRIVER=3Dusb
> -		ERROR=3DDEAD
> -		MAJOR=3D189
> -		MINOR=3D128
> -		PRODUCT=3D1d6b/2/414
> -		SEQNUM=3D2168
> -		SUBSYSTEM=3Dusb
> -		TYPE=3D9/0/1
> +		    KERNEL[130.428945] offline  /devices/pci0000:00/0000:00:10.0/usb2 =
(usb)
> +		    ACTION=3Doffline
> +		    BUSNUM=3D002
> +		    DEVNAME=3D/dev/bus/usb/002/001
> +		    DEVNUM=3D001
> +		    DEVPATH=3D/devices/pci0000:00/0000:00:10.0/usb2
> +		    DEVTYPE=3Dusb_device
> +		    DRIVER=3Dusb
> +		    ERROR=3DDEAD
> +		    MAJOR=3D189
> +		    MINOR=3D128
> +		    PRODUCT=3D1d6b/2/414
> +		    SEQNUM=3D2168
> +		    SUBSYSTEM=3Dusb
> +		    TYPE=3D9/0/1
> =20
>  Users:		chromium-os-dev@chromium.org
> diff --git a/scripts/get_abi.pl b/scripts/get_abi.pl
> index 413349789145..bdef3e5c35c7 100755
> --- a/scripts/get_abi.pl
> +++ b/scripts/get_abi.pl
> @@ -316,8 +316,6 @@ sub output_rest {
>  				$len =3D length($name) if (length($name) > $len);
>  			}
> =20
> -			print "What:\n\n";
> -
>  			print "+-" . "-" x $len . "-+\n";
>  			foreach my $name (@names) {
>  				printf "| %s", $name . " " x ($len - length($name)) . " |\n";

