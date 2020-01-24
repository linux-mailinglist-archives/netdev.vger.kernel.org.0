Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 46E7C147F87
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 12:03:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388189AbgAXLDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jan 2020 06:03:00 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:45923 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731048AbgAXLC7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jan 2020 06:02:59 -0500
Received: by mail-qt1-f193.google.com with SMTP id d9so1129659qte.12
        for <netdev@vger.kernel.org>; Fri, 24 Jan 2020 03:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=mlCKmeixelvAOw1aSZX5jxVRNwHbo39mZj1uDf35TNRKWswhfMJ3y+Akk5WBFdegg1
         TWlvE4jLISqcI3OKdR5kDOLyrhXkn77MN1VPe6q3dMBHlt+BEOX+9jujKpeHO2KTXE9C
         unjb6bbfOWttk2Cpp2tMIKz5QMDIRnPsMUlzNIjHfDlVUgmm2EtFKkH7/yEf6LYFwG1h
         uUmAzXI//CEWAVNIgbndq0ISEhRMG4QevaZ57a1DpmXSTC3xvnYAGLd4lxp9Wl63XJLa
         2OlN3kMxZ1ozer9qQDAuk5x14el0gLFBv343swOu9AWfgr9QdD0LqiMVQOmZmv76r29K
         HB0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=uOXGibFHbvI+841lMapY1Tyhz6YjustgVZ9oXO+BzUN7wfUHyyFQlvs2ysRa6lZUSN
         fO86Zm8R9kLN25WX0F6ZDImqEjM4C8/6tqn9/36Wubk8PvtaJ6/3OMRnWY439Emty19R
         ShwFue5ayj6HRo/ExMmM8Tf0CS8wGZw66AiXQjjvkKBGqJfzhCTsyajZAAcXovmiDUGf
         0PFR+5rWwjVtkZ90+67NoPDQQvrC1jS4ujP7C5CZVF8QYa1Iq9udT8n4q9VCzDXyFclw
         /+bK1+xhe+6c6yZhf+Ku51/3f+z+gtUZJdfNhbeYcqvS/Cq0GtistmeQ8cIRSdIhyqhk
         y7rQ==
X-Gm-Message-State: APjAAAVRe4fB+LVdu8Bsm244TpjeIpsocoi2/2hz/1y9S9fFGRL4jQVX
        54dTO6wSlDdGnwjTzM3cgQzfRtp3tyLHgs6kPro=
X-Google-Smtp-Source: APXvYqxEpa8Vc4IqFqU7/q+dqPZlDSdJmlAco24NycA1xluv4SrymNnFI+5S5eLK/X1u45RTobN5UKIV32b4T3GlAwk=
X-Received: by 2002:aed:2284:: with SMTP id p4mr1471664qtc.329.1579863778954;
 Fri, 24 Jan 2020 03:02:58 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a0c:f9cc:0:0:0:0:0 with HTTP; Fri, 24 Jan 2020 03:02:58
 -0800 (PST)
Reply-To: jonasnana858@gmail.com
From:   Jonas nana <benardkojo122@gmail.com>
Date:   Fri, 24 Jan 2020 11:02:58 +0000
Message-ID: <CAFAbDnaupKHDbt-xdCycwLWSfF5LvqYYRtDVgRTpT6-ase9SBg@mail.gmail.com>
Subject: =?UTF-8?Q?Buenas_tardes=2C_por_favor=2C_=C2=BFrecibi=C3=B3_mi_mensaje_ante?=
        =?UTF-8?Q?rior=3F?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


