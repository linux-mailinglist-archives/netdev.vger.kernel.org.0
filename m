Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A46B6211D7
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 03:48:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfEQBsu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 21:48:50 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:45910 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfEQBsu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 21:48:50 -0400
Received: by mail-pf1-f195.google.com with SMTP id s11so2791771pfm.12;
        Thu, 16 May 2019 18:48:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wuDXc+IXQGay7e3fD99hwMFa7JXXaUv+8T7wwPWp5iw=;
        b=UEhjmF6eiDf58glo5/r876Y/ZolFULRbkk4VMEerl0DrtWonfVbR+RTc96v+okNHcj
         7wamKkA+9HKjOp+wrsYIJz2wySZqlYdMp+5HDJcjl36bwS02ua8+99qAb1SgQ+ZgatTm
         sQOEdsXswqGj8Fpub9rZdEo9cGvJZ4tucFK3KsMgQe7ABts5tjh73KpInbj0/0SzlCfp
         qhrmPOshGBnOHTHaCYBmcOF3MW+pfEIMZsy9vBqi6C0mXow/FgJfAcVd7ZMvtQdExY+h
         osqj9vqt/LjXLi6CuAy/oszppueVG5zZreArQcxPZQcc57UPrRxxmOTya6YaQn75cWAL
         QZ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wuDXc+IXQGay7e3fD99hwMFa7JXXaUv+8T7wwPWp5iw=;
        b=DKO8ZE7SkoX3DLz08elZ7qsCJ9HNJxJkv1jQucm8O6BMEweZ1S8okDXWXRIzaMaO1J
         xM/O4/FAHxtBAbHjF9rwvsKGJ2eZu86DONxVqW403uziIVyE+kFrjeKt+4fzU6Rq6JYi
         8UHXqS1BuybcGb/uyLu0BuZ2rVbAKTfqnv2uUsmXBdZzRNOlxE+x7woKF/yk2jDhwJOl
         FyzwxAPHkPar9Dr/yD9MXgzUrOYIMC/lO82Xbxw/OakIvfUyNr+n7M+GpISvJ50+7+W3
         CsTckhurVsyVwHvpTgRs/Ejh5f3olaEYXNeSXN+wDqHVvKBWjLNf8bTGEhxPbB4uBPMK
         a2rw==
X-Gm-Message-State: APjAAAVGgkft8H3q7TSJtDGL6V+vaajKBUI8/5liAUnJpOO/7sqPnG3m
        wso9SOh/KNoh0gXCmCHFVCxPre6B
X-Google-Smtp-Source: APXvYqzemz/xV7mTxS06IPnyybDyeoue+wEcoMxhSLWRmNonKjhneN4QQeH2TlSUMZp4+19UN8DTrg==
X-Received: by 2002:aa7:8186:: with SMTP id g6mr58368552pfi.126.1558057728807;
        Thu, 16 May 2019 18:48:48 -0700 (PDT)
Received: from [10.230.28.107] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j19sm8403874pfr.155.2019.05.16.18.48.44
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 18:48:47 -0700 (PDT)
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
To:     Daniel Walker <danielwa@cisco.com>
Cc:     "Nikunj Kela (nkela)" <nkela@cisco.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
 <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
 <20190517010330.2wynopuhsqycqzuq@zorba>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <bd9e6a93-c8e8-a90e-25b0-26ccbf65b7c4@gmail.com>
Date:   Thu, 16 May 2019 18:48:43 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190517010330.2wynopuhsqycqzuq@zorba>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/16/2019 6:03 PM, Daniel Walker wrote:
> On Thu, May 16, 2019 at 03:02:18PM -0700, Florian Fainelli wrote:
>> On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
>>>
>>>
>>> On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
>>>
>>>     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
>>>    >> Some of the broken NICs don't have EEPROM programmed correctly. It
>>>    >> results
>>>    >> in probe to fail. This change adds a module parameter that can be
>>>    >> used to
>>>    >> ignore nvm checksum validation.
>>>    >> 
>>>    >> Cc: xe-linux-external@cisco.com
>>>    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
>>>    >> ---
>>>    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
>>>    >> ++++++++++++++++++++++------
>>>    >>  1 file changed, 22 insertions(+), 6 deletions(-)
>>>     
>>>     >NAK for two reasons.  First, module parameters are not desirable
>>>     >because their individual to one driver and a global solution should be
>>>     >found so that all networking device drivers can use the solution.  This
>>>     >will keep the interface to change/setup/modify networking drivers
>>>     >consistent for all drivers.
>>>
>>>     
>>>     >Second and more importantly, if your NIC is broken, fix it.  Do not try
>>>     >and create a software workaround so that you can continue to use a
>>>     >broken NIC.  There are methods/tools available to properly reprogram
>>>     >the EEPROM on a NIC, which is the right solution for your issue.
>>>
>>> I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.
>>
>> Then why even bother with sending this upstream?
> 
> It seems rather drastic to disable the entire driver because the checksum
> doesn't match. It really should be a warning, even a big warning, to let people
> know something is wrong, but disabling the whole driver doesn't make sense.

You could generate a random Ethernet MAC address if you don't have a
valid one, a lot of drivers do that, and that's a fairly reasonable
behavior. At some point in your product development someone will
certainly verify that the provisioned MAC address matches the network
interface's MAC address.
-- 
Florian
