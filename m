Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E66F020A304
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 18:32:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390785AbgFYQcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 12:32:39 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:7420 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2390007AbgFYQci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 12:32:38 -0400
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.42/8.16.0.42) with SMTP id 05PGQJFF017311;
        Thu, 25 Jun 2020 09:32:35 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=pfpt0818;
 bh=wrEfSMqC13aIM9VXqXL1TEgtz+RXlEWadjiNY+kcFMY=;
 b=jxxVBcFDx9NL2VJpgPt/m9Olhj3LHFhbOI1/ks8NOTiU7hx22Ko3NU3r368c/AWIRWCl
 Rs1a6Gjpyyr7U0T7fGEqw8/b0qQQpXINVAHy4g/gLIx3266ocrL53AOS+IjOqXEua68j
 WUjaTjjN5cc0yeNCzx89xB9sLE5Npmqw2F5csTsxHjr4QuZaq9AKemuzZWnzAamEpjCq
 C6ayIOCks6aXzwfeNR6mJXKvmnJEjWElQRhgnN0vPZd16kBCisiERtM5ttBtp3ax4VrC
 u1xaT0NgCCzD/9B27vypb1PkAk8w95AQoEnIREu9fImDLwDvDfq6L9awrONymAyyNFLD ZQ== 
Received: from sc-exch03.marvell.com ([199.233.58.183])
        by mx0a-0016f401.pphosted.com with ESMTP id 31uuqh0jcw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 25 Jun 2020 09:32:35 -0700
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH03.marvell.com
 (10.93.176.83) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 25 Jun
 2020 09:32:32 -0700
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 25 Jun 2020 09:32:33 -0700
Received: from [10.193.39.5] (unknown [10.193.39.5])
        by maili.marvell.com (Postfix) with ESMTP id ECC053F7040;
        Thu, 25 Jun 2020 09:32:29 -0700 (PDT)
Subject: Re: [EXT] [PATCH] qed: add missing error test for
 DBG_STATUS_NO_MATCHING_FRAMING_MODE
To:     Colin King <colin.king@canonical.com>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2 <GR-everest-linux-l2@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Kalderon <mkalderon@marvell.com>,
        <netdev@vger.kernel.org>
CC:     <kernel-janitors@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20200624101302.8316-1-colin.king@canonical.com>
From:   Igor Russkikh <irusskikh@marvell.com>
Message-ID: <a562bb9e-f158-3cdb-f969-fcbf88a2fad8@marvell.com>
Date:   Thu, 25 Jun 2020 19:32:28 +0300
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.0
MIME-Version: 1.0
In-Reply-To: <20200624101302.8316-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.216,18.0.687
 definitions=2020-06-25_11:2020-06-25,2020-06-25 signatures=0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Colin!

Thanks for catching this, indeed this was missed!

> 
>  	/* DBG_STATUS_INVALID_FILTER_TRIGGER_DWORDS */
>  	"The filter/trigger constraint dword offsets are not enabled for 
> recording",
> -
> +	/* DBG_STATUS_NO_MATCHING_FRAMING_MODE */
> +	"No matching framing mode",
> 

Could you please however change the string to

	"No matching framing mode found for the enabled blocks/Storms - use less
dwords for blocks data",

If you don't have much time, I can repost this for you. With this change it'll
 be in sync with our internal error descriptions.

Thanks
  Igor
