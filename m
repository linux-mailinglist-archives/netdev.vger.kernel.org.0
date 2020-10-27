Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4F0629A37B
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505293AbgJ0D4c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:56:32 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:32949 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503837AbgJ0D4b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 23:56:31 -0400
Received: by mail-pg1-f194.google.com with SMTP id r186so17346pgr.0;
        Mon, 26 Oct 2020 20:56:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=928Y6cCd6X7WfnBYvopP1Oa2ebBib5VLieFKDVDEi2w=;
        b=X6v+3QJK/VS5UqSInpaGMsjoTfULx1WBJnoglunD0dwztyk+j76zyuuliPcfXojQqL
         nGa8gkbaGIQM/MCJ67Y7uDBmaCVNfbpMfKmjb/1luBo5LEhBx0hz9XImMryKJHWPpsSv
         BL4sUI+ZKpoveeXqMi0gW+uB/mPrEFjK9F4itvkRgULsEyPxPrLBMv/zzc42zLD7uLpp
         zzg+Wy68Ns0ajIo/F5a8A84+bOkh7izxulhhk5iLBY//3xIn7xIQh8eICphbv7MStFhi
         AwLrAQ2sM3bpWh6yXdr9WKluQzGZ9cG1olSAp+8Kahj/OSShOL8nkcoC6g1oxCsX6Bvv
         4NMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=928Y6cCd6X7WfnBYvopP1Oa2ebBib5VLieFKDVDEi2w=;
        b=Z73emwARnXuv9KRmzrBlmuwjKssMMwr4eVg0eGaD7jthPWAhFIkiSh8246Lb8i/Kdd
         g+uONHpKosNIgh1ZSsuOAvqTPgwl5zPQJz8eq5zUAuxGnOW33oBdcqu9MMrU/QqAswx0
         Pg7zZwzYa7igo2CW9QpeNeMeW8wMShYn3tNbzAwXxCEkH5CcAnpj7FWTWuJP26dmA9Tl
         I8u+L/S3/iC9m157AfcUR+0pf/iLBjXp4s5BUiTrqAVRKoUwtwWDTDr0Dy3oeAWNasDR
         L4KROgJZhzjmlOdo7ZCyI5ug3WvtucttuSjrmHYVh84Fke8yKJ/ZDWiDgw9sblrZH3mi
         eOOQ==
X-Gm-Message-State: AOAM533vdWZQTK09ZxB+urWpFbPcZ+E3aFYI2dpQbmjSI7toaDAHEYNk
        tEK3zrzFUjrH9BTvFt76kfNj3WvS5fI=
X-Google-Smtp-Source: ABdhPJxHBlE1wiWdIs0h7c8vreie4hIKCN0s6QZmaABbCv180f9n6Nc4xRdKkSigvrkO1FjPirDjow==
X-Received: by 2002:a05:6a00:13a4:b029:163:f435:28b5 with SMTP id t36-20020a056a0013a4b0290163f43528b5mr299215pfg.45.1603770990931;
        Mon, 26 Oct 2020 20:56:30 -0700 (PDT)
Received: from shane-XPS-13-9380.hsd1.ca.comcast.net ([2601:646:8800:1c00:ac90:26e5:f63a:9f81])
        by smtp.gmail.com with ESMTPSA id e5sm274355pfl.216.2020.10.26.20.56.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 20:56:30 -0700 (PDT)
From:   Xie He <xie.he.0141@gmail.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Xie He <xie.he.0141@gmail.com>, Chas Williams <3chas3@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Subject: Re: [PATCH net-next 01/11] atm: horizon: shut up clang null pointer arithmetic warning
Date:   Mon, 26 Oct 2020 20:55:58 -0700
Message-Id: <20201027035558.16864-1-xie.he.0141@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201026213040.3889546-1-arnd@kernel.org>
References: <20201026213040.3889546-1-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -  for (mem = (HDW *) memmap; mem < (HDW *) (memmap + 1); ++mem)
> +  for (mem = (HDW *) memmap; mem < (HDW *) ((uintptr_t)memmap + 1); ++mem)

Note that these two lines are semantically different. In the first line,
"+ 1" moves the pointer by (sizeof memmap) bytes. However in the second
line, "+ 1" moves the pointer by only 1 byte.

This driver is old, but let's still keep its code correct!
