Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC9E251D3C
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726635AbgHYQbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725936AbgHYQbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:31:41 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 356B6C061574
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 09:31:41 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id nv17so1526602pjb.3
        for <netdev@vger.kernel.org>; Tue, 25 Aug 2020 09:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=+MdN10yOlmvPDW7ZjBGesayXHLO548E6YyDx46HTvE0=;
        b=j1MWm3nfL6tKrqJObZIbOcg+LMgBfmNkLYLffqbT4ai4X3AMGNSbcjb7e0faP1bhmO
         krdNAWKQ+OJBwMC9S+exnCJyiUw8LGM7J7iP/ohyXqd0ATYT6C37fzFn3C1t74Rzc+eM
         8x6tVfwyhZJQr4OmfliSlN4DOE0GdkOVooSIcnklPmQIg/vKqEeqw9qqgy3nx2hEIFuc
         y/lWuX1fgSxHAWxlJ+hAVP64jNiiEJCn8pm34+3JDhZt3XV8oi7UWVnlbVdOW7+8Mt33
         clc4JWanASHIIdE+MYXaLbxQaMCM2guC0q43B1oKqm7E1lz9MFtMU65iGqTVMT05T25i
         sD5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=+MdN10yOlmvPDW7ZjBGesayXHLO548E6YyDx46HTvE0=;
        b=fHpRoAZht81mzxBO+MJYtLVex7zgoILheLqVntUAgQJKK238Nv2j3v49wWPlQgrMWU
         43hCPZnjB7xN/DlNzRtRXJ7x13U0o2g1VcBj7gx4/x3H6gSdV0FH+Waw/6pzmcWN/pue
         3y3FuzsfoIxCtcl+v4JVE2k7hSdN2lqqRVReFaWwd/Lp3IHFNBAO1jycTfImP9b8bEK3
         ke4Rq+PAI68KwGZFOAiKYLlvBJkFOy9u0DcGrhDCX8j0BBkbxFrOFeXqC2fgX5Qmjyak
         Zb5p/2At5qrp8YsOT9OlkqnwRFt+UuE4vaIJnax6gJzfNhYRMSr0oU6I5ky5bbED01xJ
         bIvQ==
X-Gm-Message-State: AOAM53020QJjxRCPasHq6Ha/I+HugO5HQRQsI5+8rmX8I10Fm/PmdEA1
        HIEtOg6LIpm4/ilOoGUHXgwgEw==
X-Google-Smtp-Source: ABdhPJwYuVHSf9gDARhu/9gdG9KGqd3vS00F30OFvW02WmEEqacbWqajgvsxunpYlyXObJt4ZIv7gg==
X-Received: by 2002:a17:90a:d3d4:: with SMTP id d20mr2191203pjw.111.1598373100563;
        Tue, 25 Aug 2020 09:31:40 -0700 (PDT)
Received: from Shannons-MacBook-Pro.local (static-50-53-47-17.bvtn.or.frontiernet.net. [50.53.47.17])
        by smtp.gmail.com with ESMTPSA id y7sm3115819pjn.54.2020.08.25.09.31.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 09:31:40 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 0/2] Granular VF Trust Flags for SR-IOV
To:     Carolyn Wyborny <carolyn.wyborny@intel.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        tom.herbert@intel.com
References: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
From:   Shannon Nelson <snelson@pensando.io>
Message-ID: <f2105737-007d-35f6-426d-ba72df029c13@pensando.io>
Date:   Tue, 25 Aug 2020 09:31:36 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <159797251668.773633.8211193648312545241.stgit@cmw-fedora32-wp.jf.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 8/20/20 6:16 PM, Carolyn Wyborny wrote:
> Proposal for Granular VF Trust Flags for SR-IOV
>
> I would like to propose extending the concept of VF trust in a more
> granular way by creating VF trust flags. VF Trust Flags would allow more
> flexibility in assigning privileges to VF's administratively in SR-IOV.
> Users are asking for more configuration to be available in the VF.
> Features for one use case like a firewall are not always wanted in a
> different type of privilegd VF.  If a base set of generic privileges could be
> configured in a more granular way, they can be combined in a more flexible
> way by the user.
>
> The implementation would do this by by adding a new iflattribute for trust
> flags which defines the flags in an nla_bitfield32.  The changes `would
> also include changes to .ndo_set_vf_trust parameters, different or converted
> settings in .ndo_get_vf_config, kernel validation of the trust flags and
> driver changes for those that implement .ndo_set_vf_trust. There will also
> be changes proposed for ip link in the iproute2 toolset.
>
> This patchset provides an example implementation that is not complete.
> It does not include the full validation of the feature flags in the kernel,
> all the helper macros likely needed for the trust flags nor all the driver
> changes needed. It also needs a method for advertising supported privileges
> and validation to ensure unsupported privileges are not being set.
> It does have a simple example driver implementation in igb.  The full
> patchset will include all these things.
>
> I'd like to start the discussion about the general idea and then begin the
> dicussion about a base set of VF privleges that would be generic across the
> device vendors.
>
> ---

Hi Carolyn, thanks for sending this out, and for your presentation at 
NetDev last week.  Here are some initial thoughts and questions I had to 
get the discussion going.

Would this ever need to be extended to the sub-function devices (sf) 
that some devlink threads are discussing?

What would the user-land side of this look like?  Would this be an 
extension of the existing ip link set dev <pf> vf <vfid> <attr> 
<value>?  How would these attributes be named?

Will enabling the legacy trust include trusting all current and future 
trust items, or should it be limited to the current set?  If limited, 
then you might add a macro for VF_TRUST_F_ALL_LEGACY.  Not sure whether 
or not this would be a good thing.

Instead of SPFCHK_DIS or "spoofchk_disable" - can we get replace the 
reverse logic and rename these?

Permission bits might be needed for allowing RSS configuration and 
bandwidth limits.

Will there need to be more granularity around the Advanced Flow 
configuration abilities?

Should there be permission bits for changing settings found in 
ethtool-based settings like link-ksettings, coalesce, pause, speed, etc?

How can we guide/manage this to be sure we don't end up with vendors 
pushing device specific permission bits or feature enabling bits rather 
than generic permissions?

Do we really need a typedef for vf_trust_flags_t, or can we keep with a 
simple type?

Cheers,
sln

