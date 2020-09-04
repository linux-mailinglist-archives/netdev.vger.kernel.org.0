Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA05925D3B2
	for <lists+netdev@lfdr.de>; Fri,  4 Sep 2020 10:31:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729863AbgIDIbr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Sep 2020 04:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729707AbgIDIbp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Sep 2020 04:31:45 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B6EAC061244
        for <netdev@vger.kernel.org>; Fri,  4 Sep 2020 01:31:45 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id c19so7007410wmd.1
        for <netdev@vger.kernel.org>; Fri, 04 Sep 2020 01:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=suUQ7WIdhqwk50H5z4NVhYXy4Z+GJL5LbpX6c91ONvA=;
        b=uwR7d883hwS/MxVq/iVHFyn41Py6PMltA9NnTLoDyfs3UmhEthSLsuocJh2y8uPXl1
         wGJZeEGThQp9vUxYG6lowRI3HEH57RzvUuBuOKXHi+Ckb3aaJEG9fIUyArjFX2tUEEkq
         l1gyvp4gPHCEjDdyoCk8UgDejWdU0+yTWDES9lVEW5vWfsXPASR5/TkW5A5NaUMnXzfn
         v+E2H6yODiXHY3Le4pwF8xSTlkWjewKOvTQ4c5irP95PQ0eii15ywaeoO+NG8bo9bv7v
         7FQJfvOUciYGqSPJDahBYxFdns3vO2zsglW1v91fOwC2z3UWWzjiKOvlm1WhqhdshnqL
         e3jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=suUQ7WIdhqwk50H5z4NVhYXy4Z+GJL5LbpX6c91ONvA=;
        b=oBJGKaBp+ns3DjpqbUnHEdRiwMDvNQP80CCwmdcgg4Mkkh+xG0ugcCaOohadtZK0lV
         IKB0W6QWtc3AiIV3c/X0AJUFAm/Y1wP16Ex+wverDWyFRJOq+KpPSRkmEDLDpHuApvt4
         5mj7eDXvw1337dOahb9+PLi3blWd5NgtnaOWOsQOe5xX6P8oUbHUiNDGinau3cyBCpU3
         4QbqR2A3F8TSmIcwYRsSmp+6ouNZXDBKhBeRPxRT3bmLySdV4REWg1Vy4a0dICjHJu6f
         lSC2veqWSRupa9efjG6rURk1W5LNLH/k1KPeo1cYKZBKZJ4C6ZuX5pX672xkQ1/6YWNr
         +ANw==
X-Gm-Message-State: AOAM531ggOqcuKB7MRTOeb8IWnJ/jm79l53LCDkBNxhmPGZOqCtDa5rM
        J/8OqreNyApgTmgeIWqEYU0mLg==
X-Google-Smtp-Source: ABdhPJxgbU2OSMZTygUl5y3oQwo+jX5kG7iwisav38Q0Rp8cjE9/3V0EaLimEQ/wED3plby2oeS71w==
X-Received: by 2002:a1c:31d7:: with SMTP id x206mr6136139wmx.2.1599208303412;
        Fri, 04 Sep 2020 01:31:43 -0700 (PDT)
Received: from localhost ([86.61.181.4])
        by smtp.gmail.com with ESMTPSA id q18sm9835871wre.78.2020.09.04.01.31.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 01:31:42 -0700 (PDT)
Date:   Fri, 4 Sep 2020 10:31:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Thomas Falcon <tlfalcon@linux.ibm.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com
Subject: Re: Exposing device ACL setting through devlink
Message-ID: <20200904083141.GE2997@nanopsycho.orion>
References: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7f76581-8525-2b98-ec4d-e772db692318@linux.ibm.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Sep 03, 2020 at 07:59:45PM CEST, tlfalcon@linux.ibm.com wrote:
>Hello, I am trying to expose MAC/VLAN ACL and pvid settings for IBM VNIC devices to administrators through devlink (originally through sysfs files, but that was rejected in favor of devlink). Could you give any tips on how you might go about doing this?

Tom, I believe you need to provide more info about what exactly do you
need to setup. But from what you wrote, it seems like you are looking
for bridge/tc offload. The infra is already in place and drivers are
implementing it. See mlxsw for example.
