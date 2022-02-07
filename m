Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D38DA4AC0D7
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 15:16:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349134AbiBGOQD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 09:16:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390416AbiBGN5e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 08:57:34 -0500
X-Greylist: delayed 1762 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Feb 2022 05:57:29 PST
Received: from mx07-0057a101.pphosted.com (mx07-0057a101.pphosted.com [205.220.184.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32DD4C0401C5
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 05:57:28 -0800 (PST)
Received: from pps.filterd (m0214197.ppops.net [127.0.0.1])
        by mx07-0057a101.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 217BSTR9014899;
        Mon, 7 Feb 2022 14:27:46 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=westermo.com; h=date : from : to :
 cc : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=12052020; bh=pQ4+uX/QMochd9sPwGFaAzokREF0acE7OJnWSqGMGEw=;
 b=QucZcBGxppDVWb0WpuqeGoVYbu09qtfwt8IBFK0biObQnR4RV/xtLhD5/nRF/5Br+J8G
 O9kz7a5VlpUbip2/vX3vqxhQeKepKCjW6KZPoN01GPYFYRKmTXN3L3tQVv6RVlOQWSgu
 2Dhjij6H0TlbYIb26yl08VZT5JigzHo+Z1OZNiON2ryxroKqtKI/x9zj7ucxNargBy2+
 dRkc2knu7kcO8qZsD5NB3j6SonNCTU4SYLSqCr8uk5cESL8PA2n/yP1LXf7uIIjo9l30
 g3K5I8HdX53Gm6PCpGKeeLzGRqphVpY3uYc8u/BVJoXI08O+ApY0uuxelg4AWoPL/yUg lA== 
Received: from mail.beijerelectronics.com ([195.67.87.131])
        by mx07-0057a101.pphosted.com (PPS) with ESMTPS id 3e1efe9xbr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Mon, 07 Feb 2022 14:27:46 +0100
Received: from westermo.com (192.168.131.30) by
 EX01GLOBAL.beijerelectronics.com (10.101.10.25) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id
 15.1.2375.17; Mon, 7 Feb 2022 14:27:45 +0100
Date:   Mon, 7 Feb 2022 14:27:44 +0100
From:   Jacques de Laval <Jacques.De.Laval@westermo.com>
To:     David Ahern <dsahern@gmail.com>
CC:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 1/1] net: Add new protocol attribute to IP
 addresses
Message-ID: <20220207132744.mnk62qaxngswb3dz@westermo.com>
References: <42653bf5-ba76-2561-9cf9-27b0ae730210@gmail.com>
 <20220204180728.1597731-1-Jacques.De.Laval@westermo.com>
 <1f5e05a3-7d07-0412-1db2-8a848aa868d9@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1f5e05a3-7d07-0412-1db2-8a848aa868d9@gmail.com>
X-Originating-IP: [192.168.131.30]
X-ClientProxiedBy: wsevst-s0023.westermo.com (192.168.130.120) To
 EX01GLOBAL.beijerelectronics.com (10.101.10.25)
X-Proofpoint-GUID: PwFDPBr1pR2kx8SUsCUIq64Wbne3dOG8
X-Proofpoint-ORIG-GUID: PwFDPBr1pR2kx8SUsCUIq64Wbne3dOG8
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 04, 2022 at 09:10:51PM -0700, David Ahern wrote:
> On 2/4/22 11:07 AM, Jacques de Laval wrote:
> >>> @@ -69,4 +70,7 @@ struct ifa_cacheinfo {
> >>>  #define IFA_PAYLOAD(n) NLMSG_PAYLOAD(n,sizeof(struct ifaddrmsg))
> >>>  #endif
> >>>  
> >>> +/* ifa_protocol */
> >>> +#define IFAPROT_UNSPEC	0
> >>
> >> *If* the value is just a passthrough (userspace to kernel and back), no
> >> need for this uapi. However, have you considered builtin protocol labels
> >> - e.g. for autoconf, LLA, etc. Kernel generated vs RAs vs userspace
> >> adding it.
> > 
> > Agreed. For my own (very isolated) use case I only need the passthrough,
> > but I can see that it would make sense to standardize some labels.
> > I was trying to give this some thought but I have to admit I copped out
> > because of my limited knowledge on what labels would be reasonable to
> > reserve.
> > 
> > Based on what you mention, do you think the list bellow would make sense?
> > 
> > #define IFAPROT_UNSPEC		0  /* unspecified */
> > #define IFAPROT_KERNEL_LO	1  /* loopback */
> > #define IFAPROT_KERNEL_RA	2  /* auto assigned by kernel from router announcement */
> > #define IFAPROT_KERNEL_LL	3  /* link-local set by kernel */
> 
> Those above look good to me.
> 
> > #define IFAPROT_STATIC		4  /* set by admin */
> > #define IFAPROT_AUTO		5  /* DHCP, BOOTP etc. */
> > #define IFAPROT_LL		6  /* link-local set by userspace */
> > 
> > Or do you think it needs more granularity?
> 
> anything coming from userspace can just be a passthrough, so protocol
> label is only set if it is an autonomous action by the kernel or some
> app passed in a value.
> 

Thanks David, that makes sense. Will include the first defines in v2
and try to set them when appropriate.
