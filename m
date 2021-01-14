Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F33D2F5F57
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 11:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728733AbhANK4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 05:56:06 -0500
Received: from smtprelay0007.hostedemail.com ([216.40.44.7]:59406 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726416AbhANK4A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jan 2021 05:56:00 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 2FC50181D3025;
        Thu, 14 Jan 2021 10:55:18 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,,RULES_HIT:41:355:379:599:800:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:2393:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:4321:5007:6742:7576:7652:7974:8603:10004:10400:10848:11026:11232:11473:11658:11914:12043:12048:12109:12296:12297:12438:12740:12895:13019:13069:13095:13255:13311:13357:13439:13894:14181:14659:14721:21080:21433:21451:21524:21627:21990:30012:30054:30055:30063:30064:30091,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache:0,MSF:not bulk,SPF:,MSBL:0,DNSBL:none,Custom_rules:0:0:0,LFtime:1,LUA_SUMMARY:none
X-HE-Tag: rake95_1e0310527526
X-Filterd-Recvd-Size: 3103
Received: from [192.168.1.159] (unknown [47.151.137.21])
        (Authenticated sender: joe@perches.com)
        by omf20.hostedemail.com (Postfix) with ESMTPA;
        Thu, 14 Jan 2021 10:55:15 +0000 (UTC)
Message-ID: <ff6c529f78396aa3ce8d9cb9fefeeb098e64342f.camel@perches.com>
Subject: Re: [Intel-wired-lan] [net-next] net: iavf: Use the ARRAY_SIZE
 macro for aq_to_posix
From:   Joe Perches <joe@perches.com>
To:     "Jankowski, Konrad0" <konrad0.jankowski@intel.com>,
        Wei Xu <xuwei5@hisilicon.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "jinying@hisilicon.com" <jinying@hisilicon.com>,
        "tangkunshan@huawei.com" <tangkunshan@huawei.com>,
        "huangdaode@hisilicon.com" <huangdaode@hisilicon.com>,
        "john.garry@huawei.com" <john.garry@huawei.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "shameerali.kolothum.thodi@huawei.com" 
        <shameerali.kolothum.thodi@huawei.com>,
        "zhangyi.ac@huawei.com" <zhangyi.ac@huawei.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "jonathan.cameron@huawei.com" <jonathan.cameron@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "liguozhu@hisilicon.com" <liguozhu@hisilicon.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "shiju.jose@huawei.com" <shiju.jose@huawei.com>
Date:   Thu, 14 Jan 2021 02:55:13 -0800
In-Reply-To: <CY4PR11MB15769D5697074F230C8742CAABA80@CY4PR11MB1576.namprd11.prod.outlook.com>
References: <1599641471-204919-1-git-send-email-xuwei5@hisilicon.com>
         <CY4PR11MB15769D5697074F230C8742CAABA80@CY4PR11MB1576.namprd11.prod.outlook.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.38.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-01-14 at 09:57 +0000, Jankowski, Konrad0 wrote:
> > -----Original Message-----
> > From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of Wei Xu
[]
> > Use the ARRAY_SIZE macro to calculate the size of an array.
> > This code was detected with the help of Coccinelle.
[]
> > diff --git a/drivers/net/ethernet/intel/iavf/iavf_adminq.h
[]
> > @@ -120,7 +120,7 @@ static inline int iavf_aq_rc_to_posix(int aq_ret, int aq_rc)
> >  	if (aq_ret == IAVF_ERR_ADMIN_QUEUE_TIMEOUT)
> >  		return -EAGAIN;
> > 
> > -	if (!((u32)aq_rc < (sizeof(aq_to_posix) / sizeof((aq_to_posix)[0]))))
> > +	if (!((u32)aq_rc < ARRAY_SIZE(aq_to_posix)))
> >  		return -ERANGE;
> > 
> >  	return aq_to_posix[aq_rc];
> 
> Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>

I think several things are poor here.

This function shouldn't really be a static inline as it would just bloat
whatever uses it and should just be a typical function in a utility .c file.

And it doesn't seem this function is used at all so it should be deleted.

aq_to_posix should be static const.

And if it's really necessary, I think it would be simpler to read using code
without the cast and negation.

	if (aq_rc < 0 || aq_rc >= ARRAY_SIZE(aq_to_posix))
		return -ERANGE;



