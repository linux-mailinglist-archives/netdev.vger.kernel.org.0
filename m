Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C90449DEEF
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 11:14:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232712AbiA0KOb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 05:14:31 -0500
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:59870
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229518AbiA0KOb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 05:14:31 -0500
Received: from [192.168.1.9] (unknown [222.129.35.96])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id 0957F3F336;
        Thu, 27 Jan 2022 10:14:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1643278469;
        bh=B7XWtDPVFpdv23EpjWRaYlK3xfQcvW6SrE+CKuoYqBg=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=mqyQ2xuvMdVBoVdv50FL9fafQQh5ywYnm3cdnTtKaBO3pBcGTTH5ZfZHOGf3PykO2
         nArGyJtfQVRarvtpkL5TjzR9BgWSiRPiih0We9eFD5HvaYGZdnAR4iXm9wU4M2Ysrg
         AqyZgB88sChq/d+8Ff70QwDFyocJtC3WAApIMhScZlndLy/1F0BdMs12Lk8F4hyoIw
         ioJTRGsVYx+1CtMPEjvMmcb3QGozV7zBkL4EMTGVfZZgIRsaPZEs2KqlcPEG1RDDOw
         SGzcCsyOT7RB5avhcDYO/XOlwSZdaG2NNf/C8hZCnJ7jSQTRk+1ew/0KKyxw1ulhBF
         Bpy3Q96yAfDQw==
Message-ID: <4ba77e39-93e7-9263-0a3a-57695e4ad945@canonical.com>
Date:   Thu, 27 Jan 2022 18:14:19 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] net: usb: r8152: Add MAC passthrough support for
 RTL8153BL
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Mario.Limonciello@amd.com, kuba@kernel.org,
        henning.schild@siemens.com, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, tiwai@suse.de
References: <20220127100109.12979-1-aaron.ma@canonical.com>
 <YfJvhItQAmRJrool@kroah.com>
From:   Aaron Ma <aaron.ma@canonical.com>
In-Reply-To: <YfJvhItQAmRJrool@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/27/22 18:10, Greg KH wrote:
>> +#define BL_MASK                 BIT(3)
> No tab?:(
> 

My bad, vim paste.
Allow me to fix it v2.

Aaron
