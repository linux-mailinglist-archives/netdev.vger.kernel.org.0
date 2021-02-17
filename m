Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3E1331D42F
	for <lists+netdev@lfdr.de>; Wed, 17 Feb 2021 04:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229763AbhBQDNp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Feb 2021 22:13:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbhBQDNo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Feb 2021 22:13:44 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A4CAC061574;
        Tue, 16 Feb 2021 19:13:03 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id o24so754404wmh.5;
        Tue, 16 Feb 2021 19:13:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:sender:from:mime-version:content-transfer-encoding
         :content-description:subject:to:date:reply-to;
        bh=EtgVAmMZmRbpHi/fUwmACsED6bFm70nAWWTosG/q2KU=;
        b=J5uXIzOxxRCAYjE3jTarvd5GKJlLZI9ppx1UZxx1qz4HWCCMfX0qrKqnQZ4UKWmzHg
         fIIpRlBv+Y/qX3LNsJ44GDYYhw4XxVYayL8Yz6pLCMl/xbm/RluJMYiMVmkUbZipqSD3
         MpEfmLGmSN1plwQxq+RBlsFz6OY2FszuMcP2gwkBz4RmLDo2BQhpYRHfCV7aqKD9Xty5
         9gY6AcyUOjjS08CZTkNAZe2TahXOquewo5okcKFUvXeE/a/CUyT1rCRj7sH9cdfOnFX8
         ES27ODlbVRjz3bNeT8r2iWj9QTIZKMPzIW66DbD0hMhVG1SMTTPfHelGjQnatVtgeN0d
         YsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:sender:from:mime-version
         :content-transfer-encoding:content-description:subject:to:date
         :reply-to;
        bh=EtgVAmMZmRbpHi/fUwmACsED6bFm70nAWWTosG/q2KU=;
        b=bMoGHcKi98ynFpGPi7CuqMmKU9UFfDBmeiGgGZmk+Eo7hdYlkPYGu8HZtTvedXgcem
         lEM17LuFEztNk75LXBOhAvHiXmqQ1bhf1a6HL8X2QfMc4SBg6lLMt4lRBAGNpNtymLRS
         pT7/LQgUTdgchn7A1uNVGXq07VzyCatJOJX2FV4rz1voLiYFKvW4jJgWWz0DgZGP/jay
         gyF0le3hhMIvr0AQAeg6BrI7ocn93XlY+Ojj9WGT70h2wQp74sVKSegVgiLDz8hM4RCQ
         BJTaojValsGqz4PHBEjh5onbUlRIw/dLoWFuRaiGh8c/v8mwg8l8tTntNIgbwjTaUw1q
         lKtQ==
X-Gm-Message-State: AOAM531gPeIhZXv+8abij6STx4c27kVJMwlH6rs1UsMF94xl4hwCU9kD
        pSb3IlENDoadU1KKUwiuE9c=
X-Google-Smtp-Source: ABdhPJzCGGgGcFyPVUrgDFyypDMVlcQAu2+a8C9D81iLlNwdROCPE3kLzaf7YizLSmwTDDhaJQGIQg==
X-Received: by 2002:a1c:2090:: with SMTP id g138mr5235412wmg.137.1613531582233;
        Tue, 16 Feb 2021 19:13:02 -0800 (PST)
Received: from [192.168.1.5] ([41.82.185.62])
        by smtp.gmail.com with ESMTPSA id h18sm1601020wrm.54.2021.02.16.19.13.00
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Tue, 16 Feb 2021 19:13:02 -0800 (PST)
Message-ID: <602c89be.1c69fb81.15dbd.2d6a@mx.google.com>
Sender: Anderson skylar <biramsow216@gmail.com>
From:   Calantha CAMARA <sgtandersonskylar1@gmail.com>
X-Google-Original-From: Calantha CAMARA
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Description: Mail message body
Subject: Hi dear
To:     Recipients <Calantha@vger.kernel.org>
Date:   Wed, 17 Feb 2021 03:12:59 +0000
Reply-To: calanthac20@gmail.com
X-Mailer: cdcaafe51be8cdb99a1c85906066cad3d0e60e273541515a58395093a7c4e1f0eefb01d7fc4e6278706e9fb8c4dad093c3263345202970888b6b4d817f9e998c032e7d59
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Do you speak English
