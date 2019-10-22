Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B87DDFA1C
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 03:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbfJVBZQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 21:25:16 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:33164 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727264AbfJVBZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 21:25:16 -0400
Received: by mail-pl1-f195.google.com with SMTP id d22so7529141pls.0
        for <netdev@vger.kernel.org>; Mon, 21 Oct 2019 18:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=INGXgLube8X4ynAth399zZk+ZPCGzZaT2kV4vGGyNeE=;
        b=wMRTcJeHfK1531nTHeTkvR59WIhM8612My2vIVF+ZfQyl2yZTD3JMo5+WRY4mPVVxo
         X3bi0QvDRtv6FXiQOP30XdRMrZm4fPS8mS6PL85J66klcn6oQT4ecRHJhp9AXFxZEC02
         7uSqgoqu5wXA9HoiYrcq98PrhvrtXn3pWulzUrMhml4r+yTgILAdSuDYj0lvGKQZvOZo
         acKYJUjBGsubi5ISPPTtENAcI5qyFVsz3FWfWA0Ix9UzfPkBsqooHorTwIGQDPTiipGL
         QbfmTeAULlTtMv2k2e8AXS6HP2QKBte9PP9n07f2/zblZLEHQkmWoNMvhAHFraxZoL1J
         PTog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=INGXgLube8X4ynAth399zZk+ZPCGzZaT2kV4vGGyNeE=;
        b=AaKbI7cVn6OkCT37W6NppDhtBTj3HhNDr83NYUCklmgSboSDupAMEwxLUsUVNYX6FA
         /OC0VGgPVT9vJfGjwdzZS5LHW1/zvFDyIy15L2Q1EagcPadoEA7JP0MkRbB2Mk22dUzU
         I6btL5MtmYP/LQErVZY7qTgPwzKlj05XihGTkyVBeMaCJRAOyEdXJH/MiaMuwrZEzRE/
         /ds70RBvY39sz38hVZQt63YQQPBP4KUBhIGw8Drpc0d44CE+OgV7dnIh9TUqozGEDhmz
         I+nUNT6Whc6Hk7Zl0SO65nap2uRqEaxNVVrO/YuxvjyZjY5RkZADuA2Fj5A9H9T7lcOb
         U+tg==
X-Gm-Message-State: APjAAAWYbqiDhB3MJPLeCus8EhqSUDfaSV+pgdNoKrbD2RjP527wFZ4T
        WBmDVov+PRtIShSnDqvA/1GZFA==
X-Google-Smtp-Source: APXvYqym5MDRHDu3B2k5hRDt2DoHaJ1Azpvllag/RpNg4CPn9ahRfRvlkqoRkEWWk441DME4+ih+UA==
X-Received: by 2002:a17:902:9a41:: with SMTP id x1mr894084plv.331.1571707515724;
        Mon, 21 Oct 2019 18:25:15 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id d1sm17397411pfc.98.2019.10.21.18.25.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Oct 2019 18:25:15 -0700 (PDT)
Date:   Mon, 21 Oct 2019 18:25:13 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/10] IXP4xx networking cleanups
Message-ID: <20191021182513.521d85b1@cakuba.netronome.com>
In-Reply-To: <20191021000824.531-1-linus.walleij@linaro.org>
References: <20191021000824.531-1-linus.walleij@linaro.org>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 21 Oct 2019 02:08:14 +0200, Linus Walleij wrote:
> This is a patch series which jams together Arnds and mine
> cleanups for the IXP4xx networking.
> 
> I also have patches for device tree support but that
> requires more elaborate work, this series is some of
> mine and some of Arnds patches that is a good foundation
> for his multiplatform work and my device tree work.
> 
> These are for application to the networking tree so
> that can be taken in one separate sweep.

Also looks good for me with the minor request to reorder
the patches.

FWIW if you're targeting the networking tree feel free to
add --subject-prefix="PATCH net-next" when generating the
patches, this way they stand out nicely in the inbox and
in patchwork.

> I have tested the patches for a bit using zeroday builds
> and some boots on misc IXP4xx devices and haven't run
> into any major problems. We might find some new stuff
> as a result from the new compiler coverage.
> 
> The patch set also hits in the ARM tree but Arnd is
> a ARM SoC maintainer and is hereby informed :)

