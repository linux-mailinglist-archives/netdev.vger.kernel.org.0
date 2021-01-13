Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8E2F4C59
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 14:41:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726490AbhAMNlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 08:41:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbhAMNlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 08:41:12 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD05CC061794
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:40:31 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id t16so2174979wra.3
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 05:40:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dMjTrj2ZIsoT3fBEIxgqx1DWDqd428z7/UmN+TbPMFk=;
        b=VTykuygDV07n7rb9AR5EaWZw/Y6ruBu7yjavYFfuTauGgwJgzJsGjpNHSJdVs63mK2
         Nx1H2/JHx4awT8kgPRpKcpOukZAtjUg5c0NxhWUZ/CFl5PdPEn/rFhELcGA0PIjM6ZQF
         Cr6/KAmN+sGsexbn4Kk3xmdymGrxQrANtjsZMCO18z6BRPYiiQNhb3/6h9SFaeO8T8+9
         MqDc6ak7jawPRubJTTdE6WLXkeqikTtG43IhEP1nzdZ9o4iWCe5Zg7eAHQi3apBKrS3q
         xF30rAYQ9crgOqGU3Z53dhL/sWGkAqJ5ar+PNjSHRtbKwOyTxuoRQZFPpNl8Th1HaRYU
         644A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dMjTrj2ZIsoT3fBEIxgqx1DWDqd428z7/UmN+TbPMFk=;
        b=ZtzSbZ0boAIo70xe5nSIVWxxoV8G0qyC2L/HsVrgAC9DQKT2nPlX/rJVhWqIvgcDaF
         9Zul/NboSzfVeRwHJ4tBAmfb6RUb+LwvOlnGAcfVo0MTdiyEa+3gQizELIpbvWq6Zzqb
         pIoUmAt4TzpJsVoysxHmTZOSEQbmnv0RV3Ps3N4egLHEzu097qYG+eXItuzt+UCHDq9f
         7z11XcZiZ0SbHZ9Ikxy1FEQckz6aY+i/RAzDseaFVXiyPRj9+8GnhqhztSGOkkY1u0Kn
         sIRc6zfI0tFlomvKsVMaqpZ9aU5OmScVDJYeiw/IO47f+LNNK92joLz3JZmHPAZvlChh
         Npvw==
X-Gm-Message-State: AOAM531QPes6k8HyovcvNe5pKjxYlk5vI7OTnoJR/DH1hYoXqcjgE8JG
        Jjo8A2sSANqmfNp9on5FNTysl+26Se5uuOSe
X-Google-Smtp-Source: ABdhPJwccaVZGRSA+aGHgX2qEYIPNh2zKNIR84Mo9/U4nVk6k0LbIA0QJca9SZNbzI1sOkAQ3wDbZA==
X-Received: by 2002:adf:eac7:: with SMTP id o7mr2705655wrn.23.1610545230394;
        Wed, 13 Jan 2021 05:40:30 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id d187sm2720317wmd.8.2021.01.13.05.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 05:40:29 -0800 (PST)
Date:   Wed, 13 Jan 2021 14:40:29 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, jacob.e.keller@intel.com,
        roopa@nvidia.com, mlxsw@nvidia.com
Subject: Re: [patch iproute2/net-next RFC] devlink: add support for linecard
 show and provision
Message-ID: <20210113134029.GI3565223@nanopsycho.orion>
References: <20210113121222.733517-1-jiri@resnulli.u>
 <20210113121531.733849-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210113121531.733849-1-jiri@resnulli.us>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please ignore this, I messed up the threading. Reposted.
