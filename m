Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F30077592
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 03:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387457AbfG0BP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 21:15:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50438 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfG0BP6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 21:15:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5BEDD605FE; Sat, 27 Jul 2019 01:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564190157;
        bh=qsbw5+cS65oYX+84bRq5psMv6Kp8aHFt76f38HF5E4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IFbKm07X55NB0NhpSg31jYRGsOBriHVFcMStcYvPN7XO4EbCvHjSJmMAb9mabiE28
         9E1/ZLyvfQNETXIDPgc19890qG5GCMieYLA4KeBJmE1g218BCceVE/i+4q4kBHu0/+
         brgdBRe1Xrbd5ctPew4kvwvEsUZbKhCeRyI0me0M=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DAC06602B7;
        Sat, 27 Jul 2019 01:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1564190156;
        bh=qsbw5+cS65oYX+84bRq5psMv6Kp8aHFt76f38HF5E4w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Em4PCW0oqfi25wnJZVDWFpbOt9aAqTDyEh0M2OvkjP8CMNFzvAzCaI7mkrKfWAzHH
         Cbgti3y5T/c6GZoSrq3kDOfiQuzU8BbIApPFx9lPTqbuYEji6CewRvsWcFAEefNJ6q
         ry/12f+Qza86RUbLkz1HhckJojoipiePcCDd+IKI=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sat, 27 Jul 2019 09:15:56 +0800
From:   xiaofeis@codeaurora.org
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     vkoul@kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] net: dsa: qca8k: enable port flow control
In-Reply-To: <20190726132919.GB18223@lunn.ch>
References: <1563944576-62844-1-git-send-email-xiaofeis@codeaurora.org>
 <20190724175031.GA28488@lunn.ch>
 <351b5292d597e47d69d0dcfd5af6a188@codeaurora.org>
 <20190725130135.GA21952@lunn.ch>
 <e2c51913e0e38450b09ef8f06bf259c0@codeaurora.org>
 <20190726132919.GB18223@lunn.ch>
Message-ID: <2e2b0d3962d387046ae430be61acbf44@codeaurora.org>
X-Sender: xiaofeis@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-07-26 21:29, Andrew Lunn wrote:
>> I didn't compile it on this tree, same code is just compiled and 
>> tested on
>> kernel v4.14.
> 
> For kernel development work, v4.14 is dead. It died 12th November
> 2017. It gets backports of bug fixes, but kernel developers otherwise
> don't touch it.
> 
>> We are working on one google project, all the change is
>> required to upstream by Google.
>> But if I do the change based on the new type for kernel 5.3, then the 
>> commit
>> can't be used directly for Google's project.
> 
> So you will need to backport the change. In this case, you will have a
> very different patch in v4.14 than in mainline, due to changes like
> this. That is part of the pain in using such an old kernel.
> 
> You should use the function
> 
> void phy_support_asym_pause(struct phy_device *phydev);
> 
> to indicate the MAC supports asym pause.
> 
>    Andrew

Hi Andrew

Thanks a lot, you are correct. phy_support_asym_pause is the API to do 
this.

Very appreciate for all your patinet explaination and good suggestion.

Thanks
Xiaofeis
