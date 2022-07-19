Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1DE9C57A10A
	for <lists+netdev@lfdr.de>; Tue, 19 Jul 2022 16:17:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGSOQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jul 2022 10:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238742AbiGSOQm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Jul 2022 10:16:42 -0400
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com [IPv6:2607:f8b0:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1006654AFD
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:47:34 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id r191so6784255oie.7
        for <netdev@vger.kernel.org>; Tue, 19 Jul 2022 06:47:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=JjmTxe3l9f5dy0FDhlsFClyIwHrz7OLCznA+4gbsJXI=;
        b=cMbzztC6SRewxLfMcM82GIrVOsv4oTacHce/PjKYEE5+dn6P/LVFH5nUJ4WSX98fGd
         hLlUYUGHiMrdwJTxGeOquuAkZWD9tsW3muiWCCLs1IAPW/wquSK9BxbDo0IMwScpjYGE
         a46JXnYNbQ8D7JDBjYvyW3slcPCbgI07Fo9eCDkWlDdLX47GQ9CkrTZQBEFoBI/hv0eR
         I2rWY9FVp0C/XkhW9HjDB6BPy2kHLP6hWjmLZlsg69dk6nZ2OitzrXV573I8UrNolwdT
         uj68mrMG65xR6KeVuFX/Ol/Kowj+tZ3uJUNFkpcV0wRpmaEQgpPqUc4NYaMv8lxPpJLK
         hX6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=JjmTxe3l9f5dy0FDhlsFClyIwHrz7OLCznA+4gbsJXI=;
        b=Cz7LilJtbpG5evFTQYC6IqWx3G4U7pQF68hsVxdP0K4oQzeGDfzHCFVvruT/mGoDUf
         Db0Tj+7sSYyM7lterDhN9xbtEq8tWW1Kh6d0QZS4h7XxBQpCCNzuYElZy/8qalTdgYrd
         YAsaSE+RyHVvmACy6dtVp2TnFJwEOUHIpMNf5QzJ5r9EVFT6wQSYw4W/YdP8sOoPnQAE
         pN1epbM+TTdMft8EfZmR+q+OeozqMEViz2I8CTTSeC3LvHhoswL+/T1AaNfSsSTYKK6J
         nRkSDu/ksJFQe4K4vv1+MPU7tK9z9wbFnEP9izNiCkLfzg2egXoTrJdMxkQzQho0ONlZ
         Um5A==
X-Gm-Message-State: AJIora+JlwF/cgroy9gjtXv0Mh6kaLrTE9I41pb4+Bm/hogddVO2Chu5
        g7ymOGR1LprLO9o86zcFleah5W7f4cjNZZw+bgw=
X-Google-Smtp-Source: AGRyM1v2FmEs2nE36BLeHDVNvQNBxT9DR1rg774v2yKNF+j4YZzsXAOecNj8tZ9Ibyx76JwL3Kp98GkkWIPib2i2MxY=
X-Received: by 2002:a05:6808:f92:b0:33a:441e:979b with SMTP id
 o18-20020a0568080f9200b0033a441e979bmr11971682oiw.220.1658238453483; Tue, 19
 Jul 2022 06:47:33 -0700 (PDT)
MIME-Version: 1.0
Sender: manuellongman147@gmail.com
Received: by 2002:a05:6358:2490:b0:af:f781:9abb with HTTP; Tue, 19 Jul 2022
 06:47:33 -0700 (PDT)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Tue, 19 Jul 2022 06:47:33 -0700
X-Google-Sender-Auth: PwDg2FQwFE_WJDTco2SGySWWQ-g
Message-ID: <CA+ZiWatBqaxUzFVPFeH3uUWAde7pdmbekEX3XVC8VwW+xdWBqg@mail.gmail.com>
Subject: PLEASE CONFIRM MY PREVIOUS MAIL FOR MORE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good morning from here this morning my dear, how are you doing today?
My name is Mrs. Rabi Affason Marcus; Please I want to confirm if you
get my previous mail?
