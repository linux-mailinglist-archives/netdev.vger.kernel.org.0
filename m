Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8D95F7A5B
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 19:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKKSAJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 13:00:09 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37076 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbfKKSAJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 13:00:09 -0500
Received: by mail-pg1-f196.google.com with SMTP id z24so9912035pgu.4
        for <netdev@vger.kernel.org>; Mon, 11 Nov 2019 10:00:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/3KkrE46+/JPy7tyWVvZkTVNILFYb7qm0ljpC6RfCnI=;
        b=ONZZ/CFwrDeJBGz3yMNVxQmVFl5v3yLdRPfG8xFJvJGDhRfes9N+Em6aR/YBy+xHM1
         9/skAY0kYGSDCMCpL/GML54HQBz7sqbkpyEulIwQfVxbayquV5T9VO5AWHk25gCVW1uR
         UxsdyD+hF4lKPzJuG3ZPrC4KMJFEJoBmGB0XjuJlOrmNW1P65HPvBWuXKlBjSrRfdCle
         esukWdfww5lh4A+sHeXGcHh+NCXVSbNz3FwhLhRFdUCsOLj88GsjftXd1r+ynTG2DJMS
         3DxvCy55bL9ZHQiQCMmthA7taM8u6kHNiuPFqGIVq56jGDdkBL1tKQJ9qAvaTfFrowHu
         ixpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/3KkrE46+/JPy7tyWVvZkTVNILFYb7qm0ljpC6RfCnI=;
        b=A6+V3IK202xHWl4VTH8BqyLMmC16+puuUPsm0h+xHtdzs2kmUN7csJttKRKeblyouj
         eD7qVovnpIORZcrPwqm+4Uwr3iXZSkaQsFpKb7+4Q45xRG+GwnEeTzd9IlEXJSH+sIm0
         +ubRpvydmFKcUZXOwvn7rudU3dJd4/NiCN4s8hrIJrN7ghVYb5h8woZTqpFX4zJDDcUT
         +yG17iMgjUWZjv9o2VuX3JcLnwpvg3EfBdQHAlr9ZyTeeKaVnhBiVHNhjibIq36AN6KZ
         o78y0EMKsCShIQAwxEO73+9bTOej9PDKp8Ukk7cIt5B1gcTj7eWHirqIJcHxgTn3o0GI
         z6WA==
X-Gm-Message-State: APjAAAVgO02fFfv6DmCJCIMij2ak4JKigB7I5ZbCCztJEj8xrcNOZS5T
        OA1nrbpubkpbm7XjR2mFRKgy3g==
X-Google-Smtp-Source: APXvYqwV5Bvf4LgAkLLVjgqTxowt77pNViNBuBgEugF8A0z9MED+jKLq8zipUprV3D+cepKvSbcuzw==
X-Received: by 2002:a17:90a:bc41:: with SMTP id t1mr294921pjv.89.1573495208494;
        Mon, 11 Nov 2019 10:00:08 -0800 (PST)
Received: from cakuba (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d7sm15550257pfc.180.2019.11.11.10.00.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 10:00:08 -0800 (PST)
Date:   Mon, 11 Nov 2019 10:00:04 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>, jiri@mellanox.com
Cc:     netdev@vger.kernel.org, saeedm@mellanox.com, leon@kernel.org,
        davem@davemloft.net, shuah@kernel.org, danielj@mellanox.com,
        parav@mellanox.com, andrew.gospodarek@broadcom.com,
        michael.chan@broadcom.com
Subject: Re: [PATCH net-next v2 00/10] devlink subdev
Message-ID: <20191111100004.683b7320@cakuba>
In-Reply-To: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
References: <1573229926-30040-1-git-send-email-yuvalav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  8 Nov 2019 18:18:36 +0200, Yuval Avnery wrote:
> This patchset introduces devlink subdev.
>=20
> Currently, legacy tools do not provide a comprehensive solution that can
> be used in both SmartNic and non-SmartNic mode.
> Subdev represents a device that exists on the ASIC but is not necessarily
> visible to the kernel.
>=20
> Using devlink ports is not suitable because:
>=20
> 1. Those devices aren't necessarily network devices (such as NVMe devices)
>    and doesn=E2=80=99t have E-switch representation. Therefore, there is =
need for
>    more generic representation of PCI VF.
> 2. Some attributes are not necessarily pure port attributes
>    (number of MSIX vectors)

PCIe attrs will require persistence. Where is that in this design?

Also MSIX vectors are configuration of the devlink port (ASIC side), the
only reason you're putting them in subdev is because some of the subdevs
don't have a port, muddying up the meaning of things.

> 3. It creates a confusing devlink topology, with multiple port flavours
>    and indices.
>=20
> Subdev will be created along with flavour and attributes.
> Some network subdevs may be linked with a devlink port.
>=20
> This is also aimed to replace "ip link vf" commands as they are strongly
> linked to the PCI topology and allow access only to enabled VFs.
> Even though current patchset and example is limited to MAC address
> of the VF, this interface will allow to manage PF, VF, mdev in
> SmartNic and non SmartNic modes, in unified way for networking and
> non-networking devices via devlink instance.
>=20
> Use case example:
> An example system view of a networking ASIC (aka SmartNIC), can be seen in
> below diagram, where devlink eswitch instance and PCI PF and/or VFs are
> situated on two different CPU subsystems:
>=20
>=20
>       +------------------------------+
>       |                              |
>       |             HOST             |
>       |                              |
>       |   +----+-----+-----+-----+   |
>       |   | PF | VF0 | VF1 | VF2 |   |
>       +---+----+-----------+-----+---+
>                  PCI1|
>           +---+------------+
>               |
>      +----------------------------------------+
>      |        |         SmartNic              |
>      |   +----+-------------------------+     |
>      |   |                              |     |
>      |   |               NIC            |     |
>      |   |                              |     |
>      |   +---------------------+--------+     |
>      |                         |  PCI2        |
>      |         +-----+---------+--+           |
>      |               |                        |
>      |      +-----+--+--+--------------+      |
>      |      |     | PF  |              |      |
>      |      |     +-----+              |      |
>      |      |      Embedded CPU        |      |
>      |      |                          |      |
>      |      +--------------------------+      |
>      |                                        |
>      +----------------------------------------+
>=20
> The below diagram shows an example devlink subdev topology where some
> subdevs are connected to devlink ports::
>=20
>=20
>=20
>             (PF0)    (VF0)    (VF1)           (NVME VF2)
>          +--------------------------+         +--------+
>          | devlink| devlink| devlink|         | devlink|
>          | subdev | subdev | subdev |         | subdev |
>          |    0   |    1   |    2   |         |    3   |
>          +--------------------------+         +--------+
>               |        |        |

What is this NVME VF2 connected to? It's gotta get traffic from
somewhere? Frames come in from the uplink, then what?

>               |        |        |
>               |        |        |
>      +----------------------------------+
>      |   | devlink| devlink| devlink|   |
>      |   |  port  |  port  |  port  |   |
>      |   |    0   |    1   |    2   |   |
>      |   +--------------------------+   |
>      |                                  |
>      |                                  |
>      |           E-switch               |
>      |                                  |
>      |                                  |
>      |          +--------+              |
>      |          | uplink |              |
>      |          | devlink|              |
>      |          |  port  |              |
>      +----------------------------------+
> =20
> Devlink command example:
>=20
> A privileged user wants to configure a VF's hw_addr, before the VF is
> enabled.
>=20
> $ devlink subdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66
>=20
> $ devlink subdev show pci/0000:03:00.0/1
> pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22:33=
:44:55:66
>=20
> $ devlink subdev show pci/0000:03:00.0/1 -jp
> {
>     "subdev": {
>         "pci/0000:03:00.0/1": {
>             "flavour": "pcivf",

If the flavour is pcivf what differentiates this (Ethernet) VF from=20
a NVME one?

>             "pf": 0,
>             "vf": 0,
>             "port_index": 1,
>             "hw_addr": "10:22:33:44:55:66"

Since you're messing with the "hw_addr", you should at least provision
the uAPI for adding multiple addresses. Intel guys were asking for this
long time ago.

Have you considered implementing some compat code so drivers don't
have to implement the legacy ndos if they support subdevs?

>         }
>     }
> }

Okay, so you added two diagrams. I guess I was naive in thinking that
"you thought this all through in detail and have more documentation and
design docs internally".

I don't like how unconstrained this is, the only implemented use case is
weak. But since you're not seeing this you probably never will, so
seems like a waste of time to fight it.
