Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A71D9F08CE
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 22:55:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbfKEVzs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 16:55:48 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:43722 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729747AbfKEVzr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 16:55:47 -0500
Received: by mail-lf1-f67.google.com with SMTP id j5so16314968lfh.10
        for <netdev@vger.kernel.org>; Tue, 05 Nov 2019 13:55:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=HsX+1QFT9d8M8onYkicH56ucxJM3dc57YZusD9pWNSM=;
        b=K0fap7thlt6D0uWvkwrIXghtBYpbDw3tv8+tyD6dZmGarvjR9+VlvoukpTmOtYR+6N
         +HWa9Bo/+EejdxLOpSVfBnUT88UJRZaCyML7GuDQh1z4f19s3GS4F/0B2VCKNwdaHsS5
         mCA4vBTrP9TSf4Js/e5XJCgpI2bmGQ5QpJBzOf0wBu4oyUL+ZTvtWve1dssbyt6OwIN4
         o6K/yH8q43Rb/hkTprtxFoEQY4Rj7ujnA0m7nQPoF79yYeyW9vl0R9UYMcrbGjdTZJea
         WRqMp6utzV+QHx4dsHgq8lkKg/r4O7jM9uAr48uRDXSyqIFuPzBKoaMcfIMvZ/2LD0Vf
         8dtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=HsX+1QFT9d8M8onYkicH56ucxJM3dc57YZusD9pWNSM=;
        b=rSlzY1UtHBCOJQLBFrxHwp676tyEIw3xCQuwDwCZsy3I2en7KSb1ybk0gFQvs3nFRD
         I7a3yuIqoUnFAtvhZE3ogpj4SW5a1r8b2ttBqsSJwkbbTJ0kFLu0jvKHewCITVlYnvEK
         l50yzEDF61SlVUqUw1X2S1aWYomo34E0Up97WQhyjVOTYSniD4YxHv6eMayp1q4fvHE3
         OiHNnH7gg1X58tRW8NA87faYP24Um5IGqLKz+TpCUGtzE5OWR5ohLJYtXgdhm+0jgI9I
         j0DOqUMGCCo5lq7zy16sIwzup4Z3YcB1/fRTnA+y0pIEex/c+tZsfTbBir9RflQwxbCC
         4irw==
X-Gm-Message-State: APjAAAWGyKj451/s5t2LNS6Und9NsSYEubmWM5534EgtDDKttvDgiTvd
        hM9p/qXi6InIfWzPDEKZ6b/lxg==
X-Google-Smtp-Source: APXvYqyldlMJ/rsvNqv6pwwxIinu0dv8OPXRrbMOYCOvW5ht5EHdXNXtjAztNlQSJmWgSRHHDVGl5g==
X-Received: by 2002:ac2:5df4:: with SMTP id z20mr21800930lfq.2.1572990945132;
        Tue, 05 Nov 2019 13:55:45 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y6sm9610893lfj.75.2019.11.05.13.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Nov 2019 13:55:44 -0800 (PST)
Date:   Tue, 5 Nov 2019 13:55:36 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Saeed Mahameed <saeedm@mellanox.com>
Cc:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Message-ID: <20191105135536.5da90316@cakuba.netronome.com>
In-Reply-To: <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
        <20191031172330.58c8631a@cakuba.netronome.com>
        <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
        <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
        <20191101172102.2fc29010@cakuba.netronome.com>
        <358c84d69f7d1dee24cf97cc0ad6fe59d5c313f5.camel@mellanox.com>
        <78befeac-24b0-5f38-6fd6-f7e1493d673b@gmail.com>
        <20191104183516.64ba481b@cakuba.netronome.com>
        <3da1761ec4a15db87800a180c521bbc7bf01a5b2.camel@mellanox.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 5 Nov 2019 20:10:02 +0000, Saeed Mahameed wrote:
> > > > Now if the only remaining problem is the uAPI, we can minimize
> > > > kernel impact or even make no kernel changes at all, only ip
> > > > route2 and drivers, by reusing the current set_vf_vlan_ndo.    
> > > 
> > > And this caught my eye as well -- iproute2 does not need the
> > > baggage either.
> > > 
> > > Is there any reason this continued support for legacy sriov can
> > > not be done out of tree?  
> > 
> > Exactly. Moving to upstream is only valuable if it doesn't require
> > brining all the out-of-tree baggage.  
> 
> this baggage is a very essential part for eth sriov, it is a missing
> feature in both switchdev mode (bridge offloads) and legacy.

AFAIK from uAPI perspective nothing is missing in switchdev mode.

> Guys, I need to know my options here and make some effort assessment.
> 
> 1) implement bridge offloads: months of development, years for
> deployment and migration
> 2) Close this gap in legacy mode: days.
> 
> I am all IN for bridge offloads, but you have to understand why i pick
> 2, not because it is cheaper, but because it is more realistic for my
> current users. Saying no to this just because switchdev mode is the de
> facto standard isn't fair and there should be an active clear
> transition plan, with something available to work with ... not just
> ideas.

I understand your perspective. It is cheaper for you.

> Your claims are valid only when we are truly ready for migration. we
> are simply not and no one has a clear plan in the horizon, so i don't
> get this total freeze attitude of legacy mode, 

There will never be any L2 plan unless we say no to legacy extensions.

> it should be just like ethtool we want to to replace it but we know
> we are not there yet, so we carefully add only necessary things with
> lots of auditing, same should go here.

Worked out amazingly for ethtool, right?
