Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37B0868F0A9
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 15:25:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231146AbjBHOZG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 09:25:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbjBHOZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 09:25:05 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 797144B1B4;
        Wed,  8 Feb 2023 06:24:49 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id u27so19483612ljo.12;
        Wed, 08 Feb 2023 06:24:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=1vOkyMIDiWB6sURnHjbu9ZFJQDwJmyhQ+v6EgkiUJs4=;
        b=aCnxBUVFUCZWK9tL1m/c272lfBQVi/Lf33R+DSi1fQlw1ZeVijkQ6J6n7itHxKJdkz
         9fD565zNOP9xQ2QI+c6CF1tNOabRCOhlvkHUtJQ28egWhW0LD4kkGbPViGHaxJVWfxhO
         /QBgDKRZwZ/opbM/ycwwR770V3ckvotfiSqa60lCeQWTB2L9JrJjymeezSAYbRf8zglT
         i5LKgMhmMIa6bLn7fakrw/FM98juEPeF5ALKQwqZXEdEqczQMruE/WccLyoF6Gop2c+8
         n1q92ViGCRCaaPcOyI5M3uDgwheupT0Kkj49d5f6aGqufFUdAeALYbtKJhF9FWtbdZ11
         LjzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1vOkyMIDiWB6sURnHjbu9ZFJQDwJmyhQ+v6EgkiUJs4=;
        b=U/cPbAbOJsArzhVu6rJ+l6H1pwjXD9x2BI5gjZ5kHhHJJlZJf+uLqzKsfda3jOQDUr
         LTndsRJ9dSmVttTc4RK46tJohDhFzZERrx3DO657A0Ww4zTcyHMHPLdNRWUPCcEV3OJZ
         UzkVARmTxu75JnpZw3WFALMX49Ibtb0HmdtTq6RS9MnJxHC+oiJspb7kwhNMYcGP67Cy
         W56QVFKpI59FS7bqS3ZCpmIEXhAnykuSX8QUK2zhKTb9SWj0cSpqGtQ1oUVX9J3Ww55Y
         VGMDGcGyC/OphLiSlaqf4BncQys+QCImTtSK9YzJ4SC1P83vF+VKY3Jy6+23kZ6FD0nu
         kDqw==
X-Gm-Message-State: AO0yUKVs2EcD8YoiRuKOsd2Bv3GdsYNL9H3j/o35erTxys0YvI01j0Wc
        Z6nqeonCb0vTXhQ7wpAtKqJXVaPkjRPN28Xpwyg=
X-Google-Smtp-Source: AK7set+gXjpsTfchDsqaYaTmyZwoANlVdeeIqNy4hYI4Cz9W1EeN5HEYw4Jff5zhU/9oD2TYFIPHn0JMPYFXiyiRCrE=
X-Received: by 2002:a05:651c:2006:b0:290:70d1:7157 with SMTP id
 s6-20020a05651c200600b0029070d17157mr1179877ljo.172.1675866287750; Wed, 08
 Feb 2023 06:24:47 -0800 (PST)
MIME-Version: 1.0
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Wed, 8 Feb 2023 15:24:35 +0100
Message-ID: <CAEyMn7aV-B4OEhHR4Ad0LM3sKCz1-nDqSb9uZNmRWR-hMZ=z+A@mail.gmail.com>
Subject: wilc1000 MAC address is 00:00:00:00:00:00
To:     Ajay Singh <ajay.kathat@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Michael Walle <michael@walle.cc>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I'm using the WILC1000 wifi and with NetworkManager [1] I see issues
in certain situations I see problems.

I was able to reduce the problem and have now found out that the cause
is that the interface has the HW MAC address is 00:00:00:00:00 after
startup. Only when the interface is startup (ip link set dev wlan0
up), the driver sets a "valid" address.

Is this a valid behavior and shouldn't the address already be set
after loading the driver?

[1] https://gitlab.freedesktop.org/NetworkManager/NetworkManager/-/issues/1200

-- 
Heiko
