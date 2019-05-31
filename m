Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFDF43187D
	for <lists+netdev@lfdr.de>; Sat,  1 Jun 2019 01:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbfEaX7q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 19:59:46 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:34120 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726550AbfEaX7p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 May 2019 19:59:45 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 7B0C36070D; Fri, 31 May 2019 23:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559347184;
        bh=tJJKl5ehmjDb2KK6XeMOmnd1rblvf2TEFa0oPKfTx5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DrR5If3bSV4UtULQl7DoeUdYH0qFStHS2EZNSIBc+cRSxZWIZArUiSxyvoPNOcyc+
         BV1zFF3oNDbjY01hii7pjCDzqV2bQY+v6PFLeGPMvyWpdx0LSzd0kKC/qtsqXQKFE2
         F9xYliUcplczYufvnmMhN9ZUuMk3PlzArFyOZXIM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 2C6286070D;
        Fri, 31 May 2019 23:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1559347183;
        bh=tJJKl5ehmjDb2KK6XeMOmnd1rblvf2TEFa0oPKfTx5A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JhHqfqgmdNVqLrmRdouTw0Seluy99Trhgv3NmXlFn69xRxPpycBc/Q+DRSfAeVwu4
         JTEboKLfLKX0c13lS4DlpcSurxqakUSwUHvxF/LXUHDnPuoHKctksui16YqOi10b83
         IBD+oLcK1w2+MnQzgPq0KGIsSeRbdNA1g0f1wxfU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 31 May 2019 17:59:43 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     Alex Elder <elder@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
        Dan Williams <dcbw@redhat.com>,
        David Miller <davem@davemloft.net>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        evgreen@chromium.org, Ben Chan <benchan@google.com>,
        Eric Caruso <ejcaruso@google.com>, cpratapa@codeaurora.org,
        syadagir@codeaurora.org, abhishek.esse@gmail.com,
        Networking <netdev@vger.kernel.org>,
        DTML <devicetree@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
In-Reply-To: <20190531233306.GB25597@minitux>
References: <20190531035348.7194-1-elder@linaro.org>
 <e75cd1c111233fdc05f47017046a6b0f0c97673a.camel@redhat.com>
 <065c95a8-7b17-495d-f225-36c46faccdd7@linaro.org>
 <CAK8P3a05CevRBV3ym+pnKmxv+A0_T+AtURW2L4doPAFzu3QcJw@mail.gmail.com>
 <a28c5e13-59bc-144d-4153-9d104cfa9188@linaro.org>
 <20190531233306.GB25597@minitux>
Message-ID: <d76a710d45dd7df3a28afb12fc62cf14@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019-05-31 17:33, Bjorn Andersson wrote:
> On Fri 31 May 13:47 PDT 2019, Alex Elder wrote:
> 
>> On 5/31/19 2:19 PM, Arnd Bergmann wrote:
>> > On Fri, May 31, 2019 at 6:36 PM Alex Elder <elder@linaro.org> wrote:
>> >> On 5/31/19 9:58 AM, Dan Williams wrote:
>> >>> On Thu, 2019-05-30 at 22:53 -0500, Alex Elder wrote:
>> >>>
>> >>> My question from the Nov 2018 IPA rmnet driver still stands; how does
>> >>> this relate to net/ethernet/qualcomm/rmnet/ if at all? And if this is
>> >>> really just a netdev talking to the IPA itself and unrelated to
>> >>> net/ethernet/qualcomm/rmnet, let's call it "ipa%d" and stop cargo-
>> >>> culting rmnet around just because it happens to be a net driver for a
>> >>> QC SoC.
>> >>
>> >> First, the relationship between the IPA driver and the rmnet driver
>> >> is that the IPA driver is assumed to sit between the rmnet driver
>> >> and the hardware.
>> >
>> > Does this mean that IPA can only be used to back rmnet, and rmnet
>> > can only be used on top of IPA, or can or both of them be combined
>> > with another driver to talk to instead?
>> 
>> No it does not mean that.
>> 
>> As I understand it, one reason for the rmnet layer was to abstract
>> the back end, which would allow using a modem, or using something
>> else (a LAN?), without exposing certain details of the hardware.
>> (Perhaps to support multiplexing, etc. without duplicating that
>> logic in two "back-end" drivers?)
>> 
>> To be perfectly honest, at first I thought having IPA use rmnet
>> was a cargo cult thing like Dan suggested, because I didn't see
>> the benefit.  I now see why one would use that pass-through layer
>> to handle the QMAP features.
>> 
>> But back to your question.  The other thing is that I see no
>> reason the IPA couldn't present a "normal" (non QMAP) interface
>> for a modem.  It's something I'd really like to be able to do,
>> but I can't do it without having the modem firmware change its
>> configuration for these endpoints.  My access to the people who
>> implement the modem firmware has been very limited (something
>> I hope to improve), and unless and until I can get corresponding
>> changes on the modem side to implement connections that don't
>> use QMAP, I can't implement such a thing.
>> 
> 
> But any such changes would either be years into the future or for
> specific devices and as such not applicable to any/most of devices on
> the market now or in the coming years.
> 
> 
> But as Arnd points out, if the software split between IPA and rmnet is
> suboptimal your are encouraged to fix that.
> 
> Regards,
> Bjorn

The split rmnet design was chosen because we could place rmnet
over any transport - IPA, PCIe (https://lkml.org/lkml/2018/4/26/1159)
or USB.

rmnet registers a rx handler, so the rmnet packet processing itself
happens in the same softirq when packets are queued to network stack
by IPA.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
