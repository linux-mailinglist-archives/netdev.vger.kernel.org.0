Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B232A0B81
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727276AbgJ3QnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:43:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgJ3QnF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:43:05 -0400
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4494EC0613D2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:43:05 -0700 (PDT)
Received: by mail-il1-x141.google.com with SMTP id k6so7062995ilq.2
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:43:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NZmqGfCg08N6iXx9q7TVWlSnhQqIDOwOjzOwbvXDxjI=;
        b=INVfZz/fkvsZivy8jdRFY4jjuumPUnT03fIMmAZxhr2j3OQtTxmqWeMui9FFLMvZFz
         QB2ePhBsJkuNysGjMHbU9DiLLxlLmss4JFzjBmUNAkJoiiGzYBFH/upOKm0AUQMizu+W
         okAB9PgkVOM5lyq7RfM3eZWziu4Lw6xFmIPsA3WEdWrepzCLkMsPGFysW4PIdG4Ix46W
         ABDHiqA089OjzR7YGXqWWnY73UPmGi5ssu5dObic6I8EipSHtDNSFTIEabkYZFtOUw53
         gKZFvyCe8mIA4cQPQ5Ji/NguzzOPrnGBpJ5jXdtWnz2BLO+k8PETRjkg1JznRZelvTOY
         uyUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NZmqGfCg08N6iXx9q7TVWlSnhQqIDOwOjzOwbvXDxjI=;
        b=cx3ERUfri0xhj3Pqxy1QC3tdG6HzikWHyuaFtriuwEwR8xhkYO2BlYtCzSkkcR6J3+
         IyL5sGddYX2WiOCUpBt0PT41gbBYHz3Fn2UXU+KK0eTSjSjjGeHxxPlfpMreP+rjcr5S
         6a3Lgdd/nry1YEIuxwiqfbUI+rXzib+rcc2Zr+0WU8y8QEW9x4LFS/J/Bz7ddggeFpZh
         jS3VeZKEsPTkCbAUVoj70Ih67sEkdxDbHmxcTE8c/o8t/W/2KS7+Y+aEU9aOxx1X5DJg
         Y3kwAJO8t7KWEvm3nVNDbzUFtRXLS1goqg232aXsW4ERpeAR8rWsSPtp6/+kRfTnUeCL
         0DDw==
X-Gm-Message-State: AOAM531fXTJjT6uq81GfPIuPDWQ2ycA+YT6Dh+Uj/fN14BowZJxW2kUI
        +bm8Zc3usYz5v8Je3pebzazXe88hnOy0axdaNJ4jEg==
X-Google-Smtp-Source: ABdhPJwYf7SWuKIRh8xsBOBodbVLmuU+KCM1QaVpZsez95JZOYKTbDYung3PLxm+lfmttII+vBXdnzsUUs8NHjrseg0=
X-Received: by 2002:a92:6403:: with SMTP id y3mr2528711ilb.72.1604076184121;
 Fri, 30 Oct 2020 09:43:04 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1604042072.git.mchehab+huawei@kernel.org> <5bc78e5b68ed1e9e39135173857cb2e753be868f.1604042072.git.mchehab+huawei@kernel.org>
In-Reply-To: <5bc78e5b68ed1e9e39135173857cb2e753be868f.1604042072.git.mchehab+huawei@kernel.org>
From:   Mathieu Poirier <mathieu.poirier@linaro.org>
Date:   Fri, 30 Oct 2020 10:42:53 -0600
Message-ID: <CANLsYkxc2uzA57Hg5OX31JOx08JCZfynzebjABv=6H01796xGA@mail.gmail.com>
Subject: Re: [PATCH v2 31/39] docs: ABI: cleanup several ABI documents
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "Gautham R. Shenoy" <ego@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>,
        =?UTF-8?B?TWFyZWsgQmVow7pu?= <marek.behun@nic.cz>,
        =?UTF-8?Q?Marek_Marczykowski=2DG=C3=B3recki?= 
        <marmarek@invisiblethingslab.com>,
        =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        =?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>,
        Alexander Antonov <alexander.antonov@linux.intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Andreas Klinger <ak@it-klinger.de>,
        Andrew Donnellan <ajd@linux.ibm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Anton Vorontsov <anton@enomsg.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
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
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Hanjun Guo <guohanjun@huawei.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Jason Gunthorpe <jgg@ziepe.ca>, Jens Axboe <axboe@kernel.dk>,
        Jerry Snitselaar <jsnitsel@redhat.com>,
        Jingoo Han <jingoohan1@gmail.com>,
        Johan Hovold <johan@kernel.org>,
        Jonas Meurer <jonas@freesources.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Kees Cook <keescook@chromium.org>,
        Konstantin Khlebnikov <koct9i@gmail.com>,
        Kranthi Kuntala <kranthi.kuntala@intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Lee Jones <lee.jones@linaro.org>, Len Brown <lenb@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mario Limonciello <mario.limonciello@dell.com>,
        Mark Gross <mgross@linux.intel.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Michael Hennerich <Michael.Hennerich@analog.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Mike Leach <mike.leach@linaro.org>,
        Oded Gabbay <oded.gabbay@gmail.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Oleh Kravchenko <oleg@kaa.org.ua>, Pavel Machek <pavel@ucw.cz>,
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
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tom Rix <trix@redhat.com>, Tony Luck <tony.luck@intel.com>,
        Vaibhav Jain <vaibhav@linux.ibm.com>,
        Vineela Tummalapalli <vineela.tummalapalli@intel.com>,
        Wu Hao <hao.wu@intel.com>, ceph-devel@vger.kernel.org,
        Coresight ML <coresight@lists.linaro.org>,
        dri-devel@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        linux-f2fs-devel@lists.sourceforge.net, linux-fpga@vger.kernel.org,
        linux-gpio@vger.kernel.org, linux-i3c@lists.infradead.org,
        linux-iio@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-remoteproc <linux-remoteproc@vger.kernel.org>,
        linux-stm32@st-md-mailman.stormreply.com,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 at 01:41, Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> There are some ABI documents that, while they don't generate
> any warnings, they have issues when parsed by get_abi.pl script
> on its output result.
>
> Address them, in order to provide a clean output.
>
> Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com> #for IIO
> Reviewed-by: Tom Rix <trix@redhat.com> # for fpga-manager
> Reviewed-By: Kajol Jain<kjain@linux.ibm.com> # for sysfs-bus-event_source-devices-hv_gpci and sysfs-bus-event_source-devices-hv_24x7
> Acked-by: Oded Gabbay <oded.gabbay@gmail.com> # for Habanalabs
> Acked-by: Vaibhav Jain <vaibhav@linux.ibm.com> # for sysfs-bus-papr-pmem
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---

>  .../testing/sysfs-bus-coresight-devices-etb10 |   5 +-

For the CoreSight part:

Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
