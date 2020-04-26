Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D631B92CE
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 20:33:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726170AbgDZSdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Apr 2020 14:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726152AbgDZSdR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Apr 2020 14:33:17 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 990F0C061A0F
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:33:17 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id z90so12496477qtd.10
        for <netdev@vger.kernel.org>; Sun, 26 Apr 2020 11:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8t4xsjbwT0nGqrKsKYLEFRpxw3G2kfw7+vnDqb0eZ+Q=;
        b=tEmeMI8Tc5hijs0gAbyv1JNwTPHEn+9qK0zjePkm4dpkNoXRLL6PjochYyOmRirge2
         o9rNtEEfYZNUhLAveuaaneRIMsw1RMGPWeZRsigp042GDP72bwZX14dhlhICpx4PEDwN
         rU6Fs6efffSFsUQbas18y8R7RyETbe/T5+PPuF/t5kgj+ALd3FZyE6gf5yMNXiGxilzs
         PSae+5h691nREUqedPYFYvhvl4MVgwrSlVWsEYxbPeF+cAufrAF7Io4lgDbmkU22cZla
         RQfrRhOWGFtLfVf+ev0Lht8PSlbn+JMSwzLYR/UnZWkuVrSIn5mU9B83jDzbtuAlOhKZ
         VqCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8t4xsjbwT0nGqrKsKYLEFRpxw3G2kfw7+vnDqb0eZ+Q=;
        b=IfmYLDeW8Igp0MEjkTLJKO/nbh2QGjoGgfxf7OSYrRgssB1b/of1Dg+Zr/wg5q2QnO
         Oz7Q7UHXK76i+Qv+CUe/xyYe2Ici8IXK4EN4RhMBuq4URiOeJ2aihta9YDtf8XtzrWA4
         +0S94staV+X8HfkPq6Vns/LEEcLmnYTtPgWq3S73tZR8wYQo6zBxVvEUAdXiI41w63Fk
         3m2kfcjO91F5h8SNwlO1Z2l11dy6f3Q/PBD0vt2CFWYN/SuiLtm9bkRTDjjl6eXDl4UG
         FtC27aWHYCMp5ckOBdNa9rIMagWCOiWxojjylWZvzcPiK+41nG/AcQ7ZM6kJWjB68pSe
         4DBw==
X-Gm-Message-State: AGi0PuYiBbuV11KK5f4eyAua48AdCqx5FFE03beOgOcgUOOW4Axl7hS9
        meKPpaUOszBsXKWgD5KZO3U=
X-Google-Smtp-Source: APiQypKAs9atSx0Anc6/ROn50YG7k1D7GGMCnkiR8XakMnEhlyJ5+Zpi/al+Apc0STCENTY1yapOrw==
X-Received: by 2002:ac8:5057:: with SMTP id h23mr19517821qtm.287.1587925996741;
        Sun, 26 Apr 2020 11:33:16 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:a88f:52f9:794e:3c1? ([2601:282:803:7700:a88f:52f9:794e:3c1])
        by smtp.googlemail.com with ESMTPSA id u26sm8124327qkm.125.2020.04.26.11.33.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 26 Apr 2020 11:33:16 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/2] macsec: add offloading support
To:     Igor Russkikh <irusskikh@marvell.com>, netdev@vger.kernel.org
Cc:     dsahern@gmail.com, stephen@networkplumber.org,
        Mark Starovoytov <mstarovoitov@marvell.com>
References: <20200424083857.1265-1-irusskikh@marvell.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0a44a226-0890-c856-58dd-b16e8b83c9dc@gmail.com>
Date:   Sun, 26 Apr 2020 12:33:14 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200424083857.1265-1-irusskikh@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/24/20 2:38 AM, Igor Russkikh wrote:
> From: Mark Starovoytov <mstarovoitov@marvell.com>
> 
> This series adds support for selecting the offloading mode of a MACsec
> interface at link creation time.
> Available modes are for now 'off', 'phy' and 'mac', 'off' being the default
> when an interface is created.
> 
> First patch adds support for MAC offloading.
> 
> Last patch allows a user to change the offloading mode at runtime
> through a new attribute, `ip link add link ... offload`:
> 
>   # ip link add link enp1s0 type macsec encrypt on offload off
>   # ip link add link enp1s0 type macsec encrypt on offload phy
>   # ip link add link enp1s0 type macsec encrypt on offload mac
> 
> Mark Starovoytov (2):
>   macsec: add support for MAC offload
>   macsec: add support for specifying offload at link add time
> 
>  ip/ipmacsec.c        | 23 ++++++++++++++++++++++-
>  man/man8/ip-macsec.8 | 10 ++++++++--
>  2 files changed, 30 insertions(+), 3 deletions(-)
> 

applied to iproute2-next. Thanks

