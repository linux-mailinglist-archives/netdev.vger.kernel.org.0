Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34856202B4A
	for <lists+netdev@lfdr.de>; Sun, 21 Jun 2020 17:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgFUPNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jun 2020 11:13:06 -0400
Received: from nbd.name ([46.4.11.11]:43154 "EHLO nbd.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730255AbgFUPNG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jun 2020 11:13:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=djo7iQgt66wMkSN4g+R/vgINg3CHs19houvzuc155RI=; b=GzeA4Y5QT+MeNKQgGUfqRmFXSH
        YTmMVsAt1XycRAXc7Yd1Y1pg9HCnb7mQi4xhJvoe/IGV3PWHGk42nRFAc8QuKYa+NkyU7Fo0u6sik
        aU+HaI+IPnmGkJnTC9eAfGroefHK7EFThHgWW+si9EtzkQCn4YJy4+zkiyFcm3lENG4k=;
Received: from p54ae948c.dip0.t-ipconnect.de ([84.174.148.140] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1jn1eM-0003U8-7O; Sun, 21 Jun 2020 17:12:50 +0200
Subject: Re: [PATCH] MAINTAINERS: remove Felix Fietkau for the Mediatek
 ethernet driver
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Jakub Kicinski <kuba@kernel.org>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20200218103959.GA9487@e0022681537dd.dyn.armlinux.org.uk>
 <20200218120036.380a5a16@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
 <6ec21622-f9fe-8cf9-0464-7f5e4bb0a47e@nbd.name>
 <20200621144436.GJ1605@shell.armlinux.org.uk>
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
Message-ID: <500d561a-2f50-0d87-53cf-12c90d717e4b@nbd.name>
Date:   Sun, 21 Jun 2020 17:12:49 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200621144436.GJ1605@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-06-21 16:44, Russell King - ARM Linux admin wrote:
> On Thu, Feb 20, 2020 at 09:54:44AM +0100, Felix Fietkau wrote:
>> On 2020-02-18 21:00, Jakub Kicinski wrote:
>> > On Tue, 18 Feb 2020 10:40:01 +0000 Russell King wrote:
>> >> Felix's address has been failing for a while now with the following
>> >> non-delivery report:
>> >> 
>> >> This message was created automatically by mail delivery software.
>> >> 
>> >> A message that you sent could not be delivered to one or more of its
>> >> recipients. This is a permanent error. The following address(es) failed:
>> >> 
>> >>   nbd@openwrt.org
>> >>     host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
>> >>     SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
>> >>     550 Unrouteable address
>> >> 
>> >> Let's remove his address from MAINTAINERS.  If a different resolution
>> >> is desired, please submit an alternative patch.
>> >> 
>> >> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
>> >> ---
>> >>  MAINTAINERS | 1 -
>> >>  1 file changed, 1 deletion(-)
>> >> 
>> >> diff --git a/MAINTAINERS b/MAINTAINERS
>> >> index a0d86490c2c6..82dccd29b24f 100644
>> >> --- a/MAINTAINERS
>> >> +++ b/MAINTAINERS
>> >> @@ -10528,7 +10528,6 @@ F:	drivers/leds/leds-mt6323.c
>> >>  F:	Documentation/devicetree/bindings/leds/leds-mt6323.txt
>> >>  
>> >>  MEDIATEK ETHERNET DRIVER
>> >> -M:	Felix Fietkau <nbd@openwrt.org>
>> >>  M:	John Crispin <john@phrozen.org>
>> >>  M:	Sean Wang <sean.wang@mediatek.com>
>> >>  M:	Mark Lee <Mark-MC.Lee@mediatek.com>
>> > 
>> > Let's CC Felix, I think he's using nbd@nbd.name these days.
>> Yes, my address should simply be changed to nbd@nbd.name.
>> 
>> Thanks,
> 
> And _still_, in next-next, four months on, your MAINTAINERS entry is
> still incorrect.
> 
> Can someone please merge my patch so I'm not confronted by bounces
> due to this incorrect entry?  I really don't see why I should be
> the one to provide a patch to correct Felix's address - that's for
> Felix himself to do, especially as he has already been made aware
> of the issue.
I forgot to take care of this, sorry about that. I just sent a patch to
netdev to update the address.

- Felix
