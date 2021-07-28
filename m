Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A23053D8D7E
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 14:10:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234910AbhG1MKK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 08:10:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234647AbhG1MKJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 08:10:09 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A10DC061757
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 05:10:08 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id nd39so4213218ejc.5
        for <netdev@vger.kernel.org>; Wed, 28 Jul 2021 05:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=seja4eeYUckqwZ5S9INDMzP6B+XclkPhXWDd5ioC3L0=;
        b=WBNC9iJvLhXi2roFN3DrIP3CVUifqN5SvW/JZB9OdEg/+Yzq8H2xR45K4otPDM1cRe
         DrqvjX8hxlPYNM4lM99FTlssHQ7buxpk/tuBpz9ikPUEmqU6qzIv1c1drRZPxWO5NP+W
         S7u7tCDs9G8b0SPFMZhv9uQDZ7s8knyvaj7SE7LI7q0bIikL9PdfopvWWith8sMGuXQ5
         CaDsf3bd1E0iAHfB7O+awkkXNpE2AcBOtc1za362WXL54fy3RtrL/esCqRFOje/4MjxZ
         pkoFHs71YoNicdtae0G9JUHP+7+acCgffRuiFqv4J3BJ+/8acQI3yom/8p67i0onbqLR
         k1WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=seja4eeYUckqwZ5S9INDMzP6B+XclkPhXWDd5ioC3L0=;
        b=OfMN+OugYouc93SUd14fshN3j8xYb3XmiEpLF9PRZEuV9c7ZEcYsPQrbzbxGpVoH9x
         adKJh7LaIOESm4frmfer8Lki2BziTPPqYDSn8UC8MN9oAJ9PYegl80AvD1gCC6+Nqi/x
         y+0S0LAZZE73OSkeDbrJCj1cwwA5TIh6DovO9io6HkKY/kFzWS+OFu31tc12egb28SaF
         TZDIL72dhsvdxr/PfHVBJKjYn0ezaQOD/4hD7gO0Ee2cWBjxQpRKYf8UfxFp+RWwGHWo
         iD+y//oDkL7ubdMEwRbfHv18rwNyacTk7KcAXTBijN2nRT/ff0xPSBJsVXHGyLkyCyLG
         jhLA==
X-Gm-Message-State: AOAM532QtL88PdAUBs7q1uSvmWnnUv8ONFpOgPxYwA/WVarnEh51djvH
        0hf4KV4QUC5Q+ajaEfe3rULQzH5f5A5X/wr43iA=
X-Google-Smtp-Source: ABdhPJwg5MDrniGKEGdnVg1D3pvpdEcfk14iNaKrpHJ2wMqFFc4b/igaQagNyZKOUqZ2FclpLheNaRcOGyHRzyIJcIY=
X-Received: by 2002:a17:906:d8a7:: with SMTP id qc7mr19768202ejb.372.1627474206807;
 Wed, 28 Jul 2021 05:10:06 -0700 (PDT)
MIME-Version: 1.0
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Wed, 28 Jul 2021 20:09:30 +0800
Message-ID: <CAMDZJNXEXdMR+wUOHKOnJfPwJyKECY-GXAUK0bRp-M1=Au9Ung@mail.gmail.com>
Subject: sock dst_entry
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eric
the commit 7f502361531e9eecb396cf99bdc9e9a59f7ebd7f remove "sk_dst_lock"
one question, what different usage between __sk_dst_set and sk_dst_set?
and __sk_dst_set only is used in __sk_dst_reset, can we remove __sk_dst_set ?


-- 
Best regards, Tonghao
