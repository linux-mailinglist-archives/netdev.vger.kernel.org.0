Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FCCC2641D7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 11:29:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730127AbgIJJ3u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 05:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730358AbgIJJYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 05:24:38 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 140A9C061573;
        Thu, 10 Sep 2020 02:24:37 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z25so6271818iol.10;
        Thu, 10 Sep 2020 02:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UyqGiyvWtrvEPIbfLtgakvWHIPcO7f2wwjJnMPORWG0=;
        b=BoSxMiljYiAjMP/XBn/hYGNVKL/oHxnqnEUJ7qSdwoJLG0pxR2qK3V4/fkUTSaV51s
         3pvr292/IyS8ps68VC6dxn72XHdiWpnrMVrw8xogJTOMYamirEZ059PvshX7H4Z5GWuh
         Vr7j8283bIhfaNsK7sxUGLf6s0Z2Efi6Yl4vefoBSqVlIDK265aYxjjSjS69bDYpqbGV
         /GSb5UhzJJFq63scKHt5GhqSRkybY6g2zuA571aN2zohyHumpin0aZgpFfaeOPy0WbSg
         Mpw6iHtgik0cTA/OjEeiGwKuBqjHR2p7i1mxyZ7WrSW4CGvjjQTt8jjc//sWyeGDOFMK
         9KBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UyqGiyvWtrvEPIbfLtgakvWHIPcO7f2wwjJnMPORWG0=;
        b=O/2XUnV1EtfgfgEoeb0tWhNcir4xfPnAGynDycHILp/UjjoK+MkhZcdiMLOsBL6sdx
         ueBZJVL79C2C9MYcsMGOL5bdh4O3PQW2D9Pvgjq4HoEkSZEPII9X+aymHemdtnjE0Alr
         0WZSMVhmEj8voYJ03ltlEthJhY6lv0tbZJuxabeIV0pa9EMhXA9un7B+DH/ntObBIf+9
         BmpMd/WrGD0wwAbHbSMBDvQItIHDUC0d9E+sFnVFDAaI8gr/N227J5uMxl5cT6wXoE10
         IPnjMS2l7nvI//BN//lgm0N0g8L3K4kq5Py7WD00fgh6oDALQkzp7TRutHF6MYjxWahv
         sM6A==
X-Gm-Message-State: AOAM532ywlPycKW7BigrvrbeI5fmmYuKtgIlMY+CTkpgz3ykrSwmz6YG
        yk2jcSj2kjVBOGcpW+CrBpuFuh7r23UhtnrKsec=
X-Google-Smtp-Source: ABdhPJzJ/LFpexv9kLm1kjwc0/B+7GHCOB8WQagf03Hz+gzhVFwgLWrpkGefOcCCEeSFlcKtCwndocR5oDNlZlvNymM=
X-Received: by 2002:a5d:8846:: with SMTP id t6mr7056972ios.123.1599729876856;
 Thu, 10 Sep 2020 02:24:36 -0700 (PDT)
MIME-Version: 1.0
References: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
In-Reply-To: <e6387578c75736d61b2fe70d9783d91329a97eb4.camel@perches.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 10 Sep 2020 11:24:26 +0200
Message-ID: <CAOi1vP-v77pj3G5Ez94CDYVs2jSO828c4uV_wzNi6sRKp=Yvyg@mail.gmail.com>
Subject: Re: [trivial PATCH] treewide: Convert switch/case fallthrough; to break;
To:     Joe Perches <joe@perches.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Jiri Kosina <trivial@kernel.org>,
        Kees Cook <kees.cook@canonical.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        linux-mips@vger.kernel.org, linux-s390@vger.kernel.org,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        linux-ide@vger.kernel.org, linux-atm-general@lists.sourceforge.net,
        netdev <netdev@vger.kernel.org>, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org,
        linux-input@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-rdma@vger.kernel.org, iommu@lists.linux-foundation.org,
        dm-devel@redhat.com, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        intel-wired-lan@lists.osuosl.org, oss-drivers@netronome.com,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-pm@vger.kernel.org, linux-rtc@vger.kernel.org,
        linux-scsi@vger.kernel.org, storagedev@microchip.com,
        sparclinux@vger.kernel.org, linux-serial@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, linux-parisc@vger.kernel.org,
        linux-fbdev@vger.kernel.org, linux-afs@lists.infradead.org,
        Ceph Development <ceph-devel@vger.kernel.org>,
        linux-nfs@vger.kernel.org, bpf@vger.kernel.org,
        dccp@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, linux-sctp@vger.kernel.org,
        alsa-devel <alsa-devel@alsa-project.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 10:10 PM Joe Perches <joe@perches.com> wrote:
>
> fallthrough to a separate case/default label break; isn't very readable.
>
> Convert pseudo-keyword fallthrough; statements to a simple break; when
> the next label is case or default and the only statement in the next
> label block is break;
>
> Found using:
>
> $ grep-2.5.4 -rP --include=*.[ch] -n "fallthrough;(\s*(case\s+\w+|default)\s*:\s*){1,7}break;" *
>
> Miscellanea:
>
> o Move or coalesce a couple label blocks above a default: block.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>
> Compiled allyesconfig x86-64 only.
> A few files for other arches were not compiled.
>
>  arch/arm/mach-mmp/pm-pxa910.c                             |  2 +-
>  arch/arm64/kvm/handle_exit.c                              |  2 +-
>  arch/mips/kernel/cpu-probe.c                              |  2 +-
>  arch/mips/math-emu/cp1emu.c                               |  2 +-
>  arch/s390/pci/pci.c                                       |  2 +-
>  crypto/tcrypt.c                                           |  4 ++--
>  drivers/ata/sata_mv.c                                     |  2 +-
>  drivers/atm/lanai.c                                       |  2 +-
>  drivers/gpu/drm/i915/display/intel_sprite.c               |  2 +-
>  drivers/gpu/drm/nouveau/nvkm/engine/disp/hdmi.c           |  2 +-
>  drivers/hid/wacom_wac.c                                   |  2 +-
>  drivers/i2c/busses/i2c-i801.c                             |  2 +-
>  drivers/infiniband/ulp/rtrs/rtrs-clt.c                    | 14 +++++++-------
>  drivers/infiniband/ulp/rtrs/rtrs-srv.c                    |  6 +++---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c               |  2 +-
>  drivers/irqchip/irq-vic.c                                 |  4 ++--
>  drivers/md/dm.c                                           |  2 +-
>  drivers/media/dvb-frontends/drxd_hard.c                   |  2 +-
>  drivers/media/i2c/ov5640.c                                |  2 +-
>  drivers/media/i2c/ov6650.c                                |  5 ++---
>  drivers/media/i2c/smiapp/smiapp-core.c                    |  2 +-
>  drivers/media/i2c/tvp5150.c                               |  2 +-
>  drivers/media/pci/ddbridge/ddbridge-core.c                |  2 +-
>  drivers/media/usb/cpia2/cpia2_core.c                      |  2 +-
>  drivers/mfd/iqs62x.c                                      |  3 +--
>  drivers/mmc/host/atmel-mci.c                              |  2 +-
>  drivers/mtd/nand/raw/nandsim.c                            |  2 +-
>  drivers/net/ethernet/intel/e1000e/phy.c                   |  2 +-
>  drivers/net/ethernet/intel/fm10k/fm10k_pf.c               |  2 +-
>  drivers/net/ethernet/intel/i40e/i40e_adminq.c             |  2 +-
>  drivers/net/ethernet/intel/i40e/i40e_txrx.c               |  2 +-
>  drivers/net/ethernet/intel/iavf/iavf_txrx.c               |  2 +-
>  drivers/net/ethernet/intel/igb/e1000_phy.c                |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_82599.c            |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_main.c             |  2 +-
>  drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c            |  2 +-
>  drivers/net/ethernet/intel/ixgbevf/vf.c                   |  2 +-
>  drivers/net/ethernet/netronome/nfp/nfpcore/nfp6000_pcie.c |  2 +-
>  drivers/net/ethernet/qlogic/qed/qed_mcp.c                 |  2 +-
>  drivers/net/ethernet/sfc/falcon/farch.c                   |  2 +-
>  drivers/net/ethernet/sfc/farch.c                          |  2 +-
>  drivers/net/phy/adin.c                                    |  3 +--
>  drivers/net/usb/pegasus.c                                 |  4 ++--
>  drivers/net/usb/usbnet.c                                  |  2 +-
>  drivers/net/wireless/ath/ath5k/eeprom.c                   |  2 +-
>  drivers/net/wireless/mediatek/mt7601u/dma.c               |  8 ++++----
>  drivers/nvme/host/core.c                                  | 12 ++++++------
>  drivers/pcmcia/db1xxx_ss.c                                |  4 ++--
>  drivers/power/supply/abx500_chargalg.c                    |  2 +-
>  drivers/power/supply/charger-manager.c                    |  2 +-
>  drivers/rtc/rtc-pcf85063.c                                |  2 +-
>  drivers/s390/scsi/zfcp_fsf.c                              |  2 +-
>  drivers/scsi/aic7xxx/aic79xx_core.c                       |  4 ++--
>  drivers/scsi/aic94xx/aic94xx_tmf.c                        |  2 +-
>  drivers/scsi/lpfc/lpfc_sli.c                              |  2 +-
>  drivers/scsi/smartpqi/smartpqi_init.c                     |  2 +-
>  drivers/scsi/sr.c                                         |  2 +-
>  drivers/tty/serial/sunsu.c                                |  2 +-
>  drivers/tty/serial/sunzilog.c                             |  2 +-
>  drivers/tty/vt/vt_ioctl.c                                 |  2 +-
>  drivers/usb/dwc3/core.c                                   |  2 +-
>  drivers/usb/gadget/legacy/inode.c                         |  2 +-
>  drivers/usb/gadget/udc/pxa25x_udc.c                       |  4 ++--
>  drivers/usb/host/ohci-hcd.c                               |  2 +-
>  drivers/usb/isp1760/isp1760-hcd.c                         |  2 +-
>  drivers/usb/musb/cppi_dma.c                               |  2 +-
>  drivers/usb/phy/phy-fsl-usb.c                             |  2 +-
>  drivers/video/fbdev/stifb.c                               |  2 +-
>  fs/afs/yfsclient.c                                        |  8 ++++----
>  fs/ceph/dir.c                                             |  2 +-

For ceph:

Acked-by: Ilya Dryomov <idryomov@gmail.com>

Thanks,

                Ilya
