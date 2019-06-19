Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97B074C109
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 20:47:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730224AbfFSSro (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 14:47:44 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:52672 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726175AbfFSSro (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 14:47:44 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BFC886063F; Wed, 19 Jun 2019 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560970062;
        bh=1yZ8gW4omtDGb+oqxDGLEnHBunqq4YkklbYTCwDXY3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kQIh5jOa/cXWbooFqk3WCsn70ABRuoV0jnfVYeJSkyHfIFkju+3qmGPNMdevfks3e
         f2aBzUFDFi1wJmBElItePeSJlBzfqspKFXRjp/1g9ElfshPGiseUjQG0rTGega79Xr
         IfBUZMyHrJlFlYzC6kSekM3CXRd102LAksKVSjrU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id DADCA6063F;
        Wed, 19 Jun 2019 18:47:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1560970061;
        bh=1yZ8gW4omtDGb+oqxDGLEnHBunqq4YkklbYTCwDXY3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EYJPfomCH0dyi8k+h1DqgHcD2V+VGlCjTr2UW5kMNzdEfu1KOLIsNdJLhoktaOzmA
         m/h33t+EefNSvWuAkeKELMtnzWcc+qBxt8d9cgJtkGZ48T9SKBFnd9AXK8qipv82lA
         v0cg/okvJwlKbZsTmYQvUj8EwjwxzJTMZbjQGxjY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 19 Jun 2019 12:47:41 -0600
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Alex Elder <elder@linaro.org>, abhishek.esse@gmail.com,
        Ben Chan <benchan@google.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        cpratapa@codeaurora.org, David Miller <davem@davemloft.net>,
        Dan Williams <dcbw@redhat.com>,
        DTML <devicetree@vger.kernel.org>,
        Eric Caruso <ejcaruso@google.com>, evgreen@chromium.org,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-soc@vger.kernel.org, Networking <netdev@vger.kernel.org>,
        syadagir@codeaurora.org
Subject: Re: [PATCH v2 00/17] net: introduce Qualcomm IPA driver
In-Reply-To: <CAK8P3a3e+U85yHTeE4dHa4okLVHgBd8Kke9=FytzvMwz+wB0sQ@mail.gmail.com>
References: <380a6185-7ad1-6be0-060b-e6e5d4126917@linaro.org>
 <a94676381a5ca662c848f7a725562f721c43ce76.camel@sipsolutions.net>
 <CAK8P3a0kV-i7BJJ2X6C=5n65rSGfo8fUiC4J_G-+M8EctYKbkg@mail.gmail.com>
 <066e9b39f937586f0f922abf801351553ec2ba1d.camel@sipsolutions.net>
 <b3686626-e2d8-bc9c-6dd0-9ebb137715af@linaro.org>
 <b23a83c18055470c5308fcd1eed018056371fc1d.camel@sipsolutions.net>
 <CAK8P3a1FeUQR3pgoQxHoRK05JGORyR+TFATVQiijLWtFKTv6OQ@mail.gmail.com>
 <613cdfde488eb23d7207c7ba6258662702d04840.camel@sipsolutions.net>
 <CAK8P3a2onXpxiE4y9PzRwuPM2dh=h_BKz7Eb0=LLPgBbZoK1bQ@mail.gmail.com>
 <6c70950d0c78bc02a3d016918ec3929e@codeaurora.org>
 <CAK8P3a3e+U85yHTeE4dHa4okLVHgBd8Kke9=FytzvMwz+wB0sQ@mail.gmail.com>
Message-ID: <2926e45fd7ff62fd7c4af9b338bf0caa@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> There is a n:1 relationship between rmnet and IPA.
>> rmnet does the de-muxing to multiple netdevs based on the mux id
>> in the MAP header for RX packets and vice versa.
> 
> Oh, so you mean that even though IPA supports multiple channels
> and multiple netdev instances for a physical device, all the
> rmnet devices end up being thrown into a single channel in IPA?
> 
> What are the other channels for in IPA? I understand that there
> is one channel for commands that is separate, while the others
> are for network devices, but that seems to make no sense if
> we only use a single channel for rmnet data.
> 

AFAIK, the other channels are for use cases like tethering.
There is only a single channel which is used for RX
data which is then de-muxed using rmnet.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
