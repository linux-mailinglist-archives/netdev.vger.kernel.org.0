Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 756F45B45A
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 07:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727387AbfGAFuJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 01:50:09 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:40893 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725777AbfGAFuJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 01:50:09 -0400
Received: by mail-wr1-f67.google.com with SMTP id p11so12265125wre.7
        for <netdev@vger.kernel.org>; Sun, 30 Jun 2019 22:50:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=OHRBICDcjj1Gb85Cks7Ctqit62DxDJRlY7sUuo7CvwU=;
        b=NtaiYYaQLvf2yjROEeAHfaExrwaBCmf/q2GFIEv0uJc/eEwSiUV/KejKFg4tNERheU
         jRd0DViq91raUJbyEXRZW4NWhCamoJUU0nS2Q/Yg3zKmIHs0/GRt1Xz1CSynv5ATEz2d
         k/G+JG4j1wc+0DBu5CMTWGWMfNqI2Z7JSdintl8BV0uxv2a8In2JOQ8BX5qLKyLCe6il
         xsx9jX4AD80HCRuoHvq0eY00olON3HAUtXudIXAZtF/0C2abJjOfHKKF5uZj5K3wQ+bz
         2uABXEGFnszsjNB7CeN2G4ZlE+X2+CNkoivdGzqlcHLJg8duymPcm+ERnv2OJr26RGt5
         eE8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=OHRBICDcjj1Gb85Cks7Ctqit62DxDJRlY7sUuo7CvwU=;
        b=jJUR1wspQ3YSOOUbdHsWLdA75wZXkQvtmapCmVxKJkI2YknNZ3FnZaKIhgWKwJSY+H
         0Bgvq97e409oeyE2Bayb/S0OAN6oCdrQUebvcJBhyd0/FuGVMqDZHKN95kRgtKsJhPqY
         rq9VOHa/uvix3Y/rtnX/4Giq4/FfS9qZAAiVkRL8jdIaEAY1VpLYTyk6mPfnflYSUNXy
         QDqOvyisvQJ7sTO4uFfn7c6bEDPr7XghMvqYfuhv4WJ3uirCylYMCJDKmVY098ib3zfV
         Yxr5V20Mdrm09nPzS3/sdnivsbg3qD9WWslP9uf+Un6H4n1j5ZDTJZ8Bn/ULebumpqXk
         Myuw==
X-Gm-Message-State: APjAAAXWP+MAmH00J1KH8PD6/JFIrvFwtTRx1HmBPSBHWOHkz2yNYjCN
        +lS6X3kgoWVU3FoQVRB3kc69do1W
X-Google-Smtp-Source: APXvYqyXO4If8JXchEWmNpDDa8tk+oH5NjeL7Zz6j8n/1SlVbodfEKxlYTMek4rB15U+LxflCEGt7w==
X-Received: by 2002:adf:f902:: with SMTP id b2mr8090010wrr.199.1561960206990;
        Sun, 30 Jun 2019 22:50:06 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bd6:c00:cc53:f7f8:f2d6:4eaf? (p200300EA8BD60C00CC53F7F8F2D64EAF.dip0.t-ipconnect.de. [2003:ea:8bd6:c00:cc53:f7f8:f2d6:4eaf])
        by smtp.googlemail.com with ESMTPSA id v18sm10367777wrd.51.2019.06.30.22.50.06
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 30 Jun 2019 22:50:06 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     nic_swsd@realtek.com, romieu@fr.zoreil.com, netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
 <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
 <4437a8a6-73f0-26a7-4a61-b215c641ff20@web.de>
 <b104dbf2-6adc-2eee-0a1a-505c013787c0@gmail.com>
 <62684063-10d1-58ad-55ad-ff35b231e3b0@web.de> <20190630145511.GA5330@lunn.ch>
 <3825ebc5-15bc-2787-4d73-cccbfe96a0cc@web.de>
 <27dfc508-dee0-9dad-1e6b-2a5df93c3977@gmail.com>
 <173251e0-add7-b2f5-0701-0717ed4a9b04@web.de>
 <de38facc-37ed-313f-cf1e-1ec6de9810c8@gmail.com>
 <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <94b0f05e-2521-7251-ab92-b099a3cf99c9@gmail.com>
Date:   Mon, 1 Jul 2019 07:50:01 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <116e4be6-e710-eb2d-0992-a132f62a8727@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01.07.2019 00:21, Karsten Wiborg wrote:
> Hi Heiner,
> 
> On 30/06/2019 23:55, Heiner Kallweit wrote:
>> This one shows that the vendor driver (r8168) uses a random MAC address.
>> Means the driver can't read a valid MAC address from the chip, maybe due
>> to a broken BIOS.
>> Alternatively you could use r8169 and set a MAC address manually with
>> ifconfig <if> hw ether <MAC address>
> Hmm, did some more testing:
> did a rmmod r8168 and (after "un"blacklisting the r8169) modprobed the
> r8169. This time r8169 came up nicely but with a complete different MAC
> (forgot to not than one though).
> So I guess the vendor compilation did other stuff besides just compiling
> the r8168 kernel module.
> 
> Did another test:
> blacklisted the r8168, renamed r8168.ko to r8168.bak, depmod -a and
> powercycled the system. Funny it came up with both r8168 and r8169
> loaded and I got my intended IP address from. DHCP, so r8168 somewhat
> got loaded and used his MAC.
> Did another rmmod r8168, rmmod r8169 and then modprobe r8169.
> Even though I did NOT configure a MAC address myself manually it came up
> with a new MAC address and of course got a dynamich IP address.
> So I don't know where the vendor somewhat changed something (with his
> compiling/installing) to the effect that r8169 now works?!?
> 
When the vendor driver assigns a random MAC address, it writes it to the
chip. The related registers may be persistent (can't say exactly due to
missing documentation).

> Regards,
> Karsten
> 
Heiner
