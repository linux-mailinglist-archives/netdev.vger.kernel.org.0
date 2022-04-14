Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DC37501AF8
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 20:22:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244650AbiDNSYh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 14:24:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243914AbiDNSYg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 14:24:36 -0400
Received: from mail-lj1-x236.google.com (mail-lj1-x236.google.com [IPv6:2a00:1450:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9005B645E;
        Thu, 14 Apr 2022 11:22:10 -0700 (PDT)
Received: by mail-lj1-x236.google.com with SMTP id 15so7068410ljw.8;
        Thu, 14 Apr 2022 11:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=bZRq3oZhUdWM7gotP1i/Bzhd8FwXVmJKlpEbuaU9E70=;
        b=RbkSxphZC1+PfPjuq7th0mCg7rl5O1p6S2Y1dozh+P1yhRJutgNhLWnAEVy1odmFFc
         9SiuzS4AkV62jW0bMYsHo7TLHVN/c+7vFd+P7HmgLr+3PsK79uKCYNfvmrsWaN25Rw3I
         5P3CVfuPaWCNBiDn6AMXsPR5j7CWbsBBNRuu/86rwpNb/xwJW/31iLFGaVf/qUQp9gg3
         NlfwSRATcnBGIoLb/uUYv6ScsbJe2JbEWxHA+vgy0qZrk5uz34rnOm5YmdtI3qcIs9/k
         H2hVr6M3zz7U2wpeiqlQLHcXuCe07uPizBv+GkIRQ4+KwUBVb1YZleMvxVcU4Jg1PAJA
         4h5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=bZRq3oZhUdWM7gotP1i/Bzhd8FwXVmJKlpEbuaU9E70=;
        b=15V648oVigSXanTslayohCg0S/1HaFYymPj53LSLhpcBkyclEtoQc0V+KvJnv5Q0IC
         m3Ej2xZ4HVzi0ylrciEB5/K+de5y8y0ZBtBt+ymlcAQF2ATLtfipGPgeKPLBoH0v9zC2
         iWafwlGiJxOaX0WZ1c2UdFxlRMC3Selx26evH++T9+kRU06/YbVTToiuWnBzdBygWw/0
         kRsb9kwjG8roTEJ+rsXe7z4YMvZu2fSm0odOScPICMus6QCsAxu5Q97JGJc8xuaGDbdw
         jMT2wlsG8Zm6yqc5lHixQG3C2YKk6iN1PO5IDkpUoWfwt821SQIztXOPG0RtCmP5kuNV
         q3DA==
X-Gm-Message-State: AOAM530DtmART9QBipuTJwhCz5Z4lMoaimdQFtip3TjkDBuQHGcfZUpA
        lp840xyhqHqTzQvcA3m2QA3K7OrGSzqefWlD4wcL4CjNF4Q=
X-Google-Smtp-Source: ABdhPJzdR7mcr/SyAmuNMV8NMAWpk3ps0biU05hpbUXl8no8U+aWyizyZ1JvmS5AVU4ZTOANZXpj5XPBh1kNlxGGI3o=
X-Received: by 2002:a2e:93d5:0:b0:24b:5637:bbde with SMTP id
 p21-20020a2e93d5000000b0024b5637bbdemr2275131ljh.256.1649960529062; Thu, 14
 Apr 2022 11:22:09 -0700 (PDT)
MIME-Version: 1.0
References: <CAD56B7dMg073f56vfaxp38=dZiAFU0iCn6kmDGiNcNtCijyFoA@mail.gmail.com>
 <c2e2c7b0-cdfb-8eb0-9550-0fb59b5cd10c@hartkopp.net>
In-Reply-To: <c2e2c7b0-cdfb-8eb0-9550-0fb59b5cd10c@hartkopp.net>
From:   Paul Thomas <pthomas8589@gmail.com>
Date:   Thu, 14 Apr 2022 14:21:57 -0400
Message-ID: <CAD56B7ebyPr8h2J8WCV9rBXr9LFeakB6DV1Sk2hBYdY7OEJkyA@mail.gmail.com>
Subject: Re: peak_usb: urb aborted
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     linux-can@vger.kernel.org,
        =?UTF-8?Q?St=C3=A9phane_Grosjean?= <s.grosjean@peak-system.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        support@peak-system.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On 08.04.22 18:35, Paul Thomas wrote:
> > Folks,
> >
> > I'm using a PCAN-USB adapter, and it seems to have a lot of trouble
> > under medium load. I'm getting these urb aborted messages.
> > [125054.082248] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-71)
> > [125077.886850] peak_usb 3-2.4.4:1.0 can0: Rx urb aborted (-32)
>
> As I run the same hardware here it is very likely that you have a faulty
> CAN bus setup with
>
> - wrong bitrate setting / sample points / etc
> - wrong or no termination
> - missing or wrong configured (other) CAN nodes
Thanks Oliver, this might have been it, I'm using 1Mbit (up from
100kbit) on a different board, and not getting those errors.

>
> I added the maintainer of the PEAK USB adapter (Stephane) to the
> recipient list.
>
> Having the linux-can mailing list and Stephane in the recipient list is
> sufficient to answer the above details.
>
> Regards,
> Oliver
>
