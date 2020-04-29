Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 030281BEB79
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 00:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727783AbgD2WHH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 18:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726481AbgD2WHG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 18:07:06 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A2BC03C1AE;
        Wed, 29 Apr 2020 15:07:06 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id f7so1757551pfa.9;
        Wed, 29 Apr 2020 15:07:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9ndRoPlpZBec4FKvvdG47QpHsR6Nba+z0J+SwIthjZk=;
        b=C3D79jb7ilSAHTz9OU68LGMkmtVmvRhXcs9QnnUJuHYFVMI+CyP81stbxFpj4e+3lD
         39eycotiG0E5RgJcWixUQuNFX4w5U5MR277EwljiB2PREOVxE+n9Kn4iFbb1tgpXAZSM
         LntQvfLh1YvODX/pj7IW1w+rRaOh3vzFjFCTN1JrpG4ljUThPreehFIOq/MQXJ+kXsYS
         G1QSh70hqoGxgxFr0kx80tITYSOQVDRxyDisc2056uUwF/eNvKsuMXKHcMQgLUAiX1WG
         6QjNuiOA7g+qNd/Gqyy9cn91IdpZjxk0TEe7uLeoqWM1n1hCPSWdP09wPKS6ep5EwHlA
         XZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=9ndRoPlpZBec4FKvvdG47QpHsR6Nba+z0J+SwIthjZk=;
        b=XPgVQP5nYoX321vHhPN6393FzjAZwqHQRM/AwgAe/YOo8uC9jyaL6AUwywloskDQLH
         DTrowdJeE9ParFeNddD4Vz/qWUYhNWg6ljcPXG6OQDkZY6JK75RvROoKiO4HXcA+/zm/
         bGWwOKpx5wqru+ni3jfwZRgqmcwiUXDGRySRZC7buDQoSv90Zxyeql7+3VCIXYkKR7U9
         maL/7QmBB6SmLKOlg9Fnt5aQW9nqD41XWJKK5VI6Bh00kP9DY/sYkqPA/CiXk0FS3bjg
         vCLp3YwMv1CtOtceJd4mjBcFkycn9M/kBoxEvRVRJpYZ1SaelKCgRUBqLXyogwiRVIDd
         ID/Q==
X-Gm-Message-State: AGi0PuZz4dqLMDeBAn7vByky6R5AWKsGUhnI8MyE86Woy20thnhhVTQt
        60N2hMtDXX9mrePkoIWu3BUlSf5+
X-Google-Smtp-Source: APiQypKr4XUJ7pjYbZmWvhtvPgRnCnwI49jHaohI3baAgQHs8YfpLCYz3duP8JmElF6h3RbRYXfK4g==
X-Received: by 2002:a63:7c4:: with SMTP id 187mr317426pgh.59.1588198025793;
        Wed, 29 Apr 2020 15:07:05 -0700 (PDT)
Received: from [10.67.49.112] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 82sm1825658pfv.214.2020.04.29.15.07.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 15:07:05 -0700 (PDT)
Subject: Re: [PATCH net-next v2 0/7] net: bcmgenet: add support for Wake on
 Filter
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
From:   Doug Berger <opendmb@gmail.com>
Autocrypt: addr=opendmb@gmail.com; prefer-encrypt=mutual; keydata=
 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
 rQQYjNSD8+NSdOsIpGNCZ9xhWw==
Message-ID: <8ebd11c0-97f5-dfd4-d194-009d4df99aa6@gmail.com>
Date:   Wed, 29 Apr 2020 15:07:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/29/20 1:01 PM, Doug Berger wrote:
> Changes in v2:
> 	Corrected Signed-off-by for commit 3/7.
> 
> This commit set adds support for waking from 'standby' using a
> Rx Network Flow Classification filter specified with ethtool.
> 
> The first two commits are bug fixes that should be applied to the
> stable branches, but are included in this patch set to reduce merge
> conflicts that might occur if not applied before the other commits
> in this set.
> 
> The next commit consolidates WoL clock managment as a part of the
> overall WoL configuration.
> 
> The next commit restores a set of functions that were removed from
> the driver just prior to the 4.9 kernel release.
> 
> The following commit relocates the functions in the file to prevent
> the need for additional forward declarations.
> 
> Next, support for the Rx Network Flow Classification interface of
> ethtool is added.
> 
> Finally, support for the WAKE_FILTER wol method is added.
> 
> Doug Berger (7):
>   net: bcmgenet: set Rx mode before starting netif
>   net: bcmgenet: Fix WoL with password after deep sleep
>   net: bcmgenet: move clk_wol management to bcmgenet_wol
>   Revert "net: bcmgenet: remove unused function in bcmgenet.c"
>   net: bcmgenet: code movement
>   net: bcmgenet: add support for ethtool rxnfc flows
>   net: bcmgenet: add WAKE_FILTER support
> 
>  drivers/net/ethernet/broadcom/genet/bcmgenet.c     | 673 +++++++++++++++++++--
>  drivers/net/ethernet/broadcom/genet/bcmgenet.h     |  21 +-
>  drivers/net/ethernet/broadcom/genet/bcmgenet_wol.c |  90 ++-
>  3 files changed, 708 insertions(+), 76 deletions(-)
> 
Please holdoff on this version as there is a bug here that I'd like to
patch first.

Thanks,
    Doug
