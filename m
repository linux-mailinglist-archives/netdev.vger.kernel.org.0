Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EF10354514
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 18:21:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239145AbhDEQV0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 5 Apr 2021 12:21:26 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:2758 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238897AbhDEQVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Apr 2021 12:21:25 -0400
Received: from fraeml705-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4FDbJS55t8z685PJ;
        Tue,  6 Apr 2021 00:11:52 +0800 (CST)
Received: from lhreml701-chm.china.huawei.com (10.201.108.50) by
 fraeml705-chm.china.huawei.com (10.206.15.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 5 Apr 2021 18:21:17 +0200
Received: from lhreml703-chm.china.huawei.com (10.201.108.52) by
 lhreml701-chm.china.huawei.com (10.201.108.50) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2106.2; Mon, 5 Apr 2021 17:21:16 +0100
Received: from lhreml703-chm.china.huawei.com ([10.201.68.198]) by
 lhreml703-chm.china.huawei.com ([10.201.68.198]) with mapi id 15.01.2106.013;
 Mon, 5 Apr 2021 17:21:16 +0100
From:   Salil Mehta <salil.mehta@huawei.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linuxarm <linuxarm@huawei.com>,
        "linuxarm@openeuler.org" <linuxarm@openeuler.org>
Subject: RE: [PATCH net 1/2] net: hns3: Remove the left over redundant check &
 assignment
Thread-Topic: [PATCH net 1/2] net: hns3: Remove the left over redundant check
 & assignment
Thread-Index: AQHXKCnLHaQ/R/ieO0avXcKs+3D9qaqj1ZcAgAIEzID///cBgIAATB7A
Date:   Mon, 5 Apr 2021 16:21:15 +0000
Message-ID: <0728cf845791450c8e0ea2b199c9072c@huawei.com>
References: <20210403013520.22108-1-salil.mehta@huawei.com>
 <20210403013520.22108-2-salil.mehta@huawei.com> <YGlb6CgaW5r4lwaC@unreal>
 <09176e61b8ca495f8c20b94845d26ba0@huawei.com> <YGsF4Q4XlvpoBUJY@unreal>
In-Reply-To: <YGsF4Q4XlvpoBUJY@unreal>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.47.69.183]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Leon Romanovsky [mailto:leon@kernel.org]
> Sent: Monday, April 5, 2021 1:43 PM
> To: Salil Mehta <salil.mehta@huawei.com>
> Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> linux-kernel@vger.kernel.org; Linuxarm <linuxarm@huawei.com>;
> linuxarm@openeuler.org
> Subject: Re: [PATCH net 1/2] net: hns3: Remove the left over redundant check
> & assignment
> 
> On Mon, Apr 05, 2021 at 12:26:37PM +0000, Salil Mehta wrote:
> > Hi Leon,
> > Thanks for the review.
> >
> > > From: Leon Romanovsky [mailto:leon@kernel.org]
> > > Sent: Sunday, April 4, 2021 7:26 AM
> > > To: Salil Mehta <salil.mehta@huawei.com>
> > > Cc: davem@davemloft.net; kuba@kernel.org; netdev@vger.kernel.org;
> > > linux-kernel@vger.kernel.org; Linuxarm <linuxarm@huawei.com>;
> > > linuxarm@openeuler.org
> > > Subject: Re: [PATCH net 1/2] net: hns3: Remove the left over redundant check
> > > & assignment
> > >
> > > On Sat, Apr 03, 2021 at 02:35:19AM +0100, Salil Mehta wrote:
> > > > This removes the left over check and assignment which is no longer used
> > > > anywhere in the function and should have been removed as part of the
> > > > below mentioned patch.
> > > >
> > > > Fixes: 012fcb52f67c ("net: hns3: activate reset timer when calling
> > > reset_event")
> > > > Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> > > > ---
> > > >  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 2 --
> > > >  1 file changed, 2 deletions(-)
> > > >
> > > > diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > > index e3f81c7e0ce7..7ad0722383f5 100644
> > > > --- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > > +++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
> > > > @@ -3976,8 +3976,6 @@ static void hclge_reset_event(struct pci_dev *pdev,
> > > struct hnae3_handle *handle)
> > > >  	 * want to make sure we throttle the reset request. Therefore, we will
> > > >  	 * not allow it again before 3*HZ times.
> > > >  	 */
> > > > -	if (!handle)
> > > > -		handle = &hdev->vport[0].nic;
> > >
> > > The comment above should be updated too, and probably the signature of
> > > hclge_reset_event() worth to be changed.
> >
> >
> > Yes, true. Both the comment and the prototype will be updated in near future.
> > I can assure you this did not go un-noticed during the change. There are
> > some internal subtleties which I am trying to sort out. Those might come
> > as part of different patch-set which deals with other related changes as well.
> 
> I can buy such explanation for the change in function signature, but have hard
> time to believe that extra commit is needed to change comment above.

Sure, I understand your point. Earlier I thought to retain the comment for reference
and make it part of the refactor change. But will send another version changing
the comment now. No issues :)

Many thanks

> 
> Thanks
> 
> >
> > The current change(and some other) will pave the way for necessary refactoring
> > Of the code being done.
> >
> >
> > >
> > > Thanks
> > >
> > > >
> > > >  	if (time_before(jiffies, (hdev->last_reset_time +
> > > >  				  HCLGE_RESET_INTERVAL))) {
> > > > --
> > > > 2.17.1
> > > >
