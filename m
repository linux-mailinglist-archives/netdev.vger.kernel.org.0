Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A36D14B38D9
	for <lists+netdev@lfdr.de>; Sun, 13 Feb 2022 03:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbiBMCCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 21:02:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:60222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230179AbiBMCB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 21:01:59 -0500
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CBE5FF1C
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 18:01:54 -0800 (PST)
Received: by mail-wr1-x42a.google.com with SMTP id s10so7786092wrb.1
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 18:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=Prmmfg2rEV4uJgRWjd+vofDxNghZEzQF4wrdv02e8Pg=;
        b=BryKYgTPWtJvRUN+v/dMDyqSoOsL1IpCd8dKzn/DRbB1xtEJkHNGuXoRp3T2QzQHL0
         c7ODHAhOLr0M8H5eP4TiU449zPp2ATMlM05ckGUi8I7qzFLH204aNwSfrCjGJL9CBT17
         OyobpttUIyNWTOa08HFq0hy1zpCkielX6xgJg51cUs1ZLLxTjFJPl7b/N4fnlL1Wr1uM
         KkOTg6nFn02lXlRCR+JxVUgJ5jof07debDLI06D37HbwiF47hpYnY3WXeSdj4xyX9v5f
         3gvZeJTJbZYxO8rAocrGdEwhBvXZ6BYlc2rmCVZ4CVjUMNDKnDyi75W4+Z1W9nTmPkA5
         4L1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=Prmmfg2rEV4uJgRWjd+vofDxNghZEzQF4wrdv02e8Pg=;
        b=THn8G7bawBzdI+LS7iH1BgWiQ9GRCeSXHbX3ulLAwwe5mQFCoWAoBVOgvE9HmLuSWd
         Wa1fuPXVrIKfNnsxVUHhXaL9ZWBdNYFx3WuYWf/53tVPDsKogWCEQUT0yPPhPtREbxNC
         887YPYvtqALIkkVKt3XcQRm9eqF6szgf4/uF6Jyehe/Mrh9XQqTC3rbFreke4L5jTOxS
         IPp/JQYsyglLe2qFGaZq5zP97IqmPJ+dGdRw2CMYuoSz1MaPDvMBB0MC90yFD/ssJ/dl
         pUO9RWKp6dW51A1OMco+hE6ybei+8TkRwsBFyLZlmjnPCQR6u8+BLDu6nhCZzcunC8mD
         Hxvw==
X-Gm-Message-State: AOAM533mYEsh7TE57UVrL73sLya9riv3d4om+LmsGcqO37TD/D6e21w+
        0cuHkaPQi6kap7hH+YpaPj1B0OJxGvc13W2YG50=
X-Google-Smtp-Source: ABdhPJw5JvXHeFA8e4hU5bm9MeW4dT0AcOKrv/0YGsPwaUXPuqltXqijB0evKrpdPzNshdpGc7kN+Q9P5MhcD9K2Wec=
X-Received: by 2002:a05:6000:168c:: with SMTP id y12mr6273528wrd.265.1644717713073;
 Sat, 12 Feb 2022 18:01:53 -0800 (PST)
MIME-Version: 1.0
Sender: malindaandrew04@gmail.com
Received: by 2002:a05:6020:d789:b0:18d:5f8b:ae1 with HTTP; Sat, 12 Feb 2022
 18:01:52 -0800 (PST)
From:   "Mrs. Latifa Rassim Mohamad" <rassimlatifa400@gmail.com>
Date:   Sat, 12 Feb 2022 18:01:52 -0800
X-Google-Sender-Auth: 5QiKJFAts1GAvN6JqRx2RA3-zcM
Message-ID: <CAL7GHSHvLwmhLGpJdg1i3H=mnjvE+Zz3=HtyLN8Vdj3wvFyAHQ@mail.gmail.com>
Subject: CONFIRM YOUR EMAIL....
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.6 required=5.0 tests=BAYES_40,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_HK_NAME_FM_MR_MRS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Morning from here this Morning and how are you doing today? My
name is Mrs. Latifa Rassim Mohamad from Saudi Arabia, I have something
very important and serious i will like to discuss with you privately,
so i hope this is your private email?
