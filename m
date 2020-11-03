Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF5A2A5805
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:49:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733062AbgKCVrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733017AbgKCVrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 16:47:15 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DFEEC0613D1;
        Tue,  3 Nov 2020 13:47:15 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id s25so12653704ejy.6;
        Tue, 03 Nov 2020 13:47:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=S6CL+T+HBwhBTGbdv3kXuibM6BJcgdU3GPg2IxIyF9A=;
        b=SE/7zKsogU9eUwTHHOTXOItfRy3ydUqieWdmJtv13Z3o0Ko630AoISOOth71UzsKc2
         VO7Fj3ywRPXAOL3LB/5d4gELKwdMmPCa17f2x3nQ1hLhTszl5+UeA/c7Mo04hOv1vJQo
         CW7rnC6GLhZtQ8Ai6TUngQSwkDdbaFZNPaghGYzLbalp4R8NmhvY32lVnoZJaSAiKIk4
         W5/t4A7eGTDsV6nmQrq/JNthLQ6V0DfxpfYWhpjMMOtgxdsMmySfJt+JVAGikDJVyUmW
         qOe8HtVFw53Vs4QKjAUavGKvlP+EJ346UqpfsuPJ3McFYv9+5D98ova9Bu4tcXXZtVun
         7HuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=S6CL+T+HBwhBTGbdv3kXuibM6BJcgdU3GPg2IxIyF9A=;
        b=XqMBwwra87fHFG6xWJ0x6Oue29Q5N5lqNxgGBiPJSdtpUeIt8TionhOkk2fR/yr2Zx
         S1rk1HbcV4baXHe8ImaWxAVgq+EAnkeZ6Fk/o2WM+2JIa0XGH72N45NEaDFHBWvjevGR
         Eb3vzn5HaQt1Nz7FZtZ2+hTLW1BB0L8XQG94Dx7olF7k/XGENVRfrM5AcY+KBv9nlJ3q
         qZDzCd0AOwpS0BvTkubGd7Rp2kQZoaBtbuUFzL+FhYE6RQIKhCDyWlfWxrpxzjoZ/73C
         DFKLQptgDuucRP5nZnY4z3IwOxU2c9oOZXI45kvFKpLCdQusfuYRZUXaHFrXCjNwst16
         Nsdw==
X-Gm-Message-State: AOAM530TdoLEfbOUETH/cPw3OcCkGh//y9vfYpWZ5uVW6Kro6tDiP27c
        7Kdmwsz9+lek+cVIXi24OKM=
X-Google-Smtp-Source: ABdhPJzzwOjgj/TiQSgcFWwTsQO/P/KSxtrNK/9PSW0pP8YoD45n8lorOx44A+WeOK769s2XLUAXmQ==
X-Received: by 2002:a17:906:7e43:: with SMTP id z3mr23057767ejr.143.1604440033905;
        Tue, 03 Nov 2020 13:47:13 -0800 (PST)
Received: from skbuf ([188.25.2.177])
        by smtp.gmail.com with ESMTPSA id rl1sm11619ejb.36.2020.11.03.13.47.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 13:47:13 -0800 (PST)
Date:   Tue, 3 Nov 2020 23:47:12 +0200
From:   Vladimir Oltean <olteanv@gmail.com>
To:     Marek =?utf-8?B?QmVow7pu?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Hayes Wang <hayeswang@realtek.com>
Subject: Re: [PATCH net-next 3/5] r8152: add MCU typed read/write functions
Message-ID: <20201103214712.dzwpkj6d5val6536@skbuf>
References: <20201103192226.2455-1-kabel@kernel.org>
 <20201103192226.2455-4-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20201103192226.2455-4-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 03, 2020 at 08:22:24PM +0100, Marek Behún wrote:
> Add pla_ and usb_ prefixed versions of ocp_read_* and ocp_write_*
> functions. This saves us from always writing MCU_TYPE_PLA/MCU_TYPE_USB
> as parameter.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---

You just made it harder for everyone to follow the code through pattern
matching. Token concatenation should be banned from the C preprocessor.
