Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DFB82AB16E
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 07:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729567AbgKIGum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 01:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727077AbgKIGul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 01:50:41 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF2CC0613CF;
        Sun,  8 Nov 2020 22:50:41 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a15so6232387otf.5;
        Sun, 08 Nov 2020 22:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=gcfZadTBOaegHTN/euC4Mguw64IfCJ4DO6dFkz94EFk=;
        b=O8JKKRMUIwjbO/uEInvKIJibI26IGLwuwz+2tzloQklk2iAadrsH9eLHHvKZxvb9dN
         TsCgCo4aMpnFD1RaBtKQlwG+jlEnAWF9J6lPRXvs6R3fQCK9T8ox3tQ+nPZVjvg51a+5
         zuew/8iIUTHcTGnJQtsrWkv4UcZhfLOGLf13cMBC0avKGaTqL4aeN4ZYXDs4gd/tg56C
         z/bvId2c54xGmKAyIBL1UIXHbYWVmT8UsqBp6/cl4fE7xB/cMHrvp9+kAeaX+E/iaJLF
         73NJiSpLcr676MalXVCkrlPCKVQ0JYZ5LIKpAN4MB92eQD4MFvf4P7YFWGXF6e/WPnvS
         BqJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=gcfZadTBOaegHTN/euC4Mguw64IfCJ4DO6dFkz94EFk=;
        b=EqI2zboMJdJ/GJBJIqkXfRQdrkWSpaHZ6Go9l8Od4yAf4CMzhL2cyX4d4QGaqt0Ymt
         Ml40aqvw7/pXOr0XNZ5ckKJ3hZMVLV+UdKBwDSSX3FuH4i+yOllEA5b5X9W3XsDs3GTq
         2PUYpcBKAs1LyM6Jcsv2Bx4EZGI+/vrUPG32tG5vEHWcBJdBxGGDdj9tyDOOIXPgfOW2
         gaPQ2geMzHFXUkSaVVOd8+raHGx9mDEaB7DQRG7R+01pGUL0tb5K+V93YR3/pd2LTzZH
         ousheyjeUHfZeX4zpsQy0YlQ97qGqBQcj5jUqrljBmkNx5alJmHGngCqirGbiqzXPQja
         7CQw==
X-Gm-Message-State: AOAM531/a5/u04/izzEMiNQmUJSnXmrDNoUL/rhJtmSIl0+0Fw5ql4ul
        7gHOrhCRik5xzEtfTPqQCVY=
X-Google-Smtp-Source: ABdhPJyUwWS4O2EPAA2tI2OkyhSeY4qx00VdcjI586yz3z9/UCaRYn5k+Xk2vXdKIgVeM4SaCQYWJA==
X-Received: by 2002:a05:6830:1002:: with SMTP id a2mr9794310otp.316.1604904641200;
        Sun, 08 Nov 2020 22:50:41 -0800 (PST)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id g15sm2358644otn.12.2020.11.08.22.50.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2020 22:50:40 -0800 (PST)
Date:   Sun, 08 Nov 2020 22:50:32 -0800
From:   John Fastabend <john.fastabend@gmail.com>
To:     menglong8.dong@gmail.com, daniel@iogearbox.net
Cc:     ast@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        andrii@kernel.org, john.fastabend@gmail.cm, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Message-ID: <5fa8e6b8cd7d6_2056c208c0@john-XPS-13-9370.notmuch>
In-Reply-To: <1604654034-52821-1-git-send-email-dong.menglong@zte.com.cn>
References: <1604654034-52821-1-git-send-email-dong.menglong@zte.com.cn>
Subject: RE: [PATCH] samples/bpf: remove duplicate include
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

menglong8.dong@ wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> Obviously, 'bpf/bpf.h' in 'samples/bpf/hbm.c' is duplicated.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
> ---

Acked-by: John Fastabend <john.fastabend@gmail.com>
