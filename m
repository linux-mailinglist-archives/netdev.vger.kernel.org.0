Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97CB9125118
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 19:57:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727049AbfLRS5M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 18 Dec 2019 13:57:12 -0500
Received: from mga09.intel.com ([134.134.136.24]:9014 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726824AbfLRS5M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 13:57:12 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 18 Dec 2019 10:57:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,330,1571727600"; 
   d="scan'208";a="218238744"
Received: from fmsmsx104.amr.corp.intel.com ([10.18.124.202])
  by orsmga003.jf.intel.com with ESMTP; 18 Dec 2019 10:57:10 -0800
Received: from fmsmsx118.amr.corp.intel.com (10.18.116.18) by
 fmsmsx104.amr.corp.intel.com (10.18.124.202) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 18 Dec 2019 10:57:10 -0800
Received: from fmsmsx124.amr.corp.intel.com ([169.254.8.10]) by
 fmsmsx118.amr.corp.intel.com ([169.254.1.58]) with mapi id 14.03.0439.000;
 Wed, 18 Dec 2019 10:57:10 -0800
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     'Greg KH' <gregkh@linuxfoundation.org>
CC:     "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "parav@mellanox.com" <parav@mellanox.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>
Subject: RE: [PATCH v3 04/20] i40e: Register a virtbus device to provide RDMA
Thread-Topic: [PATCH v3 04/20] i40e: Register a virtbus device to provide
 RDMA
Thread-Index: AQHVruLyruZaK+NBaUahwsdRBRLbTKe0CH+AgAR/tTCAAVOvgIAE7IIg
Date:   Wed, 18 Dec 2019 18:57:10 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7B6B9AFF7@fmsmsx124.amr.corp.intel.com>
References: <20191209224935.1780117-1-jeffrey.t.kirsher@intel.com>
 <20191209224935.1780117-5-jeffrey.t.kirsher@intel.com>
 <20191210153959.GD4053085@kroah.com>
 <9DD61F30A802C4429A01CA4200E302A7B6B9345E@fmsmsx124.amr.corp.intel.com>
 <20191214083753.GB3318534@kroah.com>
In-Reply-To: <20191214083753.GB3318534@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiZDU5NWQ3ZWQtYTI4My00NjUzLTkxN2YtNmI5YTg5YTJlZjExIiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoiQjJaeGVFbnR3V242eW1UbkdwaWUyNGROMFhpM2ZscTdcL0dpSWJqVmcwVCtKSFlBeEJTSXhVNTJ5d1BtYjliQUsifQ==
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.108]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > Subject: Re: [PATCH v3 04/20] i40e: Register a virtbus device to
> > > provide RDMA
[.....]

> > >
> > > And who owns the memory of this thing that is supposed to be
> > > dynamically controlled by something OUTSIDE of this driver?  Who
> > > created that thing 3 pointers deep?  What happens when you leak the
> > > memory below (hint, you did), and who is supposed to clean it up if
> > > you need to properly clean it up if something bad happens?
> >
> > The i40e_info object memory is tied to the PF driver.
> 
> What is a "PF"?

physical function.

> 
> > The object hierarchy is,
> >
> > i40e_pf: pointer to i40e_client_instance
> > 	----- i40e_client_instance: i40e_info
> > 		----- i40e_info: virtbus_device
> 
> So you are 3 pointers deep to get a structure that is dynamically controlled?  Why
> are those "3 pointers" not also represented in sysfs?
> You have a heiarchy within the kernel that is not being represented that way to
> userspace, why?
> 
> Hint, I think this is totally wrong, you need to rework this to be sane.
> 
> > For each PF, there is a client_instance object allocated.
> 
> Great, make it dynamic and in the device tree.
> 
> > The i40e_info object is populated and the virtbus_device hanging off this object
> is registered.
> 
> Great, make that dynamic and inthe device tree.
> 
> If you think this is too much, then your whole mess here is too much and needs to
> be made a lot simpler.
>

I think we can decouple the virtbus_device object from i40e_info object.

Instead allocate a i40e_virtbus_device object which contains
the virtbus_device and a pointer to i40e_info object for the
RDMA driver to consume on probe(). Register it the virtbus, and provide
a release callback to free up its memory.

Sending a patch snippet to hopefully make it clearer.

diff --git a/drivers/net/ethernet/intel/i40e/i40e_client.c b/drivers/net/ethernet/intel/i40e/i40e_client.c
index b80ffaf..c6cf2eb 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_client.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_client.c
@@ -281,6 +281,42 @@ void i40e_client_update_msix_info(struct i40e_pf *pf)
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 }
 
+static void i40e_virtdev_release(struct device *dev)
+{
+	struct virtbus_device *vdev = container_of(dev, struct virtbus_device, dev);
+	struct i40e_virtbus_device *i40e_vdev =
+		container_of(vdev, struct i40e_virtbus_device, vdev);
+
+	kfree(i40e_vdev);
+}
+
+static int i40e_init_client_virtdev(struct i40e_info *ldev)
+{
+	struct pci_dev *pdev = ldev->pcidev;
+	struct i40e_virtbus_device *i40e_vdev;
+	int ret;
+
+	i40e_vdev = kzalloc(sizeof(*i40e_vdev), GFP_KERNEL);
+	if (!i40e_vdev)
+		return -ENOMEM;
+
+	i40e_vdev->vdev.name = I40E_PEER_RDMA_NAME;
+	i40e_vdev->vdev.dev.parent = &pdev->dev;
+	i40e_vdev->vdev.dev.release = i40e_virtdev_release;
+	i40e_vdev->ldev = ldev;
+
+	ret = virtbus_dev_register(&i40e_vdev->vdev);
+	if (ret)
+		/* TBD: Assuming virtbus_dev_register() does put_device
+		 * on err clean-up
+		 */
+		return ret;
+
+	ldev->vdev = &i40e_vdev->vdev;
+
+	return 0;
+}
+
 /**
  * i40e_client_add_instance - add a client instance struct to the instance list
  * @pf: pointer to the board struct
@@ -313,11 +349,8 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->lan_info.fw_build = pf->hw.aq.fw_build;
 	set_bit(__I40E_CLIENT_INSTANCE_NONE, &cdev->state);
 
-	if (i40e_client_get_params(vsi, &cdev->lan_info.params)) {
-		kfree(cdev);
-		cdev = NULL;
-		return;
-	}
+	if (i40e_client_get_params(vsi, &cdev->lan_info.params))
+		goto free_cdev;
 
 	mac = list_first_entry(&cdev->lan_info.netdev->dev_addrs.list,
 			       struct netdev_hw_addr, list);
@@ -332,6 +365,14 @@ static void i40e_client_add_instance(struct i40e_pf *pf)
 	cdev->lan_info.msix_count = pf->num_iwarp_msix;
 	cdev->lan_info.msix_entries = &pf->msix_entries[pf->iwarp_base_vector];
 
+	if (i40e_init_client_virtdev(&cdev->lan_info))
+		goto free_cdev;
+
+	return;
+
+free_cdev:
+	kfree(cdev);
+	cdev = NULL;
 }
 
 /**
@@ -452,7 +493,7 @@ int i40e_lan_del_device(struct i40e_pf *pf)
 	struct i40e_device *ldev, *tmp;
 	int ret = -ENODEV;
 
-	virtbus_dev_unregister(&pf->cinst->lan_info.vdev);
+	virtbus_dev_unregister(pf->cinst->lan_info.vdev);
 
 	/* First, remove any client instance. */
 	i40e_client_del_instance(pf);
diff --git a/include/linux/net/intel/i40e_client.h b/include/linux/net/intel/i40e_client.h
index 7e147d3..5c81261 100644
--- a/include/linux/net/intel/i40e_client.h
+++ b/include/linux/net/intel/i40e_client.h
@@ -83,11 +83,11 @@ struct i40e_params {
 
 /* Structure to hold Lan device info for a client device */
 struct i40e_info {
 	struct i40e_client_version version;
 	u8 lanmac[6];
 	struct net_device *netdev;
 	struct pci_dev *pcidev;
+	struct virtbus_device *vdev;
 	u8 __iomem *hw_addr;
 	u8 fid;	/* function id, PF id or VF id */
 #define I40E_CLIENT_FTYPE_PF 0
@@ -112,6 +112,11 @@ struct i40e_info {
 	u32 fw_build;                   /* firmware build number */
 };
 
+struct i40e_virtbus_device {
+	struct virtbus_device vdev;
+	struct i40e_info *ldev;
+};
+

Is this more in line with correct usage and what you're expecting?

Shiraz
