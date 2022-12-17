Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515AB64FC2E
	for <lists+netdev@lfdr.de>; Sat, 17 Dec 2022 21:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiLQUEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Dec 2022 15:04:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiLQUEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Dec 2022 15:04:20 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B362101E4
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:04:19 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id d20so8064200edn.0
        for <netdev@vger.kernel.org>; Sat, 17 Dec 2022 12:04:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=Err5wlrIP/1VOIktu7I3VnhAuntZYD+1++f0k3CZqcSw0uoHFk5ysBmreEpJyKiFaw
         aaCcMrxXAkJiBAhOV7INwV5ZXfNEtMZKS+v8TZtyCSc3L/WSsTeON+m6q3JnK1h3tbJD
         /YlOwyeo4nOkgiyF82jduN6H7/qAdnEPY+m1tjjUUpvFxczYPfo9hupC8WzKvFOdgbva
         snxXA0/UngG87HHIrszTILYh+jBNR1/PwBeCFKNRseldSPJtVwqfMMSlOLcrdo9ekwGK
         K90eSo+hJmcMnmY6A0lx8snUccz5rp/3z3bCOhQcRVmH8L0IpiMcHpQ8D3l+yas5kRYL
         9g7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UleXfybfkB/Pp7XCNYIxvDWfUpO/oLpvjkUbrsMk7bk=;
        b=SLIvpsExEdt8cK3xiNR4h1c1B2UQiFI+/wG9qAKGQbV81Xxb470PUluOo9LGCqu++q
         aYgRzG/bjgaYrXM6FJNMyEjyy/1kC9Qn0fjG0dM9VZq0rRdVQJNDenlFVsg6+V3Kep0X
         y4HXu3BC5xCAtM63nSBER+kf+LcLInv1aXqrCpzfIBlRE01vngibXGLyBYesdoZHY+tQ
         9AtYpxWAPrJMKdrr+S1tWhMVFLxoSvbTwgV30ty+bpiyvycapSZYYgsuFLT/qhpdoaMw
         reTfDboRlilqYSSPSLIdGXkUwqsiJuF5J/IRmb+9jhLULkz+pAkcjkCO8HW7t7NiG5yJ
         H4Ug==
X-Gm-Message-State: ANoB5pkBKhJseqzvedcpmLUG8pwZO0GdHlYw0xGQjcxf+/6hp/xFO5Sv
        7GJOp7r8TRplVXj0/DfG3N95+E8sOJwBfd97ZBE=
X-Google-Smtp-Source: AA0mqf7XX4vFRUuS7sWi8N5kvjtwBft774146fxmEG2ju4PBacZHxTz0CX203VaCjifqqWrX7FEXG73fqqwyXhO33HU=
X-Received: by 2002:aa7:d9c9:0:b0:46d:d9be:1315 with SMTP id
 v9-20020aa7d9c9000000b0046dd9be1315mr3112574eds.261.1671307457579; Sat, 17
 Dec 2022 12:04:17 -0800 (PST)
MIME-Version: 1.0
Sender: adjanaflorent@gmail.com
Received: by 2002:a05:640c:d8e:b0:192:d5a1:1e1d with HTTP; Sat, 17 Dec 2022
 12:04:16 -0800 (PST)
From:   John Kumor <a45476301@gmail.com>
Date:   Sat, 17 Dec 2022 20:04:16 +0000
X-Google-Sender-Auth: AgYmET8qnxOF3kXl5XrqwUj8Siw
Message-ID: <CAKS=+rZ_hb7Wd9HT6z1j25jhOdxoLYj6CEw0tXuMs=m5mwZ8wQ@mail.gmail.com>
Subject: It's very urgent.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings!!
Did you receive my previous email?
Regards,
John Kumor,
