Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD0241BEFA
	for <lists+netdev@lfdr.de>; Wed, 29 Sep 2021 08:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244246AbhI2GN1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Sep 2021 02:13:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244076AbhI2GN0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Sep 2021 02:13:26 -0400
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31A0C06161C
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 23:11:45 -0700 (PDT)
Received: by mail-ot1-x32a.google.com with SMTP id 16-20020a9d0590000000b0054da8bdf2aeso1518689otd.12
        for <netdev@vger.kernel.org>; Tue, 28 Sep 2021 23:11:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=pkOE6GhYBnoMWX9bfx7qjJXbJy9nBE9vL5NjKWq1tcQ=;
        b=NqJerZwKfKjIBmOiluf3Z7MTtJFJ2k25XT+nTYPTc1kLjCOn5GZar9xtoBPaTDQAoO
         GRH8hqHO0pNc3TuKeU0M1yIAeIIG4H/0vgCsk7EA38DlSnZypBEHzz5sVckcdk3AqqXD
         2oq5iyAvkNQvBThhj3y85ThhEYcRg+ATrOMKE9BbMOnGPJriQ1dxKe5NMumCzhUqK1rk
         NHwy5RANYlsyHTbNgKRSclpcUtPXcCBumJjyPqBiHsrgzeKkNYaPEbKX37t1oi+XHaKB
         yHT9yqdzknwhlR1gjGvxw0N0mf4evfls/9HKbmStEOJ2FpOZ665b+iypoMnqqdoSjm/n
         a6ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=pkOE6GhYBnoMWX9bfx7qjJXbJy9nBE9vL5NjKWq1tcQ=;
        b=RchRAEu1qMYhnUSJsHsXLvcziuemhKPwZ55GILqwtCAJZ/w/t39Aaeh8z8l1HApLRd
         YfGa+dAr9HV3zL9jFRYkhsZzc0yfhY7mLN4ev4NYYrN1HJK805MgTaTGs/n8BNbF9LTs
         tASmoSn775BeFgDdIHsFSeCqQysS/mrD5AAqvslDk6F4CKFowTMgVybPlwJeTZdZUYvn
         51jw3+tESvVHFSaf8TUNupo6W1Lvh7KR67YmUAdaQP2Cd8t/ecqCKqv2RrWbtLKxRyYg
         lELiVMJ92OrtORe+spWgA1nL9vEeAO1PZov91Jl3QIuBMUTy70x4zjm8UjZgSjhTImwe
         xIJQ==
X-Gm-Message-State: AOAM532eGMawkIVv46wqK1MZ0+Z8dlji05htbAT3mKZIy6AWtL45gKkw
        Xsqk/Wt4xVxCZWJgA+oZ+rx05HGLNm8rDB6YxZo=
X-Google-Smtp-Source: ABdhPJwAkN7Mz9tugFlggDg5W9a1v9OnQ6QJpcWBgjFVx0wMawh9/Oi9Yy6VVNNhzTXKNVOGHsw38bu7hHBfcwUQ0go=
X-Received: by 2002:a9d:d4a:: with SMTP id 68mr8568513oti.5.1632895904589;
 Tue, 28 Sep 2021 23:11:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4a:4fc8:0:0:0:0:0 with HTTP; Tue, 28 Sep 2021 23:11:44
 -0700 (PDT)
From:   Green Rodriguez <misoho505@gmail.com>
Date:   Wed, 29 Sep 2021 07:11:44 +0100
Message-ID: <CACSD0TCX9hzLcpDLDZXRUXMdUjuiUQN1FGsMqxS8-2LOfBXNGg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Do you need a loan(finance)? Contact us now. Mr. Green Rodriguez.
