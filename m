Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8024F102CEB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 20:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbfKSTkh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 14:40:37 -0500
Received: from mail-pl1-f196.google.com ([209.85.214.196]:38020 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKSTkh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 14:40:37 -0500
Received: by mail-pl1-f196.google.com with SMTP id q18so8624471pls.5
        for <netdev@vger.kernel.org>; Tue, 19 Nov 2019 11:40:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=h//iVorELzHVDjO/qXB9yu0h5u+J6/G0Z54rLn1URKo=;
        b=QmKLwYfM5YWvd/PK17t30ukf9G087XBUeCfwi9sMbaAgU2oSkFMZ9xpSw2iLMhjp5x
         ayIauv7LSn3rOORk6bwZrEFk5tL5M3FByIYpER1n93tMrEucZ5S6tI/LzsXxVqxufqo6
         wrFHxQrvPx9rfG54ikjBJP4O9XkYvfx9FavdVGcn4fDdYMRNJk641XPeeNy+XmHWdhon
         2CJIw8rI2IURoTBGi9JptPjH5donBdwWgPpA5gFtWWyWL/Jpn4jlYax66OwERbSMh9Hj
         jE4tCBFGwnCdY1qnB6HpLdXVuxPMKPdXzdQbcHFXyLl9Jo9Q78F4tn3FWm+cVp1krRAR
         i3PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h//iVorELzHVDjO/qXB9yu0h5u+J6/G0Z54rLn1URKo=;
        b=gYOcobiAZOIZG0XMGudyhMt+AOsa4b1OdDLbaWhRlb8xTmtX6Q1tjyVXMOrPSKUpTq
         dMXY7yOSp1lyg81YD2F8z4xdzMnC4ZSLouf40FuftfZvrk+1XhdlTRdiTD92WOjYzOA1
         72x3Vxndmginbutue2BA6kOehsJ2OeCBMNb/tV4jP9aBNnBw6UsYVww4P+LX1raYCEeg
         RXkkbgnz8sl3nRok5qHWHENBm+aluArW2uyRhCyBTX96KBQMTu/F+KF+l1WVI1gNS/Gv
         h5EOGHoJ6T0gwCvshxTjNIIsiLfx7JwJnOqDkzeXEXzoo1AgAhz+8CmKwYEQ4twAi6pN
         7UnA==
X-Gm-Message-State: APjAAAW8qP0gaA/oQFPnvAVJP76NMkGys80DGtymEYPYQPQNU6funMXt
        PxI/Y0MpdBAzeNkV/Uyq2l9Y7Q==
X-Google-Smtp-Source: APXvYqw/DG0iI7WPhvRX5JG6k7ITDeStIyV9e/q910X5TGWESPeaHRhY5mb7gSs2ag3/guHuUotwWA==
X-Received: by 2002:a17:90a:ff04:: with SMTP id ce4mr8620151pjb.133.1574192436266;
        Tue, 19 Nov 2019 11:40:36 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id c12sm28091773pfp.67.2019.11.19.11.40.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Nov 2019 11:40:35 -0800 (PST)
Date:   Tue, 19 Nov 2019 11:40:32 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 v2 0/5] fix json output for some keys
Message-ID: <20191119114032.15d0c4db@hermes.lan>
In-Reply-To: <20191114124441.2261-1-roid@mellanox.com>
References: <20191114124441.2261-1-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 14 Nov 2019 14:44:36 +0200
Roi Dayan <roid@mellanox.com> wrote:

> Hi,
> 
> This series is fixing output for tos, ttl, ct_zone, ct_mark
> in json format.
> 
> Thanks,
> Roi
> 
> Eli Britstein (5):
>   tc_util: introduce a function to print JSON/non-JSON masked numbers
>   tc_util: add an option to print masked numbers with/without a newline
>   tc: flower: fix newline prints for ct-mark and ct-zone
>   tc_util: fix JSON prints for ct-mark and ct-zone
>   tc: flower: fix output for ip tos and ttl
> 
>  tc/f_flower.c | 19 +++-----------
>  tc/m_ct.c     |  4 +--
>  tc/tc_util.c  | 79 +++++++++++++++++++++++++++++++++++++++--------------------
>  tc/tc_util.h  |  6 +++--
>  4 files changed, 62 insertions(+), 46 deletions(-)
> 

Applied, thanks
