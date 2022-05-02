Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC815176EA
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 20:53:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230156AbiEBS4m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 14:56:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbiEBS4l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 14:56:41 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1013B60E4
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 11:53:12 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id m23so19542454ljc.0
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 11:53:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=N5YmcK3LQPDa9S46t80JlSLlg4biAStd9bgeO+N30vODAQrv9onTsgiLFjiWGoogXY
         zCipKUDp7x3HALjmJOfuUmU3i1St1fBQzldyGHsCHQxweFjZBOcVZJdTfsPDIVb8xeJw
         MvnFL0U5YaASisdNf4IjP54tuteEBpRI0JE0p38X3ocMAlsuZ7poilvzX5o10H1U7+3n
         c55cDak9uHakFk5uSIkd+qA7WvGKEBny4fNVNHBzVGFBe1nYQenwTDcyaGvHFWbRizhW
         kyMLdbFFAcb7cxtFo6qjICC9qCRqY4Y6m7Xy0JK7tVD2uTdRMkV/ecPCi3v5YFnuZkmB
         VfxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=kdTSJmnbBK4N/virhew8A7fzQDKu0iWJnLEnGHSX4Dw=;
        b=ePAUQMtTiD5pJ2dg9Ky746NDy8hYKUVZUX9tDT+PC4TAoSACGJMLty35+CGBdjlXL/
         kLz4ODBFQPRC1XG0SOSRRNyRRW4lKo01fy4Dde6+N4TYlQRRTFAf3UyajYkQfh/7fugQ
         tg9h7BiQdmHBVU3dQ8uQrzpbqGep56CHCcNfH8QLUTPDmSKyM7BTd21I/XXnxOQhdCPH
         d9qAxOhZT4aJLMOf2ZghZzC3w/MrF/d/QfB/p81rzTFJ+nxOFL0zfg+5nxh9HvW8W5IH
         /V/1Kj1XcK/ItAfjXRwyUqEG6Bxn5hrhHyA+JuB+Pwferh1tPVEXcXZyVSsafeWogORH
         soog==
X-Gm-Message-State: AOAM532AGbgkNfmCo/BQS26B3sBDgthvQKH3CnBqFiDS1jHxOMC7v5B0
        sn2ZRGaVlzhJdEuAbldC+FsWVrYGJA6xXl+goj0=
X-Google-Smtp-Source: ABdhPJz7C6SVKT9tAoxKnXnhS03WedWXXQndPaTcaA7YOgwbZ6jT6ydw35Q+pSph1cx+YJP9OSDpnsqFIc87+SVEhCY=
X-Received: by 2002:a2e:8503:0:b0:24f:dc3:9e8c with SMTP id
 j3-20020a2e8503000000b0024f0dc39e8cmr8160165lji.8.1651517590053; Mon, 02 May
 2022 11:53:10 -0700 (PDT)
MIME-Version: 1.0
Sender: mrderick.smith2@gmail.com
Received: by 2002:a05:6512:11e9:0:0:0:0 with HTTP; Mon, 2 May 2022 11:53:09
 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Mon, 2 May 2022 19:53:09 +0100
X-Google-Sender-Auth: w7tShoxfKKdaJOQADzlISLWrpRg
Message-ID: <CAO-9xdmKLkNCS=Fir4-JRei7qAUuTxJZsQvr0bQnxJsX=BL2mA@mail.gmail.com>
Subject: Hi Dear!
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi Dear

My name is Lisa  Williams, I am from United States of America, Its my
pleasure to contact you for new and special friendship, I will be glad to
see your reply for us to know each other better

Yours
Lisa
