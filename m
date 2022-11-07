Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA3861E8AB
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 03:46:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKGCqN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Nov 2022 21:46:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbiKGCqM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Nov 2022 21:46:12 -0500
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A8B654B
        for <netdev@vger.kernel.org>; Sun,  6 Nov 2022 18:46:09 -0800 (PST)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20221107024605epoutp04398f70027631935e779a2ab410a9431f~lLWj-DKTu3113931139epoutp04I
        for <netdev@vger.kernel.org>; Mon,  7 Nov 2022 02:46:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20221107024605epoutp04398f70027631935e779a2ab410a9431f~lLWj-DKTu3113931139epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667789166;
        bh=H7WV2pqBSsRHzfPWmTTDOSWsxrpjUZuYeWyJ/2fPXtw=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=S0Yg87+0hXrTEJvE9LgxkeT8DsvFrMNirH6G4Bv4y7/Pboh5PIx2qmXwdbcWDpTzR
         XDS+XMTaCxfjR/PkGunNS8OXHEk7PcEFM3thZoCBw1wsaSzQs6JEaSTY0qLbRvoa6D
         a7pCdc6abgLynysf6PdCVW7NNRh8joMn/kAEPaoo=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20221107024605epcas2p2d7d9fb625e60dd175764a2124fd1d2a3~lLWjuqI6a2374023740epcas2p2E;
        Mon,  7 Nov 2022 02:46:05 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.36.89]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4N5FwY1JtLz4x9Q9; Mon,  7 Nov
        2022 02:46:05 +0000 (GMT)
X-AuditID: b6c32a45-643fb7000001f07d-2a-6368716c7756
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        B5.5D.61565.C6178636; Mon,  7 Nov 2022 11:46:04 +0900 (KST)
Mime-Version: 1.0
Subject: RE: [PATCH net-next v3] nfc: Allow to create multiple virtual nci
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
In-Reply-To: <20221104170422.979558-1-dvyukov@google.com>
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20221107024604epcms2p174f8813f4e18607b93813021f5b048b0@epcms2p1>
Date:   Mon, 07 Nov 2022 11:46:04 +0900
X-CMS-MailID: 20221107024604epcms2p174f8813f4e18607b93813021f5b048b0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpmk+LIzCtJLcpLzFFi42LZdljTXDe3MCPZYM5FdostzZPYLSY8bGO3
        2Pt6K7vFlF9LmS2OLRCzOPKmm9mBzWPBplKPPRNPsnlsWtXJ5nHn2h42j74tqxg9Pm+SC2CL
        yrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpCSaEs
        MacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgXqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd
        cWDqMdaCA6IVb3ZPY2pgPC7YxcjBISFgIrHtulkXIxeHkMAORomLHT0sIHFeAUGJvzuEuxg5
        OYQFQiT27H/JBGILCShK/O84xwYR15V48fcomM0moC2x9mgjE8gcEYF3jBKXj75gAUkwC9hK
        PPy9AaxZQoBXYkb7UxYIW1pi+/KtjCA2p4ClxI8Fv1gh4hoSP5b1MkPYohI3V79lh7HfH5vP
        CGGLSLTeOwtVIyjx4OduqLiUxKeHZ6Dm5Eu83NXBBmGXSDw+swiq3lxiz5tdYHFeAV+JzXNW
        gd3GIqAq0Xp1G9QcF4n1c9dC3S8vsf3tHGZQmDALaEqs36UPCTZliSO3oCr4JDoO/2WH+XDH
        vCdQ36pK9DZ/YYL5dvLsFqjpHhK3l/1nncCoOAsR0LOQ7JqFsGsBI/MqRrHUguLc9NRiowJD
        eNQm5+duYgSnRi3XHYyT337QO8TIxMF4iFGCg1lJhPeGW1qyEG9KYmVValF+fFFpTmrxIUZT
        oC8nMkuJJucDk3NeSbyhiaWBiZmZobmRqYG5kjhv1wytZCGB9MSS1OzU1ILUIpg+Jg5OqQam
        aJvgjUHJrLysZ5L2Lvc9/yNZQVZi0a141b0HH1YrnUuasLvyXLZTyq4HufYiUV+1jtatcNm7
        7C9nSy9z6zSL6EZm2cSNJ/XnXvK/vf1Idt6Uty+yZulNVNJJSd056UVFmeH/z6I786PLS+Zb
        yKRPsms+/O63jM75/4rTuG4FnHb+nHelu9HWmO/D0cb6BVErarfca45PE765ct5HB+OFxudn
        qc4KySvqmJNqP+9Pw3HzVb+X7+w6yt61beqqXRE3Vn1svRwdqaV15dxBuacn/tw/JfmONaFP
        WtMxRY2LbVptxc2FIvJfmmMfiy9T/vaS7bDZHQEG89VP9ASn3fz5+Qjv29m1GSdZiha58HVM
        UmIpzkg01GIuKk4EADflOyMWBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <20221104170422.979558-1-dvyukov@google.com>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p1>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 5, 2022 at 2:04 AM Dmitry Vyukov<dvyukov@google.com> wrote:
> The current virtual nci driver is great for testing and fuzzing.
> But it allows to create at most one "global" device which does not allow
> to run parallel tests and harms fuzzing isolation and reproducibility.
> Restructure the driver to allow creation of multiple independent devices.
> This should be backwards compatible for existing tests.

I totally agree with you for parallel tests and good design.
Thanks for good idea.
But please check the abnormal situation.
for example virtual device app is closed(virtual_ncidev_close) first and then
virtual nci driver from nci app tries to call virtual_nci_send or virtual_nci_close.
(there would be problem in virtual_nci_send because of already destroyed mutex)
Before this patch, this driver used virtual_ncidev_mode state and nci_mutex that isn't destroyed.

> 
> Signed-off-by: Dmitry Vyukov <dvyukov@google.com>
> Cc: Bongsu Jeon <bongsu.jeon@samsung.com>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Cc: netdev@vger.kernel.org
> 
> ---
> Changes in v3:
>  - free vdev in virtual_ncidev_close()
> 
> Changes in v2:
>  - check return value of skb_clone()
>  - rebase onto currnet net-next
> ---
>  drivers/nfc/virtual_ncidev.c | 147 +++++++++++++++++------------------
>  1 file changed, 71 insertions(+), 76 deletions(-)
> 
> diff --git a/drivers/nfc/virtual_ncidev.c b/drivers/nfc/virtual_ncidev.c
> index 85c06dbb2c449..bb76c7c7cc822 100644
> --- a/drivers/nfc/virtual_ncidev.c
> +++ b/drivers/nfc/virtual_ncidev.c
> @@ -13,12 +13,6 @@
>  
>  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  {
> -	mutex_lock(&nci_mutex);
> -	if (state != virtual_ncidev_enabled) {
> -		mutex_unlock(&nci_mutex);
> +	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> +
> +	mutex_lock(&vdev->mtx);
  
  I think this vdev and vdev->mtx are already destroyed so that it would be problem.

> +	if (vdev->send_buff) {
> +		mutex_unlock(&vdev->mtx);
>  		kfree_skb(skb);
> -		return 0;
> +		return -1;
>  	}
> 
> 	
>  static int virtual_ncidev_close(struct inode *inode, struct file *file)
>  {
> -	mutex_lock(&nci_mutex);
> -
> -	if (state == virtual_ncidev_enabled) {
> -		state = virtual_ncidev_disabling;
> -		mutex_unlock(&nci_mutex);
> +	struct virtual_nci_dev *vdev = file->private_data;
>  
> -		nci_unregister_device(ndev);
> -		nci_free_device(ndev);
> -
> -		mutex_lock(&nci_mutex);
> -	}
> -
> -	state = virtual_ncidev_disabled;
> -	mutex_unlock(&nci_mutex);
> +	nci_unregister_device(vdev->ndev);
> +	nci_free_device(vdev->ndev);
> +	mutex_destroy(&vdev->mtx);
> +	kfree(vdev);
>  
>  	return 0;
>  }
