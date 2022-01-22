Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7250496B6F
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 10:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbiAVJeE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 04:34:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230011AbiAVJeD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 04:34:03 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664BEC06173B
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 01:34:03 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id n8so19625522wmk.3
        for <netdev@vger.kernel.org>; Sat, 22 Jan 2022 01:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to
         :references:from:subject:in-reply-to:content-transfer-encoding;
        bh=82N3pZxTGQGdnKz7sduXPrq71J6/BJyEju5EUfigQB8=;
        b=oyX7l3g94Ttb1StYjFB3QUH2fGkqbfooAqWUV1vJkHg8bNtdge9KhW1QgesNBVYCB9
         CLJ1R8CqInksNh1q8QG0+OPJgZNavlTxhRAazPRapErAOkK/iQo6hX7O1LgoGTYD+Uyc
         hdy1B1cwcXtzTLRp4H0bgzrIvr6ZZUk74Tlao3u6iFsv1rAKNMISlX1mgRj/ZVpUVOLI
         3egGz4bqXp753gOUDlChV7bLefIQkWlCQYsm4MluBgDSLxE6m89MzKEHaKGKymDBegJO
         CRVkzFgibMRB6BLwyjWxoS6HPyR74O0SbzjqIH6kREh62srmbVw5A+qKxqfcsacn9zwA
         cPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:references:from:subject:in-reply-to
         :content-transfer-encoding;
        bh=82N3pZxTGQGdnKz7sduXPrq71J6/BJyEju5EUfigQB8=;
        b=5WFdn8KqPhkl+H0ccv9Y9sQ7JTOSC3/CzjUqEqTxiqYvUsexMnXE94q52im/1QG07j
         pxhTVeemBMW9ojC7KKCLMv/XH3azaLQ9Sg9U0j3zZe+TsjtcH0IGG0DrkFRoQXKhkLuU
         Rn04zQ8E2gycjPlk4ZXtk0qm9josbC3KnBGHW8ZiSiT+NNrt4jINKO1tYStLEfWk1wm7
         jhsTo7Ls5/y9R/qGubq1blynUXxsqwrCWyUM4S8J1QQ/2xhtJSAuRCPLEbs82v5avj6Z
         xnDkWobcL+eoR4DGv3fVUCniOKhSNmKKz97bvzwODicN+W1YFC8LUfAqoIfeeoTrQ2d1
         GTlg==
X-Gm-Message-State: AOAM530GksTIv04QQy+2R6mPl0xMGLcrpGyS6SiDBzTZ0P5lpntz3Pit
        skSS937x5aialejoUHA77891VOaXG7Q=
X-Google-Smtp-Source: ABdhPJx2JVt+rs/6AY95b+3S5MmkCQEJ2Dz//Cwa0B9GwZ03HDOmRPx4KaGmBw/em+qk6iwLVNCAPQ==
X-Received: by 2002:a05:600c:4fd5:: with SMTP id o21mr3783574wmq.184.1642844041769;
        Sat, 22 Jan 2022 01:34:01 -0800 (PST)
Received: from ?IPV6:2003:ea:8f08:c900:8441:97be:1ca5:d79? (p200300ea8f08c900844197be1ca50d79.dip0.t-ipconnect.de. [2003:ea:8f08:c900:8441:97be:1ca5:d79])
        by smtp.googlemail.com with ESMTPSA id t17sm8297835wrs.10.2022.01.22.01.34.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Jan 2022 01:34:01 -0800 (PST)
Message-ID: <24747dcf-8442-6d53-626f-e03b3cafe246@gmail.com>
Date:   Sat, 22 Jan 2022 10:33:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     Tim Harvey <tharvey@gateworks.com>, netdev <netdev@vger.kernel.org>
References: <CAJ+vNU1Grqy0qkqz3NiSMwDT=OX3zOpmtXyH78Fq2+mOsAFj4w@mail.gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: best way to disable ANEG and force ethernet link?
In-Reply-To: <CAJ+vNU1Grqy0qkqz3NiSMwDT=OX3zOpmtXyH78Fq2+mOsAFj4w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 21.01.2022 18:20, Tim Harvey wrote:
> Greetings,
> 
> I'm troubleshooting a network issue and am looking for the best way to
> force link speed/duplex without using auto-negotiation.
> 
> What is the best way to do this in Linux? Currently from a userspace
> perspective I have only been able to using 'ifconfig' to bring the
> link up, then 'mii-tool -F 100baseTx-FD <dev>' to force it. The
> ethtool methods do not work on my MAC/PHY (not clear what ethtool
> support is needed for that on a driver level). For testing purposes I
> would like to avoid the link coming up at 1000mbps in the first place
> and force it to 100mbps.
> 
> Before hacking the heck out of the phy layer in the kernel I was
> hoping for some advice for the best place to do this.
> 
> In case it matters I have two boards that I would like to do this on:
> an IMX8MM with FEC MAC and a CN803X with an RGMII (thunderx) vnic MAC.
> Both have a GPY111 (Intel Xway) PHY.
> 
> Best regards,
> 
> Tim

ifconfig is a legacy tool, better use ip. ethtool should work for you.
If not, please provide the details: Which command are you using, any error?
The Intel Xway PHY driver is loaded?
For just disabling Gbit mode you don't have to switch to forced mode.
You can just disable advertising Gbit mode:
ethtool -s <if> advertise 1000baseT/Full off
