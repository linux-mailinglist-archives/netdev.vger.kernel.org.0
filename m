Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E00CC4D03DF
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:17:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237275AbiCGQSJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 11:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244075AbiCGQSI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:18:08 -0500
Received: from mail-qt1-x831.google.com (mail-qt1-x831.google.com [IPv6:2607:f8b0:4864:20::831])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A593532FC
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:17:14 -0800 (PST)
Received: by mail-qt1-x831.google.com with SMTP id c4so13683622qtx.1
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 08:17:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=c3P4r2Qz0VdfRBuStsXVpcJEgpWE5t0Sgi1SeeHIl+U=;
        b=qLh1xGHv9ZaTRrZzpqcOoD1+8uHX58u1nMs6oSW6WhrHKmvFia5wivCGIniVm6FgkR
         iLC0Y8OkeuWmcwx+M3Ed+4lITVZWEEeEUU4MMxItwYA6l6XBHu78SVcuoL+XanMlZgqn
         MSTaZUPUKKUVPiM1iUOv8DrDZaVExh6oBfzh4uHZ1mYRzM5rYwB8vjDPpGEn4y1CJpbJ
         0ZTR6D9jGwa8sTXP0cEpkQbga/MUh+0KQBIB3tmfRsl6Lxd/U8Hwf1wRbRmYXPyWehHv
         erZTkyiJjbds40BgSx9Z6M615FfWyoCBlFOzKvZvXtPZCvh3WxMhmOB+RU5Atx7QBeb9
         OI8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=c3P4r2Qz0VdfRBuStsXVpcJEgpWE5t0Sgi1SeeHIl+U=;
        b=ICSxaSVKAasM35WYfel6HKTQskt48ZuJmXONOh12jrMVDDRWAbv2SI2nFdkNKL26pv
         eY1nNYP/JqATXH3r6OgQwrwYcrf8D+i3aHd/tZ6/SOC+BS/z1jQwZ0AwyDI1ybt967q0
         R4yXSmxv234hGw01qCGeJwwcm8bPCxzfS3LTGqYS1kYy8rtmGKz1PnLD1vpw8KbI8eu7
         Oi3qdxEAn79Cmbwnqvn7sqhy1a/t04hlesqYH7K159Ww9UuHrjPUQI7BGds4GHaQ2jQL
         UavFvq0rmAHQh6mg8Heaz/Bk+NsJwhEiQgt8D+u0P3AstqVw07l2vISXbfgOLq32mJO7
         AiLA==
X-Gm-Message-State: AOAM5332NZOfIdKgnlldBCz4HsY9KL3AR2Q3/gOicaqrbGsrlcapWH31
        hfyRoAVeVokXhqiwXmaAjRRKuCpMOTnwKI3rvSI=
X-Google-Smtp-Source: ABdhPJxHqRLxeTHutyIHKPk0zXlP00KDJKsdfGnUZdGC8XmAFUiG7PdpmXHxheXLigZ4inYz9C7UHBMv4EGcuSd63xM=
X-Received: by 2002:a05:622a:58d:b0:2e0:6694:ab1 with SMTP id
 c13-20020a05622a058d00b002e066940ab1mr4729603qtb.593.1646669833230; Mon, 07
 Mar 2022 08:17:13 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:622a:1354:0:0:0:0 with HTTP; Mon, 7 Mar 2022 08:17:12
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <fernadezl768@gmail.com>
Date:   Mon, 7 Mar 2022 08:17:12 -0800
Message-ID: <CA+J-fD71VmnH153pBpOOwkQVsefY4ao=3j5yCYi8g1A5PeopkA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.1 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Please with honesty did you receive our message we send to you?
