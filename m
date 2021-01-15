Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0722B2F71FB
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 06:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729845AbhAOFOa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 00:14:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726776AbhAOFO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 00:14:29 -0500
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03222C0613C1;
        Thu, 14 Jan 2021 21:13:49 -0800 (PST)
Received: by mail-wr1-x432.google.com with SMTP id a12so7960273wrv.8;
        Thu, 14 Jan 2021 21:13:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:sender:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=WwwZ5INxbChgA54D8alL+8opcbTX2Y/SEfcezGICCQg=;
        b=WaHuHmPAmnWB9P8rEaQuXbS0U5k1yKJGEV4xpeXS1QyV9vG2+JJK9Qk6ClTKYt13RF
         BSU8XLmxNZ+srxuUzk0m6mtXuATBazXAI/taPgAQ6fQ0jLVUSk/PMk53l2m4m+WXuLvj
         a9gs+AupckG6vUa5Ur4YMOevehjf5FELmZP+d4126LFrd1v7e1+t82hohGo/NdhvLJyM
         CyEEAsauBfaaIMo2e9eklrnYIcnBZiLxwvhDt8y9oM/MSu7/MzY7rt0ShvNruc6gmKSV
         Pc92ZxQjnwiNaefgHrtU720VXpZneT4oQwuDY9XJZarAyE2qPrtJAtjmcPo1rQOEpfJZ
         YL+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:sender:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=WwwZ5INxbChgA54D8alL+8opcbTX2Y/SEfcezGICCQg=;
        b=pXiB8QiBtcp8VEeEMCp8fPWnzd1J6v17z4I3JVb2ChTTq7ytaDp3XLQip/He9C/l++
         dds6hpMxnuZTSv6gjGLKezE7VMhhWB6w+VZ9Fr/9Ujx5mOhxxPxpMag8PxOElcVobnZ7
         cIWOdpRNwspVjzsdKZ57Mt8Uu06+rk8CnjIkkZTuFm1PU4Ke75IU48exH2CQUUewYFdM
         fA5P4BwdP7gCQVVL3RpfaNh8vneHJk3xZmCweUoqltX6teA5E2UYVVNm6DmlhWYTQdN+
         2OSK6D2OPUPBK7OJiQIXvkMdy29qMPWSCm3z/RoKxYJZAk8Elj0ek5If4SI0WtAH46Sk
         qxCw==
X-Gm-Message-State: AOAM5305nWNwPG9ykqQ/Wh4WXIU2tlSrxwwgniYuVW9v9Dql/y2OKyu4
        LLG6xF65K6CCiKdbquP7ObQ=
X-Google-Smtp-Source: ABdhPJxdr3FH/KcVCnwEbKthbE2WQi+wLg/YXsz86K5zTFQRCeWULrT2zYzPZm8PLxD0jP8dtsF4UA==
X-Received: by 2002:adf:d218:: with SMTP id j24mr11590746wrh.361.1610687627803;
        Thu, 14 Jan 2021 21:13:47 -0800 (PST)
Received: from [192.168.1.8] ([154.124.154.14])
        by smtp.gmail.com with ESMTPSA id i16sm12485349wrx.89.2021.01.14.21.13.41
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Thu, 14 Jan 2021 21:13:47 -0800 (PST)
Message-ID: <6001248b.1c69fb81.d7d4c.1646@mx.google.com>
Sender: Skylar Anderson <mbayetousha2000@gmail.com>
From:   Skylar Anderson <sgt.andersonskylar0@gmail.com>
X-Google-Original-From: Skylar Anderson
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: hey
To:     Recipients <Skylar@vger.kernel.org>
Date:   Fri, 15 Jan 2021 05:13:35 +0000
Reply-To: sgt.skylar.andersin@gmail.com
X-Mailer: cdcaafe51be8cdb99a1c85906066cad3d0e60e273541515a58395093a7c4e1f0eefb01d7fc4e6278706e9fb8c4dad093c3263345202970888b6b4d817f9e998c032e7d59
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'M Skylar I Need To Tell U This
