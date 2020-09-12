Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1483267B2D
	for <lists+netdev@lfdr.de>; Sat, 12 Sep 2020 17:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgILPH4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Sep 2020 11:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725850AbgILPHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Sep 2020 11:07:53 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98456C061573;
        Sat, 12 Sep 2020 08:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=ns0xiwrnJendxN6CLtcox2ImSbCLh3e9jw5WmzFYNI8=; b=Fe2I67kfkTO1R1g0KBKMpXFStG
        gJc/PLRzuGX0cfpNiI1WuH3686jPQc1haYhCarW5LvrlrUuBr10pm0FsC2DKZLyoM1bz/LwGASQ8Z
        eijcOqVQp0I7ZRWAvFqCT9WxYyOLzLSRGscWvL6ZKFDvL7E5BG0PmP0SCK9BRM1djmTVe+b9Fu8As
        behoGvhI9TeXgjpySNZUEAKWkhVejYhxbmZqV7sz2wrEeiYXZKMbRS/3a0JorZU+hxlZF3Sb8zCeF
        luEX4WoUrRmncQb7t9HdIDLpIvlmZ/IddF0H38srMkHHJHou+GSWoVs/tAM6/ONeI01jWJPGsWr7y
        yClvn3RQ==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kH77t-0004Fq-M6; Sat, 12 Sep 2020 15:07:41 +0000
Subject: Re: [PATCH v2 08/14] habanalabs/gaudi: add a new IOCTL for NIC
 control operations
To:     Oded Gabbay <oded.gabbay@gmail.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     SW_Drivers@habana.ai, gregkh@linuxfoundation.org,
        davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Omer Shpigelman <oshpigelman@habana.ai>
References: <20200912144106.11799-1-oded.gabbay@gmail.com>
 <20200912144106.11799-9-oded.gabbay@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <59a861d7-86e5-d806-a195-fd229d27ffb4@infradead.org>
Date:   Sat, 12 Sep 2020 08:07:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200912144106.11799-9-oded.gabbay@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 9/12/20 7:41 AM, Oded Gabbay wrote:
> +#define HL_IOCTL_NIC	_IOWR('H', 0x07, struct hl_nic_args)


ioctl numbers ('H') should be documented in
Documentation/userspace-api/ioctl/ioctl-number.rst

Sorry if I missed seeing that. (I scanned quickly.)

thanks.

-- 
~Randy

