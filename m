Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39E4251796
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 13:30:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729977AbgHYLaj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 07:30:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:43858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729710AbgHYLai (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 07:30:38 -0400
Received: from coco.lan (ip5f5ad5a4.dynamic.kabel-deutschland.de [95.90.213.164])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B53082068E;
        Tue, 25 Aug 2020 11:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598355037;
        bh=hS8MOXkGn7JYwFlDKqfpgI96hhlOO6z5RGuYqJxyWNk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vjYUYXjEaXVD3eAv3vZmxrvIuLgKkLKqMeS9kLfzQ69qD0P0HbZowGUT/hmAmwffm
         yhiHRysfyy1aN6khI/k+KqtD8yKFr0XivtzoBQzJmSmoZhDkN4wwHZH+fXlz9L07Pt
         MOWyOw/24QeMx5Wugndtf9E49WkpaoSdesV/9YFE=
Date:   Tue, 25 Aug 2020 13:30:25 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Dave Airlie <airlied@gmail.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        David Airlie <airlied@linux.ie>,
        Wanchun Zheng <zhengwanchun@hisilicon.com>,
        linuxarm@huawei.com, dri-devel <dri-devel@lists.freedesktop.org>,
        Andrzej Hajda <a.hajda@samsung.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        driverdevel <devel@driverdev.osuosl.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        Xiubin Zhang <zhangxiubin1@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        Xinliang Liu <xinliang.liu@linaro.org>,
        Xinwei Kong <kong.kongxinwei@hisilicon.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Bogdan Togorean <bogdan.togorean@analog.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Laurentiu Palcu <laurentiu.palcu@nxp.com>,
        linux-media <linux-media@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, Liwei Cai <cailiwei@hisilicon.com>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Chen Feng <puck.chen@hisilicon.com>,
        Alexei Starovoitov <ast@kernel.org>,
        "moderated list:DMA BUFFER SHARING FRAMEWORK" 
        <linaro-mm-sig@lists.linaro.org>, Rob Herring <robh+dt@kernel.org>,
        mauro.chehab@huawei.com, Rob Clark <robdclark@chromium.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Liuyao An <anliuyao@huawei.com>,
        Network Development <netdev@vger.kernel.org>,
        Rongrong Zou <zourongrong@gmail.com>,
        BPF Mailing List <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 00/49] DRM driver for Hikey 970
Message-ID: <20200825133025.13f047f0@coco.lan>
In-Reply-To: <CAPM=9twzsw7T=GD6Jc1EFenXq9ZhTgf_Nuo71uLfX2W33oa=6w@mail.gmail.com>
References: <cover.1597833138.git.mchehab+huawei@kernel.org>
        <20200819152120.GA106437@ravnborg.org>
        <20200819153045.GA18469@pendragon.ideasonboard.com>
        <CALAqxLUXnPRec3UYbMKge8yNKBagLOatOeRCagF=JEyPEfWeKA@mail.gmail.com>
        <20200820090326.3f400a15@coco.lan>
        <20200820100205.GA5962@pendragon.ideasonboard.com>
        <CAPM=9twzsw7T=GD6Jc1EFenXq9ZhTgf_Nuo71uLfX2W33oa=6w@mail.gmail.com>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 25 Aug 2020 05:29:29 +1000
Dave Airlie <airlied@gmail.com> escreveu:

> On Thu, 20 Aug 2020 at 20:02, Laurent Pinchart
> <laurent.pinchart@ideasonboard.com> wrote:
> >
> > Hi Mauro,
> >
> > On Thu, Aug 20, 2020 at 09:03:26AM +0200, Mauro Carvalho Chehab wrote: =
=20
> > > Em Wed, 19 Aug 2020 12:52:06 -0700 John Stultz escreveu: =20
> > > > On Wed, Aug 19, 2020 at 8:31 AM Laurent Pinchart wrote: =20
> > > > > On Wed, Aug 19, 2020 at 05:21:20PM +0200, Sam Ravnborg wrote: =20
> > > > > > On Wed, Aug 19, 2020 at 01:45:28PM +0200, Mauro Carvalho Chehab=
 wrote: =20
> > > > > > > This patch series port the out-of-tree driver for Hikey 970 (=
which
> > > > > > > should also support Hikey 960) from the official 96boards tre=
e:
> > > > > > >
> > > > > > >    https://github.com/96boards-hikey/linux/tree/hikey970-v4.9
> > > > > > >
> > > > > > > Based on his history, this driver seems to be originally writ=
ten
> > > > > > > for Kernel 4.4, and was later ported to Kernel 4.9. The origi=
nal
> > > > > > > driver used to depend on ION (from Kernel 4.4) and had its own
> > > > > > > implementation for FB dev API.
> > > > > > >
> > > > > > > As I need to preserve the original history (with has patches =
from
> > > > > > > both HiSilicon and from Linaro),  I'm starting from the origi=
nal
> > > > > > > patch applied there. The remaining patches are incremental,
> > > > > > > and port this driver to work with upstream Kernel.
> > > > > > > =20
> > > > ... =20
> > > > > > > - Due to legal reasons, I need to preserve the authorship of
> > > > > > >   each one responsbile for each patch. So, I need to start fr=
om
> > > > > > >   the original patch from Kernel 4.4; =20
> > > > ... =20
> > > > > > I do acknowledge you need to preserve history and all -
> > > > > > but this patchset is not easy to review. =20
> > > > >
> > > > > Why do we need to preserve history ? Adding relevant Signed-off-b=
y and
> > > > > Co-developed-by should be enough, shouldn't it ? Having a public =
branch
> > > > > that contains the history is useful if anyone is interested, but =
I don't
> > > > > think it's required in mainline. =20
> > > >
> > > > Yea. I concur with Laurent here. I'm not sure what legal reasoning =
you
> > > > have on this but preserving the "absolute" history here is actively
> > > > detrimental for review and understanding of the patch set.
> > > >
> > > > Preserving Authorship, Signed-off-by lines and adding Co-developed-=
by
> > > > lines should be sufficient to provide both atribution credit and DCO
> > > > history. =20
> > >
> > > I'm not convinced that, from legal standpoint, folding things would
> > > be enough. See, there are at least 3 legal systems involved here
> > > among the different patch authors:
> > >
> > >       - civil law;
> > >       - common law;
> > >       - customary law + common law.
> > >
> > > Merging stuff altogether from different law systems can be problemati=
c,
> > > and trying to discuss this with experienced IP property lawyers will
> > > for sure take a lot of time and efforts. I also bet that different
> > > lawyers will have different opinions, because laws are subject to
> > > interpretation. With that matter I'm not aware of any court rules
> > > with regards to folded patches. So, it sounds to me that folding
> > > patches is something that has yet to be proofed in courts around
> > > the globe.
> > >
> > > At least for US legal system, it sounds that the Country of
> > > origin of a patch is relevant, as they have a concept of
> > > "national technology" that can be subject to export regulations.
> > >
> > > From my side, I really prefer to play safe and stay out of any such
> > > legal discussions. =20
> >
> > Let's be serious for a moment. If you think there are legal issues in
> > taking GPL-v2.0-only patches and squashing them while retaining
> > authorship information through tags, the Linux kernel if *full* of that.
> > You also routinely modify patches that you commit to the media subsystem
> > to fix "small issues".
> >
> > The country of origin argument makes no sense either, the kernel code
> > base if full of code coming from pretty much all country on the planet.
> >
> > Keeping the patches separate make this hard to review. Please squash
> > them. =20
>=20
> I'm inclined to agree with Laurent here.
>=20
> Patches submitted as GPL-v2 with DCO lines and author names/companies
> should be fine to be squashed and rearranged,
> as long as the DCO and Authorship is kept somewhere in the new patch
> that is applied.
>=20
> Review is more important here.

Sorry, but I can't agree that review is more important than to be able
to properly indicate copyrights in a valid way at the legal systems that
it would apply ;-)

In any case, there's an easy way to make the code easy to review:
I can write the patches against staging (where it is OK to submit
preserving the history) and then add a final patch moving it out
of staging.

You can then just review the last patch, as it will contain the
entire code on it.

Another alternative, as I'm already doing with Sam, is for me to
submit the folded code as a reply to 00/xx. You can then just=20
review the final code, without concerning about how the code reached
there.

=46rom review point of the view, this will be the same as reviewing
a folded patch, but, from legal standpoint, the entire copyright
chain will be preserved.

Thanks,
Mauro
