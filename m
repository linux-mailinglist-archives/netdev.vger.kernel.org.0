Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9EBEBFA52
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 21:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfIZTvP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 26 Sep 2019 15:51:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:5636 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728750AbfIZTvO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Sep 2019 15:51:14 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga101.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Sep 2019 12:51:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,553,1559545200"; 
   d="scan'208";a="273578835"
Received: from fmsmsx103.amr.corp.intel.com ([10.18.124.201])
  by orsmga001.jf.intel.com with ESMTP; 26 Sep 2019 12:51:13 -0700
Received: from fmsmsx120.amr.corp.intel.com (10.18.124.208) by
 FMSMSX103.amr.corp.intel.com (10.18.124.201) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 26 Sep 2019 12:51:13 -0700
Received: from fmsmsx123.amr.corp.intel.com ([169.254.7.221]) by
 fmsmsx120.amr.corp.intel.com ([169.254.15.9]) with mapi id 14.03.0439.000;
 Thu, 26 Sep 2019 12:51:13 -0700
From:   "Saleem, Shiraz" <shiraz.saleem@intel.com>
To:     Leon Romanovsky <leon@kernel.org>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
CC:     "dledford@redhat.com" <dledford@redhat.com>,
        "jgg@mellanox.com" <jgg@mellanox.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: RE: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Topic: [RFC 04/20] RDMA/irdma: Add driver framework definitions
Thread-Index: AQHVdInWRrhtw3GiCUGgUX5/wYICeKc+rIcA//+i1cA=
Date:   Thu, 26 Sep 2019 19:51:12 +0000
Message-ID: <9DD61F30A802C4429A01CA4200E302A7AC702C20@fmsmsx123.amr.corp.intel.com>
References: <20190926164519.10471-1-jeffrey.t.kirsher@intel.com>
 <20190926164519.10471-5-jeffrey.t.kirsher@intel.com>
 <20190926173046.GB14368@unreal>
In-Reply-To: <20190926173046.GB14368@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ctpclassification: CTP_NT
x-titus-metadata-40: eyJDYXRlZ29yeUxhYmVscyI6IiIsIk1ldGFkYXRhIjp7Im5zIjoiaHR0cDpcL1wvd3d3LnRpdHVzLmNvbVwvbnNcL0ludGVsMyIsImlkIjoiYTAzMTMwMjUtZTgxZC00M2E1LTk2MDItYTU2MjNiZjNlMjU3IiwicHJvcHMiOlt7Im4iOiJDVFBDbGFzc2lmaWNhdGlvbiIsInZhbHMiOlt7InZhbHVlIjoiQ1RQX05UIn1dfV19LCJTdWJqZWN0TGFiZWxzIjpbXSwiVE1DVmVyc2lvbiI6IjE3LjEwLjE4MDQuNDkiLCJUcnVzdGVkTGFiZWxIYXNoIjoicEk0Y05lcTZUOTQ5aUFLeWgrbFBDYWU1VjR5a1hkVk5jWFJjS1c4MjdyWWhPUEtnSUhCVHM2d0wxcmM0OXlrRCJ9
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.1.200.106]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Subject: Re: [RFC 04/20] RDMA/irdma: Add driver framework definitions
> 

<...............>

> > +/**
> > + * i40iw_l2param_change - handle qs handles for QoS and MSS change
> > + * @ldev: LAN device information
> > + * @client: client for parameter change
> > + * @params: new parameters from L2
> > + */
> > +static void i40iw_l2param_change(struct i40e_info *ldev,
> > +				 struct i40e_client *client,
> > +				 struct i40e_params *params)
> > +{
> > +	struct irdma_l2params *l2params;
> > +	struct l2params_work *work;
> > +	struct irdma_device *iwdev;
> > +	struct irdma_handler *hdl;
> > +	int i;
> > +
> > +	hdl = irdma_find_handler(ldev->pcidev);
> > +	if (!hdl)
> > +		return;
> > +
> > +	iwdev = (struct irdma_device *)((u8 *)hdl + sizeof(*hdl));
> > +
> > +	if (atomic_read(&iwdev->params_busy))
> > +		return;
> > +	work = kzalloc(sizeof(*work), GFP_KERNEL);
> > +	if (!work)
> > +		return;
> > +
> > +	atomic_inc(&iwdev->params_busy);
> 
> Changing parameters through workqueue and perform locking with atomic_t,
> exciting.
> Please do proper locking scheme and better to avoid workqueue at all.

Hmmm....Yes, this is buggy. Will come up with a better solution.

> 
> <...>
> 
> > +/* client interface functions */
> > +static const struct i40e_client_ops i40e_ops = {
> > +	.open = i40iw_open,
> > +	.close = i40iw_close,
> > +	.l2_param_change = i40iw_l2param_change };
> > +
> > +static struct i40e_client i40iw_client = {
> > +	.name = "irdma",
> > +	.ops = &i40e_ops,
> > +	.version.major = I40E_CLIENT_VERSION_MAJOR,
> > +	.version.minor = I40E_CLIENT_VERSION_MINOR,
> > +	.version.build = I40E_CLIENT_VERSION_BUILD,
> > +	.type = I40E_CLIENT_IWARP,
> > +};
> > +
> > +int i40iw_probe(struct platform_device *pdev) {
> > +	struct i40e_peer_dev_platform_data *pdata =
> > +		dev_get_platdata(&pdev->dev);
> > +	struct i40e_info *ldev;
> > +
> > +	if (!pdata)
> > +		return -EINVAL;
> > +
> > +	ldev = pdata->ldev;
> > +
> > +	if (ldev->version.major != I40E_CLIENT_VERSION_MAJOR ||
> > +	    ldev->version.minor != I40E_CLIENT_VERSION_MINOR) {
> > +		pr_err("version mismatch:\n");
> > +		pr_err("expected major ver %d, caller specified major ver %d\n",
> > +		       I40E_CLIENT_VERSION_MAJOR, ldev->version.major);
> > +		pr_err("expected minor ver %d, caller specified minor ver %d\n",
> > +		       I40E_CLIENT_VERSION_MINOR, ldev->version.minor);
> > +		return -EINVAL;
> > +	}
> 
> This is can't be in upstream code, we don't support out-of-tree modules,
> everything else will have proper versions.
> 

OK.
