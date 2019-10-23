Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E79BFE2302
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 21:00:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404900AbfJWTAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 15:00:51 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:33893 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403979AbfJWTAv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 15:00:51 -0400
Received: by mail-pg1-f195.google.com with SMTP id k20so12693789pgi.1
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 12:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=d5cJz79Gw0krZSBZCUh4KtCx0Qu/r41KYEQB53X44fI=;
        b=iaQzn1N5lYWZS7frcbg2wyBLjQrqFca5jcoSqfj0aT9efBgFnbcGSTM7b218mW5FVm
         6eq/nQPMlbHRbpym0ZCy/pkn5rHOxzkLTYdPR5Qe0CawH7cMbQc+AJx6YZzkYQ9Y5Jil
         2RbKI8GuMxm5hQePnXBXBWvfcQ2rcVIKWsXn3Yy9ADewWT2llkF/57IlBFONpa0fKLLd
         uWq8q18H4D1tn/elzKD1choFfmVcM3QUWPqQ1L7FPF7Y1jxIe355yFPDbTWb1D2HHeqg
         jtN0P2RTNrdhatz1RiflVBiPn+JUh6egjTtOwA+GrBiZYVS8KlSd13yo7nhqOrKzJoAZ
         hNmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=d5cJz79Gw0krZSBZCUh4KtCx0Qu/r41KYEQB53X44fI=;
        b=lRpeJbNxmkgCEhLEsqnsKsZnvVu5Xb50V9Endrxz7Y8tlZFFHc672XXOG83XHkPI9Y
         A2EkJYi+NUPHqweDrofL1pcJSgWKsCDoqRmyGaXBvwgfJ0Kwqcd0IE2RwJ2IdyeIPzqP
         EjR8NjEWDSJWr6at3147aDNKNDi7YRgRkGmNdCHJiUhxHyBkBy4NS92iQmD7XOq+yU/k
         L7AxfgyUBHpqTL4GAAeRTBEvERc1I2Oy5TC88d0SbaVgSLxFkO1oxSjLDqmZuZiRze1Q
         3PwcuxbkrfbDmVONIE3Q+Ys+t9NtfXYvr9pB/fESgq3Ets328U0Rhg2Rt+UFPvFBJ3Ok
         BozA==
X-Gm-Message-State: APjAAAXmxbCZclO8pFMS2C4QLWw8yZDbj0+VRpXr8dKZiEGHvGhjURAw
        zTZpwn7ooxNlCBJwNbqMNie8SstblJk=
X-Google-Smtp-Source: APXvYqy2uMzUtp+ktIexM/jf+ltBd4FwUflcgN7FRHiWI+Buu2GMlPSKN3WN1Up9VT0/xUKhFwdZcw==
X-Received: by 2002:a62:b616:: with SMTP id j22mr12117004pff.201.1571857250654;
        Wed, 23 Oct 2019 12:00:50 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id t125sm28084014pfc.80.2019.10.23.12.00.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Oct 2019 12:00:50 -0700 (PDT)
Date:   Wed, 23 Oct 2019 12:00:46 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org, davem@davemloft.net, shuah@kernel.org
Subject: Re: [PATCH net-next 0/9] devlink vdev
Message-ID: <20191023120046.0f53b744@cakuba.netronome.com>
In-Reply-To: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
References: <1571766190-23943-1-git-send-email-yuvalav@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Oct 2019 20:43:01 +0300, Yuval Avnery wrote:
> This patchset introduces devlink vdev.
>=20
> Currently, legacy tools do not provide a comprehensive solution that can
> be used in both SmartNic and non-SmartNic mode.
> Vdev represents a device that exists on the ASIC but is not necessarily
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
> 3. It creates a confusing devlink topology, with multiple port flavours
>    and indices.
>=20
> Vdev will be created along with flavour and attributes.
> Some network vdevs may be linked with a devlink port.
>=20
> This is also aimed to replace "ip link vf" commands as they are strongly
> linked to the PCI topology and allow access only to enabled VFs.
> Even though current patchset and example is limited to MAC address
> of the VF, this interface will allow to manage PF, VF, mdev in
> SmartNic and non SmartNic modes, in unified way for networking and
> non-networking devices via devlink instance.
>=20
> Example:
>=20
> A privileged user wants to configure a VF's hw_addr, before the VF is
> enabled.
>=20
> $ devlink vdev set pci/0000:03:00.0/1 hw_addr 10:22:33:44:55:66
>=20
> $ devlink vdev show pci/0000:03:00.0/1
> pci/0000:03:00.0/1: flavour pcivf pf 0 vf 0 port_index 1 hw_addr 10:22:33=
:44:55:66
>=20
> $ devlink vdev show pci/0000:03:00.0/1 -jp
> {
>     "vdev": {
>         "pci/0000:03:00.0/1": {
>             "flavour": "pcivf",
>             "pf": 0,
>             "vf": 0,
>             "port_index": 1,
>             "hw_addr": "10:22:33:44:55:66"
>         }
>     }
> }

I don't trust this is a good design.=20

We need some proper ontology and decisions what goes where. We have
half of port attributes duplicated here, and hw_addr which honestly
makes more sense in a port (since port is more of a networking
construct, why would ep storage have a hw_addr?). Then you say you're
going to dump more PCI stuff in here :(

"vdev" sounds entirely meaningless, and has a high chance of becoming=20
a dumping ground for attributes.

I'm kind of sour about the debug interfaces that were added to devlink.
Seems like the health API superseded the region stuff to a certain
extent and the two don't interact with each other.

I'm slightly worried there is too much "learning by doing" going on
with these new devlink uABIs.

I'm sure you guys thought this all through in detail and have more
documentation and design docs internally. Could you provide more of
this information here? How things fit together? Bigger picture?

The 20 lines of cover letters and no Documentation/ is definitely not
going to cut it this time.
