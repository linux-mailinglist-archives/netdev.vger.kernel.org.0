Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA98484E63
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 07:31:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232629AbiAEGbR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 01:31:17 -0500
Received: from smtp02.smtpout.orange.fr ([80.12.242.124]:57660 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232333AbiAEGbQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 01:31:16 -0500
Received: from [192.168.1.18] ([90.11.185.88])
        by smtp.orange.fr with ESMTPA
        id 4zpGnt6LQBazo4zpGny1Ls; Wed, 05 Jan 2022 07:31:14 +0100
X-ME-Helo: [192.168.1.18]
X-ME-Auth: YWZlNiIxYWMyZDliZWIzOTcwYTEyYzlhMmU3ZiQ1M2U2MzfzZDfyZTMxZTBkMTYyNDBjNDJlZmQ3ZQ==
X-ME-Date: Wed, 05 Jan 2022 07:31:14 +0100
X-ME-IP: 90.11.185.88
Message-ID: <9b93f495-2bfe-1ade-141b-69c4842aee8e@wanadoo.fr>
Date:   Wed, 5 Jan 2022 07:31:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [Intel-wired-lan] [PATCH] intel: Simplify DMA setting
Content-Language: en-US
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "Lobakin, Alexandr" <alexandr.lobakin@intel.com>
Cc:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <c7a34d0096eb4ba98dd9ce5b64ba079126cab708.1641255235.git.christophe.jaillet@wanadoo.fr>
 <20220104132936.252202-1-alexandr.lobakin@intel.com>
 <c258c3bb440b88e984b0385af8ffb38a017ba644.camel@intel.com>
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
In-Reply-To: <c258c3bb440b88e984b0385af8ffb38a017ba644.camel@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le 04/01/2022 à 22:56, Nguyen, Anthony L a écrit :
> On Tue, 2022-01-04 at 14:29 +0100, Alexander Lobakin wrote:
>> From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
>> Date: Tue, 4 Jan 2022 01:15:20 +0100
>>
>> Reviewed-by: Alexander Lobakin <alexandr.lobakin@intel.com>
>>
>> Tony might ask to split it into per-driver patches tho, will see.
> 
> Hi Christophe,
> 
> As mentioned by others, would mind breaking these per-driver?
> 
> Thanks,
> Tony
> 

I'll do, but to much bureaucracy will kill us all.

CJ

>>
>> --- 8< ---
>>
>> Al
> 

