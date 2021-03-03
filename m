Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5059D32B414
	for <lists+netdev@lfdr.de>; Wed,  3 Mar 2021 05:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236581AbhCCETm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Mar 2021 23:19:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1449743AbhCCEC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Mar 2021 23:02:59 -0500
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AD96C06121F
        for <netdev@vger.kernel.org>; Tue,  2 Mar 2021 20:02:19 -0800 (PST)
Received: by mail-oi1-x234.google.com with SMTP id a13so24535803oid.0
        for <netdev@vger.kernel.org>; Tue, 02 Mar 2021 20:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=MF3q5LsFxiiZEwIRvcWgf7VjHoEGODe2jEV+FbkK9D0=;
        b=TgUh4eeU5KHIHhJ13O6bPbZGaKb6ICYIzD7CrHm9/X2hWdeplqZ/pQ7KrvP1QF4DXx
         94XRLlMKsAVccACggnPbgljvJ7Kqgk/S5eAH2rFjBYW+1g3CpslqEN+iEa7u6FoxwFhS
         UwbAI5/KlEUR1CIs2Ema454qhlBEpYwa94DoBmhYinZv+l8/xTFzKkQU7UwRcuMjAPyH
         bP+6nyhBtKKK8oET7CFjw91pxzcATRh82UIqiDTnKjR9Z4+xRjI/bNngluUmvsR8jA8p
         xpqZhwrUlu6RjXF1ZLuhERvJ4egMPmEV5dK4s4bypvsXiwWG2s2KQJHXwCV5LyTi4m2q
         DAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MF3q5LsFxiiZEwIRvcWgf7VjHoEGODe2jEV+FbkK9D0=;
        b=RtmPi5LQt2oWSRKYqfND9mXZENmY33Qr4ksKp3V/dsp1JWpQauBCBSNqFosGnQXFtw
         kVEqfarUCxRvuV3DIzfg1BNKx6vhZHO0TrC3ZIeuontRpO65R3Qet6VV4nAdhf0IwHPF
         aWRr0mmB1h+B03QEidLwIEwCQ2hXLN5nmNdxVSm+USpGjwE+MMoe6uUIr/7DroSX+2Q5
         Yf4Jx0ur3IPxhjlAzNvaxFQUFWP6jor8UKI58AAyyScTk4uTA7zQrFQXNxhlZVh7+pMU
         2CwZYHAkO0U8MmM7MyfjhaiB18LyHYJTu3YzAVaBfP+i2Namz1/uyTIlPyUCAHlfNMM/
         yuPg==
X-Gm-Message-State: AOAM533GHCAlI6K2e/Q0lQsFtXt2XEpQ6U5/W/1iy57ewRBZQBQNkM7S
        UxrgFJkBaxDycBRcOOIOS9ynEOZtYSo=
X-Google-Smtp-Source: ABdhPJyU+3dTQR74Ni+fLE71fXlikMTo+ReBk7wtJcK5nmMQAr+oLIKzJeF1x0EIfAVvGYuUxuZ4Ug==
X-Received: by 2002:a05:6808:f15:: with SMTP id m21mr5813410oiw.123.1614744138742;
        Tue, 02 Mar 2021 20:02:18 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.40])
        by smtp.googlemail.com with ESMTPSA id a84sm4509860oib.54.2021.03.02.20.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 20:02:18 -0800 (PST)
Subject: Re: [PATCH iproute2-next 0/4] devlink: Use utils helpers
To:     Parav Pandit <parav@nvidia.com>, stephen@networkplumber.org,
        netdev@vger.kernel.org
References: <20210301105654.291949-1-parav@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3b698223-8c50-9a28-1ce1-b1e7bd1b97a1@gmail.com>
Date:   Tue, 2 Mar 2021 21:02:17 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210301105654.291949-1-parav@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/1/21 3:56 AM, Parav Pandit wrote:
> This series uses utils helper for socket operations, string
> processing and print error messages.
> 
> Patch summary:
> Patch-1 uses utils library helper for string split and string search
> Patch-2 extends library for socket receive operation
> Patch-3 converts devlink to use socket helpers from utlis library
> Patch-4 print error when user provides invalid flavour or state
> 
> Parav Pandit (4):
>   devlink: Use library provided string processing APIs
>   utils: Introduce helper routines for generic socket recv
>   devlink: Use generic socket helpers from library
>   devlink: Add error print when unknown values specified
> 
>  devlink/devlink.c   | 365 ++++++++++++++++++++------------------------
>  devlink/mnlg.c      | 121 ++-------------
>  devlink/mnlg.h      |  13 +-
>  include/mnl_utils.h |   6 +
>  lib/mnl_utils.c     |  25 ++-
>  5 files changed, 203 insertions(+), 327 deletions(-)
> 

applied to iproute2-next. Thanks, Parav
