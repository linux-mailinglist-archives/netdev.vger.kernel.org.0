Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA86A130B5
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 16:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727999AbfECOwN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 10:52:13 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:40263 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726480AbfECOwM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 10:52:12 -0400
Received: by mail-wm1-f67.google.com with SMTP id h11so7066338wmb.5;
        Fri, 03 May 2019 07:52:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sxtpfFkJtjPkfp3NlTG65T2tIBSz9kZ6rxvyi5s+nLQ=;
        b=HX/ZXAzYdDB4oWnAF4FshLL9gFs3s7vkn9tklcAnomJDJ/Hkg9ssuAX+biS4HbcGFp
         7SD9xVSEM33hzwVcNkQSC2cjDU7IxfKjsbqju+wcsSUGM07elKC6JznB3oUiRmmJpYhz
         tk6ZACnG0QDB0ckAJWdmhUBsqG9niNKWxx0g4dvDkcwO9jpoM/95I4l0nw+gkdkCMpif
         eaO1rBh7LhTobaSNPb7UyccbmquumtFni4kM2aXTE79aZTeybQU97Ga0aH4qsA3skGlp
         LHRSd6+7IzPpZb1rmZRR9M3UPxL1ZKWwUxMDSAGel7atIhr2UDbcepH8PQH6zSB/tbtl
         WXjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sxtpfFkJtjPkfp3NlTG65T2tIBSz9kZ6rxvyi5s+nLQ=;
        b=Ms+m5GHwXhmJDXSyMgFT3yN6atNLuLvyEv/sYPw9LyUA/tbZECKsVpOz69cKHHlwmr
         XSQNZyH1pIcWZok8LsQ06pZWkVvS3YaGWFogiYvrAeTHKnk6Hga9nYZooAdRXBP6O6pK
         ZA7pJoWTOqGJz8/Ez7u31qJpf8HmPmhe7oKbVr/rywJn8/IX0Dgiyv7D36W2nFMbNkcw
         YLEMtvKBSsbvaASGvTxJaqfTwZC7Kj+7TJBkrvsdpMeiU0NLG2b7hSjubBXDr3hWhvtK
         DCpWMdcg6K7v+QqtgY0XTpIc0DAGi1FuAvkpdPWneMUfOlOGoQfWjIlZaMeTIzxCa6nf
         ZxFA==
X-Gm-Message-State: APjAAAViSM+sprkD1/BMdILQs1F4uwF1eSN8uOmO91Ri7uBvb8HMm6uP
        /Nh4oodfhc0zk4ghIuKan8kjCGIGQAMOcfW6Zo8=
X-Google-Smtp-Source: APXvYqwfCPIorEnyaKdWrP2AR2wEqo6ZKYMyAxRCRT5ibRjIkI6W+RPyP5f1wS/jRxdJEjp5TjDgrJtvqnwnCumIdpo=
X-Received: by 2002:a1c:5543:: with SMTP id j64mr6506675wmb.37.1556895130556;
 Fri, 03 May 2019 07:52:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190502202340.21054-1-olteanv@gmail.com> <20190503.105104.932427839600881016.davem@davemloft.net>
In-Reply-To: <20190503.105104.932427839600881016.davem@davemloft.net>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Fri, 3 May 2019 17:51:59 +0300
Message-ID: <CA+h21hpJUC+vMOcsAeUo9KTNL31hvAUcc1sHDPUvWqVgQzeoVw@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 00/12] NXP SJA1105 DSA driver
To:     David Miller <davem@davemloft.net>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, vivien.didelot@gmail.com,
        Andrew Lunn <andrew@lunn.ch>, netdev <netdev@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 May 2019 at 17:51, David Miller <davem@davemloft.net> wrote:
>
> From: Vladimir Oltean <olteanv@gmail.com>
> Date: Thu,  2 May 2019 23:23:28 +0300
>
> > This patchset adds a DSA driver for the SPI-controlled NXP SJA1105
> > switch.
>
> Series applied, thank you.
>

Thank you!

-Vladimir
