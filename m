Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D244BA035
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 04:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727120AbfIVCO0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Sep 2019 22:14:26 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:43812 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727027AbfIVCOZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Sep 2019 22:14:25 -0400
Received: by mail-pl1-f194.google.com with SMTP id 4so4915309pld.10
        for <netdev@vger.kernel.org>; Sat, 21 Sep 2019 19:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Y6ym4Jb74HV5Ic0bRz8+IsF8ACoZYIX3JdjNQ9WH2D8=;
        b=jznDIUbabIy4oqDpnAtpS0LxnzoLlxdWBs9qGSpG9ZAqvbMNx4R8G4MwFRcOjCumgP
         c99f3UidfO27AxeR2CAAIOeCQyJ7gkZzDAoeCeIvpOHB4dUPQv66/0DGTX4au7Xaf9Zq
         AnKmGvuuZtf0wWd8tkuemIg5bggrNF7G33ed+l2Ak+MTbk0cqEXsJOrOaSo1Uo3vM2de
         4FK16k5e8ov1xLVm0//p6rjWftKvnNfBkvOnhxQS8zUYw1wFHOhBl2Zq9DeWZ5yNwMz6
         oCKIAj8GkGS5EBz8FHlG1WuY4aytC8LxLBqXTq0LHNZRpUV7+lSWMEhBIVp5Lgj80aCG
         kNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Y6ym4Jb74HV5Ic0bRz8+IsF8ACoZYIX3JdjNQ9WH2D8=;
        b=J3GMv7NsuKYSgupV5sMvHQS6YDt3OEwJJHWcs4UQPFND+mYFrPDfhuRvxYUG+EbV37
         EFIXs58KkDPgBMNRupvrHrOzIRMyoIL2kxDitvHLxV+DF6bjoVt1zs90I8TIRlkpZR1u
         HJcifTnkAFNlgAFVpymlDzUQAST+Ft8OG+K3qGJPDrKxrCvhCEFNhwPtCkAbWWFybkYt
         R4iJDfFWRYx2arBfSCxe+oEDDJavalAft4ZSVMDIRyPxeuKSP7bEjc9F2ZKSBU/diTdl
         frTXdBD+ZF0p1+hNKwxTvoOKBhypOkxWbswpgPDznJsLz3Y1RylkNLShlJbS7pVYtUTg
         1+dg==
X-Gm-Message-State: APjAAAU7loRaciLaANe8BPrmeXdCxhNOil1Rv7EMdbonXWAjvwjHPn4k
        zERdM4+wgP7jxFx9JNsfTZO0gg==
X-Google-Smtp-Source: APXvYqw3LXv6NsBHRw9j/oiyHWwqS76ZeXOPDpafoCdZiYEV1bfYJjitqt40mLzVZGOJST1LVyodQg==
X-Received: by 2002:a17:902:b701:: with SMTP id d1mr23095246pls.209.1569118465126;
        Sat, 21 Sep 2019 19:14:25 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id g5sm7288490pgd.82.2019.09.21.19.14.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 21 Sep 2019 19:14:24 -0700 (PDT)
Date:   Sat, 21 Sep 2019 19:14:21 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Uwe =?UTF-8?B?S2xlaW5lLUs=?= =?UTF-8?B?w7ZuaWc=?= 
        <u.kleine-koenig@pengutronix.de>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: remove netx ethernet driver
Message-ID: <20190921191421.102e6155@cakuba.netronome.com>
In-Reply-To: <20190918202243.2880006-1-arnd@arndb.de>
References: <20190918202243.2880006-1-arnd@arndb.de>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Sep 2019 22:21:24 +0200, Arnd Bergmann wrote:
> The ARM netx platform got removed in 5.3, so this driver
> is now useless.
>=20
> Reported-by: Uwe Kleine-K=C3=B6nig <u.kleine-koenig@pengutronix.de>
> Cc: Sascha Hauer <s.hauer@pengutronix.de>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Applied, thank you!

FWIW there seems to be a lone mention of something called netx_timer in
linux-next, not sure if that's related too..

linux $ git grep netx_timer
Documentation/admin-guide/kernel-parameters.txt:                        [AR=
M] imx_timer1,OSTS,netx_timer,mpu_timer2,
