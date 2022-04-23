Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 521FE50C940
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 12:31:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234523AbiDWK3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Apr 2022 06:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbiDWK3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Apr 2022 06:29:34 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C36417041
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 03:26:37 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l3-20020a05600c1d0300b0038ff89c938bso5939566wms.0
        for <netdev@vger.kernel.org>; Sat, 23 Apr 2022 03:26:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=timebeat-app.20210112.gappssmtp.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dxT76AKXVMJdrv9eKM19J2qUD2MImpqx+4ItNMuNzk8=;
        b=syIGwy2RuUosd2cJ5hXs4ls8mQ0N5dhZ8qRpJYHaiXLK74pwrZDebWssVUJJV0838o
         fvjG+Ba1zpPcc6NolXM/ef1Q8MThgXCLJeCrHclAkwsh3CprFW/rJ7fnfjAuyAd1kBMX
         Ge5mm4QVVGpZ0/7fRATdceqyzfLlRYDyZFt51iThtO6hpouNeSCRRpiXRcvaH9pRxpKa
         3mgg4mAy/KknqlcxIta0o7Qjy49y4bkjw52slRjNTyUSf2Uw+J9mqBoyOlT29hprVIEZ
         81xH7qkhJzCqxAHEMsuzKQl8U4P6gmS0m1nqo3VCp4Quedwez2kHXGBfWhjcSdMQgp4i
         VnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=dxT76AKXVMJdrv9eKM19J2qUD2MImpqx+4ItNMuNzk8=;
        b=cOgasboVHFw1lC52BhRSMzfkLUXqJfDtcUmSrp9e314vk1SzdWgjHk1kFvnSzFWSNO
         JXpNWn39IzHc6pZf9TgQ4gqZ4Z9A0NkcTDefMHkk1fprdgtk+BHogo5ugR/iN37heba4
         ZyxQtykkOwU4lXgboj8hfCatNLJDku0BMLd9tBBSMMTFaa20FF8mTHLJxCgyic4Csxv9
         oXsmmp8IkLaKiCXZpJ0pB4AXDnrqVML3D62o8wGeZwahWaw6KuiFk8z6EVP5S8a2ph9M
         dNNPGXIGE75ws36n6fzP+BywK163OrCxVs1CBYNee19LcBoKH1f2mjAU3M89IiGpVGfZ
         jcwQ==
X-Gm-Message-State: AOAM531nVoZYT/LejPGWdfN2PBlCtezphPutvOIQV9JfsvEcDML6mty6
        lW6aKAnLXC5ih63JSnVQ4ebloB/z3huugHX9
X-Google-Smtp-Source: ABdhPJyW8O4v7BALrTvsbYPg6FfvTAt9+mJmpB5FysPnxrGUUUQtc0sKefLlbs8mS9j3v+wnW7VevA==
X-Received: by 2002:a05:600c:3789:b0:38c:bd93:77d6 with SMTP id o9-20020a05600c378900b0038cbd9377d6mr8262869wmr.12.1650709595912;
        Sat, 23 Apr 2022 03:26:35 -0700 (PDT)
Received: from smtpclient.apple ([2a02:6b62:a490:1878:54e6:5bf:e9a9:8ad])
        by smtp.gmail.com with ESMTPSA id b3-20020a05600018a300b0020a8b2341f9sm5336850wri.18.2022.04.23.03.26.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Apr 2022 03:26:35 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.80.82.1.1\))
Subject: Re: [PATCH net-next v2] net: phy: broadcom: 1588 support on
 bcm54210pe
From:   Lasse Johnsen <lasse@timebeat.app>
In-Reply-To: <FCDBE44F-57EB-420E-844B-29BBB37EA2C6@gmail.com>
Date:   Sat, 23 Apr 2022 11:26:34 +0100
Cc:     Richard Cochran <richardcochran@gmail.com>, netdev@vger.kernel.org,
        Gordon Hollingworth <gordon@raspberrypi.com>,
        Ahmad Byagowi <clk@fb.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        bcm-kernel-feedback-list@broadcom.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <57D5F4E2-409F-4709-A9E7-299AF28E4AB3@timebeat.app>
References: <928593CA-9CE9-4A54-B84A-9973126E026D@timebeat.app>
 <20220421144825.GA11810@hoboy.vegasvil.org>
 <208820C3-E4C8-4B75-B926-15BCD844CE96@timebeat.app>
 <20220422152209.cwofghzr2wyxopek@bsd-mbp.local>
 <567C8D9F-BF2B-4DE6-8991-DB86A845C49C@timebeat.app>
 <FCDBE44F-57EB-420E-844B-29BBB37EA2C6@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
X-Mailer: Apple Mail (2.3696.80.82.1.1)
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NEUTRAL autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have reviewed the documentation again, and I am inclined to agree with =
you. I will modify driver to use in-band RX timestamps. It looks like TX =
timestamps can also be updated on the fly to allow for one-step =
operation.


> On 22 Apr 2022, at 19:20, Jonathan Lemon <jonathan.lemon@gmail.com> =
wrote:
>=20
> Uhm, I have inbound timestamps working for RX on an RPI CM4.

