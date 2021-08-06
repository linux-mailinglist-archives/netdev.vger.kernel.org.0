Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F4393E2968
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245452AbhHFLUm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235696AbhHFLUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Aug 2021 07:20:37 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA1CC061798
        for <netdev@vger.kernel.org>; Fri,  6 Aug 2021 04:20:20 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id go31so14545171ejc.6
        for <netdev@vger.kernel.org>; Fri, 06 Aug 2021 04:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=/WYwAOEW+LFa7fsoJmfRmyG0YL6abiPbzdMZU9DntE0=;
        b=D733lgmwfumZLss5bPPco8gYIZK9Z9gZecaOV3Shy3pcf+OdsW+3nHtDgVj0FexFKT
         fzkUq0A58wDs24ZlB09s8w+BHSOVB7fbCpMBOTggM0P0iXt8mYXfHg1Lz4mFc5a7SShd
         bPXWo8V4dDddiOX6AEnCSnnk4iRhSXA0JCquHmUfGj6bTU1zjY0Wpijv8KR7C9U9lUPz
         ylkh4JMipdCXpTp6t9mc4+yjR7+Nz4OYIgDPFV/LKcFH2Xk/+ysbx54l2QFg/ylg6amm
         NhEKOvlebqYa3mNDIYigYaPdIZiTr/9AzwZhiyJ3bpOteF/BKM2nWEgP+scOO+ZM/jdd
         PoKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=/WYwAOEW+LFa7fsoJmfRmyG0YL6abiPbzdMZU9DntE0=;
        b=QdY0b7EnoIwssLeQuEj4QSjup/Fp2x4v8jAj8+9GbhC7ZEQ7W617j7TGoZoFc50z6P
         n4I/7xwz4UJ6HTJBdcZHAGlwTDedAGWcgtpDXCUBOqc3YOii+o0WHcan/XLsQmdmfPM5
         Zl31ro+EAkSpkAZce9EkqzPgoDfO0PwgEW5P+4sbzNoavZj0YhNphxrIKHhIlk0lLLFj
         YSIQTT/pnCUuNDOgHoc3C7oKCCPXel0z+XdZ6FFByr3vOtDmcWWPx5b71KIzKRz/3Fb2
         PIstNATlvN2shayFgSK2o5PU+6CoeufD0PtKq5FSi/4AlCMZgJMcdDQVIoKn2pDbmA7l
         SSpw==
X-Gm-Message-State: AOAM530WKuwFDo033dSM0hjWy87PNLy4gHRZw6CdTnv+ZIAkAzOk0qgy
        dUHptOav5dUT08YRbhlCGjLwYZePl+wh4Zs5z1k=
X-Google-Smtp-Source: ABdhPJxNYWnCq4Kw2fUU37EnokO+68eKczIBGwP5XENfSsxbVdTiTfpB69OPy3PGE/e5jlxxXiAzfFEUhmK6o1W4BXA=
X-Received: by 2002:a17:906:4b18:: with SMTP id y24mr9137109eju.42.1628248819239;
 Fri, 06 Aug 2021 04:20:19 -0700 (PDT)
MIME-Version: 1.0
Sender: petersgarry3@gmail.com
Received: by 2002:a55:e547:0:b029:112:9f58:2959 with HTTP; Fri, 6 Aug 2021
 04:20:18 -0700 (PDT)
From:   Alary Jean Claude <claudealaryjean@gmail.com>
Date:   Fri, 6 Aug 2021 11:20:18 +0000
X-Google-Sender-Auth: UO2MfIckkdpws4Wl_ipwTvJJaZc
Message-ID: <CAB1rweEHwFEHWY7+gsGyDL1KFJg5h4nN9o732_7V87k76+rGVw@mail.gmail.com>
Subject: please i really need your urgent assistance.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Beloved,

It's my pleasure to contact you to seek for your urgent assistance in
this humanitarian social investment project to be establish in your
country for the mutual benefit of the orphans and the less privileged
ones, haven't known each other or met before, I know that everything
is controlled by God as there is nothing impossible to him. I believe
that you and I can cooperate together in the service of the Lord,
please open your heart to assist me in carrying out this benevolently
project in your country/position. I am Mrs.Alary Jean Claude, a dying
widow hospitalized undergoing treatment for brain tumor disease, I
believe that you will not expose or betray this trust and confidence
that I am about to entrust on you for the mutual benefit of the
orphans and the less privileged ones. My late husband made a
substantial deposit with the Bank which I have decided to hand over
and entrust the sum of ($ 12,000,000.Dollars) in the account under
your custody for you to invest it into any social charitable project
in your location or your country. Based on my present health status I
am permanently indisposed to handle finances or any financial related
project.

This is the reason why I decided to contact you for your support and
help to stand as my rightful beneficiary and claim the money for
humanitarian purposes for the mutual benefits of the less privileged
ones. Because If the money remains unclaimed with the bank after my
death, those greedy bank executives will place the money as an
unclaimed Fund and share it for their selfish and worthless ventures.
However I need your sincerity and ability to carry out this
transaction and fulfill my final wish in implementing the charitable
investment project in your country as it requires absolute trust and
devotion without any failure. Meanwhile It will be my pleasure to
compensate you with part of the total money as my Investment
manager/partner for your effort in handling the transaction, while the
remaining amount shall be invested into any charity project of your
choice there in your country.

=C2=A0Please I'm waiting for your prompt response if only you are
interested. I will send you further details and the bank contact
details where the fund has been deposited for you to contact the Bank
for immediate release and transfer of the fund into your bank account
as my rightful beneficiary.

Respectfully,

Mrs.Alary Jean Claude.
