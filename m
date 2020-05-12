Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F68C1CFD78
	for <lists+netdev@lfdr.de>; Tue, 12 May 2020 20:43:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728070AbgELSne (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 14:43:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgELSnd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 14:43:33 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36177C061A0C;
        Tue, 12 May 2020 11:43:33 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id u22so5739727plq.12;
        Tue, 12 May 2020 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=yEQQ3oY6n+6Y5G7SrZB9zIDyQj6Eog3Iin7PH+iGp/c=;
        b=KcxcfLLj2zlF9sfSUoowcJSR21V6lFSddOpYjAZgCfrJoNrbZQE4Wn7O4OTEmCQDsQ
         zuJIZcN9aAGS/bPN+ZfjKh58iDq5PSK4D7ZMEvRFFtcn0qv+rDITU/gT0XbKh6Vp/lOG
         8hv/kvmFBSCQaPupN31nRIBtTxzumBenrnV/g/0+vHexRAyEjHTtbN6FBM6Z/pvZNQMT
         wIXRoqU3Fq3e+s600oQT3XQ1vcF1nou0jvud2iM2HclUmgYLHtxZGn7PcAEIUJn/+TDE
         IF30QnV+7CwocCCtYvuc2HASis6ND1L0THtDg4E97xfGF28k79epP4Oh+27Rf7nWaX0n
         AXTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=yEQQ3oY6n+6Y5G7SrZB9zIDyQj6Eog3Iin7PH+iGp/c=;
        b=q1pcYfd8yUeFFWRd9NP1avAGmDh3cbjYILNxRVzmWj9rCjl5Fsc+xJ5KgRuO58NjoZ
         9+sfPbSEgcqXyb3tubEj3nbmnkpCQuakzPVzqEP1uBF0/M6IxoIZ1QecTMFP5hFVkwiL
         KXLRVDPOvWaRAlyi+r8rP8eDO4QOH1R70fH42QkbpGW1cEO9u1LptZLGZWdVyDEO1YTd
         hwndTcH/M5boXARQgA/Rv6t6+rGaYlN09NqNAe0xnjeiqCW/b7XzPIr2gttMnHBSbCQp
         kNffyAp/8M+EsrMiwlNijiehmlNEA0CZXZMHi2T0fLIIf8We3bWPsLVJMR3AmBaE+MnX
         Cl/w==
X-Gm-Message-State: AGi0PuZoJegclzIJP2ZqiUVYileHcy/N8xyEMRZnqXRqG447c/FHglrs
        3tiHPbt0Dri9lnokcXhBd80DW2rL
X-Google-Smtp-Source: APiQypK86i+XgsSCfbBIThKrVEfVIiPh+0/4/VL7zndVgxQMlqoEDRvnOdn4xlt1baUNlwp8WICS6A==
X-Received: by 2002:a17:90a:cb8c:: with SMTP id a12mr30448567pju.153.1589309012268;
        Tue, 12 May 2020 11:43:32 -0700 (PDT)
Received: from [10.230.191.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q2sm12712326pfl.174.2020.05.12.11.43.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 May 2020 11:43:31 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] net: ethernet: introduce phy_set_pause
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <1589243050-18217-1-git-send-email-opendmb@gmail.com>
 <1589243050-18217-4-git-send-email-opendmb@gmail.com>
 <20200512005118.GE409897@lunn.ch>
From:   Doug Berger <opendmb@gmail.com>
Message-ID: <569e5f7b-6a6e-a350-53c1-cc6b234078f0@gmail.com>
Date:   Tue, 12 May 2020 11:46:20 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200512005118.GE409897@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/11/2020 5:51 PM, Andrew Lunn wrote:
> On Mon, May 11, 2020 at 05:24:09PM -0700, Doug Berger wrote:
>> This commit introduces the phy_set_pause function to the phylib as
>> a helper to support the set_pauseparam ethtool method.
>>
>> It is hoped that the new behavior introduced by this function will
>> be widely embraced and the phy_set_sym_pause and phy_set_asym_pause
>> functions can be deprecated. Those functions are retained for all
>> existing users and for any desenting opinions on my interpretation
>> of the functionality.
> 
> It would be good to add comments to phy_set_sym_pause and
> phy_set_asym_pause indicating they are deprecated and point to
> phy_set_pause().
> 
> 	Andrew
> 

To be clear, this patch set reflects the pauseparam implementation I
desire for the bcmgenet driver. I attempted to implement it as a common
phylib service with the hope that it would help other network driver
maintainers add support for pause in a common way.

I would like to get feedback/consensus that it is desirable behavior for
other drivers to implement before promoting the change of existing
implementations.

In particular, I would like to know Russell King's opinion since he has
clearly observed (and documented) the short comings of current
implementations as part of his phylink work.

If others agree with this being the way to move forward, I will submit
another revision with your suggested comments about deprecation within
the specified functions.

Thanks for the feedback,
    Doug
