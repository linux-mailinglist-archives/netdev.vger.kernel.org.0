Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEB35618D5A
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 01:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiKDA70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Nov 2022 20:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229634AbiKDA7Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Nov 2022 20:59:25 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C56DA62D7
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 17:59:23 -0700 (PDT)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221104005919epoutp023a84013146bbe83a141cc3837fceea32~kO9edu8Qa3069230692epoutp02Y
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 00:59:19 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221104005919epoutp023a84013146bbe83a141cc3837fceea32~kO9edu8Qa3069230692epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667523559;
        bh=VA2j6JFdcbgNkArZv+VB/jK2mp0CN7fHg/StXtrg1J8=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=OMMw5IhcriQbYjVMiftLjZuV/hJg/8lw0FS9e1QOBa+Yrg/iAjgJOlKzLksIeSVMq
         r2/j8bxIUBTkBUORaxszpdnlBUjVedquI4ZXlqWGoI3jUZxRauWYTL2igXwI3Scpt3
         ze7WdsufZi5BZvUHMRQLHrJ7vIbREad9RTY+N7l8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTP id
        20221104005918epcas2p115bcdd1035d372e491a79af4fbd2df36~kO9d_E8vK1007910079epcas2p1B;
        Fri,  4 Nov 2022 00:59:18 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.36.100]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4N3Mhk1FDVz4x9Q6; Fri,  4 Nov
        2022 00:59:18 +0000 (GMT)
X-AuditID: b6c32a47-ac5b870000002127-56-636463e5f7c5
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        8D.92.08487.5E364636; Fri,  4 Nov 2022 09:59:18 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH net-next v2] nfc: Allow to create multiple virtual nci
 devices
Reply-To: bongsu.jeon@samsung.com
Sender: Bongsu Jeon <bongsu.jeon@samsung.com>
From:   Bongsu Jeon <bongsu.jeon@samsung.com>
To:     Dmitry Vyukov <dvyukov@google.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Bongsu Jeon <bongsu.jeon@samsung.com>,
        "krzysztof.kozlowski@linaro.org" <krzysztof.kozlowski@linaro.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "syzkaller@googlegroups.com" <syzkaller@googlegroups.com>
X-Priority: 3
X-Content-Kind-Code: NORMAL
In-Reply-To: <20221103181836.766399-1-dvyukov@google.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221104005917epcms2p228981fa87d326a8d4f503911f3472703@epcms2p2>
Date:   Fri, 04 Nov 2022 09:59:17 +0900
X-CMS-MailID: 20221104005917epcms2p228981fa87d326a8d4f503911f3472703
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpik+LIzCtJLcpLzFFi42LZdljTVPdZckqywdl/rBZbmiexW0x42MZu
        sff1VnaLKb+WMlscWyBmceRNN7MDm8eCTaUeeyaeZPPYtKqTzePOtT1sHn1bVjF6fN4kF8AW
        lW2TkZqYklqkkJqXnJ+SmZduq+QdHO8cb2pmYKhraGlhrqSQl5ibaqvk4hOg65aZA3SEkkJZ
        Yk4pUCggsbhYSd/Opii/tCRVISO/uMRWKbUgJafAvECvODG3uDQvXS8vtcTK0MDAyBSoMCE7
        4/redewFM8QqXq3bzdrAuEuoi5GTQ0LARGLOzaOsXYxcHEICOxglHqxoZOti5ODgFRCU+LtD
        GMQUFgiRaJubAVIuJKAo8b/jHBuILSygK/Hi71Ewm01AW2Lt0UYmkDEiAu8YJS4ffcECkmAW
        sJV4+HsDE8QuXokZ7U9ZIGxpie3LtzKCzOcUsJRouucAEdaQ+LGslxnCFpW4ufotO4z9/th8
        RghbRKL13lmoGkGJBz93Q8WlJD49PMMKYedLvNzVwQZhl0g8PrMIqt5cYs+bXWBxXgFfiRM3
        f4GdwyKgKjGz7xnULheJhm8nGCHOl5fY/nYOM8iZzAKaEut36YOYEgLKEkduQT3IJ9Fx+C87
        zIM75j2BelZVorf5CxPMs5Nnt0Bd6SEx/9MRxgmMirMQwTwLya5ZCLsWMDKvYhRLLSjOTU8t
        Niowhsdscn7uJkZwYtRy38E44+0HvUOMTByMhxglOJiVRHg/bUtOFuJNSaysSi3Kjy8qzUkt
        PsRoCvTlRGYp0eR8YGrOK4k3NLE0MDEzMzQ3MjUwVxLn7ZqhlSwkkJ5YkpqdmlqQWgTTx8TB
        KdXAlMO05IB3cuurr/OYq6cVTHncnZ6rcjlaxtBJcenJF47q+z/G65i5Fa1dn1UsLPlJyOO1
        lkj5CvNvMxf3c+zs3Lprg878V6x6iVd+f1nL+L5J1/PMI5U7S9Jb/5wWuCo1/6/fsq1/VziZ
        bWd/dmH2BnOB+xax6T/WuIv3BqomHV/oVdJRxHm9V+2DS7VjVPjrW9pndFKDZh+JXzDPr/S5
        eGHWzZkRC91mGMreu9l6XKZChunTV4ZZ79dG+odsPv3gWXF2zYfM6co7nv0NkA6Sy0s+vz40
        JNv/fVnlqYNH25Z4t4crW2wy0TrwLNFR6iK3rShTXUbJj5m1jQ38D+4VG7eaMH4QvvP9wLpo
        /+/PlFiKMxINtZiLihMB9WfhKhUEAAA=
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221103181845epcas2p2d3e49699d634440046fc8a9deb9785be
References: <20221103181836.766399-1-dvyukov@google.com>
        <CGME20221103181845epcas2p2d3e49699d634440046fc8a9deb9785be@epcms2p2>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Fri, Nov 4, 2022 at 3:19 AM Dmitry Vyukov<dvyukov@google.com> wrote:
>
>The current virtual nci driver is great for testing and fuzzing.
>But it allows to create at most one "global" device which does not allow
>to run parallel tests and harms fuzzing isolation and reproducibility.
>Restructure the driver to allow creation of multiple independent devices.
>This should be backwards compatible for existing tests.
>
>Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
>Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
>Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
>Cc: netdev@vger.kernel.org
>
>---
>Changes in v2:
> - check return value of skb_clone()
> - rebase onto currnet net-next
>---
> drivers/nfc/virtual_ncidev.c | 146 +++++++++++++++++------------------
> 1 file changed, 70 insertions(+), 76 deletions(-)
>
>diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
>index 85c06dbb2c449..48d6d09e2f6fd 100644
>--- a/drivers/nfc/virtual_ncidev.c
>+++ b/drivers/nfc/virtual_ncidev.c
>@@ -13,12 +13,6 @@

<...>

> static int virtual_ncidev_open(struct inode *inode, struct file *file)
> {
> 	int ret = 0;
>+	struct virtual_nci_dev *vdev;
> 
>-	mutex_lock(&nci_mutex);
>-	if (state != virtual_ncidev_disabled) {
>-		mutex_unlock(&nci_mutex);
>-		return -EBUSY;
>-	}
>-
>-	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
>-				   0, 0);
>-	if (!ndev) {
>-		mutex_unlock(&nci_mutex);
>+	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
>+	if (!vdev)
>+		return -ENOMEM;
>+	vdev->ndev = nci_allocate_device(&virtual_nci_ops,
>+		VIRTUAL_NFC_PROTOCOLS, 0, 0);
>+	if (!vdev->ndev) {
>+		kfree(vdev);
> 		return -ENOMEM;
> 	}
> 
>-	ret = nci_register_device(ndev);
>+	mutex_init(&vdev->mtx);
>+	init_waitqueue_head(&vdev->wq);
>+	file->private_data = vdev;
>+	nci_set_drvdata(vdev->ndev, vdev);
>+
>+	ret = nci_register_device(vdev->ndev);
> 	if (ret < 0) {
>-		nci_free_device(ndev);
>-		mutex_unlock(&nci_mutex);
>+		mutex_destroy(&vdev->mtx);
>+		nci_free_device(vdev->ndev);
>+		kfree(vdev);
> 		return ret;
> 	}
>-	state = virtual_ncidev_enabled;
>-	mutex_unlock(&nci_mutex);
> 
> 	return 0;
> }
> 
> static int virtual_ncidev_close(struct inode *inode, struct file *file)
> {
>-	mutex_lock(&nci_mutex);
>-
>-	if (state == virtual_ncidev_enabled) {
>-		state = virtual_ncidev_disabling;
>-		mutex_unlock(&nci_mutex);
>+	struct virtual_nci_dev *vdev = file->private_data;
> 
>-		nci_unregister_device(ndev);
>-		nci_free_device(ndev);
>-
>-		mutex_lock(&nci_mutex);
>-	}
>-
>-	state = virtual_ncidev_disabled;
>-	mutex_unlock(&nci_mutex);
>+	nci_unregister_device(vdev->ndev);
>+	nci_free_device(vdev->ndev);
>+	mutex_destroy(&vdev->mtx);

    Isn't kfree(vdev) necessary?

> 
> 	return 0;
> }
>
