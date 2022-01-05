Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF64E4858AE
	for <lists+netdev@lfdr.de>; Wed,  5 Jan 2022 19:53:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243201AbiAESxZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Jan 2022 13:53:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbiAESxY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Jan 2022 13:53:24 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04689C061245
        for <netdev@vger.kernel.org>; Wed,  5 Jan 2022 10:53:24 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id g7-20020a7bc4c7000000b00345c4bb365aso2459807wmk.4
        for <netdev@vger.kernel.org>; Wed, 05 Jan 2022 10:53:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=VS5pNjM+dtzy9PLwNcG+/sVOQHrdlQb2MUBNj5cMGEA=;
        b=LSiaePdgN1fVVIbqTViAf0ZxUltWeSo19uVcIQfcM1eSGl2WvPy412+E1PYAPa5iK9
         2QfY9IWbiQxNvnbrsQ9jqWD7CVziJTt74mSRhZfXsxrNfYTtfl+QoYyJzcMCOK4HBKJW
         Z4t0CB9wWxhc06mCK3sPs1M1ztdRTLLY3yXDBJJk/xz+BoVEzgL65pLBT55KUOHxHs4L
         zAtuJ9JzPJCC5fl6xwplDlv+0DdkCeLsOM4r9c6Anj6fZCOl3M/mvlfKfw4H69fckCv8
         +bxvdZOb2Ul6q/vsm68o5rsPw1oGWDMGMopmn4vJEXn7UsJ5BZ5vJPZWtyE4cx3KA4Fu
         ZKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=VS5pNjM+dtzy9PLwNcG+/sVOQHrdlQb2MUBNj5cMGEA=;
        b=cPfRnoaHQbN47iuxNZT6aON7r7wHpwvE8ZGrRqMU9vVR0M5i+LLVckqMAMa59ucrdB
         2AyATXDR53x46uMHSUBwgXvmBf3/NQZjOXcG1oiseOYscnl75RkgducuYQwFKkVtj9sO
         kWdRwsjixkUlwim9UaC6JkYb6BJDdSikSYJJyybAM7ERoxBVhGGDvcVls37jqOMQ/TaM
         rzWfYTbK333W2Ajf4F7CKpyB6k28S5DrQxyPF7uEewpqa+3LtLQbCRGopgoTG7+uwXko
         3wKrBxMS5KMZyoyEsG6pTsKQx9nrhVuUqgbGPjC926xAIjk8cknmImbxqoim/R802xoa
         fXvA==
X-Gm-Message-State: AOAM532SmMv6ztgZIyY8sktpDlHMUbi7cmbeqrziC7IB3JwwEuI+JPmp
        HvS99tmeTrKbT9ZncuOl11Sqz+hsgWP1z0t33XY=
X-Google-Smtp-Source: ABdhPJy/meNtoYOUPKz9BUcF16sSE3qd2dqq/fgu+Oc0yorZAv3rdn3sVURQIOahZaB0S2Pgi/LhC7D6I+UmcnvqSD8=
X-Received: by 2002:a05:600c:4fcc:: with SMTP id o12mr3991006wmq.184.1641408802664;
 Wed, 05 Jan 2022 10:53:22 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a5d:4b90:0:0:0:0:0 with HTTP; Wed, 5 Jan 2022 10:53:22 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <sylviajones.usa1@gmail.com>
Date:   Wed, 5 Jan 2022 10:53:22 -0800
Message-ID: <CAA0-3mjb4UUBMs6ydYE60QoX_XDH5OGpuR4hzrtPz8EdsskdWw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

Happy new year to you. Please  did you receive my message i send to you?
