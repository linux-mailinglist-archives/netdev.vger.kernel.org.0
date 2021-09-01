Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87B563FD1E1
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 05:41:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241806AbhIADmB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 23:42:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241754AbhIADmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Aug 2021 23:42:00 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A90E8C061575
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:41:04 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id q21so696729plq.3
        for <netdev@vger.kernel.org>; Tue, 31 Aug 2021 20:41:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XT7f8c1sBQbTql3YMuMv73QLmoOl2+Ey3vIW3aawLuY=;
        b=PeG0Fhb77R2iRB60DK+/upgR0WiFY6SaXKShNUYIC+QzC0TF/NAY65chPUALRKNeFw
         TdrxKunOEMykA4a5rZRCc9fK6tfyeltO0qrjHuN5GJTeW4LoAN8EVlcta4zeamOZDISw
         NkeMzKTlilZJcllKW9jntSoZl0UM88O7BtPJCe9kftt8ytYJUEAoDqWH0cjtagNXMUoX
         ukmk8JWJeUrl5LvhVfoX+VkdVdkWwNeJeSmSEo1Gu6OVRZ9dM0pdZOh93C0BaHNTVD8l
         eEqtGiXBksHfpMunFxXYFSfturycSAkVrvwxSN2FQ+dmUBzo9Wd/ITVVoMGQywF34vlB
         hlvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XT7f8c1sBQbTql3YMuMv73QLmoOl2+Ey3vIW3aawLuY=;
        b=PXrhEHolttBNzDjXyu9gg+04irBzmQji3zlzslbs3HFUAYbgnwZhxvxcX+25Ksokij
         X/hB/4ryveMVjiq1HiNAaI9lOQnJIK4dmcYKkSHDh2ryNWFIgP23v6nOAzR/coIbbcXi
         pByDCkAa2hXJ1z9J9+4qgAQ1J4qPHkZGxAVl/ULcSFsIBJ2zWeQPP4vmfKpQqlwDO4NU
         wmlCHRl2GFGbKjpkvvCAmH9D8u08iKsvczi1CpFDTRVHfQkXoaZD/PQ+gbXns/+/aM9g
         vT8ZOTBslmyeH0UeLqTgoU3mGPqKJx5tpV4hUCsQykp5kKSaA2TiAoRJ/uXX+oGJD0zA
         +hqA==
X-Gm-Message-State: AOAM530E23qfLS5ENgibu16/Vr/vHD2hS3fDYJF52nJVboyWI3VGErt5
        P+p9V4HC9P6zHYItogHtm41Kn05Cpe4=
X-Google-Smtp-Source: ABdhPJxM4Q2t8ziKUm9GiLHDAgaQTCEIZ6rqYTaS8K1nCJI2dmCDOMseD+fUxxeItSU+WtpoY15qtg==
X-Received: by 2002:a17:902:7897:b0:132:580a:90b4 with SMTP id q23-20020a170902789700b00132580a90b4mr7670342pll.7.1630467663900;
        Tue, 31 Aug 2021 20:41:03 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.45.42.119])
        by smtp.googlemail.com with ESMTPSA id d4sm8792954pfv.21.2021.08.31.20.41.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Aug 2021 20:41:03 -0700 (PDT)
Subject: Re: [iproute2] concern regarding the color option usage in "bridge" &
 "tc" cmd
To:     Gokul Sivakumar <gokulkumar792@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@kernel.org>,
        Roopa Prabhu <roopa@nvidia.com>
Cc:     netdev@vger.kernel.org
References: <20210829094953.GA59211@lattitude>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <e1cfb620-7c87-ce63-2bb4-6e9b3df0863e@gmail.com>
Date:   Tue, 31 Aug 2021 20:41:01 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20210829094953.GA59211@lattitude>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/29/21 2:49 AM, Gokul Sivakumar wrote:
> Hi Stephen, David,
> 
> Recently I have added a commit 82149efee9 ("bridge: reorder cmd line arg parsing
> to let "-c" detected as "color" option") in iproute2 tree bridge.c which aligns
> the behaviour of the "bridge" cmd with the "bridge" man page description w.r.t
> the color option usage. Now I have stumbled upon a commit f38e278b8446 ("bridge:
> make -c match -compressvlans first instead of -color") that was added back in
> 2018 which says that "there are apps and network interface managers out there
> that are already using -c to prepresent compressed vlans".
> 
> So after finding the commit f38e278b8446, now I think the man page should have
> fixed instead of changing the bridge.c to align the behaviour of the "bridge" cmd
> with the man page. Do you think we can revert the bridge.c changes 82149efee9,
> so that the "bridge" cmd detects "-c" as "-compressedvlans" instead of "-color"?
> 
> If we are reverting the commit 82149efee9, then "-c" will be detected as
> "-compressedvlans" and I will send out a patch to change the "bridge" man page
> to reflect the new "bridge" cmd behaviour. If we are not reverting the commit
> 82149efee9, then "-c" will be detected as "-color" and I will send a out a patch
> to change the "bridge" cmd help menu to reflect the current "bridge" cmd behaviour.
> Please share your thoughts.
> 
> And also regarding the "tc" cmd, in the man/man8/tc.8 man page, the "-c" option
> is mentioned to be used as a shorthand option for "-color", but instead it is
> detected as "-conf". So here also, we need to decide between fixing the man page
> and fixing the "tc" cmd behaviour w.r.t to color option usage.
> 
> I understand that "matches()" gives a lot of trouble and I see that you both are
> now preferring full "strcmp()" over "matches()" for newly added cmd line options.
> 


Stephen: This should be reverted for 5.14 release given the change in
behavior. I will take a wild guess that ifupdown2 is the interface
manager that will notice.
