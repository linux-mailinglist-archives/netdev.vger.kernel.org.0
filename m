Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73D8422A3BA
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 02:35:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387431AbgGWAfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 20:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387427AbgGWAfH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 20:35:07 -0400
Received: from mail-qt1-x842.google.com (mail-qt1-x842.google.com [IPv6:2607:f8b0:4864:20::842])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A08CC0619DC
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:35:07 -0700 (PDT)
Received: by mail-qt1-x842.google.com with SMTP id e12so3255562qtr.9
        for <netdev@vger.kernel.org>; Wed, 22 Jul 2020 17:35:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9MfjHEjIOEz2vznB1MFDJ2BU0OjR+6Ks5eYaV4toaDw=;
        b=lASBsi8h8hMIGbptSz6088JrZByHcXJka1PZnCzDv4rgAMy05RBQa94A88bFP/5CGU
         RTxS33IK393rZmDzrb+4YvNLb77p8WdjJ3G7HLIkmQFcf0MAaPgDjz3KG5aBH701MDE+
         s9N1Vr+ekWwSgFwC4T74xxKLLNNsNUiuuHUJBYBFjE2gQT6KJNNWU3pezFdXpWbolv67
         /AlPcOkNgXz+OwmhBhk85LW6g5BAvf7QDmhcG4qSSGIIqBpebGmg48up3EX8llM7BdPc
         Azp1Atr2o4X/AXT5J9b/HbfCvqZdi7t3ZfaPQsAKAnn23EVVQROvO2Dyy8aCbykDIGFp
         vQxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9MfjHEjIOEz2vznB1MFDJ2BU0OjR+6Ks5eYaV4toaDw=;
        b=KQv2/h57kA3wiAfmHnghj4adgc1ZKEpD+mASubPYOHMwDytY+Gs+eJOfFTSZQdZHsa
         yxRgamDfAPzCit5tTg1NZaybKaOkWZR2GlRvSADucuRi/8FkJrIZfr+YUnR0DCr0jRcC
         qxRczsUaqES2T2ZdjNd5e2CUjA3sNQ6BVlizH0BP9X/3HF+TLgMFc6Eh2aaJHpNL9MJV
         gSzsuWXIbbQgTl9UA57XFyqQ6mU+CNtP8puzW/J5fgFqd5Mbc1mspW9pm+Y+mEbTIQW7
         ImWuS+I3kWj4tBMva29hpryECB4Qyj/aE1NO5M/hydi5p2W+34r7c8OT96kJdwQFqXp5
         451A==
X-Gm-Message-State: AOAM531EYYf54CxY/rRxjAC3d2wnTxwevDfMwwExIGMF+eb2ymOv251W
        wmJBuZ3dHZ1NI2ZC6stCP0awurCG
X-Google-Smtp-Source: ABdhPJyq94ImR7tpR7/iK7Knn8iVHm5LUfPpS19jpPsZDFwKoEfDodNh1YYL2Z9LujVgHaib3S2GWA==
X-Received: by 2002:ac8:3528:: with SMTP id y37mr1102886qtb.308.1595464506229;
        Wed, 22 Jul 2020 17:35:06 -0700 (PDT)
Received: from ?IPv6:2601:282:803:7700:5c10:aafb:1d38:5735? ([2601:282:803:7700:5c10:aafb:1d38:5735])
        by smtp.googlemail.com with ESMTPSA id k56sm1152995qtk.61.2020.07.22.17.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2020 17:35:05 -0700 (PDT)
Subject: Re: [PATCH iproute2-next 0/3] devlink: Add devlink port health
 command
To:     Moshe Shemesh <moshe@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org
References: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <29b36120-1bd7-2fa2-ed0a-92974fa5abda@gmail.com>
Date:   Wed, 22 Jul 2020 18:35:04 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1595165763-13657-1-git-send-email-moshe@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/19/20 7:36 AM, Moshe Shemesh wrote:
> Implement commands for interaction with per-port devlink health
> reporters. To do this, adapt devlink-health for usage of port handles
> with any existing devlink-health subcommands. Add devlink-port health
> subcommand as an alias for devlink-health.
> 

applied to iproute2-next

