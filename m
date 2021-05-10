Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B1E378F69
	for <lists+netdev@lfdr.de>; Mon, 10 May 2021 15:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238390AbhEJNng (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 May 2021 09:43:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:41772 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353064AbhEJNjY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 10 May 2021 09:39:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC3B261421;
        Mon, 10 May 2021 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620653898;
        bh=POTo3HRRxAhY1WWlaeFo6BkcTm5UFXPjKCsWF/vTqlE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P/4kt59ATJt3MMq8o3rrK9LzWa5UoPyyn/Qv8Q6NsR+ovsaNgOhGumkJ3s+QeyZlY
         mkp1RSJDBywuRK2pqIzCfULgKANDf0kVzPkShXm7Qraf/KL42h8sHNzwIIIZziepHU
         1cBc0VMGP5ZXCvpOozd/XPhpRcKII2GV+t+2//cIV3cuDJc3nOaIF/eyI7STcvNwxN
         jcxTZBK8NBHOGI9kqRh0ffPb4rvNMVcODBe0KVX9czYjhKVi+9lVKEPkHn0PIjvDDH
         U/oUPFuGfszy5HRsPJnifB10869mpbS6mtWdO6hSvo3gHoQbR2cZYguXdpJ4LGaYVv
         DmXbC6buzATmw==
Date:   Mon, 10 May 2021 15:38:07 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Edward Cree <ecree.xilinx@gmail.com>
Cc:     David Woodhouse <dwmw2@infradead.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
        intel-wired-lan@lists.osuosl.org, keyrings@vger.kernel.org,
        kvm@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-edac@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-fpga@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-iio@vger.kernel.org, linux-input@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-media@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-rdma@vger.kernel.org, linux-riscv@lists.infradead.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 00/53] Get rid of UTF-8 chars that can be mapped as
 ASCII
Message-ID: <20210510153807.4405695e@coco.lan>
In-Reply-To: <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
References: <cover.1620641727.git.mchehab+huawei@kernel.org>
        <2ae366fdff4bd5910a2270823e8da70521c859af.camel@infradead.org>
        <20210510135518.305cc03d@coco.lan>
        <df6b4567-030c-a480-c5a6-fe579830e8c0@gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 10 May 2021 14:16:16 +0100
Edward Cree <ecree.xilinx@gmail.com> escreveu:

> On 10/05/2021 12:55, Mauro Carvalho Chehab wrote:
> > The main point on this series is to replace just the occurrences
> > where ASCII represents the symbol equally well =20
>=20
> > 	- U+2014 ('=E2=80=94'): EM DASH =20
> Em dash is not the same thing as hyphen-minus, and the latter does not
>  serve 'equally well'.  People use em dashes because =E2=80=94 even in
>  monospace fonts =E2=80=94 they make text easier to read and comprehend, =
when
>  used correctly.

True, but if you look at the diff, on several places, IMHO a single
hyphen would make more sensus. Maybe those places came from a converted
doc.

> I accept that some of the other distinctions =E2=80=94 like en dashes =E2=
=80=94 are
>  needlessly pedantic (though I don't doubt there is someone out there
>  who will gladly defend them with the same fervour with which I argue
>  for the em dash) and I wouldn't take the trouble to use them myself;
>  but I think there is a reasonable assumption that when someone goes
>  to the effort of using a Unicode punctuation mark that is semantic
>  (rather than merely typographical), they probably had a reason for
>  doing so.
>=20
> > 	- U+2018 ('=E2=80=98'): LEFT SINGLE QUOTATION MARK
> > 	- U+2019 ('=E2=80=99'): RIGHT SINGLE QUOTATION MARK
> > 	- U+201c ('=E2=80=9C'): LEFT DOUBLE QUOTATION MARK
> > 	- U+201d ('=E2=80=9D'): RIGHT DOUBLE QUOTATION MARK =20
> (These are purely typographic, I have no problem with dumping them.)
>=20
> > 	- U+00d7 ('=C3=97'): MULTIPLICATION SIGN =20
> Presumably this is appearing in mathematical formulae, in which case
>  changing it to 'x' loses semantic information.
>=20
> > Using the above symbols will just trick tools like grep for no good
> > reason. =20
> NBSP, sure.  That one's probably an artefact of some document format
>  conversion somewhere along the line, anyway.
> But what kinds of things with =C3=97 or =E2=80=94 in are going to be grep=
t for?

Actually, on almost all places, those aren't used inside math formulae, but
instead, they describe video some resolutions:

	$ git grep =C3=97 Documentation/
	Documentation/devicetree/bindings/display/panel/asus,z00t-tm5p5-nt35596.ya=
ml:title: ASUS Z00T TM5P5 NT35596 5.5" 1080=C3=971920 LCD Panel
	Documentation/devicetree/bindings/display/panel/panel-simple-dsi.yaml:    =
    # LG ACX467AKM-7 4.95" 1080=C3=971920 LCD Panel
	Documentation/devicetree/bindings/sound/tlv320adcx140.yaml:      1 - Mic b=
ias is set to VREF =C3=97 1.096
	Documentation/userspace-api/media/v4l/crop.rst:of 16 =C3=97 16 pixels. The=
 source cropping rectangle is set to defaults,
	Documentation/userspace-api/media/v4l/crop.rst:which are also the upper li=
mit in this example, of 640 =C3=97 400 pixels at
	Documentation/userspace-api/media/v4l/crop.rst:offset 0, 0. An application=
 requests an image size of 300 =C3=97 225 pixels,
	Documentation/userspace-api/media/v4l/crop.rst:The driver sets the image s=
ize to the closest possible values 304 =C3=97 224,
	Documentation/userspace-api/media/v4l/crop.rst:is 608 =C3=97 224 (224 =C3=
=97 2:1 would exceed the limit 400). The offset 0, 0 is
	Documentation/userspace-api/media/v4l/crop.rst:rectangle of 608 =C3=97 456=
 pixels. The present scaling factors limit
	Documentation/userspace-api/media/v4l/crop.rst:cropping to 640 =C3=97 384,=
 so the driver returns the cropping size 608 =C3=97 384
	Documentation/userspace-api/media/v4l/crop.rst:and adjusts the image size =
to closest possible 304 =C3=97 192.
	Documentation/userspace-api/media/v4l/diff-v4l.rst:size bitmap of 1024 =C3=
=97 625 bits. Struct :c:type:`v4l2_window`
	Documentation/userspace-api/media/v4l/vidioc-cropcap.rst:       Assuming p=
ixel aspect 1/1 this could be for example a 640 =C3=97 480
	Documentation/userspace-api/media/v4l/vidioc-cropcap.rst:       rectangle =
for NTSC, a 768 =C3=97 576 rectangle for PAL and SECAM

it is a way more likely that, if someone wants to grep, they would be=20
doing something like this, in order to get video resolutions:

	$ git grep -E "\b[1-9][0-9]+\s*x\s*[0-9]+\b" Documentation/
	Documentation/ABI/obsolete/sysfs-driver-hid-roccat-koneplus:Description:  =
      When read the mouse returns a 30x30 pixel image of the
	Documentation/ABI/obsolete/sysfs-driver-hid-roccat-konepure:Description:  =
      When read the mouse returns a 30x30 pixel image of the
	Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7:         =
      Provides access to the binary "24x7 catalog" provided by the
	Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7:         =
      https://raw.githubusercontent.com/jmesmon/catalog-24x7/master/hv-24x7=
-	catalog.h
	Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7:         =
      Exposes the "version" field of the 24x7 catalog. This is also
	Documentation/ABI/testing/sysfs-bus-event_source-devices-hv_24x7:         =
      HCALLs to retrieve hv-24x7 pmu event counter data.
	Documentation/ABI/testing/sysfs-bus-vfio-mdev:          "2 heads, 512M FB,=
 2560x1600 maximum resolution"
	Documentation/ABI/testing/sysfs-driver-wacom:           of the device. The=
 image is a 64x32 pixel 4-bit gray image. The
	Documentation/ABI/testing/sysfs-driver-wacom:           1024 byte binary i=
s split up into 16x 64 byte chunks. Each 64
	Documentation/ABI/testing/sysfs-driver-wacom:           image has to conta=
in 256 bytes (64x32 px 1 bit colour).
	Documentation/admin-guide/edid.rst:commonly used screen resolutions (800x6=
00, 1024x768, 1280x1024, 1600x1200,
	Documentation/admin-guide/edid.rst:1680x1050, 1920x1080) as binary blobs, =
but the kernel source tree does
	Documentation/admin-guide/edid.rst:If you want to create your own EDID fil=
e, copy the file 1024x768.S,
	Documentation/admin-guide/kernel-parameters.txt:                        ed=
id/1024x768.bin, edid/1280x1024.bin,
	Documentation/admin-guide/kernel-parameters.txt:                        ed=
id/1680x1050.bin, or edid/1920x1080.bin is given
	Documentation/admin-guide/kernel-parameters.txt:                        2 =
- The VGA Shield is attached (1024x768)
	Documentation/admin-guide/media/dvb_intro.rst:signal encoded at a resoluti=
on of 768x576 24-bit color pixels over 25
	Documentation/admin-guide/media/imx.rst:1280x960 input frame to 640x480, a=
nd then /2 downscale in both
	Documentation/admin-guide/media/imx.rst:dimensions to 320x240 (assumes ipu=
1_csi0 is linked to ipu1_csi0_mux):
	Documentation/admin-guide/media/imx.rst:   media-ctl -V "'ipu1_csi0_mux':2=
[fmt:UYVY2X8/1280x960]"

which won't get the above, due to the usage of the UTF-8 alternative.

In any case, replacing all the above by 'x' seems to be the right thing,
at least on my eyes.

> If there are em dashes lying around that semantically _should_ be
>  hyphen-minus (one of your patches I've seen, for instance, fixes an
>  *en* dash moonlighting as the option character in an `ethtool`
>  command line), then sure, convert them.
> But any time someone is using a Unicode character to *express
>  semantics*, even if you happen to think the semantic distinction
>  involved is a pedantic or unimportant one, I think you need an
>  explicit grep case to justify ASCIIfying it.

Yeah, in the case of hyphen/dash it seems to make sense to double check
it.

Thanks,
Mauro
