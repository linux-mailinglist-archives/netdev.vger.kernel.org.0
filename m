Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED5481229C1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 12:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727473AbfLQLUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 06:20:51 -0500
Received: from nbd.name ([46.4.11.11]:57510 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727161AbfLQLUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 06:20:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=hmLV8T0pAGdd3zLpLnRj4IfM+23QZs7dg/vaDrnwqec=; b=K4SSbBRtn4VJ49BTcWI/GGlegS
        0VIr6sP/TsPpoflU5+AKXQA3TD53gsVHlJYxiGVTKDi4H2AakE1yXR8bVLIzTrmuovYpPjyvTBgUd
        cfd7zqYLuKrejRNQDMrrFUXHLVDVfqGK+oIvXrfnSvDkki8nk0iyO76ewiQheXefoS30=;
Received: from [178.162.209.142] (helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1ihAu9-00082V-80; Tue, 17 Dec 2019 12:20:41 +0100
Subject: Re: [PATCH 07/55] staging: wfx: ensure that retry policy always
 fallbacks to MCS0 / 1Mbps
To:     =?UTF-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Cc:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
References: <20191216170302.29543-1-Jerome.Pouiller@silabs.com>
 <20191216170302.29543-8-Jerome.Pouiller@silabs.com>
 <0777ef33-e1f4-148a-40cb-cfe7b42d5364@nbd.name> <3755885.sodJc2dsoe@pc-42>
From:   Felix Fietkau <nbd@nbd.name>
Autocrypt: addr=nbd@nbd.name; prefer-encrypt=mutual; keydata=
 xsDiBEah5CcRBADIY7pu4LIv3jBlyQ/2u87iIZGe6f0f8pyB4UjzfJNXhJb8JylYYRzIOSxh
 ExKsdLCnJqsG1PY1mqTtoG8sONpwsHr2oJ4itjcGHfn5NJSUGTbtbbxLro13tHkGFCoCr4Z5
 Pv+XRgiANSpYlIigiMbOkide6wbggQK32tC20QxUIwCg4k6dtV/4kwEeiOUfErq00TVqIiEE
 AKcUi4taOuh/PQWx/Ujjl/P1LfJXqLKRPa8PwD4j2yjoc9l+7LptSxJThL9KSu6gtXQjcoR2
 vCK0OeYJhgO4kYMI78h1TSaxmtImEAnjFPYJYVsxrhay92jisYc7z5R/76AaELfF6RCjjGeP
 wdalulG+erWju710Bif7E1yjYVWeA/9Wd1lsOmx6uwwYgNqoFtcAunDaMKi9xVQW18FsUusM
 TdRvTZLBpoUAy+MajAL+R73TwLq3LnKpIcCwftyQXK5pEDKq57OhxJVv1Q8XkA9Dn1SBOjNB
 l25vJDFAT9ntp9THeDD2fv15yk4EKpWhu4H00/YX8KkhFsrtUs69+vZQwc0cRmVsaXggRmll
 dGthdSA8bmJkQG5iZC5uYW1lPsJgBBMRAgAgBQJGoeQnAhsjBgsJCAcDAgQVAggDBBYCAwEC
 HgECF4AACgkQ130UHQKnbvXsvgCgjsAIIOsY7xZ8VcSm7NABpi91yTMAniMMmH7FRenEAYMa
 VrwYTIThkTlQzsFNBEah5FQQCACMIep/hTzgPZ9HbCTKm9xN4bZX0JjrqjFem1Nxf3MBM5vN
 CYGBn8F4sGIzPmLhl4xFeq3k5irVg/YvxSDbQN6NJv8o+tP6zsMeWX2JjtV0P4aDIN1pK2/w
 VxcicArw0VYdv2ZCarccFBgH2a6GjswqlCqVM3gNIMI8ikzenKcso8YErGGiKYeMEZLwHaxE
 Y7mTPuOTrWL8uWWRL5mVjhZEVvDez6em/OYvzBwbkhImrryF29e3Po2cfY2n7EKjjr3/141K
 DHBBdgXlPNfDwROnA5ugjjEBjwkwBQqPpDA7AYPvpHh5vLbZnVGu5CwG7NAsrb2isRmjYoqk
 wu++3117AAMFB/9S0Sj7qFFQcD4laADVsabTpNNpaV4wAgVTRHKV/kC9luItzwDnUcsZUPdQ
 f3MueRJ3jIHU0UmRBG3uQftqbZJj3ikhnfvyLmkCNe+/hXhPu9sGvXyi2D4vszICvc1KL4RD
 aLSrOsROx22eZ26KqcW4ny7+va2FnvjsZgI8h4sDmaLzKczVRIiLITiMpLFEU/VoSv0m1F4B
 FtRgoiyjFzigWG0MsTdAN6FJzGh4mWWGIlE7o5JraNhnTd+yTUIPtw3ym6l8P+gbvfoZida0
 TspgwBWLnXQvP5EDvlZnNaKa/3oBes6z0QdaSOwZCRA3QSLHBwtgUsrT6RxRSweLrcabwkkE
 GBECAAkFAkah5FQCGwwACgkQ130UHQKnbvW2GgCfTKx80VvCR/PvsUlrvdOLsIgeRGAAn1ee
 RjMaxwtSdaCKMw3j33ZbsWS4
Message-ID: <f5a6b1b4-6000-04c9-f3a6-c2be8e5dcc61@nbd.name>
Date:   Tue, 17 Dec 2019 12:20:40 +0100
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <3755885.sodJc2dsoe@pc-42>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Jérôme,

On 2019-12-17 12:01, Jérôme Pouiller wrote:
> On Monday 16 December 2019 19:08:39 CET Felix Fietkau wrote:
>> On 2019-12-16 18:03, Jérôme Pouiller wrote:
>> > From: Jérôme Pouiller <jerome.pouiller@silabs.com>
>> >
>> > When not using HT mode, minstrel always includes 1Mbps as fallback rate.
>> > But, when using HT mode, this fallback is not included. Yet, it seems
>> > that it could save some frames. So, this patch add it unconditionally.
>> >
>> > Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
>> Are you sure that's a good idea? Sometimes a little packet loss can be
>> preferable over a larger amount of airtime wasted through using really
>> low rates. Especially when you consider bufferbloat.
> I have observed that, in some circumstances, TCP throughput was far 
> better with 802.11g than with 802.11n. I found that 802.11n had more Tx 
> failures. These failures have big impacts on the congestion window. When 
> the congestion window is low, it impacts the capacity of aggregation of 
> the link. Thus, it does not help to improve the congestion windows.
> 
> By investigating deeper, it appears that the minstrel (used by 802.11g)
> always add rate 1Mbps to the rate list while minstrel_ht (used by
> 802.11n) don't (compare minstrel_update_rates() and
> minstrel_ht_update_rates()). This difference seems to be correlated to
> the difference of TCP throughput I can observe.
> 
> I did some search in git history and I did not find any explanation for 
> this difference between minstrel and minstrel_ht (however, it seems you 
> are the right person to ask :) ). I didn't find why it would be
> efficient on minstrel and inefficient on minstrel_ht. And since this
> change fix the issue that I observed, I have tried to apply it and wait
> for feedback.
I have found that in many cases when minstrel_ht selects sub-optimal
rates that cause too many re-transmissions or re-transmission failures,
it was because there was an issue in tx status reporting.
Another possible reason is buffering too many packets without having the
ability to alter the rates for in-flight packets based on bad tx status
results.
To find out what the driver/hardware is doing, I took a quick look and
it seems to be managing multiple tx rate policies based on per-packet
rate info. Based on that I have an idea of what you could try to make
things better:
Instead of using per-packet rate info, implement the
.sta_rate_tbl_update callback to maintain a primary tx policy used for
all non-probing non-fixed-rate packets, which you can alter while
packets using it are queued already.
The existing approach using per-packet tx_info data should then be used
only for probing or fixed-rate packets.
You then probably have to be a bit clever in the tx status path for
figuring out what rates were actually used.

- Felix
