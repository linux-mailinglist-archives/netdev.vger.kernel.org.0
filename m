Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2341D67B6FB
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 17:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234924AbjAYQdz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 11:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234613AbjAYQdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 11:33:54 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B30E2F780
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:33:50 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id rl14so45840103ejb.2
        for <netdev@vger.kernel.org>; Wed, 25 Jan 2023 08:33:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oVrT6x97aQHjkZJsTwE9FkNgghMF/jWhweQ0JwPis6E=;
        b=nDdkZsJTtT0nrCJnQFog0RT2W3dHs2F8lzmx/xpycg+iy1kPnCNySCpGoT/poIHLjV
         djoWouDS+ptz0oOhDxd1QQYRigs4l16QMSCufcyH+AMDd1N37Ebd/D2G8E+ktCuPY1sF
         iIVbHzuggROQr0WZtF15UkgoU1OvcdruJ+f+yp/lfyy1BdbSQ5KABhIHwovXvEPOf4BR
         q71i7I+0hHuGsQjSb27Ou5V3aVCSn0HVIrgQlljiMk/toZdf+6JTXNpmSnxBlHrNpgJI
         146/atkTrOEJr1OVwk0nIMl1wX2Q3N/S9Wy6fR0qMux80xdXxlAYItft+jZk88bXw9Kp
         pMxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oVrT6x97aQHjkZJsTwE9FkNgghMF/jWhweQ0JwPis6E=;
        b=XKst80i3MO2DCSsuvlOv8GBGOZ0u5FxKzEp7GKObR6Sw6PgFQc/ncQubXI+9OeMACO
         8SRr6CghB7PP/ubrAuOg3wlm/nRcq5oUHlO957+6mOcRLgtV00+rgpMZWRpvpGH2ax0W
         fUJRcUaDHr6B09prgo23pnfJ4GAIcynls+u3d3B5Iib9zGEn/wrQm/lWE5nok1xYoXA/
         8zvtoZy4Y/WQwIZ9GKh2dHPSSNIsNlotNFH0SfW1lKFlEk84Vz4Oe4wBDp4nO4zQkdPw
         T3fFnTszU+N7mhYxzw/8fYbm2RioTYkXPWBow/z98GqajrJA+nOkOjdqvXcZXwM0pl1h
         r1mQ==
X-Gm-Message-State: AFqh2kolRkHhgaK4elAaLrQLlhnNQQU6Z3lFkrOCPQVbcWwkMKhVZOen
        mNoDdDoCsTBOv8No42Rs0rXaXJ3OYjWxfPDImuI=
X-Google-Smtp-Source: AMrXdXsxMXp5Nkl8t8mXVk4YCurxIfrbzYitiD75za0VChyXcNOm6KJfdS288XLaIZXoFwbMMVj9i9ldDCMJDW+E9J4=
X-Received: by 2002:a17:906:5d9:b0:7b9:631b:7dfb with SMTP id
 t25-20020a17090605d900b007b9631b7dfbmr3522185ejt.32.1674664428941; Wed, 25
 Jan 2023 08:33:48 -0800 (PST)
MIME-Version: 1.0
Sender: drbatiistsbrsxton1978@gmail.com
Received: by 2002:a50:501a:0:b0:1f2:6a92:7e48 with HTTP; Wed, 25 Jan 2023
 08:33:48 -0800 (PST)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Wed, 25 Jan 2023 08:33:48 -0800
X-Google-Sender-Auth: srjSDo4dNrMjawykCRZRubGNaB4
Message-ID: <CAB6JQiXaJO2Tzv_0pDAkggDaON-on8PQkLk9p2VknB6=frTfyA@mail.gmail.com>
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

Hello my dear greetings to you and how are you doing today? I have
expecting your response my previous to you, or didn't you received my
previous mail?
