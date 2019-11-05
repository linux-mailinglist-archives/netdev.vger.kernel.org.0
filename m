Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85D79F0A12
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 00:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728965AbfKEXKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 18:10:43 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:33262 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726820AbfKEXKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 18:10:42 -0500
Received: by mail-lj1-f194.google.com with SMTP id t5so23866029ljk.0
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 15:10:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=/NxdYqXU0EuRHMjBjjcWbXCy1sSIhgK+eQUNtNeq5B0=;
        b=E3DFJ1DxIfmgW024FtOkDfVsgl2JuSSmUK2eT+1t/DcrC7nTbvQMR+flJ2q8e86YYr
         74fDyJE2Sa/DlRl4Wvd0Dezc2hDdJBG8y6JqJGmkmSXHpnoIcryWnVBDhYDOfFaTGAqp
         s5DLEkFI22Lh2y8j9DGWcslfLT3THI2GRHRl4od1XglURi33cECi8Y8d0E2smAu5+4Gc
         B9Z7FucyG6HoM2T0iR9A/+UwGWkZDYMYELDe1wTo7AOLYy4dwfcD9OyP3FZzhTcEd10k
         OmNFwSgxRI1Sc01TgGyxK2/yUYueyCDqMFZCrP41CzT64W+4Crnq0gudw4Dx2YXUBqjy
         Vrrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=/NxdYqXU0EuRHMjBjjcWbXCy1sSIhgK+eQUNtNeq5B0=;
        b=HYNaKxTRSav7YNHYkCPoS6l/rd0u8d0b+x9tHw/p7DNmdpeW+I4HFDs6bh1nDoeH/k
         p8whOp0vJyFh2kFmEU43y5LBILwpEy03/WeDcDWYDLA5esibj/rzGsIg0HVSJ5l7GyE7
         V5IaHciZApmP+SgcbC2/ct9kFoWdd6Sk3O9i4G06fYsT26H2gCEcY0YpiO3YUM8HpaUS
         8SyctKXLfQPqWTzQ012Z8n99vnr+WvHuOpCqm8C9poudTkF+Q75cgrnfRo9LsR1cEXDn
         8PcgdeAlt+tNRnAJqotIy8PxTKPxGFi20OPzwLd3Mp3BFxBiglgGz0RvcaKcEcftxDGZ
         rlSA==
X-Gm-Message-State: APjAAAUpDV+c+bhXCG8jEDnasNRHnLU1u8gCnXFT2tQ5znGJTQPF8mDd
        XEdRvfZW1Ly0XKR/+1c6J7PulQ==
X-Google-Smtp-Source: APXvYqzkmtW5frAW1G74vAARGJlAYRGopUZTjL6NK0FLLLLSf2/OMfv0R8AhKQ1XRbB3yKaxHcrUHA==
X-Received: by 2002:a2e:9b5a:: with SMTP id o26mr10320227ljj.174.1572995440665;
        Tue, 05 Nov 2019 15:10:40 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z17sm3690298ljz.30.2019.11.05.15.10.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 15:10:40 -0800 (PST)
Date:   Tue, 5 Nov 2019 15:10:31 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191105151031.1e7c6bbc@cakuba.netronome.com>
In-Reply-To: <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
        <20191101172102.2fc29010@cakuba.netronome.com>
        <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
        <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
        <20191104183516.64ba481b@cakuba.netronome.com>
        <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
        <20191105135536.5da90316@cakuba.netronome.com>
        <8c740914b7627a10e05313393442d914a42772d1.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 22:52:18 +0000, Saeed Mahameed wrote:
> > > it should be just like ethtool we want to to replace it but we know
> > > we are not there yet, so we carefully add only necessary things
> > > with
> > > lots of auditing, same should go here.  
> > 
> > Worked out amazingly for ethtool, right?  
> 
> Obviously, no one would have agreed to such total shutdown for ethtool,
> we eventually decided not to block ethtool unless we have the netlink
> adapter working .. legacy mode should get the same treatment.
> 
> Bottom line for the same reason we decided that ethtool is not totally
> dead until ethtool netlink interface is complete, we should still
> support selective and basic sriov legacy mode extensions until bridge
> offloads is complete. 

But switchdev _is_ _here_. _Today_. From uAPI perspective it's done,
and ready. We're missing the driver and user space parts, but no core
and uAPI extensions. It's just L2 switching and there's quite a few
switch drivers upstream, as I'm sure you know :/ 

ethtool is not ready from uAPI perspective, still.

It'd be more accurate to compare to legacy IOCTLs, like arguing that 
we need a small tweak to IOCTLs when Netlink is already there..
