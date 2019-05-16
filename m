Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 494F42106D
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 00:02:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727568AbfEPWCa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 18:02:30 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:44174 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726491AbfEPWCa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 May 2019 18:02:30 -0400
Received: by mail-pf1-f196.google.com with SMTP id g9so2532452pfo.11;
        Thu, 16 May 2019 15:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+YECcIThM680dn1LxRFgPVXppdSYgFAB3uXgDY3OVPo=;
        b=BuwgbuW+u8ajCJUPdyH/vEHnv2VyB5OsmVXJNyhw9aXqSq51/kufjhi9OIiAPvh1NT
         Lm/ptDzi49LcnxNJvbIgfPnYkynIys23OiY8up8iOoq49ex4pX2zA4gKamfNhs9C+Qpj
         JAz9tNfKnx3U8BAzDi7dEbmkNIQuz1PWeVvEZgKRTog7hwZ6wlb7F+RFD0/WtHmRGFYp
         IAdMHjd07Lxs9VTdlcBx8Dvex3cYv2yM2uVJQIK8T8lvkEanmFOZSeOTKIiuLIctg3S6
         9bdspyt8smxpMxwYrzIs518aNxxnYwK4mfCwQY2R1k0R4YxkZW/QToUDIzrgologeb3G
         SQUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=+YECcIThM680dn1LxRFgPVXppdSYgFAB3uXgDY3OVPo=;
        b=SL6IrDCJuwZ9jdc77QwytEJfQ1lWzkI4jj0sxr4A7smG9yvDW2uSHCfSwdcY9yoQBq
         iBZHLgdS2c4fyxd/YfD2sDOKUoDAf5A9QvFtQfCjfyf0S3SLo6CYvmN8/JLMw6Vmb2iG
         a1aUA50dEyazTgk4y05xq4DLNegdC9V8v8DNPDNAOqGGBVFa6gARbG0VKiIj/TEm7uVX
         Qrf0aq8MRZUYhn4KtSrgQwuVNsW5wVk/oscXRVdQIn+zNI26FyDB4S3xqJPF/Wf74cCM
         gy7DH8B/StUplGoTzeQYEqIVBoSM/thKer99W9VwUh+L8SJxG1xICaXoOXLXjtGpbw7G
         zVAA==
X-Gm-Message-State: APjAAAVjQCGHL4AprH7TyaXij/NeBUCbo38FIXtxtz1VolJag6cBelfo
        imbS3BEuTSEKelhYhU0OssJgK1v1
X-Google-Smtp-Source: APXvYqxPX7kr0spfgSSWVcMiFQMd98M8WoHx4cX3sK+15tewJeyHahgAyMgSumrMcCNUxDLDIQMNrA==
X-Received: by 2002:aa7:8186:: with SMTP id g6mr57304552pfi.126.1558044148984;
        Thu, 16 May 2019 15:02:28 -0700 (PDT)
Received: from [10.67.49.52] ([192.19.223.250])
        by smtp.googlemail.com with ESMTPSA id z125sm10394057pfb.75.2019.05.16.15.02.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 May 2019 15:02:28 -0700 (PDT)
Subject: Re: [PATCH] igb: add parameter to ignore nvm checksum validation
To:     "Nikunj Kela (nkela)" <nkela@cisco.com>,
        "jeffrey.t.kirsher@intel.com" <jeffrey.t.kirsher@intel.com>
Cc:     "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        "David S. Miller" <davem@davemloft.net>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1557357269-9498-1-git-send-email-nkela@cisco.com>
 <9be117dc6e818ab83376cd8e0f79dbfaaf193aa9.camel@intel.com>
 <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <4469196a-0705-5459-8aca-3f08e9889d61@gmail.com>
Date:   Thu, 16 May 2019 15:02:18 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <76B41175-0CEE-466C-91BF-89A1CA857061@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/16/19 12:55 PM, Nikunj Kela (nkela) wrote:
> 
> 
> On 5/16/19, 12:35 PM, "Jeff Kirsher" <jeffrey.t.kirsher@intel.com> wrote:
> 
>     On Wed, 2019-05-08 at 23:14 +0000, Nikunj Kela wrote:
>    >> Some of the broken NICs don't have EEPROM programmed correctly. It
>    >> results
>    >> in probe to fail. This change adds a module parameter that can be
>    >> used to
>    >> ignore nvm checksum validation.
>    >> 
>    >> Cc: xe-linux-external@cisco.com
>    >> Signed-off-by: Nikunj Kela <nkela@cisco.com>
>    >> ---
>    >>  drivers/net/ethernet/intel/igb/igb_main.c | 28
>    >> ++++++++++++++++++++++------
>    >>  1 file changed, 22 insertions(+), 6 deletions(-)
>     
>     >NAK for two reasons.  First, module parameters are not desirable
>     >because their individual to one driver and a global solution should be
>     >found so that all networking device drivers can use the solution.  This
>     >will keep the interface to change/setup/modify networking drivers
>     >consistent for all drivers.
> 
>     
>     >Second and more importantly, if your NIC is broken, fix it.  Do not try
>     >and create a software workaround so that you can continue to use a
>     >broken NIC.  There are methods/tools available to properly reprogram
>     >the EEPROM on a NIC, which is the right solution for your issue.
> 
> I am proposing this as a debug parameter. Obviously, we need to fix EEPROM but this helps us continuing the development while manufacturing fixes NIC.

Then why even bother with sending this upstream?
-- 
Florian
