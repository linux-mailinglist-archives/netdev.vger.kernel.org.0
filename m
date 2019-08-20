Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B6A9694A
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 21:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730552AbfHTTWX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Aug 2019 15:22:23 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36678 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730088AbfHTTWW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Aug 2019 15:22:22 -0400
Received: by mail-qk1-f193.google.com with SMTP id d23so5504903qko.3
        for <netdev@vger.kernel.org>; Tue, 20 Aug 2019 12:22:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=UxntnfUhoyfJtCVV8rivLfmU6f8XilX6XjYLYMrrx5k=;
        b=NB1jHGW3AC8XEU0X0M4MEWLljIPAucw1LyO0zPMU/BaLmYL8rqH32Ygv6DtluhA2Wc
         +kJpeQV148DYsYUf1NeTU1KHEbBoMgIkpjmeJl9rDmKzInPNqNIMN0/x0HwIcRE4Z5lk
         FsSrYhY3kBXzJpmPRG7wmwCe/Q/RHY3MwrtzbU9+c2o1sGgY3YVGCGQcjpQlByhlD8L9
         q6QD8447pCe5MEEZMLXDjPUCO3GWH7SoUNu67LvJk+HE3zqECpLWls15XZIK0Cov3rIP
         9Zo6OZnbV3TLcFR2BkXs7y9eQye/fqJgax7TH583KgFcRpV++eoTkGAfTsukoBwvQIdB
         oDxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=UxntnfUhoyfJtCVV8rivLfmU6f8XilX6XjYLYMrrx5k=;
        b=exnvJipsnUdXvJG+hDNqBWv0SAxBvlYiyJJZuYPhdE47ixdon4t0s+T7e4avFtuoZK
         BVL7mZ2c6cME1vk9R5428jNLv23FwT/347BrT2WbqGUx3Zb2kwgOzonQU3dEADUdhJi2
         +Ml+CFOSAiUYVZUf/vcUk5nKGiTCdNHPW4jDkfVmH5+oMSOWppH68F9vVfxAAPLCb0S0
         wPWvC5opPgLpMa0S8vdrqyfyE8pJ+IUiAveIbuK0NvoMzNSQd5BpcH2b6Rh7k1CnXR3x
         8J1N3qpcEeTNbkTSpRNnvjZrqJ6iCQVeo6ZY2C6umj3QpiFVi8+XWwlImDZt1lxJF8U4
         3m/A==
X-Gm-Message-State: APjAAAX5d0fQbIDhskFI9cNJW2AnIdr4bL+GrP8u3ADvfiGrqZF5I8Si
        PAn0PqjiQJPO5hpGDsQp0l7mnw==
X-Google-Smtp-Source: APXvYqxAdhriNfgclkhutoA76ENPDWPTnCr4/+6N7ogosLbY09gYfGp0x57+ZDCDTfwFOkvHBzGkgg==
X-Received: by 2002:a05:620a:112b:: with SMTP id p11mr28580891qkk.146.1566328941748;
        Tue, 20 Aug 2019 12:22:21 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id o43sm10499059qto.63.2019.08.20.12.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2019 12:22:21 -0700 (PDT)
Date:   Tue, 20 Aug 2019 12:22:14 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, vladbu@mellanox.com
Subject: Re: [PATCH net-next 0/2] netfilter: payload mangling offload
 support
Message-ID: <20190820122214.702476ff@cakuba.netronome.com>
In-Reply-To: <20190820104807.13843-1-pablo@netfilter.org>
References: <20190820104807.13843-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Aug 2019 12:48:05 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset adds payload mangling offload support for Netfilter:
> 
> 1) Adapt existing drivers to allow for mangling up to four 32-bit words
>    with one single flow_rule action. Hence, once single action can be
>    used to mangle an IPv6 address.
> 
> 2) Add support for netfilter packet mangling.

Why pick 128b as a unit, because that's nftables' word size? :/

Reality is unless core coalesces _all_ consecutive rewrites drivers 
will have to do their own coalescing, anyway.

We suffered through enough haphazard "updates", I don't like this either.
