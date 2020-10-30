Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C6A29FF1E
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 08:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbgJ3HxN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 03:53:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726052AbgJ3HxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 03:53:12 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4808C0613D4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 00:53:09 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id l16so5671578eds.3
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 00:53:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kbM6iuy7TeAoT0TygDSH/ZL2KreWbZXz6s9GVc5FlBQ=;
        b=NODaIJ5wbF1g0xumGUF+gMVAJ/39gdyfOfkf9H1RcKisQwxiVNlge+tNY6+GcU/OcV
         CvETZNLCRVxZxW1W48ZkcpLwpSL/iyge6bZei4SxWH6PNZdBdAKPh4w5AgAnoi7R9dW5
         y/CPdEvEsZtQMYgw8Tna83l2GOJYVsS5tdvgHxPDlJzk4HtyDen7WA8M1eGLI8M7Rdg+
         Enk7WsfckqSxoBALm+2wvtLt/lFxeLUknUU1mJPWclMsdvvupASsm7R38V4IjHtByPx6
         YTu5iPhOSKnBRUVQp6FqFc4NbWkPrBRh9gTPlIgkrogbANgAYFt9kXB3wRcefW4ZuiVd
         xhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kbM6iuy7TeAoT0TygDSH/ZL2KreWbZXz6s9GVc5FlBQ=;
        b=O0K3k3CZBo17+pMaTcavZBHBQ/CXPju9ElzZqoPS7Bi2WjxV+L9Q+X0yTtZAdkI7UX
         +qwbC5JGU4SPWkP2QFZtZdu9BwhOQ9rS20NHagTIdTHn0sZ32LYVr5FgymG/E/D8Fzy2
         o6zKKuUMgwqgj0k4JhvU5gw1Zakr+xW1Tz00MiPzT6RYXOmeV32AD0nkUKcTqJc1J3C9
         KiojCv2RUjgne7/G4/6CNY/81BZfMbq1Khz9Ek/rik/X0hbVR+3F2QxjvD1z1X65xPKp
         aDDosiaurmy5cwxpEN6Ozo8YoPq/GE1XytpckHEWqHy18H8SOeGxznTUyhTU4Z6hqlnv
         4vSg==
X-Gm-Message-State: AOAM530LNMbtt0N8wS+TYj7jYQdq5Iy9FCneAdP81UjsOfwpBfmeBK5N
        4oyGSo41Z4+bWkEx9J+t45n2ipqn9PXkvKf+pj/gpw==
X-Google-Smtp-Source: ABdhPJyMPIGgKbe3RkTv34fsHZxWrphv3D9303DBvXoC28DDE/Fo+i3GgFAIcYIMnX+dEfz0jJyXGMnflPBRQU8YAok=
X-Received: by 2002:a05:6402:3056:: with SMTP id bu22mr956716edb.252.1604044385856;
 Fri, 30 Oct 2020 00:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1603893146.git.mchehab+huawei@kernel.org> <95ef2cf3a58f4e50f17d9e58e0d9440ad14d0427.1603893146.git.mchehab+huawei@kernel.org>
In-Reply-To: <95ef2cf3a58f4e50f17d9e58e0d9440ad14d0427.1603893146.git.mchehab+huawei@kernel.org>
From:   Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date:   Fri, 30 Oct 2020 08:52:54 +0100
Message-ID: <CAMGffE=TzX1o++rKCo5dtM4Kft4ZgtQY4Z6Qd+w-EktZo0a2=A@mail.gmail.com>
Subject: Re: [PATCH 30/33] docs: ABI: cleanup several ABI documents
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
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
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jonas Meurer <jonas@freesources.org>,
        Jonathan Cameron <jic23@kernel.org>,
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
        linuxppc-dev@lists.ozlabs.org, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 28, 2020 at 3:23 PM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> There are some ABI documents that, while they don't generate
> any warnings, they have issues when parsed by get_abi.pl script
> on its output result.
>
> Address them, in order to provide a clean output.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
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
For rnbd change looks good to me, thanks!
Acked-by: Jack Wang <jinpu.wang@cloud.ionos.com> #rnbd


> index 171127294674..0b4ab9e4b8f4 100644
> --- a/Documentation/ABI/testing/sysfs-bus-thunderbolt
> +++ b/Documentation/ABI/testing/sysfs-bus-thunderbolt
> @@ -193,10 +193,11 @@ Description:      When new NVM image is written to =
the non-active NVM
>                 verification fails an error code is returned instead.
>
>                 This file will accept writing values "1" or "2"
> +
>                 - Writing "1" will flush the image to the storage
> -               area and authenticate the image in one action.
> +                 area and authenticate the image in one action.
>                 - Writing "2" will run some basic validation on the image
> -               and flush it to the storage area.
> +                 and flush it to the storage area.
>
>                 When read holds status of the last authentication
>                 operation if an error occurred during the process. This
> @@ -213,9 +214,11 @@ Description:       This contains name of the propert=
y directory the XDomain
>                 question. Following directories are already reserved by
>                 the Apple XDomain specification:
>
> -               network:  IP/ethernet over Thunderbolt
> -               targetdm: Target disk mode protocol over Thunderbolt
> -               extdisp:  External display mode protocol over Thunderbolt
> +               =3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               network   IP/ethernet over Thunderbolt
> +               targetdm  Target disk mode protocol over Thunderbolt
> +               extdisp   External display mode protocol over Thunderbolt
> +               =3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/bus/thunderbolt/devices/<xdomain>.<service>/modalias
>  Date:          Jan 2018
> @@ -293,7 +296,8 @@ Description:        For supported devices, automatica=
lly authenticate the new Thunderbo
>                 image when the device is disconnected from the host syste=
m.
>
>                 This file will accept writing values "1" or "2"
> +
>                 - Writing "1" will flush the image to the storage
> -               area and prepare the device for authentication on disconn=
ect.
> +                 area and prepare the device for authentication on disco=
nnect.
>                 - Writing "2" will run some basic validation on the image
> -               and flush it to the storage area.
> +                 and flush it to the storage area.
> diff --git a/Documentation/ABI/testing/sysfs-bus-usb b/Documentation/ABI/=
testing/sysfs-bus-usb
> index e449b8374f6a..bf2c1968525f 100644
> --- a/Documentation/ABI/testing/sysfs-bus-usb
> +++ b/Documentation/ABI/testing/sysfs-bus-usb
> @@ -9,6 +9,7 @@ Description:
>                 by writing INTERFACE to /sys/bus/usb/drivers_probe
>                 This allows to avoid side-effects with drivers
>                 that need multiple interfaces.
> +
>                 A deauthorized interface cannot be probed or claimed.
>
>  What:          /sys/bus/usb/devices/usbX/interface_authorized_default
> @@ -216,6 +217,7 @@ Description:
>                  - Bit 0 of this field selects the "old" enumeration sche=
me,
>                    as it is considerably faster (it only causes one USB r=
eset
>                    instead of 2).
> +
>                    The old enumeration scheme can also be selected global=
ly
>                    using /sys/module/usbcore/parameters/old_scheme_first,=
 but
>                    it is often not desirable as the new scheme was introd=
uced to
> diff --git a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm353=
3 b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> index c0e0a9ae7b3d..8251e78abc49 100644
> --- a/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> +++ b/Documentation/ABI/testing/sysfs-class-backlight-driver-lm3533
> @@ -6,8 +6,10 @@ Description:
>                 Get the ALS output channel used as input in
>                 ALS-current-control mode (0, 1), where:
>
> -               0 - out_current0 (backlight 0)
> -               1 - out_current1 (backlight 1)
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   out_current0 (backlight 0)
> +               1   out_current1 (backlight 1)
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/backlight/<backlight>/als_en
>  Date:          May 2012
> @@ -30,8 +32,10 @@ Contact:     Johan Hovold <jhovold@gmail.com>
>  Description:
>                 Set the brightness-mapping mode (0, 1), where:
>
> -               0 - exponential mode
> -               1 - linear mode
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   exponential mode
> +               1   linear mode
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/backlight/<backlight>/pwm
>  Date:          April 2012
> @@ -40,9 +44,11 @@ Contact:     Johan Hovold <jhovold@gmail.com>
>  Description:
>                 Set the PWM-input control mask (5 bits), where:
>
> -               bit 5 - PWM-input enabled in Zone 4
> -               bit 4 - PWM-input enabled in Zone 3
> -               bit 3 - PWM-input enabled in Zone 2
> -               bit 2 - PWM-input enabled in Zone 1
> -               bit 1 - PWM-input enabled in Zone 0
> -               bit 0 - PWM-input enabled
> +               =3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               bit 5   PWM-input enabled in Zone 4
> +               bit 4   PWM-input enabled in Zone 3
> +               bit 3   PWM-input enabled in Zone 2
> +               bit 2   PWM-input enabled in Zone 1
> +               bit 1   PWM-input enabled in Zone 0
> +               bit 0   PWM-input enabled
> +               =3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-class-bdi b/Documentation/AB=
I/testing/sysfs-class-bdi
> index d773d5697cf5..5402bd74ba43 100644
> --- a/Documentation/ABI/testing/sysfs-class-bdi
> +++ b/Documentation/ABI/testing/sysfs-class-bdi
> @@ -24,7 +24,6 @@ default
>         filesystems which do not provide their own BDI.
>
>  Files under /sys/class/bdi/<bdi>/
> ----------------------------------
>
>  read_ahead_kb (read-write)
>
> diff --git a/Documentation/ABI/testing/sysfs-class-chromeos b/Documentati=
on/ABI/testing/sysfs-class-chromeos
> index 5819699d66ec..74ece942722e 100644
> --- a/Documentation/ABI/testing/sysfs-class-chromeos
> +++ b/Documentation/ABI/testing/sysfs-class-chromeos
> @@ -17,13 +17,14 @@ Date:               August 2015
>  KernelVersion: 4.2
>  Description:
>                 Tell the EC to reboot in various ways. Options are:
> -               "cancel": Cancel a pending reboot.
> -               "ro": Jump to RO without rebooting.
> -               "rw": Jump to RW without rebooting.
> -               "cold": Cold reboot.
> -               "disable-jump": Disable jump until next reboot.
> -               "hibernate": Hibernate the EC.
> -               "at-shutdown": Reboot after an AP shutdown.
> +
> +               - "cancel": Cancel a pending reboot.
> +               - "ro": Jump to RO without rebooting.
> +               - "rw": Jump to RW without rebooting.
> +               - "cold": Cold reboot.
> +               - "disable-jump": Disable jump until next reboot.
> +               - "hibernate": Hibernate the EC.
> +               - "at-shutdown": Reboot after an AP shutdown.
>
>  What:          /sys/class/chromeos/<ec-device-name>/version
>  Date:          August 2015
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
> @@ -240,8 +241,11 @@ Contact:   linuxppc-dev@lists.ozlabs.org
>  Description:   read/write
>                 Trust that when an image is reloaded via PERST, it will n=
ot
>                 have changed.
> -               0 =3D don't trust, the image may be different (default)
> -               1 =3D trust that the image will not change.
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   don't trust, the image may be different (default)
> +               1   trust that the image will not change.
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
>  Users:         https://github.com/ibm-capi/libcxl
>
>  What:           /sys/class/cxl/<card>/psl_timebase_synced
> diff --git a/Documentation/ABI/testing/sysfs-class-devlink b/Documentatio=
n/ABI/testing/sysfs-class-devlink
> index 64791b65c9a3..b662f747c83e 100644
> --- a/Documentation/ABI/testing/sysfs-class-devlink
> +++ b/Documentation/ABI/testing/sysfs-class-devlink
> @@ -18,9 +18,9 @@ Description:
>
>                 This will be one of the following strings:
>
> -               'consumer unbind'
> -               'supplier unbind'
> -               'never'
> +               - 'consumer unbind'
> +               - 'supplier unbind'
> +               - 'never'
>
>                 'consumer unbind' means the device link will be removed w=
hen
>                 the consumer's driver is unbound from the consumer device=
.
> @@ -49,8 +49,10 @@ Description:
>
>                 This will be one of the following strings:
>
> -               '0' - Does not affect runtime power management
> -               '1' - Affects runtime power management
> +               =3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               '0'   Does not affect runtime power management
> +               '1'   Affects runtime power management
> +               =3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/devlink/.../status
>  Date:          May 2020
> @@ -68,13 +70,13 @@ Description:
>
>                 This will be one of the following strings:
>
> -               'not tracked'
> -               'dormant'
> -               'available'
> -               'consumer probing'
> -               'active'
> -               'supplier unbinding'
> -               'unknown'
> +               - 'not tracked'
> +               - 'dormant'
> +               - 'available'
> +               - 'consumer probing'
> +               - 'active'
> +               - 'supplier unbinding'
> +               - 'unknown'
>
>                 'not tracked' means this device link does not track the s=
tatus
>                 and has no impact on the binding, unbinding and syncing t=
he
> @@ -114,8 +116,10 @@ Description:
>
>                 This will be one of the following strings:
>
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>                 '0'
> -               '1' - Affects runtime power management
> +               '1'  Affects runtime power management
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                 '0' means the device link can affect other device behavio=
rs
>                 like binding/unbinding, suspend/resume, runtime power
> diff --git a/Documentation/ABI/testing/sysfs-class-extcon b/Documentation=
/ABI/testing/sysfs-class-extcon
> index 57a726232912..fde0fecd5de9 100644
> --- a/Documentation/ABI/testing/sysfs-class-extcon
> +++ b/Documentation/ABI/testing/sysfs-class-extcon
> @@ -39,19 +39,22 @@ Description:
>                 callback.
>
>                 If the default callback for showing function is used, the
> -               format is like this:
> -               # cat state
> -               USB_OTG=3D1
> -               HDMI=3D0
> -               TA=3D1
> -               EAR_JACK=3D0
> -               #
> +               format is like this::
> +
> +                   # cat state
> +                   USB_OTG=3D1
> +                   HDMI=3D0
> +                   TA=3D1
> +                   EAR_JACK=3D0
> +                   #
> +
>                 In this example, the extcon device has USB_OTG and TA
>                 cables attached and HDMI and EAR_JACK cables detached.
>
>                 In order to update the state of an extcon device, enter a=
 hex
> -               state number starting with 0x:
> -               # echo 0xHEX > state
> +               state number starting with 0x::
> +
> +                   # echo 0xHEX > state
>
>                 This updates the whole state of the extcon device.
>                 Inputs of all the methods are required to meet the
> @@ -84,12 +87,13 @@ Contact:    MyungJoo Ham <myungjoo.ham@samsung.com>
>  Description:
>                 Shows the relations of mutually exclusiveness. For exampl=
e,
>                 if the mutually_exclusive array of extcon device is
> -               {0x3, 0x5, 0xC, 0x0}, then the output is:
> -               # ls mutually_exclusive/
> -               0x3
> -               0x5
> -               0xc
> -               #
> +               {0x3, 0x5, 0xC, 0x0}, then the output is::
> +
> +                   # ls mutually_exclusive/
> +                   0x3
> +                   0x5
> +                   0xc
> +                   #
>
>                 Note that mutually_exclusive is a sub-directory of the ex=
tcon
>                 device and the file names under the mutually_exclusive
> diff --git a/Documentation/ABI/testing/sysfs-class-fpga-manager b/Documen=
tation/ABI/testing/sysfs-class-fpga-manager
> index 5284fa33d4c5..d78689c357a5 100644
> --- a/Documentation/ABI/testing/sysfs-class-fpga-manager
> +++ b/Documentation/ABI/testing/sysfs-class-fpga-manager
> @@ -28,8 +28,7 @@ Description:  Read fpga manager state as a string.
>                 * firmware request      =3D firmware class request in pro=
gress
>                 * firmware request error =3D firmware request failed
>                 * write init            =3D preparing FPGA for programmin=
g
> -               * write init error      =3D Error while preparing FPGA fo=
r
> -                                         programming
> +               * write init error      =3D Error while preparing FPGA fo=
r programming
>                 * write                 =3D FPGA ready to receive image d=
ata
>                 * write error           =3D Error while programming
>                 * write complete        =3D Doing post programming steps
> @@ -47,7 +46,7 @@ Description:  Read fpga manager status as a string.
>                 programming errors to userspace. This is a list of string=
s for
>                 the supported status.
>
> -               * reconfig operation error      - invalid operations dete=
cted by
> +               * reconfig operation error      - invalid operations dete=
cted by
>                                                   reconfiguration hardwar=
e.
>                                                   e.g. start reconfigurat=
ion
>                                                   with errors not cleared
> diff --git a/Documentation/ABI/testing/sysfs-class-gnss b/Documentation/A=
BI/testing/sysfs-class-gnss
> index 2467b6900eae..c8553d972edd 100644
> --- a/Documentation/ABI/testing/sysfs-class-gnss
> +++ b/Documentation/ABI/testing/sysfs-class-gnss
> @@ -6,9 +6,11 @@ Description:
>                 The GNSS receiver type. The currently identified types re=
flect
>                 the protocol(s) supported by the receiver:
>
> +                       =3D=3D=3D=3D=3D=3D          =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>                         "NMEA"          NMEA 0183
>                         "SiRF"          SiRF Binary
>                         "UBX"           UBX
> +                       =3D=3D=3D=3D=3D=3D          =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
>
>                 Note that also non-"NMEA" type receivers typically suppor=
t a
>                 subset of NMEA 0183 with vendor extensions (e.g. to allow
> diff --git a/Documentation/ABI/testing/sysfs-class-led b/Documentation/AB=
I/testing/sysfs-class-led
> index 65e040978f73..0ed5c2629c6f 100644
> --- a/Documentation/ABI/testing/sysfs-class-led
> +++ b/Documentation/ABI/testing/sysfs-class-led
> @@ -47,6 +47,7 @@ Contact:      Richard Purdie <rpurdie@rpsys.net>
>  Description:
>                 Set the trigger for this LED. A trigger is a kernel based=
 source
>                 of LED events.
> +
>                 You can change triggers in a similar manner to the way an=
 IO
>                 scheduler is chosen. Trigger specific parameters can appe=
ar in
>                 /sys/class/leds/<led> once a given trigger is selected. F=
or
> diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-el15203000 =
b/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> index 69befe947d7e..da546e86deb5 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> +++ b/Documentation/ABI/testing/sysfs-class-led-driver-el15203000
> @@ -27,23 +27,23 @@ Description:
>
>                         ^
>                         |
> -                   0 On -|----+                   +----+                =
   +---
> +                 0 On -|----+                   +----+                  =
 +---
>                         |    |                   |    |                  =
 |
>                     Off-|    +-------------------+    +------------------=
-+
>                         |
> -                   1 On -|    +----+                   +----+
> +                 1 On -|    +----+                   +----+
>                         |    |    |                   |    |
>                     Off |----+    +-------------------+    +-------------=
-----
>                         |
> -                   2 On -|         +----+                   +----+
> +                 2 On -|         +----+                   +----+
>                         |         |    |                   |    |
>                     Off-|---------+    +-------------------+    +--------=
-----
>                         |
> -                   3 On -|              +----+                   +----+
> +                 3 On -|              +----+                   +----+
>                         |              |    |                   |    |
>                     Off-|--------------+    +-------------------+    +---=
-----
>                         |
> -                   4 On -|                   +----+                   +-=
---+
> +                 4 On -|                   +----+                   +---=
-+
>                         |                   |    |                   |   =
 |
>                     Off-|-------------------+    +-------------------+   =
 +---
>                         |
> @@ -55,23 +55,23 @@ Description:
>
>                         ^
>                         |
> -                   0 On -|    +-------------------+    +----------------=
---+
> +                 0 On -|    +-------------------+    +------------------=
-+
>                         |    |                   |    |                  =
 |
>                     Off-|----+                   +----+                  =
 +---
>                         |
> -                   1 On -|----+    +-------------------+    +-----------=
-------
> +                 1 On -|----+    +-------------------+    +-------------=
-----
>                         |    |    |                   |    |
>                     Off |    +----+                   +----+
>                         |
> -                   2 On -|---------+    +-------------------+    +------=
-------
> +                 2 On -|---------+    +-------------------+    +--------=
-----
>                         |         |    |                   |    |
>                     Off-|         +----+                   +----+
>                         |
> -                   3 On -|--------------+    +-------------------+    +-=
-------
> +                 3 On -|--------------+    +-------------------+    +---=
-----
>                         |              |    |                   |    |
>                     Off-|              +----+                   +----+
>                         |
> -                   4 On -|-------------------+    +-------------------+ =
   +---
> +                 4 On -|-------------------+    +-------------------+   =
 +---
>                         |                   |    |                   |   =
 |
>                     Off-|                   +----+                   +---=
-+
>                         |
> @@ -83,23 +83,23 @@ Description:
>
>                         ^
>                         |
> -                   0 On -|----+                                       +-=
-------
> +                 0 On -|----+                                       +---=
-----
>                         |    |                                       |
>                     Off-|    +---------------------------------------+
>                         |
> -                   1 On -|    +----+                             +----+
> +                 1 On -|    +----+                             +----+
>                         |    |    |                             |    |
>                     Off |----+    +-----------------------------+    +---=
-----
>                         |
> -                   2 On -|         +----+                   +----+
> +                 2 On -|         +----+                   +----+
>                         |         |    |                   |    |
>                     Off-|---------+    +-------------------+    +--------=
-----
>                         |
> -                   3 On -|              +----+         +----+
> +                 3 On -|              +----+         +----+
>                         |              |    |         |    |
>                     Off-|--------------+    +---------+    +-------------=
-----
>                         |
> -                   4 On -|                   +---------+
> +                 4 On -|                   +---------+
>                         |                   |         |
>                     Off-|-------------------+         +------------------=
-----
>                         |
> diff --git a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533 b/Do=
cumentation/ABI/testing/sysfs-class-led-driver-lm3533
> index e4c89b261546..e38a835d0a85 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
> +++ b/Documentation/ABI/testing/sysfs-class-led-driver-lm3533
> @@ -6,8 +6,10 @@ Description:
>                 Set the ALS output channel to use as input in
>                 ALS-current-control mode (1, 2), where:
>
> -               1 - out_current1
> -               2 - out_current2
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               1   out_current1
> +               2   out_current2
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/leds/<led>/als_en
>  Date:          May 2012
> @@ -24,14 +26,16 @@ Contact:    Johan Hovold <jhovold@gmail.com>
>  Description:
>                 Set the pattern generator fall and rise times (0..7), whe=
re:
>
> -               0 - 2048 us
> -               1 - 262 ms
> -               2 - 524 ms
> -               3 - 1.049 s
> -               4 - 2.097 s
> -               5 - 4.194 s
> -               6 - 8.389 s
> -               7 - 16.78 s
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D
> +               0   2048 us
> +               1   262 ms
> +               2   524 ms
> +               3   1.049 s
> +               4   2.097 s
> +               5   4.194 s
> +               6   8.389 s
> +               7   16.78 s
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/leds/<led>/id
>  Date:          April 2012
> @@ -47,8 +51,10 @@ Contact:     Johan Hovold <jhovold@gmail.com>
>  Description:
>                 Set the brightness-mapping mode (0, 1), where:
>
> -               0 - exponential mode
> -               1 - linear mode
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   exponential mode
> +               1   linear mode
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/leds/<led>/pwm
>  Date:          April 2012
> @@ -57,9 +63,11 @@ Contact:     Johan Hovold <jhovold@gmail.com>
>  Description:
>                 Set the PWM-input control mask (5 bits), where:
>
> -               bit 5 - PWM-input enabled in Zone 4
> -               bit 4 - PWM-input enabled in Zone 3
> -               bit 3 - PWM-input enabled in Zone 2
> -               bit 2 - PWM-input enabled in Zone 1
> -               bit 1 - PWM-input enabled in Zone 0
> -               bit 0 - PWM-input enabled
> +               =3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               bit 5  PWM-input enabled in Zone 4
> +               bit 4  PWM-input enabled in Zone 3
> +               bit 3  PWM-input enabled in Zone 2
> +               bit 2  PWM-input enabled in Zone 1
> +               bit 1  PWM-input enabled in Zone 0
> +               bit 0  PWM-input enabled
> +               =3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-class-led-flash b/Documentat=
ion/ABI/testing/sysfs-class-led-flash
> index 220a0270b47b..11e5677c3672 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-flash
> +++ b/Documentation/ABI/testing/sysfs-class-led-flash
> @@ -55,26 +55,35 @@ Description:        read only
>                 Flash faults are re-read after strobing the flash. Possib=
le
>                 flash faults:
>
> -               * led-over-voltage - flash controller voltage to the flas=
h LED
> +               * led-over-voltage
> +                       flash controller voltage to the flash LED
>                         has exceeded the limit specific to the flash cont=
roller
> -               * flash-timeout-exceeded - the flash strobe was still on =
when
> +               * flash-timeout-exceeded
> +                       the flash strobe was still on when
>                         the timeout set by the user has expired; not all =
flash
>                         controllers may set this in all such conditions
> -               * controller-over-temperature - the flash controller has
> +               * controller-over-temperature
> +                       the flash controller has
>                         overheated
> -               * controller-short-circuit - the short circuit protection
> +               * controller-short-circuit
> +                       the short circuit protection
>                         of the flash controller has been triggered
> -               * led-power-supply-over-current - current in the LED powe=
r
> +               * led-power-supply-over-current
> +                       current in the LED power
>                         supply has exceeded the limit specific to the fla=
sh
>                         controller
> -               * indicator-led-fault - the flash controller has detected
> +               * indicator-led-fault
> +                       the flash controller has detected
>                         a short or open circuit condition on the indicato=
r LED
> -               * led-under-voltage - flash controller voltage to the fla=
sh
> +               * led-under-voltage
> +                       flash controller voltage to the flash
>                         LED has been below the minimum limit specific to
>                         the flash
> -               * controller-under-voltage - the input voltage of the fla=
sh
> +               * controller-under-voltage
> +                       the input voltage of the flash
>                         controller is below the limit under which strobin=
g the
>                         flash at full current will not be possible;
>                         the condition persists until this flag is no long=
er set
> -               * led-over-temperature - the temperature of the LED has e=
xceeded
> +               * led-over-temperature
> +                       the temperature of the LED has exceeded
>                         its allowed upper limit
> diff --git a/Documentation/ABI/testing/sysfs-class-led-trigger-netdev b/D=
ocumentation/ABI/testing/sysfs-class-led-trigger-netdev
> index 451af6d6768c..646540950e38 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-trigger-netdev
> +++ b/Documentation/ABI/testing/sysfs-class-led-trigger-netdev
> @@ -19,18 +19,23 @@ KernelVersion:      4.16
>  Contact:       linux-leds@vger.kernel.org
>  Description:
>                 Signal the link state of the named network device.
> +
>                 If set to 0 (default), the LED's normal state is off.
> +
>                 If set to 1, the LED's normal state reflects the link sta=
te
>                 of the named network device.
>                 Setting this value also immediately changes the LED state=
.
>
> +
>  What:          /sys/class/leds/<led>/tx
>  Date:          Dec 2017
>  KernelVersion: 4.16
>  Contact:       linux-leds@vger.kernel.org
>  Description:
>                 Signal transmission of data on the named network device.
> +
>                 If set to 0 (default), the LED will not blink on transmis=
sion.
> +
>                 If set to 1, the LED will blink for the milliseconds spec=
ified
>                 in interval to signal transmission.
>
> @@ -40,6 +45,8 @@ KernelVersion:        4.16
>  Contact:       linux-leds@vger.kernel.org
>  Description:
>                 Signal reception of data on the named network device.
> +
>                 If set to 0 (default), the LED will not blink on receptio=
n.
> +
>                 If set to 1, the LED will blink for the milliseconds spec=
ified
>                 in interval to signal reception.
> diff --git a/Documentation/ABI/testing/sysfs-class-led-trigger-usbport b/=
Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> index f440e690daef..eb81152b8348 100644
> --- a/Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> +++ b/Documentation/ABI/testing/sysfs-class-led-trigger-usbport
> @@ -8,5 +8,6 @@ Description:
>                 selected for the USB port trigger. Selecting ports makes =
trigger
>                 observing them for any connected devices and lighting on =
LED if
>                 there are any.
> +
>                 Echoing "1" value selects USB port. Echoing "0" unselects=
 it.
>                 Current state can be also read.
> diff --git a/Documentation/ABI/testing/sysfs-class-leds-gt683r b/Document=
ation/ABI/testing/sysfs-class-leds-gt683r
> index 6adab27f646e..b57ffb26e722 100644
> --- a/Documentation/ABI/testing/sysfs-class-leds-gt683r
> +++ b/Documentation/ABI/testing/sysfs-class-leds-gt683r
> @@ -7,9 +7,11 @@ Description:
>                 of one LED will update the mode of its two sibling device=
s as
>                 well. Possible values are:
>
> -               0 - normal
> -               1 - audio
> -               2 - breathing
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   normal
> +               1   audio
> +               2   breathing
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                 Normal: LEDs are fully on when enabled
>                 Audio:  LEDs brightness depends on sound level
> diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/AB=
I/testing/sysfs-class-net
> index 3b404577f380..7670012ae9b6 100644
> --- a/Documentation/ABI/testing/sysfs-class-net
> +++ b/Documentation/ABI/testing/sysfs-class-net
> @@ -4,10 +4,13 @@ KernelVersion:        3.17
>  Contact:       netdev@vger.kernel.org
>  Description:
>                 Indicates the name assignment type. Possible values are:
> -               1: enumerated by the kernel, possibly in an unpredictable=
 way
> -               2: predictably named by the kernel
> -               3: named by userspace
> -               4: renamed
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               1  enumerated by the kernel, possibly in an unpredictable=
 way
> +               2  predictably named by the kernel
> +               3  named by userspace
> +               4  renamed
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/net/<iface>/addr_assign_type
>  Date:          July 2010
> @@ -15,10 +18,13 @@ KernelVersion:      3.2
>  Contact:       netdev@vger.kernel.org
>  Description:
>                 Indicates the address assignment type. Possible values ar=
e:
> -               0: permanent address
> -               1: randomly generated
> -               2: stolen from another device
> -               3: set using dev_set_mac_address
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  permanent address
> +               1  randomly generated
> +               2  stolen from another device
> +               3  set using dev_set_mac_address
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/class/net/<iface>/addr_len
>  Date:          April 2005
> @@ -51,9 +57,12 @@ Description:
>                 Default value 0 does not forward any link local frames.
>
>                 Restricted bits:
> -               0: 01-80-C2-00-00-00 Bridge Group Address used for STP
> -               1: 01-80-C2-00-00-01 (MAC Control) 802.3 used for MAC PAU=
SE
> -               2: 01-80-C2-00-00-02 (Link Aggregation) 802.3ad
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  01-80-C2-00-00-00 Bridge Group Address used for STP
> +               1  01-80-C2-00-00-01 (MAC Control) 802.3 used for MAC PAU=
SE
> +               2  01-80-C2-00-00-02 (Link Aggregation) 802.3ad
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                 Any values not setting these bits can be used. Take speci=
al
>                 care when forwarding control frames e.g. 802.1X-PAE or LL=
DP.
> @@ -74,8 +83,11 @@ Contact:     netdev@vger.kernel.org
>  Description:
>                 Indicates the current physical link state of the interfac=
e.
>                 Posssible values are:
> -               0: physical link is down
> -               1: physical link is up
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +               0  physical link is down
> +               1  physical link is up
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>
>                 Note: some special devices, e.g: bonding and team drivers=
 will
>                 allow this attribute to be written to force a link state =
for
> @@ -131,8 +143,11 @@ Contact:   netdev@vger.kernel.org
>  Description:
>                 Indicates whether the interface is under test. Possible
>                 values are:
> -               0: interface is not being tested
> -               1: interface is being tested
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  interface is not being tested
> +               1  interface is being tested
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                 When an interface is under test, it cannot be expected
>                 to pass packets as normal.
> @@ -144,8 +159,11 @@ Contact:   netdev@vger.kernel.org
>  Description:
>                 Indicates the interface latest or current duplex value. P=
ossible
>                 values are:
> -               half: half duplex
> -               full: full duplex
> +
> +               =3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               half  half duplex
> +               full  full duplex
> +               =3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>                 Note: This attribute is only valid for interfaces that im=
plement
>                 the ethtool get_link_ksettings method (mostly Ethernet).
> @@ -196,8 +214,11 @@ Description:
>                 Indicates the interface link mode, as a decimal number. T=
his
>                 attribute should be used in conjunction with 'dormant' at=
tribute
>                 to determine the interface usability. Possible values:
> -               0: default link mode
> -               1: dormant link mode
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
> +               0   default link mode
> +               1   dormant link mode
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D
>
>  What:          /sys/class/net/<iface>/mtu
>  Date:          April 2005
> @@ -226,7 +247,9 @@ KernelVersion:      2.6.17
>  Contact:       netdev@vger.kernel.org
>  Description:
>                 Indicates the interface RFC2863 operational state as a st=
ring.
> +
>                 Possible values are:
> +
>                 "unknown", "notpresent", "down", "lowerlayerdown", "testi=
ng",
>                 "dormant", "up".
>
> diff --git a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm b/Document=
ation/ABI/testing/sysfs-class-net-cdc_ncm
> index f7be0e88b139..06416d0e163d 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
> +++ b/Documentation/ABI/testing/sysfs-class-net-cdc_ncm
> @@ -91,9 +91,9 @@ Date:         May 2014
>  KernelVersion: 3.16
>  Contact:       Bj=C3=B8rn Mork <bjorn@mork.no>
>  Description:
> -               Bit 0: 16-bit NTB supported (set to 1)
> -               Bit 1: 32-bit NTB supported
> -               Bits 2 =E2=80=93 15: reserved (reset to zero; must be ign=
ored by host)
> +               - Bit 0: 16-bit NTB supported (set to 1)
> +               - Bit 1: 32-bit NTB supported
> +               - Bits 2 =E2=80=93 15: reserved (reset to zero; must be i=
gnored by host)
>
>  What:          /sys/class/net/<iface>/cdc_ncm/dwNtbInMaxSize
>  Date:          May 2014
> diff --git a/Documentation/ABI/testing/sysfs-class-net-phydev b/Documenta=
tion/ABI/testing/sysfs-class-net-phydev
> index 206cbf538b59..40ced0ea4316 100644
> --- a/Documentation/ABI/testing/sysfs-class-net-phydev
> +++ b/Documentation/ABI/testing/sysfs-class-net-phydev
> @@ -35,7 +35,9 @@ Description:
>                 Ethernet driver during bus enumeration, encoded in string=
.
>                 This interface mode is used to configure the Ethernet MAC=
 with the
>                 appropriate mode for its data lines to the PHY hardware.
> +
>                 Possible values are:
> +
>                 <empty> (not available), mii, gmii, sgmii, tbi, rev-mii,
>                 rmii, rgmii, rgmii-id, rgmii-rxid, rgmii-txid, rtbi, smii
>                 xgmii, moca, qsgmii, trgmii, 1000base-x, 2500base-x, rxau=
i,
> diff --git a/Documentation/ABI/testing/sysfs-class-pktcdvd b/Documentatio=
n/ABI/testing/sysfs-class-pktcdvd
> index dde4f26d0780..ba1ce626591d 100644
> --- a/Documentation/ABI/testing/sysfs-class-pktcdvd
> +++ b/Documentation/ABI/testing/sysfs-class-pktcdvd
> @@ -11,15 +11,17 @@ KernelVersion:      2.6.20
>  Contact:       Thomas Maier <balagi@justmail.de>
>  Description:
>
> -               add:            (WO) Write a block device id (major:minor=
) to
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               add             (WO) Write a block device id (major:minor=
) to
>                                 create a new pktcdvd device and map it to=
 the
>                                 block device.
>
> -               remove:         (WO) Write the pktcdvd device id (major:m=
inor)
> +               remove          (WO) Write the pktcdvd device id (major:m=
inor)
>                                 to remove the pktcdvd device.
>
> -               device_map:     (RO) Shows the device mapping in format:
> +               device_map      (RO) Shows the device mapping in format:
>                                 pktcdvd[0-7] <pktdevid> <blkdevid>
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
>  What:          /sys/class/pktcdvd/pktcdvd[0-7]/dev
> @@ -65,29 +67,31 @@ Date:               Oct. 2006
>  KernelVersion: 2.6.20
>  Contact:       Thomas Maier <balagi@justmail.de>
>  Description:
> -               size:           (RO) Contains the size of the bio write q=
ueue.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               size            (RO) Contains the size of the bio write q=
ueue.
>
> -               congestion_off: (RW) If bio write queue size is below thi=
s mark,
> +               congestion_off  (RW) If bio write queue size is below thi=
s mark,
>                                 accept new bio requests from the block la=
yer.
>
> -               congestion_on:  (RW) If bio write queue size is higher as=
 this
> +               congestion_on   (RW) If bio write queue size is higher as=
 this
>                                 mark, do no longer accept bio write reque=
sts
>                                 from the block layer and wait till the pk=
tcdvd
>                                 device has processed enough bio's so that=
 bio
>                                 write queue size is below congestion off =
mark.
>                                 A value of <=3D 0 disables congestion con=
trol.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
>  Example:
>  --------
> -To use the pktcdvd sysfs interface directly, you can do:
> +To use the pktcdvd sysfs interface directly, you can do::
>
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
> @@ -43,7 +43,9 @@ Date:         May 2007
>  Contact:       linux-pm@vger.kernel.org
>  Description:
>                 Fine grain representation of battery capacity.
> +
>                 Access: Read
> +
>                 Valid values: 0 - 100 (percent)
>
>  What:          /sys/class/power_supply/<supply_name>/capacity_alert_max
> @@ -58,6 +60,7 @@ Description:
>                 low).
>
>                 Access: Read, Write
> +
>                 Valid values: 0 - 100 (percent)
>
>  What:          /sys/class/power_supply/<supply_name>/capacity_alert_min
> @@ -88,6 +91,7 @@ Description:
>                 completely useless.
>
>                 Access: Read
> +
>                 Valid values: 0 - 100 (percent)
>
>  What:          /sys/class/power_supply/<supply_name>/capacity_level
> @@ -111,6 +115,7 @@ Description:
>                 which they average readings to smooth out the reported va=
lue.
>
>                 Access: Read
> +
>                 Valid values: Represented in microamps. Negative values a=
re used
>                 for discharging batteries, positive values for charging b=
atteries.
>
> @@ -131,6 +136,7 @@ Description:
>                 This value is not averaged/smoothed.
>
>                 Access: Read
> +
>                 Valid values: Represented in microamps. Negative values a=
re used
>                 for discharging batteries, positive values for charging b=
atteries.
>
> @@ -383,7 +389,7 @@ Description:
>
>  **USB Properties**
>
> -What:          /sys/class/power_supply/<supply_name>/current_avg
> +What:          /sys/class/power_supply/<supply_name>/current_avg
>  Date:          May 2007
>  Contact:       linux-pm@vger.kernel.org
>  Description:
> @@ -449,6 +455,7 @@ Description:
>                 solved using power limit use input_voltage_limit.
>
>                 Access: Read, Write
> +
>                 Valid values: Represented in microvolts
>
>  What:          /sys/class/power_supply/<supply_name>/input_power_limit
> @@ -462,6 +469,7 @@ Description:
>                 limit only for problems that can be solved using power li=
mit.
>
>                 Access: Read, Write
> +
>                 Valid values: Represented in microwatts
>
>  What:          /sys/class/power_supply/<supply_name>/online,
> @@ -747,6 +755,7 @@ Description:
>                 manufactured.
>
>                 Access: Read
> +
>                 Valid values: Reported as integer
>
>  What:          /sys/class/power_supply/<supply_name>/manufacture_month
> @@ -756,6 +765,7 @@ Description:
>                 Reports the month when the device has been manufactured.
>
>                 Access: Read
> +
>                 Valid values: 1-12
>
>  What:          /sys/class/power_supply/<supply_name>/manufacture_day
> diff --git a/Documentation/ABI/testing/sysfs-class-power-mp2629 b/Documen=
tation/ABI/testing/sysfs-class-power-mp2629
> index 327a07e22805..914d67caac0d 100644
> --- a/Documentation/ABI/testing/sysfs-class-power-mp2629
> +++ b/Documentation/ABI/testing/sysfs-class-power-mp2629
> @@ -5,4 +5,5 @@ Description:
>                 Represents a battery impedance compensation to accelerate=
 charging.
>
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
>         Possible values are:
>
>                 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> -               "auto"          draw power as appropriate for detected
> +               "auto"          draw power as appropriate for detected
>                                 power source and battery status.
> -               "off"           do not draw any power.
> +               "off"           do not draw any power.
>                 "continuous"    activate mode described as "linear" in
>                                 TWL data sheets.  This uses whatever
>                                 current is available and doesn't switch o=
ff
> diff --git a/Documentation/ABI/testing/sysfs-class-rapidio b/Documentatio=
n/ABI/testing/sysfs-class-rapidio
> index 8716beeb16c1..19aefb21b639 100644
> --- a/Documentation/ABI/testing/sysfs-class-rapidio
> +++ b/Documentation/ABI/testing/sysfs-class-rapidio
> @@ -6,6 +6,7 @@ Description:
>                 The /sys/class/rapidio_port subdirectory contains individ=
ual
>                 subdirectories named as "rapidioN" where N =3D mport ID r=
egistered
>                 with RapidIO subsystem.
> +
>                 NOTE: An mport ID is not a RapidIO destination ID assigne=
d to a
>                 given local mport device.
>
> @@ -16,7 +17,9 @@ Contact:      Matt Porter <mporter@kernel.crashing.org>=
,
>                 Alexandre Bounine <alexandre.bounine@idt.com>
>  Description:
>                 (RO) reports RapidIO common transport system size:
> +
>                 0 =3D small (8-bit destination ID, max. 256 devices),
> +
>                 1 =3D large (16-bit destination ID, max. 65536 devices).
>
>  What:          /sys/class/rapidio_port/rapidioN/port_destid
> @@ -25,31 +28,32 @@ KernelVersion:      v3.15
>  Contact:       Matt Porter <mporter@kernel.crashing.org>,
>                 Alexandre Bounine <alexandre.bounine@idt.com>
>  Description:
> -               (RO) reports RapidIO destination ID assigned to the given
> -               RapidIO mport device. If value 0xFFFFFFFF is returned thi=
s means
> -               that no valid destination ID have been assigned to the mp=
ort
> -               (yet). Normally, before enumeration/discovery have been e=
xecuted
> -               only fabric enumerating mports have a valid destination I=
D
> -               assigned to them using "hdid=3D..." rapidio module parame=
ter.
> +
> +(RO) reports RapidIO destination ID assigned to the given
> +RapidIO mport device. If value 0xFFFFFFFF is returned this means
> +that no valid destination ID have been assigned to the mport
> +(yet). Normally, before enumeration/discovery have been executed
> +only fabric enumerating mports have a valid destination ID
> +assigned to them using "hdid=3D..." rapidio module parameter.
>
>  After enumeration or discovery was performed for a given mport device,
>  the corresponding subdirectory will also contain subdirectories for each
>  child RapidIO device connected to the mport.
>
>  The example below shows mport device subdirectory with several child Rap=
idIO
> -devices attached to it.
> +devices attached to it::
>
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
>
>                 This will be one of the following strings:
>
> -                       off
> -                       on
> -                       error
> -                       fast
> -                       normal
> -                       idle
> -                       standby
> +                       - off
> +                       - on
> +                       - error
> +                       - fast
> +                       - normal
> +                       - idle
> +                       - standby
>
>                 "off" means the regulator is not supplying power to the
>                 system.
> @@ -74,9 +74,9 @@ Description:
>
>                 This will be one of the following strings:
>
> -               'voltage'
> -               'current'
> -               'unknown'
> +               - 'voltage'
> +               - 'current'
> +               - 'unknown'
>
>                 'voltage' means the regulator output voltage can be contr=
olled
>                 by software.
> @@ -129,11 +129,11 @@ Description:
>
>                 The opmode value can be one of the following strings:
>
> -               'fast'
> -               'normal'
> -               'idle'
> -               'standby'
> -               'unknown'
> +               - 'fast'
> +               - 'normal'
> +               - 'idle'
> +               - 'standby'
> +               - 'unknown'
>
>                 The modes are described in include/linux/regulator/consum=
er.h
>
> @@ -360,9 +360,9 @@ Description:
>
>                 This will be one of the following strings:
>
> -               'enabled'
> -               'disabled'
> -               'unknown'
> +               - 'enabled'
> +               - 'disabled'
> +               - 'unknown'
>
>                 'enabled' means the regulator is in bypass mode.
>
> diff --git a/Documentation/ABI/testing/sysfs-class-remoteproc b/Documenta=
tion/ABI/testing/sysfs-class-remoteproc
> index 066b9b6f4924..0c9ee55098b8 100644
> --- a/Documentation/ABI/testing/sysfs-class-remoteproc
> +++ b/Documentation/ABI/testing/sysfs-class-remoteproc
> @@ -16,11 +16,11 @@ Description:        Remote processor state
>
>                 Reports the state of the remote processor, which will be =
one of:
>
> -               "offline"
> -               "suspended"
> -               "running"
> -               "crashed"
> -               "invalid"
> +               - "offline"
> +               - "suspended"
> +               - "running"
> +               - "crashed"
> +               - "invalid"
>
>                 "offline" means the remote processor is powered off.
>
> @@ -38,8 +38,8 @@ Description:  Remote processor state
>                 Writing this file controls the state of the remote proces=
sor.
>                 The following states can be written:
>
> -               "start"
> -               "stop"
> +               - "start"
> +               - "stop"
>
>                 Writing "start" will attempt to start the processor runni=
ng the
>                 firmware indicated by, or written to,
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
>
>                  to start (or stop) scanning on a channel.  <type> is one=
 of:
> -                    0 - scan
> -                    1 - scan outside BP
> -                    2 - scan while inactive
> -                    3 - scanning disabled
> -                    4 - scan (with start time of <bpst offset>)
> +
> +                  =3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +                    0   scan
> +                    1   scan outside BP
> +                    2   scan while inactive
> +                    3   scanning disabled
> +                    4   scan (with start time of <bpst offset>)
> +                  =3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:           /sys/class/uwb_rc/uwbN/mac_address
>  Date:           July 2008
> diff --git a/Documentation/ABI/testing/sysfs-class-watchdog b/Documentati=
on/ABI/testing/sysfs-class-watchdog
> index 9860a8b2ba75..585caecda3a5 100644
> --- a/Documentation/ABI/testing/sysfs-class-watchdog
> +++ b/Documentation/ABI/testing/sysfs-class-watchdog
> @@ -91,10 +91,13 @@ Description:
>                 h/w strapping (for WDT2 only).
>
>                 At alternate flash the 'access_cs0' sysfs node provides:
> -                       ast2400: a way to get access to the primary SPI f=
lash
> +
> +                       ast2400:
> +                               a way to get access to the primary SPI fl=
ash
>                                 chip at CS0 after booting from the altern=
ate
>                                 chip at CS1.
> -                       ast2500: a way to restore the normal address mapp=
ing
> +                       ast2500:
> +                               a way to restore the normal address mappi=
ng
>                                 from (CS0->CS1, CS1->CS0) to (CS0->CS0,
>                                 CS1->CS1).
>
> diff --git a/Documentation/ABI/testing/sysfs-dev b/Documentation/ABI/test=
ing/sysfs-dev
> index a9f2b8b0530f..d1739063e762 100644
> --- a/Documentation/ABI/testing/sysfs-dev
> +++ b/Documentation/ABI/testing/sysfs-dev
> @@ -9,9 +9,10 @@ Description:   The /sys/dev tree provides a method to lo=
ok up the sysfs
>                 the form "<major>:<minor>".  These links point to the
>                 corresponding sysfs path for the given device.
>
> -               Example:
> -               $ readlink /sys/dev/block/8:32
> -               ../../block/sdc
> +               Example::
> +
> +                 $ readlink /sys/dev/block/8:32
> +                 ../../block/sdc
>
>                 Entries in /sys/dev/char and /sys/dev/block will be
>                 dynamically created and destroyed as devices enter and
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
>
> -                $ ls /sys/devices/uncore_iio_0/die*
> -                -r--r--r-- /sys/devices/uncore_iio_0/die0
> -                -r--r--r-- /sys/devices/uncore_iio_0/die1
> -                -r--r--r-- /sys/devices/uncore_iio_0/die2
> -                -r--r--r-- /sys/devices/uncore_iio_0/die3
> +                   $ ls /sys/devices/uncore_iio_0/die*
> +                   -r--r--r-- /sys/devices/uncore_iio_0/die0
> +                   -r--r--r-- /sys/devices/uncore_iio_0/die1
> +                   -r--r--r-- /sys/devices/uncore_iio_0/die2
> +                   -r--r--r-- /sys/devices/uncore_iio_0/die3
>
> -                $ tail /sys/devices/uncore_iio_0/die*
> -                =3D=3D> /sys/devices/uncore_iio_0/die0 <=3D=3D
> -                0000:00
> -                =3D=3D> /sys/devices/uncore_iio_0/die1 <=3D=3D
> -                0000:40
> -                =3D=3D> /sys/devices/uncore_iio_0/die2 <=3D=3D
> -                0000:80
> -                =3D=3D> /sys/devices/uncore_iio_0/die3 <=3D=3D
> -                0000:c0
> +                   $ tail /sys/devices/uncore_iio_0/die*
> +                   =3D=3D> /sys/devices/uncore_iio_0/die0 <=3D=3D
> +                   0000:00
> +                   =3D=3D> /sys/devices/uncore_iio_0/die1 <=3D=3D
> +                   0000:40
> +                   =3D=3D> /sys/devices/uncore_iio_0/die2 <=3D=3D
> +                   0000:80
> +                   =3D=3D> /sys/devices/uncore_iio_0/die3 <=3D=3D
> +                   0000:c0
>
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
> +                   IIO PMU 0 on die 0 belongs to PCI RP on bus 0x00, dom=
ain 0x0000
> +                   IIO PMU 0 on die 1 belongs to PCI RP on bus 0x40, dom=
ain 0x0000
> +                   IIO PMU 0 on die 2 belongs to PCI RP on bus 0x80, dom=
ain 0x0000
> +                   IIO PMU 0 on die 3 belongs to PCI RP on bus 0xc0, dom=
ain 0x0000
> diff --git a/Documentation/ABI/testing/sysfs-devices-memory b/Documentati=
on/ABI/testing/sysfs-devices-memory
> index deef3b5723cf..2da2b1fba2c1 100644
> --- a/Documentation/ABI/testing/sysfs-devices-memory
> +++ b/Documentation/ABI/testing/sysfs-devices-memory
> @@ -47,16 +47,19 @@ Description:
>                 online/offline state of the memory section.  When written=
,
>                 root can toggle the the online/offline state of a removab=
le
>                 memory section (see removable file description above)
> -               using the following commands.
> -               # echo online > /sys/devices/system/memory/memoryX/state
> -               # echo offline > /sys/devices/system/memory/memoryX/state
> +               using the following commands::
> +
> +                 # echo online > /sys/devices/system/memory/memoryX/stat=
e
> +                 # echo offline > /sys/devices/system/memory/memoryX/sta=
te
>
>                 For example, if /sys/devices/system/memory/memory22/remov=
able
>                 contains a value of 1 and
>                 /sys/devices/system/memory/memory22/state contains the
>                 string "online" the following command can be executed by
> -               by root to offline that section.
> -               # echo offline > /sys/devices/system/memory/memory22/stat=
e
> +               by root to offline that section::
> +
> +                 # echo offline > /sys/devices/system/memory/memory22/st=
ate
> +
>  Users:         hotplug memory remove tools
>                 http://www.ibm.com/developerworks/wikis/display/LinuxP/po=
werpc-utils
>
> @@ -78,6 +81,7 @@ Description:
>
>                 For example, the following symbolic link is created for
>                 memory section 9 on node0:
> +
>                 /sys/devices/system/memory/memory9/node0 -> ../../node/no=
de0
>
>
> @@ -90,4 +94,5 @@ Description:
>                 points to the corresponding /sys/devices/system/memory/me=
moryY
>                 memory section directory.  For example, the following sym=
bolic
>                 link is created for memory section 9 on node0.
> +
>                 /sys/devices/system/node/node0/memory9 -> ../../memory/me=
mory9
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadge=
t b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> index d548eaac230a..40f29a01fd14 100644
> --- a/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-_UDC_-gadget
> @@ -3,8 +3,9 @@ Date:           April 2010
>  Contact:       Fabien Chouteau <fabien.chouteau@barco.com>
>  Description:
>                 Show the suspend state of an USB composite gadget.
> -               1 -> suspended
> -               0 -> resumed
> +
> +               - 1 -> suspended
> +               - 0 -> resumed
>
>                 (_UDC_ is the name of the USB Device Controller driver)
>
> @@ -17,5 +18,6 @@ Description:
>                 Storage mode.
>
>                 Possible values are:
> -                       1 -> ignore the FUA flag
> -                       0 -> obey the FUA flag
> +
> +                       - 1 -> ignore the FUA flag
> +                       - 0 -> obey the FUA flag
> diff --git a/Documentation/ABI/testing/sysfs-devices-platform-ipmi b/Docu=
mentation/ABI/testing/sysfs-devices-platform-ipmi
> index afb5db856e1c..07df0ddc0b69 100644
> --- a/Documentation/ABI/testing/sysfs-devices-platform-ipmi
> +++ b/Documentation/ABI/testing/sysfs-devices-platform-ipmi
> @@ -123,38 +123,40 @@ KernelVersion:    v4.15
>  Contact:       openipmi-developer@lists.sourceforge.net
>  Description:
>
> -               idles:                  (RO) Number of times the interfac=
e was
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               idles                   (RO) Number of times the interfac=
e was
>                                         idle while being polled.
>
> -               watchdog_pretimeouts:   (RO) Number of watchdog pretimeou=
ts.
> +               watchdog_pretimeouts    (RO) Number of watchdog pretimeou=
ts.
>
> -               complete_transactions:  (RO) Number of completed messages=
.
> +               complete_transactions   (RO) Number of completed messages=
.
>
> -               events:                 (RO) Number of IPMI events receiv=
ed from
> +               events                  (RO) Number of IPMI events receiv=
ed from
>                                         the hardware.
>
> -               interrupts:             (RO) Number of interrupts the dri=
ver
> +               interrupts              (RO) Number of interrupts the dri=
ver
>                                         handled.
>
> -               hosed_count:            (RO) Number of times the hardware=
 didn't
> +               hosed_count             (RO) Number of times the hardware=
 didn't
>                                         follow the state machine.
>
> -               long_timeouts:          (RO) Number of times the driver
> +               long_timeouts           (RO) Number of times the driver
>                                         requested a timer while nothing w=
as in
>                                         progress.
>
> -               flag_fetches:           (RO) Number of times the driver
> +               flag_fetches            (RO) Number of times the driver
>                                         requested flags from the hardware=
.
>
> -               attentions:             (RO) Number of time the driver go=
t an
> +               attentions              (RO) Number of time the driver go=
t an
>                                         ATTN from the hardware.
>
> -               incoming_messages:      (RO) Number of asynchronous messa=
ges
> +               incoming_messages       (RO) Number of asynchronous messa=
ges
>                                         received.
>
> -               short_timeouts:         (RO) Number of times the driver
> +               short_timeouts          (RO) Number of times the driver
>                                         requested a timer while an operat=
ion was
>                                         in progress.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
>  What:          /sys/devices/platform/ipmi_si.*/interrupts_enabled
> @@ -201,38 +203,40 @@ Date:             Sep, 2017
>  KernelVersion: v4.15
>  Contact:       openipmi-developer@lists.sourceforge.net
>  Description:
> -               hosed:                  (RO) Number of times the hardware=
 didn't
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               hosed                   (RO) Number of times the hardware=
 didn't
>                                         follow the state machine.
>
> -               alerts:                 (RO) Number of alerts received.
> +               alerts                  (RO) Number of alerts received.
>
> -               sent_messages:          (RO) Number of total messages sen=
t.
> +               sent_messages           (RO) Number of total messages sen=
t.
>
> -               sent_message_parts:     (RO) Number of message parts sent=
.
> +               sent_message_parts      (RO) Number of message parts sent=
.
>                                         Messages may be broken into parts=
 if
>                                         they are long.
>
> -               received_messages:      (RO) Number of message responses
> +               received_messages       (RO) Number of message responses
>                                         received.
>
> -               received_message_parts: (RO) Number of message fragments
> +               received_message_parts  (RO) Number of message fragments
>                                         received.
>
> -               events:                 (RO) Number of received events.
> +               events                  (RO) Number of received events.
>
> -               watchdog_pretimeouts:   (RO) Number of watchdog pretimeou=
ts.
> +               watchdog_pretimeouts    (RO) Number of watchdog pretimeou=
ts.
>
> -               flag_fetches:           (RO) Number of times a flag fetch=
 was
> +               flag_fetches            (RO) Number of times a flag fetch=
 was
>                                         requested.
>
> -               send_retries:           (RO) Number of time a message was
> +               send_retries            (RO) Number of time a message was
>                                         retried.
>
> -               receive_retries:        (RO) Number of times the receive =
of a
> +               receive_retries         (RO) Number of times the receive =
of a
>                                         message was retried.
>
> -               send_errors:            (RO) Number of times the send of =
a
> +               send_errors             (RO) Number of times the send of =
a
>                                         message failed.
>
> -               receive_errors:         (RO) Number of errors in receivin=
g
> +               receive_errors          (RO) Number of errors in receivin=
g
>                                         messages.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documen=
tation/ABI/testing/sysfs-devices-system-cpu
> index 274c337ec6a9..1a04ca8162ad 100644
> --- a/Documentation/ABI/testing/sysfs-devices-system-cpu
> +++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
> @@ -169,7 +169,7 @@ Description:
>                               observed CPU idle duration was too short fo=
r it
>                               (a count).
>
> -               below:   (RO) Number of times this state was entered, but=
 the
> +               below:   (RO) Number of times this state was entered, but=
 the
>                               observed CPU idle duration was too long for=
 it
>                               (a count).
>                 =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> @@ -601,7 +601,7 @@ Description:        Secure Virtual Machine
>                 Facility in POWER9 and newer processors. i.e., it is a Se=
cure
>                 Virtual Machine.
>
> -What:          /sys/devices/system/cpu/cpuX/purr
> +What:          /sys/devices/system/cpu/cpuX/purr
>  Date:          Apr 2005
>  Contact:       Linux for PowerPC mailing list <linuxppc-dev@ozlabs.org>
>  Description:   PURR ticks for this CPU since the system boot.
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-lenovo b/Document=
ation/ABI/testing/sysfs-driver-hid-lenovo
> index 53a0725962e1..aee85ca1f6be 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-lenovo
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-lenovo
> @@ -3,14 +3,18 @@ Date:         July 2011
>  Contact:       linux-input@vger.kernel.org
>  Description:   This controls if mouse clicks should be generated if the =
trackpoint is quickly pressed. How fast this press has to be
>                 is being controlled by press_speed.
> +
>                 Values are 0 or 1.
> +
>                 Applies to Thinkpad USB Keyboard with TrackPoint.
>
>  What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<inte=
rface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/dragging
>  Date:          July 2011
>  Contact:       linux-input@vger.kernel.org
>  Description:   If this setting is enabled, it is possible to do dragging=
 by pressing the trackpoint. This requires press_to_select to be enabled.
> +
>                 Values are 0 or 1.
> +
>                 Applies to Thinkpad USB Keyboard with TrackPoint.
>
>  What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<inte=
rface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/release_to_select
> @@ -25,7 +29,9 @@ Date:         July 2011
>  Contact:       linux-input@vger.kernel.org
>  Description:   This setting controls if the mouse click events generated=
 by pressing the trackpoint (if press_to_select is enabled) generate
>                 a left or right mouse button click.
> +
>                 Values are 0 or 1.
> +
>                 Applies to Thinkpad USB Keyboard with TrackPoint.
>
>  What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<inte=
rface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/sensitivity
> @@ -39,12 +45,16 @@ What:               /sys/bus/usb/devices/<busnum>-<de=
vnum>:<config num>.<interface num>/<hid-
>  Date:          July 2011
>  Contact:       linux-input@vger.kernel.org
>  Description:   This setting controls how fast the trackpoint needs to be=
 pressed to generate a mouse click if press_to_select is enabled.
> +
>                 Values are decimal integers from 1 (slowest) to 255 (fast=
est).
> +
>                 Applies to Thinkpad USB Keyboard with TrackPoint.
>
>  What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<inte=
rface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/fn_lock
>  Date:          July 2014
>  Contact:       linux-input@vger.kernel.org
>  Description:   This setting controls whether Fn Lock is enabled on the k=
eyboard (i.e. if F1 is Mute or F1)
> +
>                 Values are 0 or 1
> +
>                 Applies to ThinkPad Compact (USB|Bluetooth) Keyboard with=
 TrackPoint.
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-ntrig b/Documenta=
tion/ABI/testing/sysfs-driver-hid-ntrig
> index e574a5625efe..0e323a5cec6c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-ntrig
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-ntrig
> @@ -29,12 +29,13 @@ Contact:    linux-input@vger.kernel.org
>  Description:
>                 Threholds to override activation slack.
>
> -               activation_width:       (RW) Width threshold to immediate=
ly
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               activation_width        (RW) Width threshold to immediate=
ly
>                                         start processing touch events.
>
> -               activation_height:      (RW) Height threshold to immediat=
ely
> +               activation_height       (RW) Height threshold to immediat=
ely
>                                         start processing touch events.
> -
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/bus/hid/drivers/ntrig/<dev>/min_width
>  What:          /sys/bus/hid/drivers/ntrig/<dev>/min_height
> @@ -44,11 +45,13 @@ Contact:    linux-input@vger.kernel.org
>  Description:
>                 Minimum size contact accepted.
>
> -               min_width:      (RW) Minimum touch contact width to decid=
e
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               min_width       (RW) Minimum touch contact width to decid=
e
>                                 activation and activity.
>
> -               min_height:     (RW) Minimum touch contact height to deci=
de
> +               min_height      (RW) Minimum touch contact height to deci=
de
>                                 activation and activity.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
>  What:          /sys/bus/hid/drivers/ntrig/<dev>/sensor_physical_width
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone b/Doc=
umentation/ABI/testing/sysfs-driver-hid-roccat-kone
> index 8f7982c70d72..11cd9bf0ad18 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-roccat-kone
> @@ -3,17 +3,21 @@ Date:         March 2010
>  Contact:       Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:   It is possible to switch the dpi setting of the mouse wit=
h the
>                 press of a button.
> +
>                 When read, this file returns the raw number of the actual=
 dpi
>                 setting reported by the mouse. This number has to be furt=
her
>                 processed to receive the real dpi value:
>
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
>                 VALUE DPI
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
>                 1     800
>                 2     1200
>                 3     1600
>                 4     2000
>                 5     2400
>                 6     3200
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D
>
>                 This file is readonly.
>  Users:         http://roccat.sourceforge.net
> @@ -22,6 +26,7 @@ What:         /sys/bus/usb/devices/<busnum>-<devnum>:<c=
onfig num>.<interface num>/<hid-
>  Date:          March 2010
>  Contact:       Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:   When read, this file returns the number of the actual pro=
file.
> +
>                 This file is readonly.
>  Users:         http://roccat.sourceforge.net
>
> @@ -33,6 +38,7 @@ Description:  When read, this file returns the raw inte=
ger version number of the
>                 further usage in other programs. To receive the real vers=
ion
>                 number the decimal point has to be shifted 2 positions to=
 the
>                 left. E.g. a returned value of 138 means 1.38
> +
>                 This file is readonly.
>  Users:         http://roccat.sourceforge.net
>
> @@ -43,10 +49,13 @@ Description:        The mouse can store 5 profiles wh=
ich can be switched by the
>                  press of a button. A profile holds information like butt=
on
>                  mappings, sensitivity, the colors of the 5 leds and ligh=
t
>                  effects.
> +
>                  When read, these files return the respective profile. Th=
e
>                  returned data is 975 bytes in size.
> +
>                 When written, this file lets one write the respective pro=
file
>                 data back to the mouse. The data has to be 975 bytes long=
.
> +
>                 The mouse will reject invalid data, whereas the profile n=
umber
>                 stored in the profile doesn't need to fit the number of t=
he
>                 store.
> @@ -58,6 +67,7 @@ Contact:      Stefan Achatz <erazor_de@users.sourceforg=
e.net>
>  Description:   When read, this file returns the settings stored in the m=
ouse.
>                 The size of the data is 36 bytes and holds information li=
ke the
>                 startup_profile, tcu state and calibration_data.
> +
>                 When written, this file lets write settings back to the m=
ouse.
>                 The data has to be 36 bytes long. The mouse will reject i=
nvalid
>                 data.
> @@ -67,8 +77,10 @@ What:                /sys/bus/usb/devices/<busnum>-<de=
vnum>:<config num>.<interface num>/<hid-
>  Date:          March 2010
>  Contact:       Stefan Achatz <erazor_de@users.sourceforge.net>
>  Description:   The integer value of this attribute ranges from 1 to 5.
> +
>                  When read, this attribute returns the number of the prof=
ile
>                  that's active when the mouse is powered on.
> +
>                 When written, this file sets the number of the startup pr=
ofile
>                 and the mouse activates this profile immediately.
>  Users:         http://roccat.sourceforge.net
> @@ -80,9 +92,12 @@ Description: The mouse has a "Tracking Control Unit" w=
hich lets the user
>                 calibrate the laser power to fit the mousepad surface.
>                 When read, this file returns the current state of the TCU=
,
>                 where 0 means off and 1 means on.
> +
>                 Writing 0 in this file will switch the TCU off.
> +
>                 Writing 1 in this file will start the calibration which t=
akes
>                 around 6 seconds to complete and activates the TCU.
> +
>  Users:         http://roccat.sourceforge.net
>
>  What:          /sys/bus/usb/devices/<busnum>-<devnum>:<config num>.<inte=
rface num>/<hid-bus>:<vendor-id>:<product-id>.<num>/kone/roccatkone<minor>/=
weight
> @@ -93,14 +108,18 @@ Description:       The mouse can be equipped with on=
e of four supplied weights
>                 and its value can be read out. When read, this file retur=
ns the
>                 raw value returned by the mouse which eases further proce=
ssing
>                 in other software.
> +
>                 The values map to the weights as follows:
>
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
>                 VALUE WEIGHT
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
>                 0     none
>                 1     5g
>                 2     10g
>                 3     15g
>                 4     20g
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D
>
>                 This file is readonly.
>  Users:         http://roccat.sourceforge.net
> diff --git a/Documentation/ABI/testing/sysfs-driver-hid-wiimote b/Documen=
tation/ABI/testing/sysfs-driver-hid-wiimote
> index cd7b82a5c27d..3bf43d9dcdfe 100644
> --- a/Documentation/ABI/testing/sysfs-driver-hid-wiimote
> +++ b/Documentation/ABI/testing/sysfs-driver-hid-wiimote
> @@ -20,6 +20,7 @@ Description:  This file contains the currently connecte=
d and initialized
>                 the official Nintendo Nunchuck extension and classic is t=
he
>                 Nintendo Classic Controller extension. The motionp extens=
ion can
>                 be combined with the other two.
> +
>                 Starting with kernel-version 3.11 Motion Plus hotplugging=
 is
>                 supported and if detected, it's no longer reported as sta=
tic
>                 extension. You will get uevent notifications for the moti=
on-plus
> diff --git a/Documentation/ABI/testing/sysfs-driver-input-exc3000 b/Docum=
entation/ABI/testing/sysfs-driver-input-exc3000
> index 3d316d54f81c..cd7c578aef2c 100644
> --- a/Documentation/ABI/testing/sysfs-driver-input-exc3000
> +++ b/Documentation/ABI/testing/sysfs-driver-input-exc3000
> @@ -4,6 +4,7 @@ Contact:        linux-input@vger.kernel.org
>  Description:    Reports the firmware version provided by the touchscreen=
, for example "00_T6" on a EXC80H60
>
>                 Access: Read
> +
>                 Valid values: Represented as string
>
>  What:          /sys/bus/i2c/devices/xxx/model
> @@ -12,4 +13,5 @@ Contact:      linux-input@vger.kernel.org
>  Description:    Reports the model identification provided by the touchsc=
reen, for example "Orion_1320" on a EXC80H60
>
>                 Access: Read
> +
>                 Valid values: Represented as string
> diff --git a/Documentation/ABI/testing/sysfs-driver-jz4780-efuse b/Docume=
ntation/ABI/testing/sysfs-driver-jz4780-efuse
> index bb6f5d6ceea0..4cf595d681e6 100644
> --- a/Documentation/ABI/testing/sysfs-driver-jz4780-efuse
> +++ b/Documentation/ABI/testing/sysfs-driver-jz4780-efuse
> @@ -4,7 +4,9 @@ Contact:        PrasannaKumar Muralidharan <prasannatsmku=
mar@gmail.com>
>  Description:   read-only access to the efuse on the Ingenic JZ4780 SoC
>                 The SoC has a one time programmable 8K efuse that is
>                 split into segments. The driver supports read only.
> -               The segments are
> +               The segments are:
> +
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>                 0x000   64 bit Random Number
>                 0x008  128 bit Ingenic Chip ID
>                 0x018  128 bit Customer ID
> @@ -12,5 +14,7 @@ Description:  read-only access to the efuse on the Inge=
nic JZ4780 SoC
>                 0x1E0    8 bit Protect Segment
>                 0x1E1 2296 bit HDMI Key
>                 0x300 2048 bit Security boot key
> +               =3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=3D=3D=3D =3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>  Users:         any user space application which wants to read the Chip
>                 and Customer ID
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
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-ufs b/Documentation/A=
BI/testing/sysfs-driver-ufs
> index d1a352194d2e..adc0d0e91607 100644
> --- a/Documentation/ABI/testing/sysfs-driver-ufs
> +++ b/Documentation/ABI/testing/sysfs-driver-ufs
> @@ -18,6 +18,7 @@ Contact:      Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the device type. This is one of the UFS
>                 device descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/devi=
ce_class
> @@ -26,6 +27,7 @@ Contact:      Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the device class. This is one of the UFS
>                 device descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/devi=
ce_sub_class
> @@ -34,6 +36,7 @@ Contact:      Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the UFS storage subclass. This is one of
>                 the UFS device descriptor parameters. The full informatio=
n
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/prot=
ocol
> @@ -43,6 +46,7 @@ Description:  This file shows the protocol supported by=
 an UFS device.
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/numb=
er_of_luns
> @@ -51,6 +55,7 @@ Contact:      Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows number of logical units. This is one of
>                 the UFS device descriptor parameters. The full informatio=
n
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/numb=
er_of_wluns
> @@ -60,6 +65,7 @@ Description:  This file shows number of well known logi=
cal units.
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/boot=
_enable
> @@ -69,6 +75,7 @@ Description:  This file shows value that indicates whet=
her the device is
>                 enabled for boot. This is one of the UFS device descripto=
r
>                 parameters. The full information about the descriptor cou=
ld
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/desc=
riptor_access_enable
> @@ -79,6 +86,7 @@ Description:  This file shows value that indicates whet=
her the device
>                 of the boot sequence. This is one of the UFS device descr=
iptor
>                 parameters. The full information about the descriptor cou=
ld
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/init=
ial_power_mode
> @@ -88,6 +96,7 @@ Description:  This file shows value that defines the po=
wer mode after
>                 device initialization or hardware reset. This is one of
>                 the UFS device descriptor parameters. The full informatio=
n
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/high=
_priority_lun
> @@ -96,6 +105,7 @@ Contact:     Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the high priority lun. This is one of
>                 the UFS device descriptor parameters. The full informatio=
n
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/secu=
re_removal_type
> @@ -104,6 +114,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the secure removal type. This is one of
>                 the UFS device descriptor parameters. The full informatio=
n
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/supp=
ort_security_lun
> @@ -113,6 +124,7 @@ Description:        This file shows whether the secur=
ity lun is supported.
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/bkop=
s_termination_latency
> @@ -122,6 +134,7 @@ Description:        This file shows the background op=
erations termination
>                 latency. This is one of the UFS device descriptor paramet=
ers.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/init=
ial_active_icc_level
> @@ -130,6 +143,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the initial active ICC level. This is one
>                 of the UFS device descriptor parameters. The full informa=
tion
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/spec=
ification_version
> @@ -138,6 +152,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the specification version. This is one
>                 of the UFS device descriptor parameters. The full informa=
tion
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/manu=
facturing_date
> @@ -147,6 +162,7 @@ Description:        This file shows the manufacturing=
 date in BCD format.
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/manu=
facturer_id
> @@ -155,6 +171,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the manufacturee ID. This is one of the
>                 UFS device descriptor parameters. The full information ab=
out
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtt_=
capability
> @@ -164,6 +181,7 @@ Description:        This file shows the maximum numbe=
r of outstanding RTTs
>                 supported by the device. This is one of the UFS device
>                 descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/rtc_=
update
> @@ -173,6 +191,7 @@ Description:        This file shows the frequency and=
 method of the realtime
>                 clock update. This is one of the UFS device descriptor
>                 parameters. The full information about the descriptor
>                 could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/ufs_=
features
> @@ -182,6 +201,7 @@ Description:        This file shows which features ar=
e supported by the device.
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be
>                 found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/ffu_=
timeout
> @@ -190,6 +210,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the FFU timeout. This is one of the
>                 UFS device descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/queu=
e_depth
> @@ -198,6 +219,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the device queue depth. This is one of th=
e
>                 UFS device descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/devi=
ce_version
> @@ -206,6 +228,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the device version. This is one of the
>                 UFS device descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/numb=
er_of_secure_wpa
> @@ -215,6 +238,7 @@ Description:        This file shows number of secure =
write protect areas
>                 supported by the device. This is one of the UFS device
>                 descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_=
max_data_size
> @@ -225,6 +249,7 @@ Description:        This file shows the maximum amoun=
t of data that may be
>                 This is one of the UFS device descriptor parameters.
>                 The full information about the descriptor could be found
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/psa_=
state_timeout
> @@ -234,6 +259,7 @@ Description:        This file shows the command maxim=
um timeout for a change
>                 in PSA state. This is one of the UFS device descriptor
>                 parameters. The full information about the descriptor cou=
ld
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -244,6 +270,7 @@ Description:        This file shows the MIPI UniPro v=
ersion number in BCD format.
>                 This is one of the UFS interconnect descriptor parameters=
.
>                 The full information about the descriptor could be found =
at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/interconnect_descripto=
r/mphy_version
> @@ -253,6 +280,7 @@ Description:        This file shows the MIPI M-PHY ve=
rsion number in BCD format.
>                 This is one of the UFS interconnect descriptor parameters=
.
>                 The full information about the descriptor could be found =
at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -264,6 +292,7 @@ Description:        This file shows the total memory =
quantity available to
>                 of the UFS geometry descriptor parameters. The full
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/ma=
x_number_of_luns
> @@ -273,6 +302,7 @@ Description:        This file shows the maximum numbe=
r of logical units
>                 supported by the UFS device. This is one of the UFS
>                 geometry descriptor parameters. The full information abou=
t
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/se=
gment_size
> @@ -281,6 +311,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the segment size. This is one of the UFS
>                 geometry descriptor parameters. The full information abou=
t
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/al=
location_unit_size
> @@ -289,6 +320,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the allocation unit size. This is one of
>                 the UFS geometry descriptor parameters. The full informat=
ion
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/mi=
n_addressable_block_size
> @@ -298,6 +330,7 @@ Description:        This file shows the minimum addre=
ssable block size. This
>                 is one of the UFS geometry descriptor parameters. The ful=
l
>                 information about the descriptor could be found at UFS
>                 specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/op=
timal_read_block_size
> @@ -307,6 +340,7 @@ Description:        This file shows the optimal read =
block size. This is one
>                 of the UFS geometry descriptor parameters. The full
>                 information about the descriptor could be found at UFS
>                 specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/op=
timal_write_block_size
> @@ -316,6 +350,7 @@ Description:        This file shows the optimal write=
 block size. This is one
>                 of the UFS geometry descriptor parameters. The full
>                 information about the descriptor could be found at UFS
>                 specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/ma=
x_in_buffer_size
> @@ -325,6 +360,7 @@ Description:        This file shows the maximum data-=
in buffer size. This
>                 is one of the UFS geometry descriptor parameters. The ful=
l
>                 information about the descriptor could be found at UFS
>                 specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/ma=
x_out_buffer_size
> @@ -334,6 +370,7 @@ Description:        This file shows the maximum data-=
out buffer size. This
>                 is one of the UFS geometry descriptor parameters. The ful=
l
>                 information about the descriptor could be found at UFS
>                 specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/rp=
mb_rw_size
> @@ -343,6 +380,7 @@ Description:        This file shows the maximum numbe=
r of RPMB frames allowed
>                 in Security Protocol In/Out. This is one of the UFS geome=
try
>                 descriptor parameters. The full information about the
>                 descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/dy=
n_capacity_resource_policy
> @@ -352,6 +390,7 @@ Description:        This file shows the dynamic capac=
ity resource policy. This
>                 is one of the UFS geometry descriptor parameters. The ful=
l
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/da=
ta_ordering
> @@ -361,6 +400,7 @@ Description:        This file shows support for out-o=
f-order data transfer.
>                 This is one of the UFS geometry descriptor parameters.
>                 The full information about the descriptor could be found =
at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/ma=
x_number_of_contexts
> @@ -370,6 +410,7 @@ Description:        This file shows maximum available=
 number of contexts which
>                 are supported by the device. This is one of the UFS geome=
try
>                 descriptor parameters. The full information about the
>                 descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sy=
s_data_tag_unit_size
> @@ -378,6 +419,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows system data tag unit size. This is one of
>                 the UFS geometry descriptor parameters. The full informat=
ion
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/sy=
s_data_tag_resource_size
> @@ -388,6 +430,7 @@ Description:        This file shows maximum storage a=
rea size allocated by
>                 This is one of the UFS geometry descriptor parameters.
>                 The full information about the descriptor could be found =
at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/se=
cure_removal_types
> @@ -397,6 +440,7 @@ Description:        This file shows supported secure =
removal types. This is
>                 one of the UFS geometry descriptor parameters. The full
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/me=
mory_types
> @@ -406,6 +450,7 @@ Description:        This file shows supported memory =
types. This is one of
>                 the UFS geometry descriptor parameters. The full
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_=
memory_max_alloc_units
> @@ -416,6 +461,7 @@ Description:        This file shows the maximum numbe=
r of allocation units for
>                 enhanced type 1-4). This is one of the UFS geometry
>                 descriptor parameters. The full information about the
>                 descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/*_=
memory_capacity_adjustment_factor
> @@ -426,6 +472,7 @@ Description:        This file shows the memory capaci=
ty adjustment factor for
>                 enhanced type 1-4). This is one of the UFS geometry
>                 descriptor parameters. The full information about the
>                 descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -436,6 +483,7 @@ Description:        This file shows preend of life in=
formation. This is one
>                 of the UFS health descriptor parameters. The full
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/health_descriptor/life=
_time_estimation_a
> @@ -445,6 +493,7 @@ Description:        This file shows indication of the=
 device life time
>                 (method a). This is one of the UFS health descriptor
>                 parameters. The full information about the descriptor
>                 could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/health_descriptor/life=
_time_estimation_b
> @@ -454,6 +503,7 @@ Description:        This file shows indication of the=
 device life time
>                 (method b). This is one of the UFS health descriptor
>                 parameters. The full information about the descriptor
>                 could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -464,6 +514,7 @@ Description:        This file shows maximum VCC, VCCQ=
 and VCCQ2 value for
>                 active ICC levels from 0 to 15. This is one of the UFS
>                 power descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -473,6 +524,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file contains a device manufactureer name string.
>                 The full information about the descriptor could be found =
at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/string_descriptors/pro=
duct_name
> @@ -480,6 +532,7 @@ Date:               February 2018
>  Contact:       Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:   This file contains a product name string. The full inform=
ation
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/string_descriptors/oem=
_id
> @@ -487,6 +540,7 @@ Date:               February 2018
>  Contact:       Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:   This file contains a OEM ID string. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/string_descriptors/ser=
ial_number
> @@ -495,6 +549,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file contains a device serial number string. The ful=
l
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/string_descriptors/pro=
duct_revision
> @@ -503,6 +558,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file contains a product revision string. The full
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -512,6 +568,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows boot LUN information. This is one of
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/lun_write=
_protect
> @@ -520,6 +577,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows LUN write protection status. This is one =
of
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/lun_queue=
_depth
> @@ -528,6 +586,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows LUN queue depth. This is one of the UFS
>                 unit descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/psa_sensi=
tive
> @@ -536,6 +595,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows PSA sensitivity. This is one of the UFS
>                 unit descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/lun_memor=
y_type
> @@ -544,6 +604,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows LUN memory type. This is one of the UFS
>                 unit descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/data_reli=
ability
> @@ -553,6 +614,7 @@ Description:        This file defines the device beha=
vior when a power failure
>                 occurs during a write operation. This is one of the UFS
>                 unit descriptor parameters. The full information about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/logical_b=
lock_size
> @@ -562,6 +624,7 @@ Description:        This file shows the size of addre=
ssable logical blocks
>                 (calculated as an exponent with base 2). This is one of
>                 the UFS unit descriptor parameters. The full information =
about
>                 the descriptor could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/logical_b=
lock_count
> @@ -571,6 +634,7 @@ Description:        This file shows total number of a=
ddressable logical blocks.
>                 This is one of the UFS unit descriptor parameters. The fu=
ll
>                 information about the descriptor could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/erase_blo=
ck_size
> @@ -579,6 +643,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the erase block size. This is one of
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/provision=
ing_type
> @@ -587,6 +652,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the thin provisioning type. This is one o=
f
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/physical_=
memory_resourse_count
> @@ -595,6 +661,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the total physical memory resources. This=
 is
>                 one of the UFS unit descriptor parameters. The full infor=
mation
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/context_c=
apabilities
> @@ -603,6 +670,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the context capabilities. This is one of
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/large_uni=
t_granularity
> @@ -611,6 +679,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the granularity of the LUN. This is one o=
f
>                 the UFS unit descriptor parameters. The full information
>                 about the descriptor could be found at UFS specifications=
 2.1.
> +
>                 The file is read only.
>
>
> @@ -619,6 +688,7 @@ Date:               February 2018
>  Contact:       Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:   This file shows the device init status. The full informat=
ion
>                 about the flag could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/permanent_wpe
> @@ -627,6 +697,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether permanent write protection is ena=
bled.
>                 The full information about the flag could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/power_on_wpe
> @@ -636,6 +707,7 @@ Description:        This file shows whether write pro=
tection is enabled on all
>                 logical units configured as power on write protected. The
>                 full information about the flag could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/bkops_enable
> @@ -644,6 +716,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether the device background operations =
are
>                 enabled. The full information about the flag could be
>                 found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/life_span_mode_e=
nable
> @@ -652,6 +725,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether the device life span mode is enab=
led.
>                 The full information about the flag could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/phy_resource_rem=
oval
> @@ -660,6 +734,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether physical resource removal is enab=
le.
>                 The full information about the flag could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/busy_rtc
> @@ -668,6 +743,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether the device is executing internal
>                 operation related to real time clock. The full informatio=
n
>                 about the flag could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/disable_fw_updat=
e
> @@ -676,6 +752,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows whether the device FW update is permanent=
ly
>                 disabled. The full information about the flag could be fo=
und
>                 at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -685,6 +762,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the boot lun enabled UFS device attrib=
ute.
>                 The full information about the attribute could be found a=
t
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/current_pow=
er_mode
> @@ -693,6 +771,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the current power mode UFS device attr=
ibute.
>                 The full information about the attribute could be found a=
t
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/active_icc_=
level
> @@ -701,6 +780,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the active icc level UFS device attrib=
ute.
>                 The full information about the attribute could be found a=
t
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/ooo_data_en=
abled
> @@ -709,6 +789,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the out of order data transfer enabled=
 UFS
>                 device attribute. The full information about the attribut=
e
>                 could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/bkops_statu=
s
> @@ -717,6 +798,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the background operations status UFS d=
evice
>                 attribute. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/purge_statu=
s
> @@ -725,6 +807,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the purge operation status UFS device
>                 attribute. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/max_data_in=
_size
> @@ -733,6 +816,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the maximum data size in a DATA IN
>                 UPIU. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/max_data_ou=
t_size
> @@ -741,6 +825,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file shows the maximum number of bytes that can be
>                 requested with a READY TO TRANSFER UPIU. The full informa=
tion
>                 about the attribute could be found at UFS specifications =
2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/reference_c=
lock_frequency
> @@ -749,6 +834,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the reference clock frequency UFS devi=
ce
>                 attribute. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/configurati=
on_descriptor_lock
> @@ -765,6 +851,7 @@ Description:        This file provides the maximum cu=
rrent number of
>                 outstanding RTTs in device that is allowed. The full
>                 information about the attribute could be found at
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/exception_e=
vent_control
> @@ -773,6 +860,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the exception event control UFS device
>                 attribute. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/exception_e=
vent_status
> @@ -781,6 +869,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the exception event status UFS device
>                 attribute. The full information about the attribute could
>                 be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/ffu_status
> @@ -789,6 +878,7 @@ Contact:    Stanislav Nijnikov <stanislav.nijnikov@wd=
c.com>
>  Description:   This file provides the ffu status UFS device attribute.
>                 The full information about the attribute could be found a=
t
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/psa_state
> @@ -796,6 +886,7 @@ Date:               February 2018
>  Contact:       Stanislav Nijnikov <stanislav.nijnikov@wdc.com>
>  Description:   This file show the PSA feature status. The full informati=
on
>                 about the attribute could be found at UFS specifications =
2.1.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/psa_data_si=
ze
> @@ -805,6 +896,7 @@ Description:        This file shows the amount of dat=
a that the host plans to
>                 load to all logical units in pre-soldering state.
>                 The full information about the attribute could be found a=
t
>                 UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -815,6 +907,7 @@ Description:        This file shows the The amount of=
 physical memory needed
>                 to be removed from the physical memory resources pool of
>                 the particular logical unit. The full information about
>                 the attribute could be found at UFS specifications 2.1.
> +
>                 The file is read only.
>
>
> @@ -824,24 +917,28 @@ Contact:  Subhash Jadavani <subhashj@codeaurora.org=
>
>  Description:   This entry could be used to set or show the UFS device
>                 runtime power management level. The current driver
>                 implementation supports 6 levels with next target states:
> -               0 - an UFS device will stay active, an UIC link will
> -               stay active
> -               1 - an UFS device will stay active, an UIC link will
> -               hibernate
> -               2 - an UFS device will moved to sleep, an UIC link will
> -               stay active
> -               3 - an UFS device will moved to sleep, an UIC link will
> -               hibernate
> -               4 - an UFS device will be powered off, an UIC link will
> -               hibernate
> -               5 - an UFS device will be powered off, an UIC link will
> -               be powered off
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   an UFS device will stay active, an UIC link will
> +                   stay active
> +               1   an UFS device will stay active, an UIC link will
> +                   hibernate
> +               2   an UFS device will moved to sleep, an UIC link will
> +                   stay active
> +               3   an UFS device will moved to sleep, an UIC link will
> +                   hibernate
> +               4   an UFS device will be powered off, an UIC link will
> +                   hibernate
> +               5   an UFS device will be powered off, an UIC link will
> +                   be powered off
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/rpm_target_dev_state
>  Date:          February 2018
>  Contact:       Subhash Jadavani <subhashj@codeaurora.org>
>  Description:   This entry shows the target power mode of an UFS device
>                 for the chosen runtime power management level.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/rpm_target_link_state
> @@ -849,6 +946,7 @@ Date:               February 2018
>  Contact:       Subhash Jadavani <subhashj@codeaurora.org>
>  Description:   This entry shows the target state of an UFS UIC link
>                 for the chosen runtime power management level.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/spm_lvl
> @@ -857,24 +955,28 @@ Contact:  Subhash Jadavani <subhashj@codeaurora.org=
>
>  Description:   This entry could be used to set or show the UFS device
>                 system power management level. The current driver
>                 implementation supports 6 levels with next target states:
> -               0 - an UFS device will stay active, an UIC link will
> -               stay active
> -               1 - an UFS device will stay active, an UIC link will
> -               hibernate
> -               2 - an UFS device will moved to sleep, an UIC link will
> -               stay active
> -               3 - an UFS device will moved to sleep, an UIC link will
> -               hibernate
> -               4 - an UFS device will be powered off, an UIC link will
> -               hibernate
> -               5 - an UFS device will be powered off, an UIC link will
> -               be powered off
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   an UFS device will stay active, an UIC link will
> +                   stay active
> +               1   an UFS device will stay active, an UIC link will
> +                   hibernate
> +               2   an UFS device will moved to sleep, an UIC link will
> +                   stay active
> +               3   an UFS device will moved to sleep, an UIC link will
> +                   hibernate
> +               4   an UFS device will be powered off, an UIC link will
> +                   hibernate
> +               5   an UFS device will be powered off, an UIC link will
> +                   be powered off
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/spm_target_dev_state
>  Date:          February 2018
>  Contact:       Subhash Jadavani <subhashj@codeaurora.org>
>  Description:   This entry shows the target power mode of an UFS device
>                 for the chosen system power management level.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/spm_target_link_state
> @@ -882,18 +984,21 @@ Date:             February 2018
>  Contact:       Subhash Jadavani <subhashj@codeaurora.org>
>  Description:   This entry shows the target state of an UFS UIC link
>                 for the chosen system power management level.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_p=
resv_us_en
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows if preserve user-space was configured
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_s=
hared_alloc_units
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the shared allocated units of WB buffer
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/device_descriptor/wb_t=
ype
> @@ -901,6 +1006,7 @@ Date:              June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the configured WB type.
>                 0x1 for shared buffer mode. 0x0 for dedicated buffer mode=
.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb=
_buff_cap_adj
> @@ -910,6 +1016,7 @@ Description:       This entry shows the total user-s=
pace decrease in shared
>                 buffer mode.
>                 The value of this parameter is 3 for TLC NAND when SLC mo=
de
>                 is used as WriteBooster Buffer. 2 for MLC NAND.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb=
_max_alloc_units
> @@ -917,6 +1024,7 @@ Date:              June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the Maximum total WriteBooster Buffer si=
ze
>                 which is supported by the entire device.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb=
_max_wb_luns
> @@ -924,6 +1032,7 @@ Date:              June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the maximum number of luns that can supp=
ort
>                 WriteBooster.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb=
_sup_red_type
> @@ -937,46 +1046,59 @@ Description:     The supportability of user space =
reduction mode
>                 preserve user space type.
>                 02h: Device can be configured in either user space
>                 reduction type or preserve user space type.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/geometry_descriptor/wb=
_sup_wb_type
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   The supportability of WriteBooster Buffer type.
> -               00h: LU based WriteBooster Buffer configuration
> -               01h: Single shared WriteBooster Buffer
> -               configuration
> -               02h: Supporting both LU based WriteBooster
> -               Buffer and Single shared WriteBooster Buffer
> -               configuration
> +
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               00h  LU based WriteBooster Buffer configuration
> +               01h  Single shared WriteBooster Buffer configuration
> +               02h  Supporting both LU based WriteBooster.
> +                    Buffer and Single shared WriteBooster Buffer configu=
ration
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_enable
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the status of WriteBooster.
> -               0: WriteBooster is not enabled.
> -               1: WriteBooster is enabled
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  WriteBooster is not enabled.
> +               1  WriteBooster is enabled
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_en
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows if flush is enabled.
> -               0: Flush operation is not performed.
> -               1: Flush operation is performed.
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  Flush operation is not performed.
> +               1  Flush operation is performed.
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/flags/wb_flush_during_=
h8
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   Flush WriteBooster Buffer during hibernate state.
> -               0: Device is not allowed to flush the
> -               WriteBooster Buffer during link hibernate
> -               state.
> -               1: Device is allowed to flush the
> -               WriteBooster Buffer during link hibernate
> -               state
> +
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +               0  Device is not allowed to flush the
> +                  WriteBooster Buffer during link hibernate state.
> +               1  Device is allowed to flush the
> +                  WriteBooster Buffer during link hibernate state.
> +               =3D=3D =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_avail_bu=
f
> @@ -984,23 +1106,30 @@ Date:            June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the amount of unused WriteBooster buffer
>                 available.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_cur_buf
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the amount of unused current buffer.
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_flush_st=
atus
>  Date:          June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the flush operation status.
> -               00h: idle
> -               01h: Flush operation in progress
> -               02h: Flush operation stopped prematurely.
> -               03h: Flush operation completed successfully
> -               04h: Flush operation general failure
> +
> +
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               00h  idle
> +               01h  Flush operation in progress
> +               02h  Flush operation stopped prematurely.
> +               03h  Flush operation completed successfully
> +               04h  Flush operation general failure
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/bus/platform/drivers/ufshcd/*/attributes/wb_life_tim=
e_est
> @@ -1008,9 +1137,13 @@ Date:            June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows an indication of the WriteBooster Buffer
>                 lifetime based on the amount of performed program/erase c=
ycles
> -               01h: 0% - 10% WriteBooster Buffer life time used
> +
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +               01h  0% - 10% WriteBooster Buffer life time used
>                 ...
> -               0Ah: 90% - 100% WriteBooster Buffer life time used
> +               0Ah  90% - 100% WriteBooster Buffer life time used
> +               =3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> +
>                 The file is read only.
>
>  What:          /sys/class/scsi_device/*/device/unit_descriptor/wb_buf_al=
loc_units
> @@ -1018,4 +1151,5 @@ Date:             June 2020
>  Contact:       Asutosh Das <asutoshd@codeaurora.org>
>  Description:   This entry shows the configured size of WriteBooster buff=
er.
>                 0400h corresponds to 4GB.
> +
>                 The file is read only.
> diff --git a/Documentation/ABI/testing/sysfs-driver-w1_ds28e17 b/Document=
ation/ABI/testing/sysfs-driver-w1_ds28e17
> index d301e7017afe..e92aba4eb594 100644
> --- a/Documentation/ABI/testing/sysfs-driver-w1_ds28e17
> +++ b/Documentation/ABI/testing/sysfs-driver-w1_ds28e17
> @@ -5,7 +5,9 @@ Contact:        Jan Kandziora <jjj@gmx.de>
>  Description:   When written, this file sets the I2C speed on the connect=
ed
>                 DS28E17 chip. When read, it reads the current setting fro=
m
>                 the DS28E17 chip.
> +
>                 Valid values: 100, 400, 900 [kBaud].
> +
>                 Default 100, can be set by w1_ds28e17.speed=3D module par=
ameter.
>  Users:         w1_ds28e17 driver
>
> @@ -17,5 +19,6 @@ Description:  When written, this file sets the multipli=
er used to calculate
>                 the busy timeout for I2C operations on the connected DS28=
E17
>                 chip. When read, returns the current setting.
>                 Valid values: 1 to 9.
> +
>                 Default 1, can be set by w1_ds28e17.stretch=3D module par=
ameter.
>  Users:         w1_ds28e17 driver
> diff --git a/Documentation/ABI/testing/sysfs-firmware-acpi b/Documentatio=
n/ABI/testing/sysfs-firmware-acpi
> index e4afc2538210..b16d30a71709 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-acpi
> +++ b/Documentation/ABI/testing/sysfs-firmware-acpi
> @@ -81,11 +81,11 @@ Description:
>                   $ cd /sys/firmware/acpi/interrupts
>                   $ grep . *
>                   error:             0
> -                 ff_gbl_lock:     0   enable
> -                 ff_pmtimer:     0  invalid
> -                 ff_pwr_btn:     0   enable
> -                 ff_rt_clk:     2  disable
> -                 ff_slp_btn:     0  invalid
> +                 ff_gbl_lock:       0   enable
> +                 ff_pmtimer:        0  invalid
> +                 ff_pwr_btn:        0   enable
> +                 ff_rt_clk:         2  disable
> +                 ff_slp_btn:        0  invalid
>                   gpe00:             0  invalid
>                   gpe01:             0   enable
>                   gpe02:           108   enable
> @@ -118,9 +118,9 @@ Description:
>                   gpe1D:             0  invalid
>                   gpe1E:             0  invalid
>                   gpe1F:             0  invalid
> -                 gpe_all:    1192
> -                 sci:  1194
> -                 sci_not:     0
> +                 gpe_all:        1192
> +                 sci:            1194
> +                 sci_not:           0
>
>                 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>                 sci          The number of times the ACPI SCI
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-esrt b/Document=
ation/ABI/testing/sysfs-firmware-efi-esrt
> index 6e431d1a4e79..31b57676d4ad 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-efi-esrt
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-esrt
> @@ -35,10 +35,13 @@ What:               /sys/firmware/efi/esrt/entries/en=
try$N/fw_type
>  Date:          February 2015
>  Contact:       Peter Jones <pjones@redhat.com>
>  Description:   What kind of firmware entry this is:
> -               0 - Unknown
> -               1 - System Firmware
> -               2 - Device Firmware
> -               3 - UEFI Driver
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               0   Unknown
> +               1   System Firmware
> +               2   Device Firmware
> +               3   UEFI Driver
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/firmware/efi/esrt/entries/entry$N/fw_class
>  Date:          February 2015
> @@ -71,11 +74,14 @@ Date:               February 2015
>  Contact:       Peter Jones <pjones@redhat.com>
>  Description:   The result of the last firmware update attempt for the
>                 firmware resource entry.
> -               0 - Success
> -               1 - Insufficient resources
> -               2 - Incorrect version
> -               3 - Invalid format
> -               4 - Authentication error
> -               5 - AC power event
> -               6 - Battery power event
> +
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> +               0   Success
> +               1   Insufficient resources
> +               2   Incorrect version
> +               3   Invalid format
> +               4   Authentication error
> +               5   AC power event
> +               6   Battery power event
> +               =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>
> diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/D=
ocumentation/ABI/testing/sysfs-firmware-efi-runtime-map
> index c61b9b348e99..9c4d581be396 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> +++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
> @@ -14,7 +14,7 @@ Description:  Switching efi runtime services to virtual=
 mode requires
>                 /sys/firmware/efi/runtime-map/ is the directory the kerne=
l
>                 exports that information in.
>
> -               subdirectories are named with the number of the memory ra=
nge:
> +               subdirectories are named with the number of the memory ra=
nge::
>
>                         /sys/firmware/efi/runtime-map/0
>                         /sys/firmware/efi/runtime-map/1
> @@ -24,11 +24,13 @@ Description:        Switching efi runtime services to=
 virtual mode requires
>
>                 Each subdirectory contains five files:
>
> -               attribute : The attributes of the memory range.
> -               num_pages : The size of the memory range in pages.
> -               phys_addr : The physical address of the memory range.
> -               type      : The type of the memory range.
> -               virt_addr : The virtual address of the memory range.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +               attribute   The attributes of the memory range.
> +               num_pages   The size of the memory range in pages.
> +               phys_addr   The physical address of the memory range.
> +               type        The type of the memory range.
> +               virt_addr   The virtual address of the memory range.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D   =3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
>
>                 Above values are all hexadecimal numbers with the '0x' pr=
efix.
>  Users:         Kexec
> diff --git a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg b/Docum=
entation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> index 011dda4f8e8a..ee0d6dbc810e 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> +++ b/Documentation/ABI/testing/sysfs-firmware-qemu_fw_cfg
> @@ -15,7 +15,7 @@ Description:
>                 to the fw_cfg device can be found in "docs/specs/fw_cfg.t=
xt"
>                 in the QEMU source tree.
>
> -               =3D=3D=3D SysFS fw_cfg Interface =3D=3D=3D
> +               **SysFS fw_cfg Interface**
>
>                 The fw_cfg sysfs interface described in this document is =
only
>                 intended to display discoverable blobs (i.e., those regis=
tered
> @@ -31,7 +31,7 @@ Description:
>
>                         /sys/firmware/qemu_fw_cfg/rev
>
> -               --- Discoverable fw_cfg blobs by selector key ---
> +               **Discoverable fw_cfg blobs by selector key**
>
>                 All discoverable blobs listed in the fw_cfg file director=
y are
>                 displayed as entries named after their unique selector ke=
y
> @@ -45,24 +45,26 @@ Description:
>                 Each such fw_cfg sysfs entry has the following values exp=
orted
>                 as attributes:
>
> -               name    : The 56-byte nul-terminated ASCII string used as=
 the
> +               =3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               name      The 56-byte nul-terminated ASCII string used as=
 the
>                           blob's 'file name' in the fw_cfg directory.
> -               size    : The length of the blob, as given in the fw_cfg
> +               size      The length of the blob, as given in the fw_cfg
>                           directory.
> -               key     : The value of the blob's selector key as given i=
n the
> +               key       The value of the blob's selector key as given i=
n the
>                           fw_cfg directory. This value is the same as use=
d in
>                           the parent directory name.
> -               raw     : The raw bytes of the blob, obtained by selectin=
g the
> +               raw       The raw bytes of the blob, obtained by selectin=
g the
>                           entry via the control register, and reading a n=
umber
>                           of bytes equal to the blob size from the data
>                           register.
> +               =3D=3D=3D=3D      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> -               --- Listing fw_cfg blobs by file name ---
> +               **Listing fw_cfg blobs by file name**
>
>                 While the fw_cfg device does not impose any specific nami=
ng
>                 convention on the blobs registered in the file directory,
>                 QEMU developers have traditionally used path name semanti=
cs
> -               to give each blob a descriptive name. For example:
> +               to give each blob a descriptive name. For example::
>
>                         "bootorder"
>                         "genroms/kvmvapic.bin"
> @@ -81,7 +83,7 @@ Description:
>                 of directories matching the path name components of fw_cf=
g
>                 blob names, ending in symlinks to the by_key entry for ea=
ch
>                 "basename", as illustrated below (assume current director=
y is
> -               /sys/firmware):
> +               /sys/firmware)::
>
>                     qemu_fw_cfg/by_name/bootorder -> ../by_key/38
>                     qemu_fw_cfg/by_name/etc/e820 -> ../../by_key/35
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sfi b/Documentation=
/ABI/testing/sysfs-firmware-sfi
> index 4be7d44aeacf..5210e0f06ddb 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-sfi
> +++ b/Documentation/ABI/testing/sysfs-firmware-sfi
> @@ -9,7 +9,7 @@ Description:
>                 http://simplefirmware.org/documentation
>
>                 While the tables are used by the kernel, user-space
> -               can observe them this way:
> +               can observe them this way::
>
> -               # cd /sys/firmware/sfi/tables
> -               # cat $TABLENAME > $TABLENAME.bin
> +                 # cd /sys/firmware/sfi/tables
> +                 # cat $TABLENAME > $TABLENAME.bin
> diff --git a/Documentation/ABI/testing/sysfs-firmware-sgi_uv b/Documentat=
ion/ABI/testing/sysfs-firmware-sgi_uv
> index 4573fd4b7876..66800baab096 100644
> --- a/Documentation/ABI/testing/sysfs-firmware-sgi_uv
> +++ b/Documentation/ABI/testing/sysfs-firmware-sgi_uv
> @@ -5,7 +5,7 @@ Description:
>                 The /sys/firmware/sgi_uv directory contains information
>                 about the SGI UV platform.
>
> -               Under that directory are a number of files:
> +               Under that directory are a number of files::
>
>                         partition_id
>                         coherence_id
> @@ -14,7 +14,7 @@ Description:
>                 SGI UV systems can be partitioned into multiple physical
>                 machines, which each partition running a unique copy
>                 of the operating system.  Each partition will have a uniq=
ue
> -               partition id.  To display the partition id, use the comma=
nd:
> +               partition id.  To display the partition id, use the comma=
nd::
>
>                         cat /sys/firmware/sgi_uv/partition_id
>
> @@ -22,6 +22,6 @@ Description:
>                 A partitioned SGI UV system can have one or more coherenc=
e
>                 domain.  The coherence id indicates which coherence domai=
n
>                 this partition is in.  To display the coherence id, use t=
he
> -               command:
> +               command::
>
>                         cat /sys/firmware/sgi_uv/coherence_id
> diff --git a/Documentation/ABI/testing/sysfs-fs-f2fs b/Documentation/ABI/=
testing/sysfs-fs-f2fs
> index 834d0becae6d..67b3ed8e8c2f 100644
> --- a/Documentation/ABI/testing/sysfs-fs-f2fs
> +++ b/Documentation/ABI/testing/sysfs-fs-f2fs
> @@ -20,10 +20,13 @@ What:               /sys/fs/f2fs/<disk>/gc_idle
>  Date:          July 2013
>  Contact:       "Namjae Jeon" <namjae.jeon@samsung.com>
>  Description:   Controls the victim selection policy for garbage collecti=
on.
> -               Setting gc_idle =3D 0(default) will disable this option. =
Setting
> -               gc_idle =3D 1 will select the Cost Benefit approach & set=
ting
> -               gc_idle =3D 2 will select the greedy approach & setting
> -               gc_idle =3D 3 will select the age-threshold based approac=
h.
> +               Setting gc_idle =3D 0(default) will disable this option. =
Setting:
> +
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +               gc_idle =3D 1  will select the Cost Benefit approach & se=
tting
> +               gc_idle =3D 2  will select the greedy approach & setting
> +               gc_idle =3D 3  will select the age-threshold based approa=
ch.
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>  What:          /sys/fs/f2fs/<disk>/reclaim_segments
>  Date:          October 2013
> @@ -46,10 +49,17 @@ Date:               November 2013
>  Contact:       "Jaegeuk Kim" <jaegeuk.kim@samsung.com>
>  Description:   Controls the in-place-update policy.
>                 updates in f2fs. User can set:
> -               0x01: F2FS_IPU_FORCE, 0x02: F2FS_IPU_SSR,
> -               0x04: F2FS_IPU_UTIL,  0x08: F2FS_IPU_SSR_UTIL,
> -               0x10: F2FS_IPU_FSYNC, 0x20: F2FS_IPU_ASYNC,
> -               0x40: F2FS_IPU_NOCACHE.
> +
> +               =3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +               0x01  F2FS_IPU_FORCE
> +               0x02  F2FS_IPU_SSR
> +               0x04  F2FS_IPU_UTIL
> +               0x08  F2FS_IPU_SSR_UTIL
> +               0x10  F2FS_IPU_FSYNC
> +               0x20  F2FS_IPU_ASYNC,
> +               0x40  F2FS_IPU_NOCACHE
> +               =3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> +
>                 Refer segment.h for details.
>
>  What:          /sys/fs/f2fs/<disk>/min_ipu_util
> @@ -332,18 +342,28 @@ Date:             April 2020
>  Contact:       "Jaegeuk Kim" <jaegeuk@kernel.org>
>  Description:   Give a way to attach REQ_META|FUA to data writes
>                 given temperature-based bits. Now the bits indicate:
> -               *      REQ_META     |      REQ_FUA      |
> -               *    5 |    4 |   3 |    2 |    1 |   0 |
> -               * Cold | Warm | Hot | Cold | Warm | Hot |
> +
> +               +-------------------+-------------------+
> +               |      REQ_META     |      REQ_FUA      |
> +               +------+------+-----+------+------+-----+
> +               |    5 |    4 |   3 |    2 |    1 |   0 |
> +               +------+------+-----+------+------+-----+
> +               | Cold | Warm | Hot | Cold | Warm | Hot |
> +               +------+------+-----+------+------+-----+
>
>  What:          /sys/fs/f2fs/<disk>/node_io_flag
>  Date:          June 2020
>  Contact:       "Jaegeuk Kim" <jaegeuk@kernel.org>
>  Description:   Give a way to attach REQ_META|FUA to node writes
>                 given temperature-based bits. Now the bits indicate:
> -               *      REQ_META     |      REQ_FUA      |
> -               *    5 |    4 |   3 |    2 |    1 |   0 |
> -               * Cold | Warm | Hot | Cold | Warm | Hot |
> +
> +               +-------------------+-------------------+
> +               |      REQ_META     |      REQ_FUA      |
> +               +------+------+-----+------+------+-----+
> +               |    5 |    4 |   3 |    2 |    1 |   0 |
> +               +------+------+-----+------+------+-----+
> +               | Cold | Warm | Hot | Cold | Warm | Hot |
> +               +------+------+-----+------+------+-----+
>
>  What:          /sys/fs/f2fs/<disk>/iostat_period_ms
>  Date:          April 2020
> diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-ksm b/Documentatio=
n/ABI/testing/sysfs-kernel-mm-ksm
> index dfc13244cda3..1c9bed5595f5 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-mm-ksm
> +++ b/Documentation/ABI/testing/sysfs-kernel-mm-ksm
> @@ -34,8 +34,9 @@ Description:  Kernel Samepage Merging daemon sysfs inte=
rface
>                 in a tree.
>
>                 run: write 0 to disable ksm, read 0 while ksm is disabled=
.
> -                       write 1 to run ksm, read 1 while ksm is running.
> -                       write 2 to disable ksm and unmerge all its pages.
> +
> +                       - write 1 to run ksm, read 1 while ksm is running=
.
> +                       - write 2 to disable ksm and unmerge all its page=
s.
>
>                 sleep_millisecs: how many milliseconds ksm should sleep b=
etween
>                 scans.
> diff --git a/Documentation/ABI/testing/sysfs-kernel-slab b/Documentation/=
ABI/testing/sysfs-kernel-slab
> index ed35833ad7f0..c9f12baf8baa 100644
> --- a/Documentation/ABI/testing/sysfs-kernel-slab
> +++ b/Documentation/ABI/testing/sysfs-kernel-slab
> @@ -346,6 +346,7 @@ Description:
>                 number of objects per slab.  If a slab cannot be allocate=
d
>                 because of fragmentation, SLUB will retry with the minimu=
m order
>                 possible depending on its characteristics.
> +
>                 When debug_guardpage_minorder=3DN (N > 0) parameter is sp=
ecified
>                 (see Documentation/admin-guide/kernel-parameters.rst), th=
e minimum possible
>                 order is used and this sysfs entry can not be used to cha=
nge
> @@ -361,6 +362,7 @@ Description:
>                 new slab has not been possible at the cache's order and i=
nstead
>                 fallen back to its minimum possible order.  It can be wri=
tten to
>                 clear the current count.
> +
>                 Available when CONFIG_SLUB_STATS is enabled.
>
>  What:          /sys/kernel/slab/cache/partial
> @@ -410,6 +412,7 @@ Description:
>                 slab from a remote node as opposed to allocating a new sl=
ab on
>                 the local node.  This reduces the amount of wasted memory=
 over
>                 the entire system but can be expensive.
> +
>                 Available when CONFIG_NUMA is enabled.
>
>  What:          /sys/kernel/slab/cache/sanity_checks
> diff --git a/Documentation/ABI/testing/sysfs-module b/Documentation/ABI/t=
esting/sysfs-module
> index 0aac02e7fb0e..353c0db5bc1f 100644
> --- a/Documentation/ABI/testing/sysfs-module
> +++ b/Documentation/ABI/testing/sysfs-module
> @@ -17,14 +17,15 @@ KernelVersion:      3.1
>  Contact:       Kirill Smelkov <kirr@mns.spb.ru>
>  Description:   Maximum time allowed for periodic transfers per microfram=
e (=CE=BCs)
>
> -               [ USB 2.0 sets maximum allowed time for periodic transfer=
s per
> +               Note:
> +                 USB 2.0 sets maximum allowed time for periodic transfer=
s per
>                   microframe to be 80%, that is 100 microseconds out of 1=
25
>                   microseconds (full microframe).
>
>                   However there are cases, when 80% max isochronous bandw=
idth is
>                   too limiting. For example two video streams could requi=
re 110
>                   microseconds of isochronous bandwidth per microframe to=
 work
> -                 together. ]
> +                 together.
>
>                 Through this setting it is possible to raise the limit so=
 that
>                 the host controller would allow allocating more than 100
> @@ -45,8 +46,10 @@ Date:                Jan 2012
>  KernelVersion:=C2=BB=C2=B73.3
>  Contact:       Kay Sievers <kay.sievers@vrfy.org>
>  Description:   Module taint flags:
> -                       P - proprietary module
> -                       O - out-of-tree module
> -                       F - force-loaded module
> -                       C - staging driver module
> -                       E - unsigned module
> +                       =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> +                       P   proprietary module
> +                       O   out-of-tree module
> +                       F   force-loaded module
> +                       C   staging driver module
> +                       E   unsigned module
> +                       =3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/Documentation/ABI/testing/sysfs-platform-dell-laptop b/Docum=
entation/ABI/testing/sysfs-platform-dell-laptop
> index 9b917c7453de..82bcfe9df66e 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dell-laptop
> +++ b/Documentation/ABI/testing/sysfs-platform-dell-laptop
> @@ -34,9 +34,12 @@ Description:
>                 this file. To disable a trigger, write its name preceded
>                 by '-' instead.
>
> -               For example, to enable the keyboard as trigger run:
> +               For example, to enable the keyboard as trigger run::
> +
>                     echo +keyboard > /sys/class/leds/dell::kbd_backlight/=
start_triggers
> -               To disable it:
> +
> +               To disable it::
> +
>                     echo -keyboard > /sys/class/leds/dell::kbd_backlight/=
start_triggers
>
>                 Note that not all the available triggers can be configure=
d.
> @@ -57,7 +60,8 @@ Description:
>                 with any the above units. If no unit is specified, the va=
lue
>                 is assumed to be expressed in seconds.
>
> -               For example, to set the timeout to 10 minutes run:
> +               For example, to set the timeout to 10 minutes run::
> +
>                     echo 10m > /sys/class/leds/dell::kbd_backlight/stop_t=
imeout
>
>                 Note that when this file is read, the returned value migh=
t be
> diff --git a/Documentation/ABI/testing/sysfs-platform-dell-smbios b/Docum=
entation/ABI/testing/sysfs-platform-dell-smbios
> index 205d3b6361e0..e6e0f7f834a7 100644
> --- a/Documentation/ABI/testing/sysfs-platform-dell-smbios
> +++ b/Documentation/ABI/testing/sysfs-platform-dell-smbios
> @@ -13,8 +13,8 @@ Description:
>                 For example the token ID "5" would be available
>                 as the following attributes:
>
> -               0005_location
> -               0005_value
> +               - 0005_location
> +               - 0005_value
>
>                 Tokens will vary from machine to machine, and
>                 only tokens available on that machine will be
> diff --git a/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl b=
/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> index c394b808be19..b6a138b50d99 100644
> --- a/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> +++ b/Documentation/ABI/testing/sysfs-platform-i2c-demux-pinctrl
> @@ -5,9 +5,9 @@ Contact:        Wolfram Sang <wsa+renesas@sang-engineerin=
g.com>
>  Description:
>                 Reading the file will give you a list of masters which ca=
n be
>                 selected for a demultiplexed bus. The format is
> -               "<index>:<name>". Example from a Renesas Lager board:
> +               "<index>:<name>". Example from a Renesas Lager board::
>
> -               0:/i2c@e6500000 1:/i2c@e6508000
> +                 0:/i2c@e6500000 1:/i2c@e6508000
>
>  What:          /sys/devices/platform/<i2c-demux-name>/current_master
>  Date:          January 2016
> diff --git a/Documentation/ABI/testing/sysfs-platform-kim b/Documentation=
/ABI/testing/sysfs-platform-kim
> index c1653271872a..a7f81de68046 100644
> --- a/Documentation/ABI/testing/sysfs-platform-kim
> +++ b/Documentation/ABI/testing/sysfs-platform-kim
> @@ -5,6 +5,7 @@ Contact:        "Pavan Savoy" <pavan_savoy@ti.com>
>  Description:
>                 Name of the UART device at which the WL128x chip
>                 is connected. example: "/dev/ttyS0".
> +
>                 The device name flows down to architecture specific board
>                 initialization file from the SFI/ATAGS bootloader
>                 firmware. The name exposed is read from the user-space
> diff --git a/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2 =
b/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> index 6212697bbf6f..bc510ccc37a7 100644
> --- a/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> +++ b/Documentation/ABI/testing/sysfs-platform-phy-rcar-gen3-usb2
> @@ -7,9 +7,11 @@ Description:
>                 The file can show/change the phy mode for role swap of us=
b.
>
>                 Write the following strings to change the mode:
> -                "host" - switching mode from peripheral to host.
> -                "peripheral" - switching mode from host to peripheral.
> +
> +                - "host" - switching mode from peripheral to host.
> +                - "peripheral" - switching mode from host to peripheral.
>
>                 Read the file, then it shows the following strings:
> -                "host" - The mode is host now.
> -                "peripheral" - The mode is peripheral now.
> +
> +                - "host" - The mode is host now.
> +                - "peripheral" - The mode is peripheral now.
> diff --git a/Documentation/ABI/testing/sysfs-platform-renesas_usb3 b/Docu=
mentation/ABI/testing/sysfs-platform-renesas_usb3
> index 5621c15d5dc0..8af5b9c3fabb 100644
> --- a/Documentation/ABI/testing/sysfs-platform-renesas_usb3
> +++ b/Documentation/ABI/testing/sysfs-platform-renesas_usb3
> @@ -7,9 +7,11 @@ Description:
>                 The file can show/change the drd mode of usb.
>
>                 Write the following string to change the mode:
> -                "host" - switching mode from peripheral to host.
> -                "peripheral" - switching mode from host to peripheral.
> +
> +               - "host" - switching mode from peripheral to host.
> +               - "peripheral" - switching mode from host to peripheral.
>
>                 Read the file, then it shows the following strings:
> -                "host" - The mode is host now.
> -                "peripheral" - The mode is peripheral now.
> +
> +               - "host" - The mode is host now.
> +               - "peripheral" - The mode is peripheral now.
> diff --git a/Documentation/ABI/testing/sysfs-power b/Documentation/ABI/te=
sting/sysfs-power
> index 5e6ead29124c..51c0f578bfce 100644
> --- a/Documentation/ABI/testing/sysfs-power
> +++ b/Documentation/ABI/testing/sysfs-power
> @@ -47,14 +47,18 @@ Description:
>                 suspend-to-disk mechanism.  Reading from this file return=
s
>                 the name of the method by which the system will be put to
>                 sleep on the next suspend.  There are four methods suppor=
ted:
> +
>                 'firmware' - means that the memory image will be saved to=
 disk
>                 by some firmware, in which case we also assume that the
>                 firmware will handle the system suspend.
> +
>                 'platform' - the memory image will be saved by the kernel=
 and
>                 the system will be put to sleep by the platform driver (e=
.g.
>                 ACPI or other PM registers).
> +
>                 'shutdown' - the memory image will be saved by the kernel=
 and
>                 the system will be powered off.
> +
>                 'reboot' - the memory image will be saved by the kernel a=
nd
>                 the system will be rebooted.
>
> @@ -74,12 +78,12 @@ Description:
>                 The suspend-to-disk method may be chosen by writing to th=
is
>                 file one of the accepted strings:
>
> -               'firmware'
> -               'platform'
> -               'shutdown'
> -               'reboot'
> -               'testproc'
> -               'test'
> +               - 'firmware'
> +               - 'platform'
> +               - 'shutdown'
> +               - 'reboot'
> +               - 'testproc'
> +               - 'test'
>
>                 It will only change to 'firmware' or 'platform' if the sy=
stem
>                 supports that.
> @@ -114,9 +118,9 @@ Description:
>                 string representing a nonzero integer into it.
>
>                 To use this debugging feature you should attempt to suspe=
nd
> -               the machine, then reboot it and run
> +               the machine, then reboot it and run::
>
> -               dmesg -s 1000000 | grep 'hash matches'
> +                 dmesg -s 1000000 | grep 'hash matches'
>
>                 If you do not get any matches (or they appear to be false
>                 positives), it is possible that the last PM event point
> @@ -244,6 +248,7 @@ Description:
>                 wakeup sources created with the help of /sys/power/wake_l=
ock.
>                 When a string is written to /sys/power/wake_unlock, it wi=
ll be
>                 assumed to represent the name of a wakeup source to deact=
ivate.
> +
>                 If a wakeup source object of that name exists and is acti=
ve at
>                 the moment, it will be deactivated.
>
> diff --git a/Documentation/ABI/testing/sysfs-profiling b/Documentation/AB=
I/testing/sysfs-profiling
> index 8a8e466eb2c0..e39dd3a0ceef 100644
> --- a/Documentation/ABI/testing/sysfs-profiling
> +++ b/Documentation/ABI/testing/sysfs-profiling
> @@ -5,7 +5,7 @@ Description:
>                 /sys/kernel/profiling is the runtime equivalent
>                 of the boot-time profile=3D option.
>
> -               You can get the same effect running:
> +               You can get the same effect running::
>
>                         echo 2 > /sys/kernel/profiling
>
> diff --git a/Documentation/ABI/testing/sysfs-wusb_cbaf b/Documentation/AB=
I/testing/sysfs-wusb_cbaf
> index a99c5f86a37a..2969d3694ec0 100644
> --- a/Documentation/ABI/testing/sysfs-wusb_cbaf
> +++ b/Documentation/ABI/testing/sysfs-wusb_cbaf
> @@ -45,7 +45,8 @@ Description:
>                  7. Device is unplugged.
>
>                  References:
> -                  [WUSB-AM] Association Models Supplement to the
> +                  [WUSB-AM]
> +                           Association Models Supplement to the
>                              Certified Wireless Universal Serial Bus
>                              Specification, version 1.0.
>
> diff --git a/Documentation/ABI/testing/usb-charger-uevent b/Documentation=
/ABI/testing/usb-charger-uevent
> index 419a92dd0d86..1db89b0cf80f 100644
> --- a/Documentation/ABI/testing/usb-charger-uevent
> +++ b/Documentation/ABI/testing/usb-charger-uevent
> @@ -3,44 +3,52 @@ Date:         2020-01-14
>  KernelVersion: 5.6
>  Contact:       linux-usb@vger.kernel.org
>  Description:   There are two USB charger states:
> -               USB_CHARGER_ABSENT
> -               USB_CHARGER_PRESENT
> +
> +               - USB_CHARGER_ABSENT
> +               - USB_CHARGER_PRESENT
> +
>                 There are five USB charger types:
> -               USB_CHARGER_UNKNOWN_TYPE: Charger type is unknown
> -               USB_CHARGER_SDP_TYPE: Standard Downstream Port
> -               USB_CHARGER_CDP_TYPE: Charging Downstream Port
> -               USB_CHARGER_DCP_TYPE: Dedicated Charging Port
> -               USB_CHARGER_ACA_TYPE: Accessory Charging Adapter
> +
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +               USB_CHARGER_UNKNOWN_TYPE  Charger type is unknown
> +               USB_CHARGER_SDP_TYPE      Standard Downstream Port
> +               USB_CHARGER_CDP_TYPE      Charging Downstream Port
> +               USB_CHARGER_DCP_TYPE      Dedicated Charging Port
> +               USB_CHARGER_ACA_TYPE      Accessory Charging Adapter
> +               =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D
> +
>                 https://www.usb.org/document-library/battery-charging-v12=
-spec-and-adopters-agreement
>
> -               Here are two examples taken using udevadm monitor -p when
> -               USB charger is online:
> -               UDEV  change   /devices/soc0/usbphynop1 (platform)
> -               ACTION=3Dchange
> -               DEVPATH=3D/devices/soc0/usbphynop1
> -               DRIVER=3Dusb_phy_generic
> -               MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> -               OF_COMPATIBLE_0=3Dusb-nop-xceiv
> -               OF_COMPATIBLE_N=3D1
> -               OF_FULLNAME=3D/usbphynop1
> -               OF_NAME=3Dusbphynop1
> -               SEQNUM=3D2493
> -               SUBSYSTEM=3Dplatform
> -               USB_CHARGER_STATE=3DUSB_CHARGER_PRESENT
> -               USB_CHARGER_TYPE=3DUSB_CHARGER_SDP_TYPE
> -               USEC_INITIALIZED=3D227422826
> +               Here are two examples taken using ``udevadm monitor -p`` =
when
> +               USB charger is online::
>
> -               USB charger is offline:
> -               KERNEL change   /devices/soc0/usbphynop1 (platform)
> -               ACTION=3Dchange
> -               DEVPATH=3D/devices/soc0/usbphynop1
> -               DRIVER=3Dusb_phy_generic
> -               MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> -               OF_COMPATIBLE_0=3Dusb-nop-xceiv
> -               OF_COMPATIBLE_N=3D1
> -               OF_FULLNAME=3D/usbphynop1
> -               OF_NAME=3Dusbphynop1
> -               SEQNUM=3D2494
> -               SUBSYSTEM=3Dplatform
> -               USB_CHARGER_STATE=3DUSB_CHARGER_ABSENT
> -               USB_CHARGER_TYPE=3DUSB_CHARGER_UNKNOWN_TYPE
> +                   UDEV  change   /devices/soc0/usbphynop1 (platform)
> +                   ACTION=3Dchange
> +                   DEVPATH=3D/devices/soc0/usbphynop1
> +                   DRIVER=3Dusb_phy_generic
> +                   MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> +                   OF_COMPATIBLE_0=3Dusb-nop-xceiv
> +                   OF_COMPATIBLE_N=3D1
> +                   OF_FULLNAME=3D/usbphynop1
> +                   OF_NAME=3Dusbphynop1
> +                   SEQNUM=3D2493
> +                   SUBSYSTEM=3Dplatform
> +                   USB_CHARGER_STATE=3DUSB_CHARGER_PRESENT
> +                   USB_CHARGER_TYPE=3DUSB_CHARGER_SDP_TYPE
> +                   USEC_INITIALIZED=3D227422826
> +
> +               USB charger is offline::
> +
> +                   KERNEL change   /devices/soc0/usbphynop1 (platform)
> +                   ACTION=3Dchange
> +                   DEVPATH=3D/devices/soc0/usbphynop1
> +                   DRIVER=3Dusb_phy_generic
> +                   MODALIAS=3Dof:Nusbphynop1T(null)Cusb-nop-xceiv
> +                   OF_COMPATIBLE_0=3Dusb-nop-xceiv
> +                   OF_COMPATIBLE_N=3D1
> +                   OF_FULLNAME=3D/usbphynop1
> +                   OF_NAME=3Dusbphynop1
> +                   SEQNUM=3D2494
> +                   SUBSYSTEM=3Dplatform
> +                   USB_CHARGER_STATE=3DUSB_CHARGER_ABSENT
> +                   USB_CHARGER_TYPE=3DUSB_CHARGER_UNKNOWN_TYPE
> diff --git a/Documentation/ABI/testing/usb-uevent b/Documentation/ABI/tes=
ting/usb-uevent
> index d35c3cad892c..2b8eca4bf2b1 100644
> --- a/Documentation/ABI/testing/usb-uevent
> +++ b/Documentation/ABI/testing/usb-uevent
> @@ -6,22 +6,22 @@ Description:  When the USB Host Controller has entered =
a state where it is no
>                 longer functional a uevent will be raised. The uevent wil=
l
>                 contain ACTION=3Doffline and ERROR=3DDEAD.
>
> -               Here is an example taken using udevadm monitor -p:
> +               Here is an example taken using udevadm monitor -p::
>
> -               KERNEL[130.428945] offline  /devices/pci0000:00/0000:00:1=
0.0/usb2 (usb)
> -               ACTION=3Doffline
> -               BUSNUM=3D002
> -               DEVNAME=3D/dev/bus/usb/002/001
> -               DEVNUM=3D001
> -               DEVPATH=3D/devices/pci0000:00/0000:00:10.0/usb2
> -               DEVTYPE=3Dusb_device
> -               DRIVER=3Dusb
> -               ERROR=3DDEAD
> -               MAJOR=3D189
> -               MINOR=3D128
> -               PRODUCT=3D1d6b/2/414
> -               SEQNUM=3D2168
> -               SUBSYSTEM=3Dusb
> -               TYPE=3D9/0/1
> +                   KERNEL[130.428945] offline  /devices/pci0000:00/0000:=
00:10.0/usb2 (usb)
> +                   ACTION=3Doffline
> +                   BUSNUM=3D002
> +                   DEVNAME=3D/dev/bus/usb/002/001
> +                   DEVNUM=3D001
> +                   DEVPATH=3D/devices/pci0000:00/0000:00:10.0/usb2
> +                   DEVTYPE=3Dusb_device
> +                   DRIVER=3Dusb
> +                   ERROR=3DDEAD
> +                   MAJOR=3D189
> +                   MINOR=3D128
> +                   PRODUCT=3D1d6b/2/414
> +                   SEQNUM=3D2168
> +                   SUBSYSTEM=3Dusb
> +                   TYPE=3D9/0/1
>
>  Users:         chromium-os-dev@chromium.org
> diff --git a/scripts/get_abi.pl b/scripts/get_abi.pl
> index 413349789145..bdef3e5c35c7 100755
> --- a/scripts/get_abi.pl
> +++ b/scripts/get_abi.pl
> @@ -316,8 +316,6 @@ sub output_rest {
>                                 $len =3D length($name) if (length($name) =
> $len);
>                         }
>
> -                       print "What:\n\n";
> -
>                         print "+-" . "-" x $len . "-+\n";
>                         foreach my $name (@names) {
>                                 printf "| %s", $name . " " x ($len - leng=
th($name)) . " |\n";

> --
> 2.26.2
>
