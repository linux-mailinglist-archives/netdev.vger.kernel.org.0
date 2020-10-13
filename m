Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0717428CA11
	for <lists+netdev@lfdr.de>; Tue, 13 Oct 2020 10:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391203AbgJMIUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Oct 2020 04:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391082AbgJMIUd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Oct 2020 04:20:33 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 073BBC0613D0
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 01:20:33 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id q9so21322825iow.6
        for <netdev@vger.kernel.org>; Tue, 13 Oct 2020 01:20:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=easyb-ch.20150623.gappssmtp.com; s=20150623;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yYjNCCd/0OaEg9nQpyTSbJgG5VpeHhlwiNovNtNY1Ww=;
        b=cl60PwswHmJ29t6capTunPOQdYZDyvT70Z79mwGNwFLyB/p1d6pAIY0ZGojro42BXN
         LHbcjT8HRcBAv7sOY3HGvupj5WK1urz/TkOBgzA/vq0Utf4Or9SVsNzwY/BMceMyWGMc
         XxMg2OJ+VuvzZwVIWaCMrefFS7K2Jp3Mb3ZTngqMdnI+6g2Csvfcv6QFGFAPUbcBQnBn
         iOiRlFgo1JS4ByY1K869e7bC+r1wWjabnXwS3pT2iTUxHaCjF09NZ+AACiBy3HEB+0DN
         aPvPGpWT/JDbQb4uiwCk3AbKICTskvlMh8xEA8fsZDS6cKBtBewPsYbZTiwdwt3D3n/8
         UWtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=yYjNCCd/0OaEg9nQpyTSbJgG5VpeHhlwiNovNtNY1Ww=;
        b=EzQt5csGCv5B4Xw1FdNWViN7RcrbVsKgU2vQ+zsg+KNryt++7Gtg7hsM8mujzVFlwh
         UI/oa/RRuIHSYdMYfE1eFCWBAKNJGUFH0TTZZMcCLKwzYEisMpIZnd4x7ib5hjFzzPwm
         t8IwqR0w4BgVy84VDZ+/uLW/fyb2UN2IjJOpkvMclYATChZ+b+tMPZXMq4IJxwm/WzAY
         w1+TqsZV/17Iv9gDvuFmRnSZ9F1gIntI7tAf/54XMfd24MN5Jr8OW6Wt1EGva7ViUPxl
         dYDEUGAWUUBAdiu9SLqSukKaWolfXs3NjnpnB4ThkeCi13Ib9ttEiGmtr+O97yTgnIG5
         e04A==
X-Gm-Message-State: AOAM531leW+oYkrtBdAiVVguP/agvtgjgEm9r5pd32VKjbgZ4GtvOpo2
        a9A1s1dFAdlliKfLlyEmznDfCA==
X-Google-Smtp-Source: ABdhPJxclPusaRKDdHdjxa8HdwIJs2oNiOQnwNv7q/iVHO5shaIYuhM6sFUNNFD8Pi/ml6853y3tSw==
X-Received: by 2002:a02:a893:: with SMTP id l19mr11980762jam.1.1602577232407;
        Tue, 13 Oct 2020 01:20:32 -0700 (PDT)
Received: from [10.0.0.191] (adsl-178-38-89-98.adslplus.ch. [178.38.89.98])
        by smtp.gmail.com with ESMTPSA id p12sm939581ili.14.2020.10.13.01.20.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 13 Oct 2020 01:20:31 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.120.23.2.1\))
Subject: Re: Linux mvneta driver unable to read MAC address from HW
From:   Ezra Buehler <ezra@easyb.ch>
In-Reply-To: <20201013083554.0ab5c099@windsurf.home>
Date:   Tue, 13 Oct 2020 10:20:26 +0200
Cc:     netdev@vger.kernel.org, Stefan Roese <sr@denx.de>,
        linux-arm-kernel@lists.infradead.org, u-boot@lists.denx.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <5B9D8BBF-BED3-4762-96A1-5B14DC75CE20@easyb.ch>
References: <4E00AED7-28FD-4583-B319-FFF5C96CCE73@easyb.ch>
 <20201013083554.0ab5c099@windsurf.home>
To:     Thomas Petazzoni <thomas.petazzoni@bootlin.com>
X-Mailer: Apple Mail (2.3608.120.23.2.1)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Thomas,

On 13 Oct 2020, at 08:35, Thomas Petazzoni =
<thomas.petazzoni@bootlin.com> wrote:
> I suspect you have the mvneta driver as a module ? If this is the =
case,
> then indeed, the MAC address is lost because Linux turns of all unused
> clocks at the end of the boot. When the driver is built-in, there is a
> driver adding a reference to the clock before all unused clocks are
> disabled. When the driver is compiled as a module, this does not
> happen. So indeed, the correct solution here is to have U-Boot pass =
the
> MAC address in the Device Tree.

Yes, you are right, the driver is compiled as module. This explains
everything, thank you very much for the clarification.

Have a nice day!

Cheers,
Ezra.

