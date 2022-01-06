Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 235F44867C6
	for <lists+netdev@lfdr.de>; Thu,  6 Jan 2022 17:38:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241333AbiAFQiM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jan 2022 11:38:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiAFQiM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jan 2022 11:38:12 -0500
Received: from mail-ot1-x32b.google.com (mail-ot1-x32b.google.com [IPv6:2607:f8b0:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B870DC061245
        for <netdev@vger.kernel.org>; Thu,  6 Jan 2022 08:38:11 -0800 (PST)
Received: by mail-ot1-x32b.google.com with SMTP id 35-20020a9d08a6000000b00579cd5e605eso3742313otf.0
        for <netdev@vger.kernel.org>; Thu, 06 Jan 2022 08:38:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=1kQ3eDdhnxCQwAfzT9bsx6Py44Jw3Hg7SXX1XBgnPlY=;
        b=Xc1evd/a26dwvbsfAWOAfJlrqznHqKWOEYSDs55w4P2a9zmLXkXNHZJgOBFN0DQ+Nr
         mLp/UZiWDq3OlyqHEKK6+rPb8OQfdxEhR4wwiGj0BxZqUNPc6XRnySLdxtNipR3Zm9KD
         loFpTB/8Vn9Vxxvn7gXC2lPfFljgz1dJPnRB7SBmErkMeW2Th589kliOzTH96ZDij2Yl
         LWJaE2vsoLJbPpQXZm8B274wgINLIAK2cr9W4PnMQBdtdpn16NtbhGli+WSuv0RqtEZX
         Vl0ppLLsEGL5swGSvk2X4F/kc+oL9PJuu9MGdzfBTXjeMJI3zJ94CaeM3JohDhgrPz4i
         cBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=1kQ3eDdhnxCQwAfzT9bsx6Py44Jw3Hg7SXX1XBgnPlY=;
        b=BaeGet8hg/fD1khfY1io/QccNC6drrmRFGDt5P5zIKZ/SSemLXwPqKEE1bZFdPmrlU
         l5iwEfjSPeXeeLXWjhiNaWcdUCdd+2vcKgytQVx5qAj4C4YWUVUQgwPlNVgmUrUHrODQ
         lQRpMVFboLED985Sn8fLaPzxcQaqhOZSpxLXPdFubRAlY3MUV0rnOHWVmcJYjX/MChNP
         dBpdX7S3mhICH/Qp7jpAd1sA4mgsPe9fKdluT50/NThI0iwHurS6wucn7i3UEuUvUYTX
         STNWyf/JQlqQG1VA1R/WiGO9LJA/UUlJy222vzzVsrKWuAq4hDHi3Z1Zs+qbYqpAEIYF
         Pwyw==
X-Gm-Message-State: AOAM531iw/6IlxroGBCsZXOrSqN4S27gmFJocTspPJmWURFxu8UGnG+U
        DyaXqUI2IYMDMFV0LNvKf5nSopeYiBJx/ZrTuv8=
X-Google-Smtp-Source: ABdhPJySwE13s+imLGE5frX3kp72DpnVQbkiD4zPHWmjxoPbWn5g9YNPTf5Iu8J1Keho4ujHVqxUPurjoWf4Ton/OWY=
X-Received: by 2002:a9d:2cd:: with SMTP id 71mr41244999otl.107.1641487091157;
 Thu, 06 Jan 2022 08:38:11 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6839:2802:0:0:0:0 with HTTP; Thu, 6 Jan 2022 08:38:10
 -0800 (PST)
Reply-To: mr.damitartpaullarenoel2022@gmail.com
From:   "Mr. Damitart Paul Lare" <damitartdamitart4000@gmail.com>
Date:   Thu, 6 Jan 2022 08:38:10 -0800
Message-ID: <CAKzORxFNVu9qtNSc_7nrRHayxkBtHg9qfSoeJ__ZjjQsBdJ4ww@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings and how are you doing today?
