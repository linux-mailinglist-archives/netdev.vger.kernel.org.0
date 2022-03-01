Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42EE24C8916
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 11:15:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231678AbiCAKQN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 05:16:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbiCAKQN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 05:16:13 -0500
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0F28D6AE
        for <netdev@vger.kernel.org>; Tue,  1 Mar 2022 02:15:32 -0800 (PST)
Received: by mail-wr1-x435.google.com with SMTP id ay10so1812215wrb.6
        for <netdev@vger.kernel.org>; Tue, 01 Mar 2022 02:15:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=qBxzRmnbe3vDJ/GrMkOyf9TosViRH7MZeiAgNthvVrs=;
        b=G7O6UonoblmTAi3NtM1qNNDKe5VZlR5KpCbnA93dRfrVGNL0Z7Y4K41CmUxwGJ46uD
         syy7x8BZLZg5NIqt3PRbRrzgEvO8HKTVSHsIK2pO2/LzZK8PVvUrkRRYMPfsodxjTD1A
         4dtaT9yW0O73s+OHRdU1hg3UBWB+nTFg3PrWcQmG4uZIebVwD2Vtf9+FuBEsTB7dIQql
         Knvdd8oWK67SRssyQZc2GHOQzXSVayyDZYgwQ/myhjT43a6yitaJWPf0cghCmMkFZWAn
         dWMqDPn9pRO0cdz3RpOptQ6fIYQp1CkqBXcpKwd/lSA5EnZaH2+loza21jUqWamnnnN3
         PiZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=qBxzRmnbe3vDJ/GrMkOyf9TosViRH7MZeiAgNthvVrs=;
        b=I18+hr/3mHayEWzkCrC7Qg3k0OaTLbtMpwEmq9cou1RCev5flQd7dnG8U8phQJtzOR
         X8InpZl5Nh0Cr6uYcR2RnqlYBpaD3s4JGgOVRQGY+P4+VV2qI5SB0tPLu5GEyEuABm5A
         6vz5ZnRyDnfj8hI+LShxReq9nEfAb/in6cl59LTkTHWQSbJAFgvHeoHwC5LToWLUOCTW
         jDlygQngFLN/nH4C6fpO55NSVp88uQX46OWWaRV9OvwqPtcbyHDEIHeMhqlLSDAcBfgX
         6odMaMxXr2RqqVqVTir+3C+K8wG1xWAmS3cmObcuGeFB4+6Mp/XsAgybodwyppTbdygK
         ny6A==
X-Gm-Message-State: AOAM531sJnPVQyvKloypd9QfPntU9qirAt208/VKWBzURXoSmYcuR5sH
        Ib1s6ltJqlLhGKifhyNkcgECnJk1C3jeRhNTsBk=
X-Google-Smtp-Source: ABdhPJyHgM9RnZjUwQEjUWJ/BKREWDcR0Gugh0JGHEZdkY098vimljOvdblQljqGKH6w84P0NsT1Dv8FJmejLCJpD8E=
X-Received: by 2002:a05:6000:552:b0:1e3:7f1:fab2 with SMTP id
 b18-20020a056000055200b001e307f1fab2mr18192930wrf.327.1646129731368; Tue, 01
 Mar 2022 02:15:31 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:adf:f247:0:b0:1f0:22ec:174d with HTTP; Tue, 1 Mar 2022
 02:15:30 -0800 (PST)
Reply-To: fredbensonfirms@gmail.com
From:   linda <golddealer792@gmail.com>
Date:   Tue, 1 Mar 2022 11:15:30 +0100
Message-ID: <CADC7BigYYspuyhnoRr2chJehJEu+HmzTQnWO3TDuKuuUm8yYYg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

please send informations for the transfer
