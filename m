Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2DD117422
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 19:26:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726874AbfLIS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 13:26:01 -0500
Received: from lelv0142.ext.ti.com ([198.47.23.249]:46356 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726631AbfLIS0A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 13:26:00 -0500
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id xB9IPtM9095286;
        Mon, 9 Dec 2019 12:25:55 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1575915955;
        bh=wHjPXA26kNlnCk1JrNudGWLJavjZeOcEMg0UiUtbdZ8=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=dym3GMJQR0LJ3UuJ6i408gxdRMDtMZD5zTxWSbnrjkuG+QTkTXZLvYVt8b9H/xoOL
         ItOs1wwi2IciH1iaNPXfrfWcXDMjfl+67I6wfTwAWLyDL2cplKYfWwFxiPQxZZy1Dq
         JBj1faQQC+Iv4gMz5gD4BnoQ1pCwkZDtKfcKngqs=
Received: from DFLE113.ent.ti.com (dfle113.ent.ti.com [10.64.6.34])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id xB9IPsIO055343
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 9 Dec 2019 12:25:55 -0600
Received: from DFLE110.ent.ti.com (10.64.6.31) by DFLE113.ent.ti.com
 (10.64.6.34) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 9 Dec
 2019 12:25:54 -0600
Received: from lelv0327.itg.ti.com (10.180.67.183) by DFLE110.ent.ti.com
 (10.64.6.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 9 Dec 2019 12:25:54 -0600
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id xB9IPsad010705;
        Mon, 9 Dec 2019 12:25:54 -0600
Subject: Re: [PATCH net-next v2 0/2] Rebase of patches
To:     David Miller <davem@davemloft.net>
CC:     <andrew@lunn.ch>, <f.fainelli@gmail.com>, <hkallweit1@gmail.com>,
        <bunk@kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grygorii.strashko@ti.com>
References: <20191209175943.23110-1-dmurphy@ti.com>
 <20191209.101005.1980841296607612612.davem@davemloft.net>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <898c9346-311e-4c93-9f83-afe255b54243@ti.com>
Date:   Mon, 9 Dec 2019 12:23:46 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191209.101005.1980841296607612612.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

David

On 12/9/19 12:10 PM, David Miller wrote:
> From: Dan Murphy <dmurphy@ti.com>
> Date: Mon, 9 Dec 2019 11:59:41 -0600
>
>> This is a rebase of the dp83867 patches on top of the net-next tree
> That's not what this patch series does.
>
> The introductory posting is where you describe, at a high level, what the
> whole patch series is doing as a unit, how it is doing it, and why it is
> doing it that way.
>
> It also serves as the single email I can respond to when I want to let you
> know that I've applied the patch series.
>
> Please read the documentation under Documentation/ if you still are unsure
> what this introductory posting is all about and how you should compose one.
>
> Thank you.

I understand what a cover letter is.

I don't normally see cover letters required for small patchsets like 
this in other trees.  The commit messages should explain in detail what 
is being changed as the cover letters are not committed to the kernel.  
I only add cover letters when the patchsets are significant, per the 
Documentation/ you eluded to.

But if you require this for the linux net tree then I can add them as I 
move forward it is not a problem either way.

Dan


