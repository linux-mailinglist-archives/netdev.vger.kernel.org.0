Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 196E14CE5E4
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 17:21:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiCEQWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 11:22:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiCEQWp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 11:22:45 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9A934B93
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 08:21:56 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id d187so10148547pfa.10
        for <netdev@vger.kernel.org>; Sat, 05 Mar 2022 08:21:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=A7SqxPeuATRIawRLPRXdbXUmc+x9RhbBGbJAJobYDWo=;
        b=FqTDPr+QXK8UVZLod5IaeqfseljJZsIVgaYBKxXigfuYTmIPeAhS5Zx4QFbi3luxjk
         /HS5ppdn1JT26Ws+JCunSGa+MhB8WASjP7DAG/TuW1j9YOxOBq4+q4QOqtmCQ+6+uzcQ
         5yjYfeqeynDlJtj0heJrVOvM1mlwrDntjX1dVSSzU8xx5rTLR2Umbr7x+hz4OPfaGA+o
         HeakvG6jSsaRan8tjpTscjbum+4QPw86pEuAbb1fD4Lo70OnS95VNToniJEeoDKk25QM
         buLgnJW0jU+qCzxjsmFcJX/BUUE3ie37T+aXePpyQgXHItR4tUpKgVJmBinxsHXhZh9+
         oDOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=A7SqxPeuATRIawRLPRXdbXUmc+x9RhbBGbJAJobYDWo=;
        b=Mn5aY+AfQgAbY1+/pk1eHBmFaXe/PY1UnZFuJYn60toHaZQthRQsI7cQYu9ECVtRsN
         D71mjj6EpK8rL9hUI5DvFuIhkU0K0FfrxdlTJ3nZsVlA3eFWfk7n1bKF6ZF10xCLgIbl
         NaE5ubsqfMsSTIvFDXreBCV3WI2sZktxU2ihOLCMobOfsrH1DkSwMjjDVXDrBq7tDqAU
         8A3uRFdfzLHnzeSPV8gzV780GX8gW/g6Agwgyz8zDPV6ABQq8+M7+8hiJOD74+d79FLi
         Z11AQucWjpXFPeHpe7KNNL2ZMz1pWOzVl8e6Ibm/IQZHZ58LuvC4ozydIo9G0kLJyFkK
         cASQ==
X-Gm-Message-State: AOAM530lzvXkDokb6LzgRnOW+pgaZ6jcJzodD9N/9gA5fXHFEfF4/Y9C
        1oYECM/D/5FVyfBBJH6Qy6OGhs89RQukDrsTdw==
X-Google-Smtp-Source: ABdhPJyzCnQ1D9i3BPbSz5/JlfARUBWfXARLQvTDGUcjnBE1+ftGqK/qRtJHLc9plQLulhQkNRZ61/kNuhpoQlB2os4=
X-Received: by 2002:a63:cf01:0:b0:374:2979:8407 with SMTP id
 j1-20020a63cf01000000b0037429798407mr3192917pgg.521.1646497315310; Sat, 05
 Mar 2022 08:21:55 -0800 (PST)
MIME-Version: 1.0
Sender: alamsalman2000@gmail.com
Received: by 2002:a05:6a20:3e1d:b0:76:760c:e92d with HTTP; Sat, 5 Mar 2022
 08:21:54 -0800 (PST)
From:   Miss Qing Yu <qing9560yu@gmail.com>
Date:   Sat, 5 Mar 2022 16:21:54 +0000
X-Google-Sender-Auth: Eg2z30tKZMkDK5yzO_UGoi-ix6o
Message-ID: <CALH+dLDESWK=sd1qUb+nbeG2YAOOf5diBOYtgOZ52erN8VHJGw@mail.gmail.com>
Subject: Hello!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_SCAM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am Mrs Yu. Ging Yunnan, and i have Covid-19 and the doctor said I
will not survive it with the critical condition am in because all
vaccines has been given to me but to no avian, am a China woman but I
base here in France because am married here and I have no child for my
late husband and now am a widow.

My reason of communicating you is that i have $9.2million USD which
was deposited in BNP Paribas Bank here in France by my late husband
which am the next of kin to and I want you to stand as the replacement
beneficiary beneficiary and use the fund to build an orphanage home
there in your country.

Can you handle the project?

Mrs Yu. Ging Yunnan.
