Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65DFE1D7A10
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 15:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgERNgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 09:36:54 -0400
Received: from lelv0143.ext.ti.com ([198.47.23.248]:52406 "EHLO
        lelv0143.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726918AbgERNgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 09:36:53 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0143.ext.ti.com (8.15.2/8.15.2) with ESMTP id 04IDahY6089771;
        Mon, 18 May 2020 08:36:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1589809003;
        bh=gKUJRSdjNQnlN2s5eKUQq+ubvPAIsEetXhJ0LY3JnRs=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=JxJEvVRg6rhpU1e8wZ1P2Wkjnk36DLCS8NEhoL+sj+4Uh21dymHODRk87ZNsUhQVR
         6NXNEqnxBSwigmpSvxwMFYzbx4N27KzgtxylS4Bl7GV5sb3LSJn84HHvw4g8Pzcwoi
         ShkQS/XMMy0Jo8UPF4vHbUisCG0cHif5SiVC0YpQ=
Received: from DLEE100.ent.ti.com (dlee100.ent.ti.com [157.170.170.30])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04IDahmv112525;
        Mon, 18 May 2020 08:36:43 -0500
Received: from DLEE105.ent.ti.com (157.170.170.35) by DLEE100.ent.ti.com
 (157.170.170.30) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Mon, 18
 May 2020 08:36:42 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE105.ent.ti.com
 (157.170.170.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Mon, 18 May 2020 08:36:42 -0500
Received: from [10.250.74.234] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 04IDagxD025637;
        Mon, 18 May 2020 08:36:42 -0500
Subject: Re: [next-queue RFC 0/4] ethtool: Add support for frame preemption
To:     Michael Walle <michael@walle.cc>,
        Vinicius Costa Gomes <vinicius.gomes@intel.com>
CC:     <jeffrey.t.kirsher@intel.com>, <netdev@vger.kernel.org>,
        <vladimir.oltean@nxp.com>, <po.liu@nxp.com>,
        <Jose.Abreu@synopsys.com>
References: <20200516012948.3173993-1-vinicius.gomes@intel.com>
 <20200517170601.31832446@apollo>
From:   Murali Karicheri <m-karicheri2@ti.com>
Message-ID: <6e26814b-242e-b60b-a9b5-6ed6608d0fce@ti.com>
Date:   Mon, 18 May 2020 09:36:42 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200517170601.31832446@apollo>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 5/17/20 11:06 AM, Michael Walle wrote:
> What about the Qbu handshake state? And some NICs support overriding
> this. I.e. enable frame preemption even if the handshake wasn't
> successful.

You are talking about Verify procedure to hand shake with peer to
know if remote support IET fragmentation and re-assembly? If yes,
this manual mode of provisioning is required as well. So one
optional parameter needed is enable-verify. If that is not enabled
then device assumes the remote is capable of fragmentation and
re-assembly.

-- 
Murali Karicheri
Texas Instruments
