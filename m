Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6583E2638
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 00:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436816AbfJWWOQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 18:14:16 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:41410 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436772AbfJWWOO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 18:14:14 -0400
Received: by mail-pf1-f194.google.com with SMTP id q7so13771831pfh.8
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 15:14:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=xIIFUPrFPNKofMov1hM+Yvw1mv+r1cqTIXR7tkZiSBA=;
        b=nLhVlckZyROeKMiMdnl1Wparm8+1A26dkDmThigmOEK0l6riwwAw4kVO39gr6A+39V
         qmM7S+xMUnB1jLTKkOZgaCFdEXwKodVeoXlTV/ojxMPQsPuXkq8hvj7CWBQehuBol3Hm
         JENmRDlAw+6PuyFO/K8vtzKBZX3VJjQlFpd+J6LOvRvZf/JANc8F2IvkslBjGovus2sz
         YJyZvHgTl+hGEvh6NnkUIJE5+Bop1ExVzc34tri9tTfLYvxh7hzQLV3mTNFEpiuqhE8w
         BHzVJojKapORKUlMo5Su2J5uSXGxFPTHs/V0vfsRi8IvMsb6R+PuwTvM2CKTeOaou34X
         i7Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=xIIFUPrFPNKofMov1hM+Yvw1mv+r1cqTIXR7tkZiSBA=;
        b=HOyWwWBRG0qIy5wcd953VNcGFlAmE12k9QFM9NkRqGIyjuvU1YkLgXcSbsK5xZoBql
         CLEPKldOioTVG6u3dOF4r7nM7AjvAHoBetpZZJmlZY7bYSZ1dJxm6HLPcmtXE3RaUth7
         v+W3hEol+lP+O2raKEH5CIcpdtiwsWpTi++tidqRgzyT/fFWKTKoRFzpUACOW4HVtwpP
         oG+eS+QeJjtJZR9lFAzm6B2cEPxohyVrAs4d+L1iE+ZNlVO/QMWnL52tkF2HojhsyeZ/
         fRGmFRn415AAkdEIQQwIwgm1czmICoBDPRqoyBMXi/1AJIiPmBBM3xfTQF/oPHxILNUT
         Ge1A==
X-Gm-Message-State: APjAAAWk8YnaDnlVmJcqVthXGMRNx+wpQz7phWMPnpSDGdEvOi12IV0V
        EPnt4yrXRFaw2LVq2xTWc5MzcA==
X-Google-Smtp-Source: APXvYqxmF5gj4OEBRrGguwWpiCZSsYwHicVNZOX1IoOXb9zz+WREDrCwiw70iR6expd6N0aiK3ZU0g==
X-Received: by 2002:a63:dc45:: with SMTP id f5mr12678840pgj.250.1571868853134;
        Wed, 23 Oct 2019 15:14:13 -0700 (PDT)
Received: from cakuba.hsd1.ca.comcast.net (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id j26sm23006124pgl.38.2019.10.23.15.14.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 15:14:12 -0700 (PDT)
Date:   Wed, 23 Oct 2019 15:14:09 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Yuval Avnery <yuvalav@mellanox.com>, netdev@vger.kernel.org,
        jiri@mellanox.com, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, shuah@kernel.org
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191023151409.75676835@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20191023192512.GA2414@nanopsycho>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
        <20191023120046.0f53b744@cakuba.netronome.com>
        <20191023192512.GA2414@nanopsycho>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 23 Oct 2019 21:25:12 +0200, Jiri Pirko wrote:
> Wed, Oct 23, 2019 at 09:00:46PM CEST, jakub.kicinski@netronome.com wrote:
> >On Tue, 22 Oct 2019 20:43:01 +0300, Yuval Avnery wrote: =20
> >> This patchset introduces devlink vdev.
> >>=20
> >> Currently, legacy tools do not provide a comprehensive solution that c=
an
> >> be used in both SmartNic and non-SmartNic mode.
> >> Vdev represents a device that exists on the ASIC but is not necessarily
> >> visible to the kernel.
> >>=20
> >> Using devlink ports is not suitable because:
> >>=20
> >> 1. Those devices aren't necessarily network devices (such as NVMe devi=
ces)
> >>    and doesn=E2=80=99t have E-switch representation. Therefore, there =
is need for
> >>    more generic representation of PCI VF.
> >> 2. Some attributes are not necessarily pure port attributes
> >>    (number of MSIX vectors)
> >> 3. It creates a confusing devlink topology, with multiple port flavours
> >>    and indices.
> >>=20
> >> Vdev will be created along with flavour and attributes.
> >> Some network vdevs may be linked with a devlink port.
> >>=20
> >> This is also aimed to replace "ip link vf" commands as they are strong=
ly
> >> linked to the PCI topology and allow access only to enabled VFs.
> >> Even though current patchset and example is limited to MAC address
> >> of the VF, this interface will allow to manage PF, VF, mdev in
> >> SmartNic and non SmartNic modes, in unified way for networking and
> >> non-networking devices via devlink instance.
> >>=20
> >> Example:
> >>=20
> >> A privileged user wants to configure a VF's hw_addr, before the VF is
> >> enabled.
> >>=20
> >> $ devlink vdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66
> >>=20
> >> $ devlink vdev show pci/0000:03:00.0/1
> >> pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22=
:33:44:55:66
> >>=20
> >> $ devlink vdev show pci/0000:03:00.0/1 -jp
> >> {
> >>     "vdev": {
> >>         "pci/0000:03:00.0/1": {
> >>             "flavour": "pcivf",
> >>             "pf": 0,
> >>             "vf": 0,
> >>             "port_index": 1,
> >>             "hw_addr": "10:22:33:44:55:66"
> >>         }
> >>     }
> >> } =20
> >
> >I don't trust this is a good design.=20
> >
> >We need some proper ontology and decisions what goes where. We have
> >half of port attributes duplicated here, and hw_addr which honestly
> >makes more sense in a port (since port is more of a networking
> >construct, why would ep storage have a hw_addr?). Then you say you're
> >going to dump more PCI stuff in here :( =20
>=20
> Well basically what this "vdev" is is the "port peer" we discussed
> couple of months ago. It provides possibility for the user on bare metal
> to cofigure things for the VF - for example.
>=20
> Regarding hw_addr vs. port - it is not correct to make that a devlink
> port attribute. It is not port's hw_addr, but the port's peer hw_addr.

Yeah, I remember us arguing with others that "the other side of the
wire" should not be a port.

> >"vdev" sounds entirely meaningless, and has a high chance of becoming=20
> >a dumping ground for attributes. =20
>=20
> Sure, it is a madeup name. If you have a better name, please share.

IDK. I think I started the "peer" stuff, so it made sense to me.
Now it sounds like you'd like to kill a lot of problems with this=20
one stone. For PCIe "vdev" is def wrong because some of the config=20
will be for PF (which is not virtual). Also for PCIe the config has=20
to be done with permanence in mind from day 1, PCI often requires
HW reset to reconfig.

> Basically it is something that represents VF/mdev - the other side of
> devlink port. But in some cases, like NVMe, there is no associated
> devlink port - that is why "devlink port peer" would not work here.

What are the NVMe parameters we'd configure here? Queues etc. or some
IDs? Presumably there will be a NVMe-specific way to configure things?
Something has to point the NVMe VF to a backend, right?=20

(I haven't looked much into NVMe myself in case that's not obvious ;))
