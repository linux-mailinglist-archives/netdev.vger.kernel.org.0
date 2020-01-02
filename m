Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7F712E827
	for <lists+netdev@lfdr.de>; Thu,  2 Jan 2020 16:40:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728707AbgABPkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jan 2020 10:40:41 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:37109 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728561AbgABPkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jan 2020 10:40:41 -0500
Received: by mail-wr1-f65.google.com with SMTP id w15so27011702wru.4
        for <netdev@vger.kernel.org>; Thu, 02 Jan 2020 07:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=Xmc3VKpKNxBYypOcgtkgopQ9NCe5bA19Mr6VA9shAtQ=;
        b=ts4czW61FQIlObW6dsdMzL6UfzZ91/YEnrGfVx94Wer36WVXVGSMNUeteQEZD3UCiI
         R0jwG5QaANx7K79tGUdQ4crkTDbg4GOkRg/Hwh/+LekHof2Oj+TgRqEWqrn3g83rs+Ag
         E5e2VWU5WlNTPmp9+6uZ6cCWgsRNEDMTn4QRr4tMgbjz2VZZlFmSCOPCZ5T7B4Feu5TX
         i+1qqapprYu8v4Sgs6b5RenjEK3SCjIj3gindQzmu4trzRoyj1YVQf1Kr6fHp2Kn9Vt+
         jgDS0iBwwLXtdT/C5cnjA3wn5q5xFu15TY1MSsFbRnTZnO5D5Ah/RliG3AX4pEperjNE
         Y/0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=Xmc3VKpKNxBYypOcgtkgopQ9NCe5bA19Mr6VA9shAtQ=;
        b=cBsLD1aECwK/qMh0ajQztxmDli+XpNRTdJfHgv04zul6xVS3agwqgGB7Qqh+yhVmQb
         42Q6HZJCB0Jx+6S7mObpkV62dIwKjUr7EMWA6CXznOGIzhNPf/PIcD+egCWa7NY9RRPb
         viRY+DD4K6oqXeNab30DkfpYARxRLUD2TFa7dLaIOvuaB0EyidA/EwgQTH5U1b3psfaX
         IP+3scBcAl3CM69iFW7G8Y2fRLMN6X6yjV4gtirBOSoJEkpfmxlIeyGSOB4R2FgBFB9x
         n5VpTPEJRuszhh5gXy719dbZO2e8lZfJe62kjfXKBsxidyOqoSY6CPOateQrphoB4rTY
         LejQ==
X-Gm-Message-State: APjAAAVfRVt/AJz/9misemipm6YVZlKJmRz11zu4ZeS0ywSoxufYPUPT
        CORzBnySIipkDCPlfVbqaLM=
X-Google-Smtp-Source: APXvYqwZL/jXgPeNUuhpZ2zPoxf4l7ikjKYhNQVJtnqvjZr5AcDfB21MYCKJw27Bb+1uU1KVRnBzpg==
X-Received: by 2002:a05:6000:f:: with SMTP id h15mr78305333wrx.90.1577979639319;
        Thu, 02 Jan 2020 07:40:39 -0800 (PST)
Received: from pali ([2a02:2b88:2:1::5cc6:2f])
        by smtp.gmail.com with ESMTPSA id c4sm8774734wml.7.2020.01.02.07.40.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jan 2020 07:40:38 -0800 (PST)
Date:   Thu, 2 Jan 2020 16:40:37 +0100
From:   Pali =?utf-8?B?Um9ow6Fy?= <pali.rohar@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>, Andrew Lunn <andrew@lunn.ch>
Subject: Re: [RFC 0/3] VLANs, DSA switches and multiple bridges
Message-ID: <20200102154037.m2ric3wtfmsqd3ew@pali>
References: <20191222192235.GK25745@shell.armlinux.org.uk>
 <20191231161020.stzil224ziyduepd@pali>
 <20191231180614.GA120120@splinter>
 <20200101011027.gpxnbq57wp6mwzjk@pali>
 <20200101173014.GZ25745@shell.armlinux.org.uk>
 <20200101180727.ldqu4rsuucjimem5@pali>
 <da2191ec-b492-dfc5-95e9-d05e5f1fcf24@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <da2191ec-b492-dfc5-95e9-d05e5f1fcf24@gmail.com>
User-Agent: NeoMutt/20180716
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello, thank you for steps! For sure I will try it, but probably next
month. Currently I do not have my board in hands, so I cannot do tests.
So I will just comment this part:

On Wednesday 01 January 2020 20:53:57 Florian Fainelli wrote:
> - does it help if you go back to a kernel before and not including v5.1
> which does not have commit 061f6a505ac33659eab007731c0f6374df39ab55
> ("net: dsa: Add ndo_vlan_rx_{add, kill}_vid implementation") or if you
> can change your kernel, try something similar to [2] for mv88e6xxx and
> see if it helps
> 
> [2]:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e9bf96943b408e6c99dd13fb01cb907335787c61

Debian Buster has kernel version 4.19 and in backports is 5.3. I tested
both versions and there was no difference.

Was above mentioned commit propagated to stable trees (and there is
possibility that was backported to stable 4.19 version)?

I can use any kernel version since 4.17 (or 4.18?) as board is supported
by mainline kernel.

-- 
Pali Rohár
pali.rohar@gmail.com
