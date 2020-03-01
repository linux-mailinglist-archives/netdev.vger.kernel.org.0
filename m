Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B54174AA3
	for <lists+netdev@lfdr.de>; Sun,  1 Mar 2020 02:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgCABUb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Feb 2020 20:20:31 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:40012 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727207AbgCABUa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Feb 2020 20:20:30 -0500
Received: by mail-io1-f68.google.com with SMTP id m22so1378214ioj.7
        for <netdev@vger.kernel.org>; Sat, 29 Feb 2020 17:20:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=f5z/QHLt0ozKh8TBMNaXq75e8pU1iIjqJ84SSwXEoK8=;
        b=pgN9DHDxvMFugos3J1zQYwXDXgQkB2NadYUXSJxcmai16ygF7AjY5tWa11y9wxk3EL
         PrNqPWgM8E00RH2jy1HEYqjfFAJojxP/aNm4YuddYFsuyL9QXuPeicEyMmYjH/jVESJY
         WSFQrDAaPsN8PyxBDSPwEcSWcmtYQFxVLXzaNQi04n+zB0F8GaIa8soXwFcCJKIopt/M
         4avs59GWlude8fbn3pksmM30EcO5p2sRbEDR+toiRPFKwHRUCJBGGQafJ1NJqIMqpkdQ
         v+Rz4SAHNL5tYW+XTwHZkDIFgGWgjIDEW4mR6AzeLSay6TPzSxhYWuP/kzPEMtCOPgsH
         E3Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=f5z/QHLt0ozKh8TBMNaXq75e8pU1iIjqJ84SSwXEoK8=;
        b=cyyJZsWqRvOxfzP6CiqJFd9SZ1ngEkQi3HhjvohDumG9x5/V1x25M/QM9p8S31LcNk
         jAu48v6WNGFg9D4jgo002XnKVI49P09g2c4AhpQ3aHUHGWU1nEehMmO/89+3k+kO+eTY
         Cqmb4xZREbKc8BCIO+Xw4ypZTQESA/QzPj7jdv9nzeTV2yTSHkwcyYtQBMVdpwcDIkEq
         FZmxGiEHfrttPDF7Z92AuXMmkSc2Wqkm8ABcJIADEhWFpI3qeSOSCMjloJbkqX77R5pw
         wpBPyJHvng9KR7t+OIpYFujSgo3O1R+sC78hMKyK/61Yrp/dCFL5dumY9k3YMHvvgvBe
         RJpg==
X-Gm-Message-State: APjAAAWwEb6imGL6QyudYpIrUIbZGsBjCnLrLcRa1q1uzbdhLbQLv9rp
        xp6I3VcCCHkbYFOgnTpxYV9Mfg==
X-Google-Smtp-Source: APXvYqzCi/pc1mv8Enojrol0zk7FwZLd9rmYRooOm10UownUsG/vBKwss+EUwjQ4agh94Y8xI6w+0w==
X-Received: by 2002:a6b:740c:: with SMTP id s12mr9022219iog.108.1583025629987;
        Sat, 29 Feb 2020 17:20:29 -0800 (PST)
Received: from [10.0.0.194] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id k12sm2402743ioa.36.2020.02.29.17.20.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 29 Feb 2020 17:20:29 -0800 (PST)
To:     people <people@netdevconf.org>
Cc:     speakers-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        prog-committee-0x14@netdevconf.info,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        Christie Geldart <christie@ambedia.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, lartc@vger.kernel.org,
        pjwaskiewicz@gmail.com, arunvn@juniper.net,
        vikram.siwach@mobiledgex.com, gnu@toad.com, steve@meter.com,
        lwn@lwn.net
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: COVID-19 update, postponement of Netdev conf 0x14
Message-ID: <73dce759-8006-b8fb-5dea-3805a5d8a69c@mojatatu.com>
Date:   Sat, 29 Feb 2020 20:20:28 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Hi,

After much deliberation, due to the Coronavirus outbreak
(COVID-19) the NetDev Society board has decided to
postpone the conference scheduled to happen in Vancouver,
BC March 17th-20, 2020. Netdev Society has been consulting
with attendees and sponsors, monitoring health
organizations, and trying to work with government and
corporate imposed restrictions on travel and event
attendance. The conclusion reached is that for the health
and wellbeing of the community, it is best to postpone the
conference at this time. We understand that this is an
unfortunate situation for everyone, and very much
appreciate your understanding and cooperation in this
matter.

The new tentative date for Netdev conference is June 16
to 19th, 2020 at the same location. Please note that this
date is tentative due to the unpredictability of the
Coronavirus.

What happens to registration:
         1. If you are already registered then no action is needed.
         All registrations are applied to the new date for the
         conference.

         2. If you cannot make the new date for the conference, you
         can cancel registration for a refund minus a 7% processing
         fee. To cancel registration please send a request to
         registrar@netdevconf.info.

         3. Conference registration will remain open. If you have
         not registered and intend to attend the conference for the
         new date you may do so at current rates. Details are at:
         https://netdevconf.info/0x14/register.html.


For any questions or points of clarification, please email:
registrar@netdevconf.info

We will be updating the conference web site in the next few days.
Please see https://netdevconf.info/0x14 for the latest conference
information.

Thanks,
Jamal on behalf Netdev Society
