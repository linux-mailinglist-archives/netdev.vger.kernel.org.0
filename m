Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547701249A5
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727175AbfLRO2q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:28:46 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:23811 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727025AbfLRO2q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:28:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576679324;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=83iQi1KwLYolNhNtqdfDS/+rnUb3Q+ogYHiy8LuXrSE=;
        b=Z5Wwf2XgsC9WnuyyFu4pvpTnhvzQfSXjQ3nlmnRVM7xDyDr8mwSlGQyLCyw1EDfi4G90Qx
        4Fo7hSoDp/cW0Nrf1URhhDihJWu7s7cb4Muib5Y8Tt44mWb4m8OKLVbbk4/7WsN2HE9Y1h
        /fd4/G3xSlRAwnHVbQK2OtXvsrJ3ipI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-196-MIvxXp7LP7mnDnyIdyTNSg-1; Wed, 18 Dec 2019 09:28:40 -0500
X-MC-Unique: MIvxXp7LP7mnDnyIdyTNSg-1
Received: by mail-lf1-f69.google.com with SMTP id t74so234062lff.8
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:28:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=83iQi1KwLYolNhNtqdfDS/+rnUb3Q+ogYHiy8LuXrSE=;
        b=aKJRwSszyA64yXdIm247if1ViTSG+17EDcsjCyWbO3RITvi321ES5zdbcvQNzo/nfV
         AphNqZC3Rcm4nUFZhQq3KExaec4qGhd3m8KIXhDe7jwNYLktZ6eN5c6RHBTJn6OowYSo
         b6tYncFm6zm4UBNg9fQBXEXLD5gZcSMM04nMHatVa/YlwZbwupqCoKGFZ3PPyHiOgU1p
         zCHE+bWGWNmzNECvj4/RjH/zu70JvB7tMRmTbJtaR7uwIffId8bmBd4AFMVz+kKfYtTa
         l7UlvXLuPeh3l45qEBoOrHkv1mSuIc9oa3q6R9goYfmSyegQsVfyDc3vQk+VVD093HgD
         u01w==
X-Gm-Message-State: APjAAAUjEEqdu9+BXo9zm9FXmJ2BZ7E4eh5WvBrnzuBOHmp+980SzaMt
        knWC7QkDvl8ivJex+wpqmAPsnGdCQCUtG988oJh/SogGRNsrgOfxy37Rl8iYC7Z2xCSGAoD+4ED
        kJhNLABbw+HOM5sbJ
X-Received: by 2002:a2e:978c:: with SMTP id y12mr1745131lji.167.1576679315733;
        Wed, 18 Dec 2019 06:28:35 -0800 (PST)
X-Google-Smtp-Source: APXvYqwtsMyubCkkShNFzdvEMyUxI32zqWYDI7NNLUmY0WEK17Y5yHLtizOqYJvDy+yWgmcPSv1ToA==
X-Received: by 2002:a2e:978c:: with SMTP id y12mr1745116lji.167.1576679315600;
        Wed, 18 Dec 2019 06:28:35 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id a21sm1243254lfg.44.2019.12.18.06.28.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:28:34 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 2ED67180969; Wed, 18 Dec 2019 15:28:33 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next v1] sch_cake: drop unused variable tin_quantum_prio
In-Reply-To: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
References: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 15:28:33 +0100
Message-ID: <87tv5x4sj2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:

> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
> previous implementation of diffserv tins.  Since the variable isn't used
> in any calculations it can be eliminated.
>
> Drop variable and places where it was set.
>
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

