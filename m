Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD267273739
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 02:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbgIVATR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 20:19:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726468AbgIVATQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 20:19:16 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C031C061755
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:19:16 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x123so10795317pfc.7
        for <netdev@vger.kernel.org>; Mon, 21 Sep 2020 17:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZW7Jm5ljxePXID6CmmumColZYcB3k5ij1d7MuUa7e4k=;
        b=eeA/QVKhdDPli01SvuHx4gniKbCYPCMj08lXzUF212iD8Kt+gyc01Ag4yzXb9woNfJ
         sb2RCcon/zi9CyfsLID3GEhVMSq3X9iR5Gth5QaIVBO8PVpq2LQStdpmLpNOnOkCgk9Z
         /iHmiHeavRwH4ZAWXANSGardAVAmtt7RmvX13cU5kJcWddFaTu5FyyXs8Z6aH9jUrmgX
         rdh6X333JeqjIUzLRYBtdFNjzWdifQVoefAStxCGANtf1MONrim6ge9mLwxYFNxp4B0T
         9ZViAShLHgFNcdiApUFJnsibJR0xf/EPRquT7mXuMlcAssmhfonAHkhJLc0Q71FoAWoW
         ylXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZW7Jm5ljxePXID6CmmumColZYcB3k5ij1d7MuUa7e4k=;
        b=I2alZUcKqNSBY4xeDALtxp0gjiCd4Gg5PLFeRvcrAvdAR+ug64pDYVHRL9mpUXuxqX
         NTeBO/8hETCfQQrelItGIsPms51uq5i32Ncx70hWAM6JqOBaSx4i8KCupH4zJPvB6Fag
         n5ZhXWyQ8CceX/x4nf+EBJRj//OjTtbLuUhskZvaXOYV7NYuuzb1TY3CNTOsdg8stBSx
         DLMp2lcltDapMXL4pfaSpmQbitOMz2CZ9gXdQqVyjCFYY3tgiVvaMKvi9TV7cPIvGqGK
         Me3YZEEqthEuU1TeNnfA2KbommhcsCu8VHA+Kw1vCTu0HZ9owCBJLIh08vGOsrVAOvJm
         TK6Q==
X-Gm-Message-State: AOAM530UUL0fy79OzqP7y2AnITJpc0L9VA6vbA6iF0Kz5AF+IYAIzyxE
        lLALsE/k0mZYos2O09OQm0WeGJhSLbo1sg==
X-Google-Smtp-Source: ABdhPJyqU6+ry7uHF3P+Q0gS3CC1+DNqUA1WOwe7UUYgWW5lkSq9le4gZSY1o0MO/LfTGcDvN630JA==
X-Received: by 2002:a62:154b:0:b029:150:c091:7146 with SMTP id 72-20020a62154b0000b0290150c0917146mr1923568pfv.80.1600733955735;
        Mon, 21 Sep 2020 17:19:15 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u6sm484417pjy.37.2020.09.21.17.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2020 17:19:15 -0700 (PDT)
Date:   Mon, 21 Sep 2020 17:19:07 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] build: avoid make jobserver warnings
Message-ID: <20200921171907.23d18b15@hermes.lan>
In-Reply-To: <20200921232231.11543-1-jengelh@inai.de>
References: <20200921232231.11543-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 01:22:31 +0200
Jan Engelhardt <jengelh@inai.de> wrote:

> I observe:
>=20
> 	=C2=BB make -j8 CCOPTS=3D-ggdb3
> 	lib
> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> 	make[1]: Nothing to be done for 'all'.
> 	ip
> 	make[1]: warning: -j8 forced in submake: resetting jobserver mode.
> 	    CC       ipntable.o
>=20
> MFLAGS is a historic variable of some kind; removing it fixes the
> jobserver issue.

MFLAGS is a way to pass flags from original make into the sub-make.
Not sure if it is used anywhere else.
