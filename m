Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 58B53838C9
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:42:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHFSmC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:42:02 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:44163 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726469AbfHFSly (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:41:54 -0400
Received: by mail-qt1-f194.google.com with SMTP id 44so54564060qtg.11
        for <netdev@vger.kernel.org>; Tue, 06 Aug 2019 11:41:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=8xcfqBh6UIl/C/ekxrxUbzURhem3fjy0jnP2hgpMKys=;
        b=u9nFMnrqsQFAc/LUYvI2tdrsCE6/0sRvCSTPWJDag1JY2dGurAnhQoksDXg0oIX1SS
         k/fwbH32kunMiQ6yn2Es1k7i/h1vjevhR3m/YhgtjexhmLfUP9i1QZN50gTdiHiwhbqu
         DQAKpzzs/+q8sSog3DPjMSJjpAEskYnBAWewgkAlo3QkmrXLada3i4B43H1yp3sJI4jj
         S+WgTmBdMjFZZcPPqc7/B1VSX0gEWI2sQw7c6vT3xalJX3mlLX/jO9H5rzGnG4uytw3m
         SrVxwsq4MEYGY1/mU/YYD/yqBtWJQSnyeK89ntqjebuxHU9TUf2sLHog4leFrzUCUAdD
         5V+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=8xcfqBh6UIl/C/ekxrxUbzURhem3fjy0jnP2hgpMKys=;
        b=pO7GNrEvqAZJYz13yyKV2j1G8GQjNv2PnvOCn1SHh4cbPUcV+RcvPUEsoi4GsZTLC5
         33pCFmtgRyhpI+ne0V+VLTgizDrC6PHcr2pbZDGwb9894XJGgnVSbA+k5qoGp+Rglz22
         U/IoBUsr9daw3oSeFugKzHhtWXbfAwr1+pkW8aAzWebrg9F4nz+19PTBqGwMzneP91gj
         mRIIE3eXLUXwkSJReCsKf6KyxqfgZLUnKZfPG7a/NGy3A2KSeN5KTDlwt8LQgfkL16pY
         etS/fEz+bIwVLlEkMfjGO0gqLy2DI5AZyKfMvC0bxfxNK8+vXy3HED6jnvyVmZcQ1aNo
         yIrw==
X-Gm-Message-State: APjAAAXprFwcmzMQih8dftCmv3k0J+UEehT0XlokqmKOLo2BEusOzZ5/
        f+WMmraA+LFs4z3QqPKZVQ7esw==
X-Google-Smtp-Source: APXvYqzruFWjL/2GwPpTKTpPfw/eE6M+ZJ8LvUD0lwb09y0REyBNCEjPnxGiA4n6O8ceHLFYUmXWjw==
X-Received: by 2002:ac8:2b01:: with SMTP id 1mr4471790qtu.177.1565116913850;
        Tue, 06 Aug 2019 11:41:53 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id d20sm35426478qto.59.2019.08.06.11.41.52
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 06 Aug 2019 11:41:53 -0700 (PDT)
Date:   Tue, 6 Aug 2019 11:41:27 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, marcelo.leitner@gmail.com,
        jiri@resnulli.us, wenxu@ucloud.cn, saeedm@mellanox.com,
        paulb@mellanox.com, gerlitz.or@gmail.com
Subject: Re: [PATCH 0/2 net,v4] flow_offload hardware priority fixes
Message-ID: <20190806114127.54d9d029@cakuba.netronome.com>
In-Reply-To: <20190806160310.6663-1-pablo@netfilter.org>
References: <20190806160310.6663-1-pablo@netfilter.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Aug 2019 18:03:08 +0200, Pablo Neira Ayuso wrote:
> Hi,
> 
> This patchset contains two updates for the flow_offload users:
> 
> 1) Pass the major tc priority to drivers so they do not have to
>    lshift it. This is a preparation patch for the fix coming in
>    patch #2.
> 
> 2) Set the hardware priority from the netfilter basechain priority,
>    some drivers break when using the existing hardware priority
>    number that is set to zero.

Seems reasonable, thanks.
