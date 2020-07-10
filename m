Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 336E321B19B
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 10:50:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbgGJIua (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 04:50:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726644AbgGJIua (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 04:50:30 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6980C08C5CE
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:50:29 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id y13so2766535lfe.9
        for <netdev@vger.kernel.org>; Fri, 10 Jul 2020 01:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=waldekranz-com.20150623.gappssmtp.com; s=20150623;
        h=content-transfer-encoding:from:to:cc:subject:date:message-id
         :in-reply-to;
        bh=/wcatrJAAopGkNFtx6HArrslrg2wi6FaKekCjJk9vck=;
        b=kDC80u4vdBbI2zuqJqqT+4JE4rDSxV6XUfdP4aqRpUfoxLNDdFypX/ZBk6vhNG6b4F
         JYPjUFxnjVXYNaeyVlnEW4ty4I1WX+vWdb8CP7wqK5mYM+/NOWQmeuITS3g82ilutd7c
         Bj16izV6EamvHJnh9LXzEk4xgyHlXpTtL4Aka46/Yp0LT6Hb0Y+JuK+P+wqPIWvbDJ28
         nOx8jRmi2blx1VKOsiK7hm1fYZfnc0AJv3b6A2HxodtWsjriRuGGAGaFA1A1edpuehPA
         2kfMq+YnmX3/2qX+NYQvSPAhMvm4cSSh/nBsPmytjQm0kwN5a0shG3udIpMNPEJuie+V
         CALw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:to:cc:subject
         :date:message-id:in-reply-to;
        bh=/wcatrJAAopGkNFtx6HArrslrg2wi6FaKekCjJk9vck=;
        b=a2TM0jjh20usptxZ41HRj2ZgBBlj+OPt5MbgfuPY6JSPngu2E8q7Jgv8sg1QOxES8Y
         1UhCzbro0J72HIxPdmmeLHKDyWYdRxn+6P+1zFBe5xIR7c4DfWIkFr1G6VFOOVdNZQoH
         4DcgV76Stx+6Gk2iHrLCqH2SNVeQgYh83le1hYA/wPr1e+b26AjTPX5BYqY9Y7SI/gS7
         nr1yxzG20Tdzw6RXSDM8Y0quPjt0PP1RxrSKNZ/snfLH7iD4leNR2IZjXvDB2jQTaWG/
         R2/LmEv+sJKh/s/Rbp7bHAICYYeDomoVeRGw3FowwJ/Lh3a2wY4L1wxICWCxHXacFZyZ
         IIyw==
X-Gm-Message-State: AOAM531ypU3yG670VNjRWY63fn+1cdgkSOafSmfVNu9Ui4IL2OKR6yIj
        ktNzBxZkxLFiVDHrrMdW8Kw02w==
X-Google-Smtp-Source: ABdhPJzzN9NggEoABaQ4l/lghhR8Bvbxx7dSigPw+S0ESbmO4NqzyfKIv5+G9lUfVhTHEVF7SQPb9w==
X-Received: by 2002:ac2:5c09:: with SMTP id r9mr43416497lfp.176.1594371027382;
        Fri, 10 Jul 2020 01:50:27 -0700 (PDT)
Received: from localhost (h-79-28.A259.priv.bahnhof.se. [79.136.79.28])
        by smtp.gmail.com with ESMTPSA id e29sm1918424lfc.51.2020.07.10.01.50.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2020 01:50:26 -0700 (PDT)
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From:   "Tobias Waldekranz" <tobias@waldekranz.com>
To:     "Florian Fainelli" <f.fainelli@gmail.com>, <netdev@vger.kernel.org>
Cc:     <andrew@lunn.ch>, <hkallweit1@gmail.com>,
        "Vladimir Oltean" <olteanv@gmail.com>
Subject: Re: MDIO Debug Interface
Date:   Fri, 10 Jul 2020 10:29:47 +0200
Message-Id: <C42SX4V16JRA.2YZ27ZW6U2CUL@wkz-x280>
In-Reply-To: <9dd495d7-e663-ce37-b53e-ffebd075c495@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu Jul 9, 2020 at 5:36 PM CEST, Florian Fainelli wrote:
> Certainly, the current interface clearly has deficiencies and since
> mdio_device instances were introduced, we should have an interface to
> debug those from user-space ala i2c-dev or spidev.
>
> Can you post the kernel code for review? Would you entertain having mdio

Certainly. I just linked to the repo to show how the userspace part
would look in combination with the netlink interface, and to see if I
was in ice-cube-in-hell territory or slightly better :)

> as an user-space command being part of ethtool for instance (just to
> ease the distribution)?

If by "ethtool" you mean the project, then yes. But I think it should
be a separate binary as ethtool is very interface centric.

We might not want to restrict ourselves to a single tool either. A
binary that can do basic register read/write seems like a good fit for
shipping alongside ethtool. But a tool to read/write the LinkCrypt
registers of a Marvell PHY, as an example, might be too specific and
better managed in a separate repo.

> --
> Florian

