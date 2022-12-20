Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A565965201D
	for <lists+netdev@lfdr.de>; Tue, 20 Dec 2022 13:02:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233117AbiLTMC5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Dec 2022 07:02:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231248AbiLTMCr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Dec 2022 07:02:47 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98695CE0A
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:02:46 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-142b72a728fso15103471fac.9
        for <netdev@vger.kernel.org>; Tue, 20 Dec 2022 04:02:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1lnZKWo9VpE4FEVxdiPyfI3h9yeQKpBkW4PD5up18b0=;
        b=LVnNBzA+GopexBnS+OkB/Assh/OhijcQWZVb8695PZRQctIjciAF6MhP1380DUwfvG
         yUH3dgs1UNlva5JbMziHjVmq/vqu2E35FU/ky0c4mLsQh4Nt0830POaNizidG6Fri16x
         UTwGxZF3dhdzMNVOwfDhnPNQievrO+S/aJ7ga8Ki3o7/EOCtv69uKQO12A8YLMc5wkLs
         rc1TK5JbwwiIkIaS7CEJ86u2vquJsh3T4CGLIWDhV0NWG5Oev6PU6qx2T8sfLqJpLL+N
         UXlJ9pm9z8BTtUqlh39IHECxTiHz0SIYlZgalDZrb4bnBbW5pGy5v9C0+PIEqKDWSosH
         rMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1lnZKWo9VpE4FEVxdiPyfI3h9yeQKpBkW4PD5up18b0=;
        b=2+bprH1XJI4qMoaGe6La7DxcbVeJE2lwX4clYGTScWT8K8rHO1pVr3WJEbDNJoA/MU
         mqvjGQqjK5Au43t9XHXxfT3XEtDxFlDPeyx1JZiGz3lXGxwEkyKPRDke34FlDItpFsNi
         sOPrgfemd/JAktL4LeaTme6fnfh9EyRWPQchmmLpi5aFlg7mpq+IYNulRWu/xToVcfuH
         tHpQmJE0gP4fSkb1zzEr6IUXHuNNM6n0yqD5Lf0bvHfKdSvds07TP0hPMFnYkyb1pKrF
         9AU1wBlEHr0bw/qhQFiN44dfL8X15apjEbDW0D1hyicgKD75enNCpQ+PCALr6+22/1O6
         NdZw==
X-Gm-Message-State: ANoB5pk2PpiBJnQ0Q6wTlOspexDjldEAFllJzCa+jr7J2ETL5avG6WGS
        +Ni9Wkla6b/8MIFk19QnVrWoLQnaFwaAV1yM97c=
X-Google-Smtp-Source: AMrXdXsfQjt9ZxPLnGRJCyCWUUGO4Gcleem7h3R74NBVkPAjJqMDaLnDbRj+ll22oxFQcxt3feWJhhjh34lRS7bKDdc=
X-Received: by 2002:a05:6870:469f:b0:144:f09f:c67d with SMTP id
 a31-20020a056870469f00b00144f09fc67dmr2411496oap.258.1671537765766; Tue, 20
 Dec 2022 04:02:45 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6830:1147:0:0:0:0 with HTTP; Tue, 20 Dec 2022 04:02:45
 -0800 (PST)
Reply-To: vvivianchow22@gmail.com
From:   Chow Vivian <il023114@gmail.com>
Date:   Tue, 20 Dec 2022 12:02:45 +0000
Message-ID: <CAN1UV6rtBKHjRLyNeWqKgz5eOA+ok=NDo-zqH+4C5cWfZusZ=A@mail.gmail.com>
Subject: 
To:     il023114@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        FROM_IN_TO_AND_SUBJ,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,
I wanted to know if this email address still using?
Vivian Chow.
