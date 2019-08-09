Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C73108849D
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 23:26:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbfHIV0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 17:26:39 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:41200 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbfHIV0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 17:26:38 -0400
Received: by mail-qk1-f194.google.com with SMTP id g17so2114201qkk.8
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 14:26:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=u1+ZHMwL7ktzjtiIpIrLhQZ44PIIFJNHWIzLepMnfpM=;
        b=GpNKEfa78X950/Ovlu3fIkG+IpGx+n8vdx2z/QiMw5zHgAwYkSbAEx7PVe+Q+l7Pqg
         t+tWOAVZxv0VKA9p7Iot8VtIC3zCOUV4kF2ix7Qic2AulWH6vwzbnYq4Hl5GgEs9DAcR
         0VuC2kJxmvhqMVhp7DxzTQUrwLwEtJfCQLmGu0Pk0XAhEs8elmuGIF+OL1xsTxNfJhBK
         r43TM1lHNsOoEf2XXvOtNfD6tbIfqdy04hPiaihLWby8oCGAhtijDq/NdAo2HAFV9muq
         w2o91V8eMEmQS+ATrIy1P0DoFbiJT98bq+SlSV8u+O5uCduoC/Gfec6vzUP+lQxjHmVF
         MIpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=u1+ZHMwL7ktzjtiIpIrLhQZ44PIIFJNHWIzLepMnfpM=;
        b=EgzV1fC67258yYJsJBgWqtpq6TWYWTxn9GI0eJp3RE+48jGfcN1btvQuuSyf0RDQ9S
         Lp4BUDspmKAkn2l8kX+3G5n2QFTUKNT1j6MzCLjdIdXeKDFeYuikvONR7xupVUS9pLgZ
         +L82ZJCCW7g2z2eKxIlSrwYKZ22BpitglS59TyGuKkootK9jvTdvs98zApRNg/1Ngn5G
         XElqmBVDtn1s55uSlvY4ljvnqPsBVLINSNO7tw6DhLbIRUiW79AJ2zfLsR4+L41c0i+4
         /6dugNzHfRmV58BlN+ODjtOscTFT+RK1O3XkXRVa9xqMJ6GNj/heVouEj2yW4iAZdnlI
         5GQw==
X-Gm-Message-State: APjAAAXpIaV/R831UtWb3DA9qPMwE2XKvg/3cSPr59EvCBW4Gbee7J1q
        0wmkS+Dbpa3YqPCL0QSUxm2hNjAvihE=
X-Google-Smtp-Source: APXvYqxzvd2znr2YTbcmNzNMfvj6Zg7h2kj0Ti1sWiXtuOpfYW72GUBha0dmWKkRMFnBQuya4IIPHA==
X-Received: by 2002:a37:bd7:: with SMTP id 206mr20497203qkl.440.1565385997979;
        Fri, 09 Aug 2019 14:26:37 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id b13sm58487111qtk.55.2019.08.09.14.26.37
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 09 Aug 2019 14:26:37 -0700 (PDT)
Date:   Fri, 9 Aug 2019 14:26:35 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mlxsw@mellanox.com
Subject: Re: [patch net-next] netdevsim: register couple of devlink params
Message-ID: <20190809142635.52a6275d@cakuba.netronome.com>
In-Reply-To: <20190809110512.31779-1-jiri@resnulli.us>
References: <20190809110512.31779-1-jiri@resnulli.us>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  9 Aug 2019 13:05:12 +0200, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@mellanox.com>
> 
> Register couple of devlink params, one generic, one driver-specific.
> Make the values available over debugfs.
> 
> Example:
> $ echo "111" > /sys/bus/netdevsim/new_device
> $ devlink dev param
> netdevsim/netdevsim111:
>   name max_macs type generic
>     values:
>       cmode driverinit value 32
>   name test1 type driver-specific
>     values:
>       cmode driverinit value true
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
> 32
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
> Y
> $ devlink dev param set netdevsim/netdevsim111 name max_macs cmode driverinit value 16
> $ devlink dev param set netdevsim/netdevsim111 name test1 cmode driverinit value false
> $ devlink dev reload netdevsim/netdevsim111
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/max_macs
> 16
> $ cat /sys/kernel/debug/netdevsim/netdevsim111/test1
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>

The netdevsim patch looks good, what's the plan for tests?

We don't need much perhaps what you have in the commit message 
as a script which can be run by automated bots would be sufficient?
