Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76DB56DC541
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 11:43:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229803AbjDJJnH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229669AbjDJJnA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 05:43:00 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DC2F199E
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:42:58 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id z8so7520191lfb.12
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 02:42:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1681119777;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zWIONkUKCX2JMCosfarTeLGkNWabBO6R8R+bGsxbMRQ=;
        b=kPE+sw6YDGzJdIMe6zPrQZ7hKrX0zJ7O06LMt716/0OIwjy/7hnAMojQ4ryMrgriAs
         Awk/qfKmppyM7TrfX69aZ9iKyv22oT7r+ANZ+Zt39lhTYUrqX/S1/S4qbon50LzpbaF9
         fltGlXeGADVUXzuV8vKPIkBaVO4yfvgJrxM0o9DVZrp5MtRIEkbdE4wHwS+sk7R+L6LT
         6SJcMSecYxp/x6GD6/aGsat3Pkq+/4BEkk+iH7kAvJc8lu/x9om/VtwWNDKNf0h5V+bY
         nozgoINDuIMI6/0y8LrsMOgCGfeQXQ+Ox5rc4Dvq+2YMwmjuzT7YrTioRS+F5kKxchPp
         6gHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681119777;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zWIONkUKCX2JMCosfarTeLGkNWabBO6R8R+bGsxbMRQ=;
        b=oPqyW6J9yehtQeKbCvngydhiKhrSy6IHDqg5a/V9ct47PLWq1ub8Hzpgm9h4qTgP1L
         jifsxArQA2Ipceg+ntnaJEYqX32LgM8vigL2/TW7gJyEWaiZP23VVGt9OWm6BItLZdiT
         feeZrUwBpSVG51ojtR2jnx9tVE2gp64KK9ftH/2g2UVUlDWVCNHpvDL1ISxdEHakKWvE
         McM4Erg1LUsp8F0RUb7vyYA0GHcACgnigmoJh6ae2vvdV36QWVhFAm1IEJIg9eJhvbYF
         8INcd7DmJ/RIAo8HGirngnrl8t/xCC2YEzEEWQn/KsimR27MQv8wXkfBT6mR0VyxqAdR
         aVVA==
X-Gm-Message-State: AAQBX9c0uDqIcjAXJYH9QmmdvoES+YdsHVfUVrFoitOHV7DQ+oXjP8uM
        bunFSD4OkSScZMStxYJs6Me0sg0l91vun5rYu6E=
X-Google-Smtp-Source: AKy350aggLYuE9OB8Uvp492PIhBsbhj+4Fkaqz3hN2YFtWGZtY/Qtk4p0jZO1mwKi9Cb/Tlz/qFBwpSTU/wHtfYXsAg=
X-Received: by 2002:ac2:5fd2:0:b0:4ec:89d6:9b71 with SMTP id
 q18-20020ac25fd2000000b004ec89d69b71mr610894lfg.6.1681119776932; Mon, 10 Apr
 2023 02:42:56 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:aa6:c2e5:0:b0:24f:6912:1b1f with HTTP; Mon, 10 Apr 2023
 02:42:56 -0700 (PDT)
Reply-To: wormer.amos@aol.com
From:   Wormer Amos <maguettebadiane93@gmail.com>
Date:   Mon, 10 Apr 2023 09:42:56 +0000
Message-ID: <CA+YZjr6goHA8QWTbwWZsKD0DXr3REmcsLVcNdpbXQv50-J_7cw@mail.gmail.com>
Subject: I WANT TO KNOW YOU BETTER
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.6 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        SUBJ_ALL_CAPS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kindly want to know if you're ready for investment project in your country. i
need serious investment partnership with good background, kindly reply
me to discuss details immediately. i will appreciate you to contact me
on this email address Thanks and awaiting your quick response,

Your friend
Wormer,
