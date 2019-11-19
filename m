Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEEEA1021FB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 11:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbfKSKVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 05:21:38 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:46746 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbfKSKVi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 05:21:38 -0500
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20191119102135epoutp03729725fa0423b172f333b285141eb6dd~YiSzC7r6C1587915879epoutp036
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 10:21:35 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20191119102135epoutp03729725fa0423b172f333b285141eb6dd~YiSzC7r6C1587915879epoutp036
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1574158895;
        bh=uCgzGWyFzgjRsvAX5UZu+DD982M4BidQDfFHXZHUOjE=;
        h=From:To:Cc:Subject:Date:References:From;
        b=kGFiAlM3osOJKvttx53hBuqdOuWYQWlveN5JeTj7tNQFFTIjbXaqc5hilFBhOxNH9
         cnrKeqKX78VRzEaXK0G8AF8Gn4ZX5O1SYOcf3LcJBL9EvhhwzD5Yilu6iUU46hRkKX
         /KP8IL/LilPaBu3IC7GB2VtTlNuG7PvBt2IMkXas=
Received: from epsmges5p2new.samsung.com (unknown [182.195.42.74]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20191119102134epcas5p1ddd019c6add2a087b34c2f69e47ca858~YiSya8dj50680006800epcas5p12;
        Tue, 19 Nov 2019 10:21:34 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        7F.FF.04403.E22C3DD5; Tue, 19 Nov 2019 19:21:34 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5~YiSyCrGId1219312193epcas5p4W;
        Tue, 19 Nov 2019 10:21:34 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20191119102134epsmtrp132b131ec9761c632b733472a08efaf68~YiSyB4M--1898818988epsmtrp1y;
        Tue, 19 Nov 2019 10:21:34 +0000 (GMT)
X-AuditID: b6c32a4a-3cbff70000001133-ca-5dd3c22e6a2e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        89.55.03814.D22C3DD5; Tue, 19 Nov 2019 19:21:33 +0900 (KST)
Received: from ubuntu.sa.corp.samsungelectronics.net (unknown
        [107.108.83.125]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20191119102132epsmtip15691e0e546327ad2810a7f0d08744f05~YiSwoXjCE0108901089epsmtip1z;
        Tue, 19 Nov 2019 10:21:32 +0000 (GMT)
From:   Pankaj Sharma <pankj.sharma@samsung.com>
To:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     wg@grandegger.com, mkl@pengutronix.de, davem@davemloft.net,
        dmurphy@ti.com, rcsekar@samsung.com, pankaj.dubey@samsung.com,
        Pankaj Sharma <pankj.sharma@samsung.com>
Subject: [PATCH 0/2] can: m_can_platform: Bug fix of kernel panic for
Date:   Tue, 19 Nov 2019 15:50:36 +0530
Message-Id: <1574158838-4616-1-git-send-email-pankj.sharma@samsung.com>
X-Mailer: git-send-email 2.7.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrJIsWRmVeSWpSXmKPExsWy7bCmlq7eocuxBlPaJS3mnG9hseg+vYXV
        YtX3qcwWl3fNYbNYv2gKi8WxBWIWi7Z+YbdY3nWf2WLWhR2sFkvv7WR14PLYsvImk8fHS7cZ
        Pfr/Gnj0bVnF6HH8xnYmj8+b5ALYorhsUlJzMstSi/TtErgydkwyLOgUrJi47QRbA+Mf3i5G
        Tg4JAROJ148OsncxcnEICexmlDi19BkzhPOJUeLet18sIFVCAt8YJZZvZoPpuDK/FapjL6PE
        mpPfoTpamCS+v1vODlLFJqAncen9ZLAOEYFQiWW9E1hBipgFVjNK3JnxkhkkISzgKvH3ezdY
        EYuAqsTkMxPB4rwC7hLvN55ih1gnJ3HzXCfYBgmBJWwSu69eZoZIuEgcub+FEcIWlnh1fAtU
        g5TEy/42KDtbYuHufqAfOIDsCom2GcIQYXuJA1fmgIWZBTQl1u/SBwkzC/BJ9P5+wgRRzSvR
        0SYEUa0mMfXpO6hFMhJ3HsECwkNi8oID0ACKlXj7agrTBEaZWQhDFzAyrmKUTC0ozk1PLTYt
        MMpLLdcrTswtLs1L10vOz93ECE4AWl47GJed8znEKMDBqMTDe0LlcqwQa2JZcWXuIUYJDmYl
        EV6/RxdihXhTEiurUovy44tKc1KLDzFKc7AoifNOYr0aIySQnliSmp2aWpBaBJNl4uCUamCc
        Hs01acEC/bulOel9T5Xvac4SeHs9+HOw1oRSVveNKyXEP1pYfHC8sFXv0dkfKh15H+fF7dc0
        W1V5Lm3//3t7dv97sbIxS8q0PHIGx4r6lVub3YRe53I3XM5fvixccsILMaOiJV35jev8hXef
        /zybN/3aEoPuIwIakx9PZuzovrlW37h1/QpfJZbijERDLeai4kQADge38PwCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLLMWRmVeSWpSXmKPExsWy7bCSnK7uocuxBm/WW1nMOd/CYtF9egur
        xarvU5ktLu+aw2axftEUFotjC8QsFm39wm6xvOs+s8WsCztYLZbe28nqwOWxZeVNJo+Pl24z
        evT/NfDo27KK0eP4je1MHp83yQWwRXHZpKTmZJalFunbJXBl7JhkWNApWDFx2wm2BsY/vF2M
        nBwSAiYSV+a3sncxcnEICexmlLj/8wpbFyMHUEJGYvHnaogaYYmV/55D1TQxSUz4v5sNJMEm
        oCdx6f1kMFtEIFxi54QuJpAiZoHNjBLXu2eygiSEBVwl/n7vBitiEVCVmHxmIjOIzSvgLvF+
        4yl2iA1yEjfPdTJPYORZwMiwilEytaA4Nz232LDAKC+1XK84Mbe4NC9dLzk/dxMjONC0tHYw
        njgRf4hRgINRiYf3hMrlWCHWxLLiytxDjBIczEoivH6PLsQK8aYkVlalFuXHF5XmpBYfYpTm
        YFES55XPPxYpJJCeWJKanZpakFoEk2Xi4JRqYAyuEns4/2BVF2vSNm6XK68PytnsKPgh+2RP
        wx2bCXse2O+18Oas3XiH83hIQ4l77KcE+22Pw2Wmbg++dfL76XRnJaUfk89f+3bzWabH1i1z
        Z76RSbrGINSsd2PjGbMDheaXJa69VGk95yJRanUrkOXJnKU9Lt0TJhzc9GzJ8c3mSsyFE90P
        25sqsRRnJBpqMRcVJwIAw12JMTACAAA=
X-CMS-MailID: 20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5
References: <CGME20191119102134epcas5p4d3c1b18203e2001c189b9fa7a0e3aab5@epcas5p4.samsung.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The current code is failing while clock prepare enable because of not
getting proper clock from platform device. 

[    0.852089] Call trace:
[    0.854516]  0xffff0000fa22a668
[    0.857638]  clk_prepare+0x20/0x34
[    0.861019]  m_can_runtime_resume+0x2c/0xe4
[    0.865180]  pm_generic_runtime_resume+0x28/0x38
[    0.869770]  __rpm_callback+0x16c/0x1bc
[    0.873583]  rpm_callback+0x24/0x78
[    0.877050]  rpm_resume+0x428/0x560
[    0.880517]  __pm_runtime_resume+0x7c/0xa8
[    0.884593]  m_can_clk_start.isra.9.part.10+0x1c/0xa8
[    0.889618]  m_can_class_register+0x138/0x370
[    0.893950]  m_can_plat_probe+0x120/0x170
[    0.897939]  platform_drv_probe+0x4c/0xa0
[    0.901924]  really_probe+0xd8/0x31c
[    0.905477]  driver_probe_device+0x58/0xe8
[    0.909551]  device_driver_attach+0x68/0x70
[    0.913711]  __driver_attach+0x9c/0xf8
[    0.917437]  bus_for_each_dev+0x50/0xa0
[    0.921251]  driver_attach+0x20/0x28
[    0.924804]  bus_add_driver+0x148/0x1fc
[    0.928617]  driver_register+0x6c/0x124
[    0.932431]  __platform_driver_register+0x48/0x50
[    0.937113]  m_can_plat_driver_init+0x18/0x20
[    0.941446]  do_one_initcall+0x4c/0x19c
[    0.945259]  kernel_init_freeable+0x1d0/0x280
[    0.949591]  kernel_init+0x10/0x100
[    0.953057]  ret_from_fork+0x10/0x18
[    0.956614] Code: 00000000 00000000 00000000 00000000 (fa22a668) 
[    0.962681] ---[ end trace 881f71bd609de763 ]---
[    0.967301] Kernel panic - not syncing: Attempted to kill init! exitcode=0x0000000b

A device driver for CAN controller hardware registers itself with the
Linux network layer as a network device. So, the driver data for m_can
should ideally be of type net_device. 

Further even when passing the proper net device in probe function the
code was hanging because of the function m_can_runtime_resume() getting
recursively called from m_can_class_resume().

Pankaj Sharma (2):
  can: m_can_platform: set net_device structure as driver data
  can: m_can_platform: remove unnecessary m_can_class_resume() call

 drivers/net/can/m_can/m_can_platform.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
2.7.4

