Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A417277F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 07:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbfGXFsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 01:48:43 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:35135 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725900AbfGXFsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 01:48:43 -0400
Received: by mail-wr1-f65.google.com with SMTP id y4so45489119wrm.2
        for <netdev@vger.kernel.org>; Tue, 23 Jul 2019 22:48:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vl+4uYaHqhJOv+Pjo31wJJ/QiKb1I0k+OnqqTdPE3yA=;
        b=lAqmmeUTge08wpbZoHuaEWQBpDgu4ViXPoayBgYiixPdd2SVxYQYgDGxrjzrSrSxxR
         fQ2zR/T7/j/F6HasFFAPBwRepz42tQBBAi2JZx9/mLjDpEBl6UfkmCXnrOXg79bzlYBx
         zIADBrZs1BB/epxtUybzKk8eUr8IncOvSqbyFuEhqUcqd+wMPEczogyAym1SfhDAal0v
         WQeEEdyrXwX81DAAdGXFDX4ObW7WoHD4pQ6a5tKu3rfmDvVi7Xw0LT1DlDYTBYskdZhK
         d2YE7LGS5WCpW9NFd0fasHUgzFbsSEdjq9gt813BWgDV5QFg8qprJTV0FFzxClZnUyjk
         CK6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vl+4uYaHqhJOv+Pjo31wJJ/QiKb1I0k+OnqqTdPE3yA=;
        b=Y8yBBfSKnc/SaX2zDtJDQz2A/ijJQi+KLKn+Fc9E8gZG/KAtbo/3JYyNqYlhi2AAzE
         ZJMxoDLDOcSizKiznlx0xXhBn5GmA//BGW6Oc3FLCfB6fN97PDY4fOhQeixIQYshEFi8
         ioYgkrRQKcrSl/s5E0mHkf3iLhxud/mOIuOx+StDLmaQtAA9E71qslqsirucLZ3H8wmf
         sgcMaLVd/uaKD9oOkneJpcZaOnsx+jCeRag/aj9CsJe/8wFDQHx+bwHGPXY3GnoveUFV
         olW3WX53MH6JS9vnFSDinTVbwuoJhWClt/nt//fsiff3aajTTRTUwcdAVmyWSTvmOar3
         ghcQ==
X-Gm-Message-State: APjAAAXex9yEKzL4iK+Ptbi2TmA3CYtgBZzmPcrGsd6A/57gz53BQwvP
        T9/069UKRecT1tpNoVU3nXEaC6q3
X-Google-Smtp-Source: APXvYqxJu87wNfJXXRxinPuVUI+eOo+2WB3qm1YbYWCV+xQ6i4eH2te1eZrLqZqa1cAPh0HGyZNfVg==
X-Received: by 2002:a5d:5692:: with SMTP id f18mr39829644wrv.104.1563947321007;
        Tue, 23 Jul 2019 22:48:41 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f43:4200:44da:cb0:9744:f2d7? (p200300EA8F43420044DA0CB09744F2D7.dip0.t-ipconnect.de. [2003:ea:8f43:4200:44da:cb0:9744:f2d7])
        by smtp.googlemail.com with ESMTPSA id q18sm51918184wrw.36.2019.07.23.22.48.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 23 Jul 2019 22:48:40 -0700 (PDT)
Subject: Re: kernel v5.3.0-rc1
To:     Bob Gleitsmann <rjgleits@bellsouth.net>, netdev@vger.kernel.org
References: <ed5c39e4-e364-ccca-0a9e-8d0b4d648bfd@bellsouth.net>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <91bc69d5-6185-8bb8-cb68-eb3655782226@gmail.com>
Date:   Wed, 24 Jul 2019 07:48:32 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <ed5c39e4-e364-ccca-0a9e-8d0b4d648bfd@bellsouth.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 24.07.2019 03:38, Bob Gleitsmann wrote:
> Hello,
> 
> 
> I had problems with network functionality in kernel v5.3.0-rc1. I was
> not able to ping local devices with ip address or internet points by
> name. I have been testing git kernels for a while and this is the first
> time this has happened, i.e., it didn't happen with v5.2.0. One
> interesting thing is that simply rebooting with a good kernel doesn't
> fix the problem. The machine has to be powered off and restarted.
> 
> It was clear that network names were not being resolved.
> 
> I can provide more details and try different things to help track down
> the problem. I'm using x86-64 system, gentoo linux, r8169 PHY.
> 
Thanks for reporting. For one known issue there's a fix pending for 5.3-rc2:
1a03bb532934 ("r8169: fix RTL8168g PHY init")
You could apply it on top of 5.3-rc1 or test linux-next.

If this doesn't help then at least a full dmesg log is needed.

> 
> Best Wishes,
> 
> 
> Bob Gleitsmann
> 
> 
Heiner
