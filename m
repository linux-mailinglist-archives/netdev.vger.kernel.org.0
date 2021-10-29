Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D41DF43FABE
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 12:32:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231725AbhJ2Kel convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 29 Oct 2021 06:34:41 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:4039 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231683AbhJ2Keg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Oct 2021 06:34:36 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Hgdv44WM2z67krr;
        Fri, 29 Oct 2021 18:28:48 +0800 (CST)
Received: from lhreml717-chm.china.huawei.com (10.201.108.68) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.15; Fri, 29 Oct 2021 12:32:05 +0200
Received: from lhreml710-chm.china.huawei.com (10.201.108.61) by
 lhreml717-chm.china.huawei.com (10.201.108.68) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Fri, 29 Oct 2021 11:32:04 +0100
Received: from lhreml710-chm.china.huawei.com ([169.254.81.184]) by
 lhreml710-chm.china.huawei.com ([169.254.81.184]) with mapi id
 15.01.2308.015; Fri, 29 Oct 2021 11:32:03 +0100
From:   Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
To:     Jason Gunthorpe <jgg@nvidia.com>,
        Alex Williamson <alex.williamson@redhat.com>
CC:     Cornelia Huck <cohuck@redhat.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "saeedm@nvidia.com" <saeedm@nvidia.com>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leonro@nvidia.com" <leonro@nvidia.com>,
        "kwankhede@nvidia.com" <kwankhede@nvidia.com>,
        "mgurtovoy@nvidia.com" <mgurtovoy@nvidia.com>,
        "maorg@nvidia.com" <maorg@nvidia.com>,
        "Dr. David Alan Gilbert" <dgilbert@redhat.com>
Subject: RE: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Topic: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
 for mlx5 devices
Thread-Index: AQHXxNiJ5sEZ2IosYUWOFwYUAR8/1avamBEAgAALEACAABqtAIAAIxaAgACddACAAIzwAIAAI2+AgAAjt4CAANCrAIAAzO+AgAWtdwCAACFWgIAAB8UAgAGOQwCAAAo+gIAAS/kAgABA4gCAAUTBAIAABSWAgAFRMICAAIruAIAAwsBw
Date:   Fri, 29 Oct 2021 10:32:03 +0000
Message-ID: <9db8d3e50a6f4fcc860e5500b899eeec@huawei.com>
References: <20211025122938.GR2744544@nvidia.com>
 <20211025082857.4baa4794.alex.williamson@redhat.com>
 <20211025145646.GX2744544@nvidia.com>
 <20211026084212.36b0142c.alex.williamson@redhat.com>
 <20211026151851.GW2744544@nvidia.com>
 <20211026135046.5190e103.alex.williamson@redhat.com>
 <20211026234300.GA2744544@nvidia.com>
 <20211027130520.33652a49.alex.williamson@redhat.com>
 <20211027192345.GJ2744544@nvidia.com>
 <20211028093035.17ecbc5d.alex.williamson@redhat.com>
 <20211028234750.GP2744544@nvidia.com>
In-Reply-To: <20211028234750.GP2744544@nvidia.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.202.227.178]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jason,

> -----Original Message-----
> From: Jason Gunthorpe [mailto:jgg@nvidia.com]
> Sent: 29 October 2021 00:48
> To: Alex Williamson <alex.williamson@redhat.com>
> Cc: Cornelia Huck <cohuck@redhat.com>; Yishai Hadas <yishaih@nvidia.com>;
> bhelgaas@google.com; saeedm@nvidia.com; linux-pci@vger.kernel.org;
> kvm@vger.kernel.org; netdev@vger.kernel.org; kuba@kernel.org;
> leonro@nvidia.com; kwankhede@nvidia.com; mgurtovoy@nvidia.com;
> maorg@nvidia.com; Dr. David Alan Gilbert <dgilbert@redhat.com>
> Subject: Re: [PATCH V2 mlx5-next 12/14] vfio/mlx5: Implement vfio_pci driver
> for mlx5 devices
> 
> On Thu, Oct 28, 2021 at 09:30:35AM -0600, Alex Williamson wrote:
> > On Wed, 27 Oct 2021 16:23:45 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >
> > > On Wed, Oct 27, 2021 at 01:05:20PM -0600, Alex Williamson wrote:
> > >
> > > > > As far as the actual issue, if you hadn't just discovered it now
> > > > > nobody would have known we have this gap - much like how the very
> > > > > similar reset issue was present in VFIO for so many years until you
> > > > > plugged it.
> > > >
> > > > But the fact that we did discover it is hugely important.  We've
> > > > identified that the potential use case is significantly limited and
> > > > that userspace doesn't have a good mechanism to determine when to
> > > > expose that limitation to the user.
> > >
> > > Huh?
> > >
> > > We've identified that, depending on device behavior, the kernel may
> > > need to revoke MMIO access to protect itself from hostile userspace
> > > triggering TLP Errors or something.
> > >
> > > Well behaved userspace must already stop touching the MMIO on the
> > > device when !RUNNING - I see no compelling argument against that
> > > position.
> >
> > Not touching MMIO is not specified in our uAPI protocol,
> 
> To be frank, not much is specified in the uAPI comment, certainly not
> a detailed meaning of RUNNING.
> 
> > nor is it an obvious assumption to me, nor is it sufficient to
> > assume well behaved userspace in the implementation of a kernel
> > interface.
> 
> I view two aspects to !RUNNING:
> 
>  1) the kernel must protect itself from hostile userspace. This means
>     preventing loss of kernel or device integrity (ie no error TLPs, no
>     crashing/corrupting the device/etc)
> 
>  2) userspace must follow the rules so that the migration is not
>     corrupted. We want to set the rules in a way that gives the
>     greatest freedom of HW implementation
> 
> Regarding 1, I think we all agree on this, and currently we believe
> mlx5 is meeting this goal as-is.
> 
> Regarding 2, I think about possible implementations and come to the
> conclusion that !RUNNING must mean no MMIO. For several major reasons
> 
> - For whatever reason a poor device may become harmed by MMIO during
>   !RUNNING and so we may someday need to revoke MMIO like we do for
>   reset. This implies that segfault on MMIO during !RUNNING
>   is an option we should keep open.
> 
> - A simple DMA queue device, kind of like the HNS driver, could
>   implement migration without HW support. Transition to !RUNNING only
>   needs to wait for the device to fully drained the DMA queue.
> 
>   Any empty DMA queue with no MMIOs means a quiet and migration ready
>   device.
> 
>   However, if further MMIOs poke at the device it may resume
>   operating and issue DMAs, which would corrupt the migration.
 
Just trying to follow the thread here. The above situation where MMIOs can be
further poked in the !RUNNING state, do you mean poking through P2P or
Guest/Qemu can still do that? I am just trying to see if the current uAPI fits well
within the use case where we don't have any P2P scenario and the assigned dev
is behind the IOMMU.

Thanks,
Shameer 


> 
> - We cannot define what MMIO during !RUNNING should even do. What
>   should a write do? What should a read return? The mlx5 version is
>   roughly discard the write and return garbage on read. While this
>   does not corrupt the migration it is also not useful behavior to
>   define.
> 
> In several of these case I'm happy if broken userspace harms itself
> and corrupts the migration. That does not impact the integrity of the
> kernel, and is just buggy userspace.
> 
> > > We've been investigating how the mlx5 HW will behave in corner cases,
> > > and currently it looks like mlx5 vfio will not generate error TLPs, or
> > > corrupt the device itself due to MMIO operations when !RUNNING. So the
> > > driver itself, as written, probably does not currently have a bug
> > > here, or need changes.
> >
> > This is a system level observation or is it actually looking at the
> > bus?  An Unsupported Request on MMIO write won't even generate an AER
> > on some systems, but others can trigger a fatal error on others.
> 
> At this point this information is a design analysis from the HW
> people.
> 
> > > > We're tossing around solutions that involve extensions, if not
> > > > changes to the uAPI.  It's Wednesday of rc7.
> > >
> > > The P2P issue is seperate, and as I keep saying, unless you want to
> > > block support for any HW that does not have freeze&queice userspace
> > > must be aware of this ability and it is logical to design it as an
> > > extension from where we are now.
> >
> > Is this essentially suggesting that the uAPI be clarified to state
> > that the base implementation is only applicable to userspace contexts
> > with a single migratable vfio device instance?
> 
> That is one way to look at it, yes. It is not just a uAPI limitation
> but a HW limitation as the NDMA state does require direct HW support
> to continue accepting MMIO/etc but not issue DMA. A simple DMA queue
> device as I imagine above couldn't implement it.
> 
> > Does that need to preemptively include /dev/iommu generically,
> > ie. anything that could potentially have an IOMMU mapping to the
> > device?
> 
> Going back to the top, for #1 the kernel must protect its
> integrity. So, like reset, if we have a driver where revoke is
> required then the revoke must extend to /dev/iommu as well.
> 
> For #2 - it is up to userspace. If userspace plugs the device into
> /dev/iommu and keeps operating it then the migration can be
> corrupted. Buggy userspace.
> 
> > I agree that it would be easier to add a capability to expose
> > multi-device compatibility than to try to retrofit one to expose a
> > restriction.
> 
> Yes, me too. What we have here is a realization that the current
> interface does not support P2P scenarios. There is a wide universe of
> applications that don't need P2P.
> 
> The realization is that qemu has a bug in that it allows the VM to
> execute P2P operations which are incompatible with my above definition
> of !RUNNING. The result is the #2 case: migration corruption.
> 
> qemu should protect itself from a VM causing corruption of the
> migration. Either by only supporting migration with a single VFIO
> device, or directly blocking P2P scenarios using the IOMMU.
> 
> To support P2P will require new kernel support, capability and HW
> support. Which, in concrete terms, means we need to write a new uAPI
> spec, update the mlx5 vfio driver, implement qemu patches, and test
> the full solution.
> 
> Right now we are focused on the non-P2P cases, which I think is a
> reasonable starting limitation.
> 
> > Like I've indicated, this is not an obvious corollary of the !_RUNNING
> > state to me.  I'd tend more towards letting userspace do what they want
> > and only restrict as necessary to protect the host.  For example the
> > state of the device when !_RUNNING may be changed by external stimuli,
> > including MMIO and DMA accesses, but the device does not independently
> > advance state.
> 
> As above this is mixing #1 and #2 - it is fine to allow the device to
> do whatever as long as it doesn't harm the host - however that doesn't
> define the conditions userspace must follow to have a successful
> migration.
> 
> > Also, I think we necessarily require config space read-access to
> > support migration, which begs the question specifically which regions,
> > if any, are restricted when !_RUNNING?  Could we get away with zapping
> > mmaps (sigbus on fault) but allowing r/w access?
> 
> Ideally we would define exactly what device operations are allowed
> during !RUNNING such that the migration will be successful. Operations
> outside that list should be considered things that could corrupt the
> migration.
> 
> This list should be as narrow as possible to allow the broadest range
> of HW designs.
> 
> > > Yes, if qemu becomes deployed, but our testing shows qemu support
> > > needs a lot of work before it is deployable, so that doesn't seem to
> > > be an immediate risk.
> >
> > Good news... I guess...  but do we know what other uAPI changes might
> > be lurking without completing that effort?
> 
> Well, I would say this patch series is approximately the mid point of
> the project. We are about 60 patches into kernel changes at this
> point. What is left is approximately:
> 
>  - fix bugs in qemu so single-device operation is robust
>  - dirty page tracking using the system iommu (via iommufd I suppose?)
>  - dirty page tracking using the device iommu
>  - migration with P2P ongoing: uAPI spec, kernel implementation
>    and qemu implementation
> 
> Then we might have a product..
> 
> I also know the mlx5 device was designed with knowledge of other
> operating systems and our team believes the device interface meets all
> needs.
> 
> So, is the uAPI OK? I'd say provisionally yes. It works within its
> limitations and several vendors have implemented it, even if only two
> are heading toward in-tree.
> 
> Is it clearly specified and covers all scenarios? No..
> 
> > > If some fictional HW can be more advanced and can snapshot not freeze,
> > > that is great, but it doesn't change one bit that mlx5 cannot and will
> > > not work that way. Since mlx5 must be supported, there is no choice
> > > but to define the uAPI around its limitations.
> >
> > But it seems like you've found that mlx5 is resilient to these things
> > that you're also deeming necessary to restrict.
> 
> Here I am talking about freeze/quiesce as a HW design choice, not the
> mmio stuff.
> 
> > > So, I am not left with a clear idea what is still open that you see as
> > > blocking. Can you summarize?
> >
> > It seems we have numerous uAPI questions floating around, including
> > whether the base specification is limited to a single physical device
> > within the user's IOMMU context, what the !_RUNNING state actually
> > implies about the device state, expectations around userspace access
> > to device regions while in this state, and who is responsible for
> > limiting such access, and uncertainty what other uAPI changes are
> > necessary as QEMU support is stabilized.
> 
> I think these questions have straightfoward answers. I've tried to
> explain my view above.
> 
> > Why should we rush a driver in just before the merge window and
> > potentially increase our experimental driver debt load rather than
> > continue to co-develop kernel and userspace drivers and maybe also
> > get input from the owners of the existing out-of-tree drivers?  Thanks,
> 
> It is not a big deal to defer things to rc1, though merging a
> leaf-driver that has been on-list over a month is certainly not
> rushing either.
> 
> We are not here doing all this work because we want to co-develop
> kernel and user space drivers out of tree for ages.
> 
> Why to merge it? Because there is still lots of work to do, and to
> make progress on the next bits require agreeing to the basic stuff
> first!
> 
> So, lets have some actional feedback on what you need to see for an
> rc1 merging please.
> 
> Since there are currently no unaddressed comments on the patches, I
> assume you want to see more work done, please define it.
> 
> Thanks,
> Jason
