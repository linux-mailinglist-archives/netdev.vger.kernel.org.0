Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C53562F93FF
	for <lists+netdev@lfdr.de>; Sun, 17 Jan 2021 17:39:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729574AbhAQQiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jan 2021 11:38:17 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8326 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729319AbhAQQiI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jan 2021 11:38:08 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 10HGbRvi024512;
        Sun, 17 Jan 2021 08:37:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0220;
 bh=cbik4ZldH9wGpDYg7yWgZDq4BCHmRXFW4Gaug19ow5c=;
 b=BHN0TR4cvgj5AbvQ03635Mgl1pabvrNFs3Z6L33x21Fx8pu+POHb3XMcoNKlaZqPI2GT
 0umuRX2SxR7nkLYG27BC1UpXiWH/Ctm1gRFOggMaqTrNFMq/kvTOMSFYI1XGGbsYS7bf
 dIkiz+pqgmZj7TlvBUnkl9Z4GBAV9uCodHrrWzMCiuVHM/3CD5im9Z8K1uxMrnlNj+Zq
 nHyHGPhgcirb9LOa4yysClGRLb2T1UN9rmiab8v/p7AOSMbvOFE4xjXO8bIqwRxz2Ex/
 ku+2PCiW1Z0Q+9fb2gXBxgtjbeW5OdNthtZfa46kAMMviQupTz7LbO8QEvo0nv2A+Owo Cg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 363xcu9wpe-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sun, 17 Jan 2021 08:37:26 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Sun, 17 Jan
 2021 08:37:25 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Sun, 17 Jan 2021 08:37:25 -0800
Received: from [10.193.38.82] (unknown [10.193.38.82])
        by maili.marvell.com (Postfix) with ESMTP id 73C6E3F703F;
        Sun, 17 Jan 2021 08:37:24 -0800 (PST)
Subject: Re: [EXT] Re: [PATCH net-next 3/3] qede: set default per queue rx/tx
 usecs coalescing parameters
To:     Jakub Kicinski <kuba@kernel.org>,
        Bhaskar Upadhaya <bupadhaya@marvell.com>
CC:     <netdev@vger.kernel.org>, Ariel Elior <aelior@marvell.com>
References: <1610701570-29496-1-git-send-email-bupadhaya@marvell.com>
 <1610701570-29496-4-git-send-email-bupadhaya@marvell.com>
 <20210116182806.625c540e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <56fe2942-415e-9341-b3cd-e926559d6e31@marvell.com>
Date:   Sun, 17 Jan 2021 17:37:23 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:85.0) Gecko/20100101
 Thunderbird/85.0
MIME-Version: 1.0
In-Reply-To: <20210116182806.625c540e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.343,18.0.737
 definitions=2021-01-17_09:2021-01-15,2021-01-17 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


>> Here we do the initialization of coalescing values on load.
>> Although the default device values are the same - explicit
>> config is better visible.
> 
> Can you also make the driver store the settings across ifdown / ifup
> and allow the settings to be checked while the interface is down, 
> while at it?

Good suggestion, we'll implement that.

Thanks,
   Igor
