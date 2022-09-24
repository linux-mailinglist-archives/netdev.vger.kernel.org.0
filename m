Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E7085E9070
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 01:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbiIXXf4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 24 Sep 2022 19:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233991AbiIXXfz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 24 Sep 2022 19:35:55 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6E2736DF0
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 16:35:54 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id z20so3823197ljq.3
        for <netdev@vger.kernel.org>; Sat, 24 Sep 2022 16:35:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date;
        bh=o/Rzx2on4JtIuoMDlQWT2mKwPJ8sUwps3j3czfLOhaE=;
        b=JAnB2qjPGPpFvWvMO87RKID8xABiXP76ptc8h8BFi23fS2KmyWyAEs+hjGaOgn2yo2
         H+OR84/erhxL10D6ygyQBpyDaY5gyV5BZMIGI8uevOKLvtucBJMwLsPOwvOa+wruHfo1
         kAkzIjQqRC7YKQbfEaRVwlrIG4kDmA1xkQbWsqDOcOdCcmHw6uO8oXJeyFArTUyMWkeY
         SLYTjyToh3Zu9kDaLnslUGsfOiE9F3N+fNcsTb/WnpEne1Aa7Q111ppHKRnyI5SxYmAA
         pF2c75FN/ve7AlJMhpyOiGJjRuidWKLO73NSq7Wc7tMF1qm1p9lmHDFqtnWOlJL8opvy
         4CrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=o/Rzx2on4JtIuoMDlQWT2mKwPJ8sUwps3j3czfLOhaE=;
        b=IKHvWFMkxs13Q+4BgwqEgwCzpMibpHAkQidDZgYVVVoUCr2zh4M6HcNpkU5kcJ4LPL
         G10PsqBhYw7FdbKTCGk1vWonBJBUp0zgPf9HJPLVJ33W42H4Hwla0t5sMnvqBHD2FLh1
         Qfe1QVuhiBqARKcqc+cz444G5lHF7MW13mXIzG6pwmOaXGyY5qrIsk8ShM3DBtLy7ZwZ
         WUE4K/NSFJIyoz0sCo/fXwEvufJe9lOp15+wK69JyfuxTs2POl7evRHdb2HuWUctrsec
         z+hjI2mnBGcJsPLFsxLyb1D8LO6f9cJ6eMgD17v4mi22zOS5+3B49yDbhv9ljVThBj4f
         uqHw==
X-Gm-Message-State: ACrzQf10maMaIsO9OxQF1xb42M8Eis/33jNWwkll7XCziEWu5m2ZNinO
        Cg3v3PW9+OVqliYLp4hg9RouTwh3WqCC14PHCWY=
X-Google-Smtp-Source: AMsMyM4EulK679OTz5jqc8X4rkNGW/VxpF9dcO0rgKBEvEeh62AbOecbYxkZhK3G+ymQl8Vztt3HiZyKwHYKzlz4lRo=
X-Received: by 2002:a2e:a0d1:0:b0:26c:668a:6b36 with SMTP id
 f17-20020a2ea0d1000000b0026c668a6b36mr5137556ljm.200.1664062552922; Sat, 24
 Sep 2022 16:35:52 -0700 (PDT)
MIME-Version: 1.0
Sender: jessicadaniel7834@gmail.com
Received: by 2002:ab3:5211:0:0:0:0:0 with HTTP; Sat, 24 Sep 2022 16:35:52
 -0700 (PDT)
From:   Jessica Daniel <jessicadaniel7833@gmail.com>
Date:   Sat, 24 Sep 2022 23:35:52 +0000
X-Google-Sender-Auth: pQbGEBX75B58ORidiV3uDj1c7qo
Message-ID: <CAK8-hmJ3bk=vbdNpfzoCf0q_zkfgPSC7Ze+nJnDJXh8tDAq7og@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear
