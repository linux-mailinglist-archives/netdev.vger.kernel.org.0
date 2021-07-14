Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1903C8050
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 10:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238674AbhGNIgy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 04:36:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238653AbhGNIgx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 04:36:53 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3741C06175F;
        Wed, 14 Jul 2021 01:34:01 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id l7so2151887wrv.7;
        Wed, 14 Jul 2021 01:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=xnojNa4qPvmfBP5uflKYHlaeAfH+rfYJSOnoIOlcfbk=;
        b=gbxB2qpogKmSKsCZn9cPt1TJqOvzFsTYwqVj38szpFbCUSN9Mjnjsj90pkHG0nGuC+
         ZpwnpQs/JYPEcEnrCIFRLNLDQK3hzaJNh4AVAOAFzcBp5UF8hDxMSq1PwWUyX+RTjZEa
         Li6SoVuGpuByVaia2Nw+BYyZQgChcGZ6zW4g9Ddd8AcRUUlEKuI1wOREUbHReH7Nij33
         sFPzRLf16M3Kpe9A7ncoAyKAak49MJzwN09zthig0b8dlL2Z7Q32OZLhG3pV62fguIWh
         FAECQLZ725jo8lulitVfZVAWE5zNshOr9rtpmFAXEAr5OX33Mk2G1Rei1nUp1ExxcSbQ
         0g4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=xnojNa4qPvmfBP5uflKYHlaeAfH+rfYJSOnoIOlcfbk=;
        b=V4E+iQELjLpwfTvUJLarGxKpORszF3V8/ISITaHc4/Lje0BGe5FCIGx0e9joMhoisA
         GSp0vCpmjExxDHyiaVfZCSPAlZC2RzAiEHCDnelEVzT8e+NhwGnQBzR8Ijlzqn84IaCf
         JgNHlWGc2z0vYkXpYQMxSZZd4yBjrqrNxP8Dk+KDJe35Oa5YBIi2P49FtTM4jRxVoBKW
         CRwSKOXXqFFrGdeMrMGMEnusNnA+Hc9iTE7kPSBd/Ii9Nv6tMUkcfRWAibcuOT4sIqCX
         BIQ1AmH9u2J7TKt4P1woq6O+MTLQjRW0w2K6s8CEgiEQMjRnAlPU4/zgNOxUOmfAKX3J
         S6nA==
X-Gm-Message-State: AOAM530fdfoVa2M+R0ecDhhKL2jK+xKMELQ0IZk8Wicwto2bHIfunI0j
        rKuAVvnnHWcUlmcb0qCw7ZTQ0D5LpKvGyUSyR00=
X-Google-Smtp-Source: ABdhPJwXmAyqg5YLkEdK5FeRuR0ckVtdzPxbV5xKPHwjdOHEPpNTMbkuXokrnEXa1CTnGYvn7CEXEw==
X-Received: by 2002:a05:6000:180b:: with SMTP id m11mr11465163wrh.6.1626251640264;
        Wed, 14 Jul 2021 01:34:00 -0700 (PDT)
Received: from localhost.localdomain ([212.156.92.62])
        by smtp.gmail.com with ESMTPSA id l20sm1465619wmq.3.2021.07.14.01.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jul 2021 01:34:00 -0700 (PDT)
Date:   Wed, 14 Jul 2021 11:29:41 +0300
From:   Pavel Skripkin <paskripkin@gmail.com>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: Fixes tag needs some work in the net tree
Message-ID: <20210714112941.0b17784f@gmail.com>
In-Reply-To: <20210714082653.612f362d@canb.auug.org.au>
References: <20210714082653.612f362d@canb.auug.org.au>
X-Mailer: Claws Mail 3.17.8git77 (GTK+ 2.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Jul 2021 08:26:53 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
> 
> In commit
> 
>   deb7178eb940 ("net: fddi: fix UAF in fza_probe")
> 
> Fixes tag
> 
>   Fixes: 61414f5ec983 ("FDDI: defza: Add support for DEC
> FDDIcontroller 700
> 
> has these problem(s):
> 
>   - Subject has leading but no trailing parentheses
>   - Subject has leading but no trailing quotes
> 

Hi, Stephen and net developers!

This is definitely my fault, I am sorry for that :(

What can I do about it? Should I send revert and v2 or maybe some
addition steps needed?

> Please do not split Fixes tags over more than one line.
> 


With regards,
Pavel Skripkin

