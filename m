Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91D17391A72
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234885AbhEZOj4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:39:56 -0400
Received: from mail.zx2c4.com ([104.131.123.232]:43990 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234861AbhEZOjz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 10:39:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1622039900;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dc/ISuW9DrrnENOqNI9hosf5xagWq2gMghJkO5v1p1A=;
        b=GkYUC6af3XANUrBr+jgyIItirgVB9ReWL+l2S6hUMs1hI1I7zwjh3bqd32zwm7AOVp+EpT
        lD6u2bY1xzzzp9H2gzxZEnSwRrFsIAquGnxlotN64lt6EgWTsR2Ju622zbEiplK0+l7qbD
        XIQgYSDHQHf6J9EyO4kUX+9cSWzp03I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id df424dc0 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO)
        for <netdev@vger.kernel.org>;
        Wed, 26 May 2021 14:38:20 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id r7so2328343ybs.10
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:38:20 -0700 (PDT)
X-Gm-Message-State: AOAM530e/1QASEJhlm3NCLwEqEuinihPZxWsFEaM2uBojQGFA+4yE2O4
        qJr/dkx0YY4f1BQB+0FX+YY+WYfCdohTeTfRpvc=
X-Google-Smtp-Source: ABdhPJxSUz7P8S6nQ0BDKEPw4jnSx94LeL65ze1+2oARvjZEh6YoUGZGQtgWA4RqTcyGB6P3UamueQ7B9kmFDG/DPe0=
X-Received: by 2002:a5b:5c6:: with SMTP id w6mr49884956ybp.279.1622039899854;
 Wed, 26 May 2021 07:38:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210525121507.6602-1-liuhangbin@gmail.com> <CAHmME9qHbTWB=V3Yw6FNLa1ZgP2gxb29Pt=Nw3=+QADDXArQuA@mail.gmail.com>
 <CAPwn2JTkdXRkT=azv+hPSUvcb-Gq51T11Z2MBFBsNCRG_8=Gsg@mail.gmail.com>
In-Reply-To: <CAPwn2JTkdXRkT=azv+hPSUvcb-Gq51T11Z2MBFBsNCRG_8=Gsg@mail.gmail.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 26 May 2021 16:38:09 +0200
X-Gmail-Original-Message-ID: <CAHmME9q+_9TBv0kS4_B9WihtadT+6uDZ8Pn1yJBgrvj8c-nzzg@mail.gmail.com>
Message-ID: <CAHmME9q+_9TBv0kS4_B9WihtadT+6uDZ8Pn1yJBgrvj8c-nzzg@mail.gmail.com>
Subject: Re: [PATCH net] selftests/wireguard: make sure rp_filter disabled on vethc
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Hangbin,

fc00::1 lives inside of fc00::9/96.

Thanks,
Jason
