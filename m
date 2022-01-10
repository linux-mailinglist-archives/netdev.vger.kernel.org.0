Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11178489562
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 10:36:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243033AbiAJJgv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 04:36:51 -0500
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:43238 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S243029AbiAJJgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 04:36:07 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 20A8SpK3001224;
        Mon, 10 Jan 2022 09:34:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=LTgj9BMo0PeVOTmHS425bgS3Erf/sk7QZhpGDMjgyhM=;
 b=ZeBWbN0MuX3/AcZ5RKWxlntTjtiYf7I8s1BDSqtpXcjWdKYreu00C0yIuS54bslUb+Qr
 i8eYw95JaW/kRkoSt2zAHTinIjB+A7CPiMdtyB681hPeHcfgnzR85uHf321nrRQFc1lp
 la9fqV0TOWpjT+vO0xEhhgF1o49lWVqwByJ8qBn2XaRUDR7r5LiwvirD3oVxz1l/G8aA
 GGCXA11FLJGWT7f5iLejA1BYwhyVqSkuX7XlV9iM6xmQILJKk4eoCpwa9+QQDTpFWY9O
 RafQfotY4ReY1g/9giu+qtTtTZzWY7egugKozzrEpyohVjle6LQRR+kd516WluIEvvXn Gw== 
Received: from ppma06fra.de.ibm.com (48.49.7a9f.ip4.static.sl-reverse.com [159.122.73.72])
        by mx0b-001b2d01.pphosted.com with ESMTP id 3dfm1hp8jh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 09:34:44 +0000
Received: from pps.filterd (ppma06fra.de.ibm.com [127.0.0.1])
        by ppma06fra.de.ibm.com (8.16.1.2/8.16.1.2) with SMTP id 20A9Rlj5003316;
        Mon, 10 Jan 2022 09:34:41 GMT
Received: from b06cxnps4075.portsmouth.uk.ibm.com (d06relay12.portsmouth.uk.ibm.com [9.149.109.197])
        by ppma06fra.de.ibm.com with ESMTP id 3df1vj2baj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 10 Jan 2022 09:34:41 +0000
Received: from d06av23.portsmouth.uk.ibm.com (d06av23.portsmouth.uk.ibm.com [9.149.105.59])
        by b06cxnps4075.portsmouth.uk.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 20A9Ydft44106206
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 10 Jan 2022 09:34:39 GMT
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id CCEA2A405B;
        Mon, 10 Jan 2022 09:34:38 +0000 (GMT)
Received: from d06av23.portsmouth.uk.ibm.com (unknown [127.0.0.1])
        by IMSVA (Postfix) with ESMTP id F191AA4065;
        Mon, 10 Jan 2022 09:34:34 +0000 (GMT)
Received: from sig-9-145-16-13.uk.ibm.com (unknown [9.145.16.13])
        by d06av23.portsmouth.uk.ibm.com (Postfix) with ESMTP;
        Mon, 10 Jan 2022 09:34:34 +0000 (GMT)
Message-ID: <822ad0da702f0953b7aae1febd2c4dfcc4707864.camel@linux.ibm.com>
Subject: Re: [RFC 01/32] Kconfig: introduce and depend on LEGACY_PCI
From:   Niklas Schnelle <schnelle@linux.ibm.com>
To:     John Garry <john.garry@huawei.com>,
        Bjorn Helgaas <helgaas@kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Ettore Chimenti <ek5.chimenti@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Nick Hu <nickhu@andestech.com>,
        Greentime Hu <green.hu@gmail.com>,
        Vincent Chen <deanbo422@gmail.com>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        Palmer Dabbelt <palmer@dabbelt.com>,
        Albert Ou <aou@eecs.berkeley.edu>, Guo Ren <guoren@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hsweeten@visionengravers.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Jean Delvare <jdelvare@suse.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Karsten Keil <isdn@linux-pingi.de>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Michael Grzeschik <m.grzeschik@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Kalle Valo <kvalo@kernel.org>, Jouni Malinen <j@w1.fi>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Teddy Wang <teddy.wang@siliconmotion.com>,
        Forest Bond <forest@alittletooquiet.net>,
        Jiri Slaby <jirislaby@kernel.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-riscv@lists.infradead.org, linux-csky@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-hwmon@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, netdev@vger.kernel.org,
        linux-media@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-wireless@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        linux-spi@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-serial@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-watchdog@vger.kernel.org
Date:   Mon, 10 Jan 2022 10:34:34 +0100
In-Reply-To: <74bf4fde-3972-1c36-ca04-58089da0d82b@huawei.com>
References: <20220105194748.GA215560@bhelgaas>
         <74bf4fde-3972-1c36-ca04-58089da0d82b@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-18.el8) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: RBwht8yqbe4Zp6W3roxBtkr5zQL4IA2M
X-Proofpoint-ORIG-GUID: RBwht8yqbe4Zp6W3roxBtkr5zQL4IA2M
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.790,Hydra:6.0.425,FMLib:17.11.62.513
 definitions=2022-01-10_04,2022-01-07_01,2021-12-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 bulkscore=0
 impostorscore=0 malwarescore=0 mlxlogscore=999 lowpriorityscore=0
 phishscore=0 adultscore=0 spamscore=0 clxscore=1015 mlxscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2201100067
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2022-01-06 at 17:41 +0000, John Garry wrote:
> On 05/01/2022 19:47, Bjorn Helgaas wrote:
> > > > > >   ok if the PCI maintainers decide otherwise.
> > > > > I don't really like the "LEGACY_PCI" Kconfig option.  "Legacy" just
> > > > > means something old and out of favor; it doesn't say*what*  that
> > > > > something is.
> > > > > 
> > > > > I think you're specifically interested in I/O port space usage, and it
> > > > > seems that you want all PCI drivers that*only*  use I/O port space to
> > > > > depend on LEGACY_PCI?  Drivers that can use either I/O or memory
> > > > > space or both would not depend on LEGACY_PCI?  This seems a little
> > > > > murky and error-prone.
> > > > I'd like to hear Arnd's opinion on this but you're the PCI maintainer
> > > > so of course your buy-in would be quite important for such an option.
> > I'd like to hear Arnd's opinion, too.  If we do add LEGACY_PCI, I
> > think we need a clear guide for when to use it, e.g., "a PCI driver
> > that uses inb() must depend on LEGACY_PCI" or whatever it is.
> > 
> > I must be missing something because I don't see what we gain from
> > this.  We have PCI drivers, e.g., megaraid [1], for devices that have
> > either MEM or I/O BARs.  I think we want to build drivers like that on
> > any arch that supports PCI.
> > 
> > If the arch doesn't support I/O port space, devices that only have I/O
> > BARs won't work, of course, and hopefully the PCI core and driver can
> > figure that out and gracefully fail the probe.
> > 
> > But that same driver should still work with devices that have MEM
> > BARs.  If inb() isn't always present, I guess we could litter these
> > drivers with #ifdefs, but that would be pretty ugly.

I think this is the big question here. If we do go with a compile-time
solution as requested by Linus we will either get a lot of #ifdeffery,
coarse driver dependencies or as proposed by Alan Stern for the USB
#ifdefs might end up turning inb() into a compile-time nop.

The originally proposed change that returned ~0 from inb() and printed
a warning clearly is the simpler change and sure we could also drop the
warning. I'm honestly torn, I do agree with Linus that we shouldn't
have run-time things that we know at compile-time will not work but I
also dislike all the #ifdeffery a compile-time solution requires. Sadly
C really doesn't give us any better tools here.

Also I 100% agree with you Bjorn how likely it is to see a device on a
platform really shouldn't matter. Without going into details, on s390
we have already beneffited from PCI drivers working with 0 changes to
support devices we previously didn't have on the platform or
anticipated we would get in the future. Consequently drivers that could
work in principle should be built.

> >  
> 
> There were some ifdefs added to the 8250 drivers in Arnd's original 
> patch [0], but it does not seem included here.
> 
> Niklas, what happened to the 8250 and the other driver changes?

I missed it during the rebase, likely because the changed files compile
depend on !S390 via config SERIAL_8250 and thus didn't cause any errors
for my allyesconfig. That !S390 dependency is of course not really what
we want if the driver can use MEM BARs.


