Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CBEA24A864
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 23:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727792AbgHSVVy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 17:21:54 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:37058 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726617AbgHSVVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 17:21:53 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 07JLLl48060542;
        Wed, 19 Aug 2020 16:21:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1597872107;
        bh=/+Tm+6kFguoE4AbqqrMbP10cUaIjmqI1jlWKYkTK0Kw=;
        h=Subject:From:To:References:Date:In-Reply-To;
        b=YaevMVCPmnTnxP4vlbBk7fCwqnzZuFnDubTpw/Tq0317sXCcXaRjQbwd/XxlXm+lM
         06HD0tDc8F3TD+YXdDnQyc5/qnnQJytLOT7/O8luoJpvdxhrKL3AWrEt1S9RVnqgb/
         J8TImc9gky92tjefjq/VDqwQFwqY9/InimcV0gSA=
Received: from DFLE114.ent.ti.com (dfle114.ent.ti.com [10.64.6.35])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 07JLLlud064031
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 19 Aug 2020 16:21:47 -0500
Received: from DFLE105.ent.ti.com (10.64.6.26) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Wed, 19
 Aug 2020 16:21:47 -0500
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE105.ent.ti.com
 (10.64.6.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Wed, 19 Aug 2020 16:21:47 -0500
Received: from [10.250.53.226] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 07JLLk8k030523;
        Wed, 19 Aug 2020 16:21:46 -0500
Subject: Re: [PATCH iproute2 v5 0/2] iplink: hsr: add support for creating PRP
 device
From:   Murali Karicheri <m-karicheri2@ti.com>
To:     <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-api@vger.kernel.org>,
        <nsekhar@ti.com>, <vinicius.gomes@intel.com>,
        <stephen@networkplumber.org>
References: <20200817211737.576-1-m-karicheri2@ti.com>
Message-ID: <44143c5d-ba93-363f-ca74-f9d7833c403f@ti.com>
Date:   Wed, 19 Aug 2020 17:21:46 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200817211737.576-1-m-karicheri2@ti.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi, Stephen,

On 8/17/20 5:17 PM, Murali Karicheri wrote:
> This series enhances the iproute2 iplink module to add support
> for creating PRP device similar to HSR. The kernel part of this
> is already merged to v5.9 master
> 
> v5 - addressed comment from Stephen Hemminger
>     - Sending this with a iproute2 prefix so that this can
>       be merged to v5.9 iprout2 if possible.
> v3 of the series is rebased to iproute2-next/master at
> git://git.kernel.org/pub/scm/network/iproute2/iproute2-next
> and send as v4.
> 
> Please apply this if looks good.
> 
> 
> Murali Karicheri (2):
>    iplink: hsr: add support for creating PRP device similar to HSR
>    ip: iplink: prp: update man page for new parameter
> 
>   ip/iplink_hsr.c       | 17 +++++++++++++++--
>   man/man8/ip-link.8.in |  9 ++++++++-
>   2 files changed, 23 insertions(+), 3 deletions(-)
> 
Can we merge this version please?
-- 
Murali Karicheri
Texas Instruments
