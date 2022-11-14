Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0406627A70
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:27:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236165AbiKNK1h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:27:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiKNK1g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:27:36 -0500
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64ED1D33C
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 02:27:33 -0800 (PST)
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20221114102731epoutp01f571659634afc1c79c41c733f2e694eb~nbKb5ZKkK2580925809epoutp01P
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 10:27:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20221114102731epoutp01f571659634afc1c79c41c733f2e694eb~nbKb5ZKkK2580925809epoutp01P
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1668421651;
        bh=YNOjWjePYjVaOYZo546F8C3E2bKkRbQTyEizlU6ciYs=;
        h=Subject:Reply-To:From:To:CC:In-Reply-To:Date:References:From;
        b=j9QWY8yO3UtTZCCIcP7MBjj37cNqzmOdORGoNzrfDdDpUY31st4HD3+hHj8qqtGPl
         WCAZMuty9VXcq/fU6RO5jeSnAHaalUnDXI/E860mGP7t3Jwrw2PdDtGvC+ftzJBj0p
         osj5ntPFYj3ClaQaH4iamOTj7X6yrmr0kSfZsfs8=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20221114102730epcas2p25bdc61f6b2bfa8aded0630c37129fd9b~nbKbSFw3-2764927649epcas2p2U;
        Mon, 14 Nov 2022 10:27:30 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.97]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4N9lqk1c9kz4x9Px; Mon, 14 Nov
        2022 10:27:30 +0000 (GMT)
X-AuditID: b6c32a48-8a7fa7000001494a-ea-63721812e0e2
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        63.BB.18762.21812736; Mon, 14 Nov 2022 19:27:30 +0900 (KST)
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
Message-ID: <20221114102729epcms2p75b469f77cdd41abab4148ffd438e8bd6@epcms2p7>
Date:   Mon, 14 Nov 2022 19:27:29 +0900
X-CMS-MailID: 20221114102729epcms2p75b469f77cdd41abab4148ffd438e8bd6
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphk+LIzCtJLcpLzFFi42LZdljTVFdIoijZYOVzdostzZPYLSY8bGO3
        2Pt6K7vFlF9LmS2OLRCzOPKmm9mBzWPBplKPPRNPsnlsWtXJ5nHn2h42j74tqxg9Pm+SC2CL
        yrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvMATpCSaEs
        MacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgXqBXnJhbXJqXrpeXWmJlaGBgZApUmJCd
        8XHKafaCJ/YVdz5tYGxg7DTuYuTkkBAwkbjw7B1zFyMXh5DADkaJrR+uAzkcHLwCghJ/dwiD
        1AgLhEjs2f+SCcQWElCU+N9xjg0irivx4u9RMJtNQFti7dFGJpA5IgLvGCUuH33BApJgFrCV
        ePh7AxPEMl6JGe1PWSBsaYnty7cygticApYSPxb8YoWIa0j8WNbLDGGLStxc/ZYdxn5/bD4j
        hC0i0XrvLFSNoMSDn7uh4lISnx6egZqTL/FyVwcbhF0i8fjMIqh6c4k9b3aBxXkFfCX23r4N
        ZrMIqEpM2HAUqsZF4v6/O0wQ98tLbH87BxwmzAKaEut36YOYEgLKEkduQX3IJ9Fx+C87zIc7
        5j2B+lZVorf5CxPMt5Nnt0Bd6SFxe9l/1gmMirMQAT0Lya5ZCLsWMDKvYhRLLSjOTU8tNiow
        gcdtcn7uJkZwctTy2ME4++0HvUOMTByMhxglOJiVRHjnyeQnC/GmJFZWpRblxxeV5qQWH2I0
        BfpyIrOUaHI+MD3nlcQbmlgamJiZGZobmRqYK4nzds3QShYSSE8sSc1OTS1ILYLpY+LglGpg
        2qeVn/VrTmeMZNvd2OUTAk1TDn8uO9TA4Z2xUH7mgrUZ+RaaQlPLQkKvPPz585B+WfaMrqZP
        mVME3izUaN4cYbj18FtPgaMrnqx9vu7sasf17N8vMDxs4T89R73p+/Lnkz96xypd4bZ/Mcnh
        aOwFvzeB1898Psh55vhbPzlGTUt3vUixTTxPmOaZ6zO3chsfPviO0fLTZ9YEIY+3n0J07G4f
        9WfNfVAdp3T7hvet5QVWH2N2ej9LqxDX4T/d5GQWxf3oS8DVfk//wwaXFmqwp++2OhKkOqX+
        4o/Tn/R/zHP10FoXIdRzJ2ff3ie2OUn39lt3NFp+at2yOfr35L5ZV2s7f9l0/rG56zhZW9ft
        qRJLcUaioRZzUXEiAOTBgLgXBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d
References: <20221104170422.979558-1-dvyukov@google.com>
        <CGME20221104170430epcas2p1d854f31557e623e8fd9d16f6c162d90d@epcms2p7>
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
>  #include <linux/wait.h>
>  #include <net/nfc/nci_core.h>
>  
> -enum virtual_ncidev_mode {
> -	virtual_ncidev_enabled,
> -	virtual_ncidev_disabled,
> -	virtual_ncidev_disabling,
> -};
> -
>  #define IOCTL_GET_NCIDEV_IDX    0
>  #define VIRTUAL_NFC_PROTOCOLS	(NFC_PROTO_JEWEL_MASK | \
>  				 NFC_PROTO_MIFARE_MASK | \
> @@ -27,12 +21,12 @@ enum virtual_ncidev_mode {
>  				 NFC_PROTO_ISO14443_B_MASK | \
>  				 NFC_PROTO_ISO15693_MASK)
>  
> -static enum virtual_ncidev_mode state;
> -static DECLARE_WAIT_QUEUE_HEAD(wq);
> -static struct miscdevice miscdev;
> -static struct sk_buff *send_buff;
> -static struct nci_dev *ndev;
> -static DEFINE_MUTEX(nci_mutex);
> +struct virtual_nci_dev {
> +	struct nci_dev *ndev;
> +	struct mutex mtx;
> +	struct sk_buff *send_buff;
> +	struct wait_queue_head wq;
> +};
>  
>  static int virtual_nci_open(struct nci_dev *ndev)
>  {
> @@ -41,31 +35,34 @@ static int virtual_nci_open(struct nci_dev *ndev)
>  
>  static int virtual_nci_close(struct nci_dev *ndev)
>  {
> -	mutex_lock(&nci_mutex);
> -	kfree_skb(send_buff);
> -	send_buff = NULL;
> -	mutex_unlock(&nci_mutex);
> +	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> +
> +	mutex_lock(&vdev->mtx);
> +	kfree_skb(vdev->send_buff);
> +	vdev->send_buff = NULL;
> +	mutex_unlock(&vdev->mtx);
>  
>  	return 0;
>  }
>  
>  static int virtual_nci_send(struct nci_dev *ndev, struct sk_buff *skb)
>  {
> -	mutex_lock(&nci_mutex);
> -	if (state != virtual_ncidev_enabled) {
> -		mutex_unlock(&nci_mutex);
> +	struct virtual_nci_dev *vdev = nci_get_drvdata(ndev);
> +
> +	mutex_lock(&vdev->mtx);
> +	if (vdev->send_buff) {
> +		mutex_unlock(&vdev->mtx);
>  		kfree_skb(skb);
> -		return 0;
> +		return -1;
>  	}
> -
> -	if (send_buff) {
> -		mutex_unlock(&nci_mutex);
> +	vdev->send_buff = skb_copy(skb, GFP_KERNEL);
> +	if (!vdev->send_buff) {
> +		mutex_unlock(&vdev->mtx);
>  		kfree_skb(skb);
>  		return -1;
>  	}
> -	send_buff = skb_copy(skb, GFP_KERNEL);
> -	mutex_unlock(&nci_mutex);
> -	wake_up_interruptible(&wq);
> +	mutex_unlock(&vdev->mtx);
> +	wake_up_interruptible(&vdev->wq);
>  	consume_skb(skb);
>  
>  	return 0;
> @@ -80,29 +77,30 @@ static const struct nci_ops virtual_nci_ops = {
>  static ssize_t virtual_ncidev_read(struct file *file, char __user *buf,
>  				   size_t count, loff_t *ppos)
>  {
> +	struct virtual_nci_dev *vdev = file->private_data;
>  	size_t actual_len;
>  
> -	mutex_lock(&nci_mutex);
> -	while (!send_buff) {
> -		mutex_unlock(&nci_mutex);
> -		if (wait_event_interruptible(wq, send_buff))
> +	mutex_lock(&vdev->mtx);
> +	while (!vdev->send_buff) {
> +		mutex_unlock(&vdev->mtx);
> +		if (wait_event_interruptible(vdev->wq, vdev->send_buff))
>  			return -EFAULT;
> -		mutex_lock(&nci_mutex);
> +		mutex_lock(&vdev->mtx);
>  	}
>  
> -	actual_len = min_t(size_t, count, send_buff->len);
> +	actual_len = min_t(size_t, count, vdev->send_buff->len);
>  
> -	if (copy_to_user(buf, send_buff->data, actual_len)) {
> -		mutex_unlock(&nci_mutex);
> +	if (copy_to_user(buf, vdev->send_buff->data, actual_len)) {
> +		mutex_unlock(&vdev->mtx);
>  		return -EFAULT;
>  	}
>  
> -	skb_pull(send_buff, actual_len);
> -	if (send_buff->len == 0) {
> -		consume_skb(send_buff);
> -		send_buff = NULL;
> +	skb_pull(vdev->send_buff, actual_len);
> +	if (vdev->send_buff->len == 0) {
> +		consume_skb(vdev->send_buff);
> +		vdev->send_buff = NULL;
>  	}
> -	mutex_unlock(&nci_mutex);
> +	mutex_unlock(&vdev->mtx);
>  
>  	return actual_len;
>  }
> @@ -111,6 +109,7 @@ static ssize_t virtual_ncidev_write(struct file *file,
>  				    const char __user *buf,
>  				    size_t count, loff_t *ppos)
>  {
> +	struct virtual_nci_dev *vdev = file->private_data;
>  	struct sk_buff *skb;
>  
>  	skb = alloc_skb(count, GFP_KERNEL);
> @@ -122,63 +121,58 @@ static ssize_t virtual_ncidev_write(struct file *file,
>  		return -EFAULT;
>  	}
>  
> -	nci_recv_frame(ndev, skb);
> +	nci_recv_frame(vdev->ndev, skb);
>  	return count;
>  }
>  
>  static int virtual_ncidev_open(struct inode *inode, struct file *file)
>  {
>  	int ret = 0;
> +	struct virtual_nci_dev *vdev;
>  
> -	mutex_lock(&nci_mutex);
> -	if (state != virtual_ncidev_disabled) {
> -		mutex_unlock(&nci_mutex);
> -		return -EBUSY;
> -	}
> -
> -	ndev = nci_allocate_device(&virtual_nci_ops, VIRTUAL_NFC_PROTOCOLS,
> -				   0, 0);
> -	if (!ndev) {
> -		mutex_unlock(&nci_mutex);
> +	vdev = kzalloc(sizeof(*vdev), GFP_KERNEL);
> +	if (!vdev)
> +		return -ENOMEM;
> +	vdev->ndev = nci_allocate_device(&virtual_nci_ops,
> +		VIRTUAL_NFC_PROTOCOLS, 0, 0);
> +	if (!vdev->ndev) {
> +		kfree(vdev);
>  		return -ENOMEM;
>  	}
>  
> -	ret = nci_register_device(ndev);
> +	mutex_init(&vdev->mtx);
> +	init_waitqueue_head(&vdev->wq);
> +	file->private_data = vdev;
> +	nci_set_drvdata(vdev->ndev, vdev);
> +
> +	ret = nci_register_device(vdev->ndev);
>  	if (ret < 0) {
> -		nci_free_device(ndev);
> -		mutex_unlock(&nci_mutex);
> +		nci_free_device(vdev->ndev);
> +		mutex_destroy(&vdev->mtx);
> +		kfree(vdev);
>  		return ret;
>  	}
> -	state = virtual_ncidev_enabled;
> -	mutex_unlock(&nci_mutex);
>  
>  	return 0;
>  }
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
>  
> -static long virtual_ncidev_ioctl(struct file *flip, unsigned int cmd,
> +static long virtual_ncidev_ioctl(struct file *file, unsigned int cmd,
>  				 unsigned long arg)
>  {
> -	const struct nfc_dev *nfc_dev = ndev->nfc_dev;
> +	struct virtual_nci_dev *vdev = file->private_data;
> +	const struct nfc_dev *nfc_dev = vdev->ndev->nfc_dev;
>  	void __user *p = (void __user *)arg;
>  
>  	if (cmd != IOCTL_GET_NCIDEV_IDX)
> @@ -199,14 +193,15 @@ static const struct file_operations virtual_ncidev_fops = {
>  	.unlocked_ioctl = virtual_ncidev_ioctl
>  };
>  
> +static struct miscdevice miscdev = {
> +	.minor = MISC_DYNAMIC_MINOR,
> +	.name = "virtual_nci",
> +	.fops = &virtual_ncidev_fops,
> +	.mode = 0600,
> +};
> +
>  static int __init virtual_ncidev_init(void)
>  {
> -	state = virtual_ncidev_disabled;
> -	miscdev.minor = MISC_DYNAMIC_MINOR;
> -	miscdev.name = "virtual_nci";
> -	miscdev.fops = &virtual_ncidev_fops;
> -	miscdev.mode = 0600;
> -
>  	return misc_register(&miscdev);
>  }
> 

Reviewed-by: Bongsu Jeon

Thanks for good design and improvement.
