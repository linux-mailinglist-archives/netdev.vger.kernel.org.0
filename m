Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20ADE1F70F6
	for <lists+netdev@lfdr.de>; Fri, 12 Jun 2020 01:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726474AbgFKXnq convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 11 Jun 2020 19:43:46 -0400
Received: from mga03.intel.com ([134.134.136.65]:19591 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726327AbgFKXnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 19:43:45 -0400
IronPort-SDR: Myi0XHRCCrnX1ckcHQz9wAcCnctwfj1MrXMmyeb9N6IKFKbCgu3+OljagzDFZ54GsM8AWC8jC1
 RbDVjJAIB5AA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2020 16:43:44 -0700
IronPort-SDR: exrb0qjxmU1YHoUJ443y2itGd/R9enFU01s9kA8DhvsaMg5jntaeYnhO2EonWXQHXH1B3GsJ5+
 PF3dXEKsbYDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,501,1583222400"; 
   d="scan'208";a="448113800"
Received: from orsmsx107.amr.corp.intel.com ([10.22.240.5])
  by orsmga005.jf.intel.com with ESMTP; 11 Jun 2020 16:43:41 -0700
Received: from orsmsx152.amr.corp.intel.com (10.22.226.39) by
 ORSMSX107.amr.corp.intel.com (10.22.240.5) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Thu, 11 Jun 2020 16:43:34 -0700
Received: from orsmsx112.amr.corp.intel.com ([169.254.3.61]) by
 ORSMSX152.amr.corp.intel.com ([169.254.8.173]) with mapi id 14.03.0439.000;
 Thu, 11 Jun 2020 16:43:34 -0700
From:   "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "klassert@kernel.org" <klassert@kernel.org>,
        "akiyano@amazon.com" <akiyano@amazon.com>,
        "irusskikh@marvell.com" <irusskikh@marvell.com>,
        "ioana.ciornei@nxp.com" <ioana.ciornei@nxp.com>,
        "kys@microsoft.com" <kys@microsoft.com>,
        "saeedm@mellanox.com" <saeedm@mellanox.com>,
        "jdmason@kudzu.us" <jdmason@kudzu.us>,
        "snelson@pensando.io" <snelson@pensando.io>,
        "GR-Linux-NIC-Dev@marvell.com" <GR-Linux-NIC-Dev@marvell.com>,
        "stuyoder@gmail.com" <stuyoder@gmail.com>,
        "sgoutham@marvell.com" <sgoutham@marvell.com>,
        "luobin9@huawei.com" <luobin9@huawei.com>,
        "csully@google.com" <csully@google.com>,
        "kou.ishizaki@toshiba.co.jp" <kou.ishizaki@toshiba.co.jp>,
        "peppe.cavallaro@st.com" <peppe.cavallaro@st.com>,
        "chessman@tux.org" <chessman@tux.org>
Subject: RE: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Thread-Topic: [RFC 1/8] docs: networking: reorganize driver documentation
 again
Thread-Index: AQHWQBYlZ9b3fqzvSU6P5iNzbYtTL6jT6nZggACHPQCAAA4cAP//k44A
Date:   Thu, 11 Jun 2020 23:43:33 +0000
Message-ID: <61CC2BC414934749BD9F5BF3D5D94044986F531D@ORSMSX112.amr.corp.intel.com>
References: <20200611173010.474475-1-kuba@kernel.org>
        <20200611173010.474475-2-kuba@kernel.org>
        <61CC2BC414934749BD9F5BF3D5D94044986F4FAE@ORSMSX112.amr.corp.intel.com>
        <20200611151842.392642c5@hermes.lan>
 <20200611160912.7c2b3478@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200611160912.7c2b3478@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-version: 11.2.0.6
dlp-reaction: no-action
x-originating-ip: [10.22.254.140]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Jakub Kicinski <kuba@kernel.org>
> Sent: Thursday, June 11, 2020 16:09
> To: Stephen Hemminger <stephen@networkplumber.org>
> Cc: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net;
> netdev@vger.kernel.org; linux-doc@vger.kernel.org; klassert@kernel.org;
> akiyano@amazon.com; irusskikh@marvell.com; ioana.ciornei@nxp.com;
> kys@microsoft.com; saeedm@mellanox.com; jdmason@kudzu.us;
> snelson@pensando.io; GR-Linux-NIC-Dev@marvell.com; stuyoder@gmail.com;
> sgoutham@marvell.com; luobin9@huawei.com; csully@google.com;
> kou.ishizaki@toshiba.co.jp; peppe.cavallaro@st.com; chessman@tux.org
> Subject: Re: [RFC 1/8] docs: networking: reorganize driver documentation again
> 
> On Thu, 11 Jun 2020 15:18:42 -0700 Stephen Hemminger wrote:
> > > > Organize driver documentation by device type. Most documents have
> > > > fairly verbose yet uninformative names, so let users first select
> > > > a well defined device type, and then search for a particular
> > > > driver.
> > > >
> > > > While at it rename the section from Vendor drivers to Hardware
> > > > drivers. This seems more accurate, besides people sometimes refer
> > > > to out-of-tree drivers as vendor drivers.
> > > >
> > > > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> >
> > How much of it is still relevant and useful?
> >
> > The last time I checked, lots of this had bad advice about settings.
> > And there was lots of drivers documenting what was generic Linux
> > functionality
> >
> > And still there were references to old commands like ifconfig or ifenslave.
> 
> For general documentation I hope now that it's slightly de-cluttered it's more
> likely folks (including myself, time allowing) will be more inclined to clean up /
> contribute. I haven't looked in detail, yet.
[Kirsher, Jeffrey T] 

I agree, I have been meaning to "organize" the networking documentation for the last year, but was not finding the time.  So thank you!  This will also make it easier to review and update the current documentation.

> 
> As for the vendor docs - I guess that the obsolescence of the docs/ instructions
> goes hand in hand with obsolescence of the HW itself.
