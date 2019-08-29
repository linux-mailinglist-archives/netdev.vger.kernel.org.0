Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 10048A2B60
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 02:22:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727286AbfH3AWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 20:22:16 -0400
Received: from mail-pl1-f179.google.com ([209.85.214.179]:36766 "EHLO
        mail-pl1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726988AbfH3AWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 20:22:15 -0400
Received: by mail-pl1-f179.google.com with SMTP id f19so2425566plr.3
        for <netdev@vger.kernel.org>; Thu, 29 Aug 2019 17:22:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NKSyYzC0yvWZHg9K3gsbaOF4EhwFw+JfRQ/HjpzU3yw=;
        b=RUadGj802veU1pQkZ+zkWPfrgcP3Ws4ddeZu2rh3VGCl+FDL35LwfBzYgsKGfDiyt0
         GyMj+QXtKYsjVFtSFvyCwBSqJVREICePi9lmTwQbz9oTQyDUPY6hmJgIo+z2TPOM7xCb
         jvZZzVJORFDWs5HzJYTiTm6YEm0gO+OpE06+mBUUgLcQ1S8dlJ4t1b3DEfIJqLEGSJPn
         C90DUqkLdBdFd9xW3h+/RArrsi7YDHIwmEhTphUEfh8qpqm6re2XenmZw5r21FNxPEfG
         jpcXR5sCQENAW2lKWHloVQiUFPT4/rV/pXJKE+QT0H6LbEwy9Pv6/iBrMJUv1kk2cBTA
         uMfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NKSyYzC0yvWZHg9K3gsbaOF4EhwFw+JfRQ/HjpzU3yw=;
        b=WehL/mFPwOaqDR1Nrzs7A0bGZfgr1bZKSVRCay/27Aa/mLvWGEdFzwCJTtcnEeT+8N
         US8N6Z0XPM7ZqRM0pOwqNhurPjdX3BzWZuYwnMXOcxvlN32yBTqoISTOyJskCNBt2Y5M
         W0CI1n+7TkjV/dOhPAEPPZXkt5KuiTfO7NoteB5/ksTZMaaKRXRDEILsvY8YK47OQ3Kt
         SCvSVk/5L/wXKmdBDxAFEaYbFdlB5lIa8rBt3xzxsmsTpMbu+zV0uz23PE/LVXi7pmIW
         xn/OBm6qdE5J7hjdrlwnePxLafi8pXD6PXXYSzE7sz7+5YazaBZRKA4Tll80Cv9iu71X
         nzog==
X-Gm-Message-State: APjAAAWGBZNNsrMFP6rEDa4Pt3Ly++7to0YFYej81fjiVuDTSe1xqmwk
        kb65MmG2jyXzep2raroq2Z9bcQ==
X-Google-Smtp-Source: APXvYqxw6O/6pinN0+sd/TkAkyIipSyBdbA4+rNkMwAyxt4qIihUA409tqz1xdiH1jl68EbzwgO4FA==
X-Received: by 2002:a17:902:bb95:: with SMTP id m21mr12708786pls.26.1567124534329;
        Thu, 29 Aug 2019 17:22:14 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v189sm4514745pfv.176.2019.08.29.17.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Aug 2019 17:22:13 -0700 (PDT)
Date:   Thu, 29 Aug 2019 16:25:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Aya Levin <ayal@mellanox.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [iproute2, master 1/2] devlink: Print health reporter's dump
 time-stamp in a helper function
Message-ID: <20190829162533.25606191@hermes.lan>
In-Reply-To: <1566471942-28529-2-git-send-email-ayal@mellanox.com>
References: <1566461871-21992-1-git-send-email-ayal@mellanox.com>
        <1566471942-28529-1-git-send-email-ayal@mellanox.com>
        <1566471942-28529-2-git-send-email-ayal@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Aug 2019 14:05:41 +0300
Aya Levin <ayal@mellanox.com> wrote:

> Add pr_out_dump_reporter prefix to the helper function's name and
> encapsulate the print in it.
> 
> Fixes: 2f1242efe9d0 ("devlink: Add devlink health show command")
> Signed-off-by: Aya Levin <ayal@mellanox.com>
> Acked-by: Jiri Pirko <jiri@mellanox.com>


Looks fine, but devlink needs to be converted from doing JSON
printing its own way and use common iproute2 libraries.
