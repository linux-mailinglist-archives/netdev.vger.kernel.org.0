Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D32F81249B4
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbfLRObP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:31:15 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:57901 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727053AbfLRObO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 09:31:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576679473;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XPZ5STmd82dYjlTU9aBDA8S9wmhHM+cLVCjYGpyXvSA=;
        b=jCfrJWQ/4906X38Nx7Y+lOIUojCPjzPU0d4/OuX5ji8AheHrqm7a6zLVkVmw/wWlXaHGQ6
        NdGk8Nb9lnWkF6DwEaktKtMSLNyUoUEg9LzQaCUlpso6Wpe8NCkUXnDDPETVOL1d0UGw6a
        dIRqWfnm0x/iRgaDbGaA4fA8EGVUM6E=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-191-27NmS2CFNLS8GjZ4-Fp9tQ-1; Wed, 18 Dec 2019 09:31:12 -0500
X-MC-Unique: 27NmS2CFNLS8GjZ4-Fp9tQ-1
Received: by mail-lj1-f197.google.com with SMTP id y24so767055ljc.19
        for <netdev@vger.kernel.org>; Wed, 18 Dec 2019 06:31:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=XPZ5STmd82dYjlTU9aBDA8S9wmhHM+cLVCjYGpyXvSA=;
        b=lWLVfZ/mX0hGDlZv2qy/5bsjtlS2KdpxTrsG8W1ZymQXbob5UWEwx9GBiub4ieMTTp
         9GPATJG35b9VGKANhbStwzNayIIxaVMLw0CwxBj8sdH6+0/e97JiG+z2p4tA7xormNy7
         H8Iq/KpoEVntvRuGDuJ5gA94OMxBeEtMskk3ahF3wqaQeOhZeSLxixy+xHBEiaHpNvIF
         otexyaQGBepF73hJ4qbnc925Cg3I/tVk1+Qi1oeClaFBVfs4r5gCVsHCbUWvVJJ88HMw
         ba1qLIruo29WKWEaoNKR2lP20coJJYMKOwm7bvb4yeXIaKf8A/OoCpWQuOoZ2qpPPIP2
         QevA==
X-Gm-Message-State: APjAAAUiERCauohBuefULYnFP2xlU9UfI13uE3beCcQZaynoKg3Hoig8
        yUhK6SmeRSZUWJFH7x6xS+3JcXftZjE5C4Lya4nDPIFwAyD6camMTNsTfaNwmdVYtbuMafNZG0b
        xQV7TWIXfEmhlFZYC
X-Received: by 2002:a2e:8016:: with SMTP id j22mr2100645ljg.24.1576679470674;
        Wed, 18 Dec 2019 06:31:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqy46J2+tUxZIy8aeDOt3xDai2xBCBqtJ/9cfAWdtzQPQou7oEmhZZ9Sl+iu4eXWPSNCrMioOA==
X-Received: by 2002:a2e:8016:: with SMTP id j22mr2100632ljg.24.1576679470543;
        Wed, 18 Dec 2019 06:31:10 -0800 (PST)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id s2sm1242617lji.33.2019.12.18.06.31.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 06:31:09 -0800 (PST)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 3C459180969; Wed, 18 Dec 2019 15:31:09 +0100 (CET)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>,
        "netdev\@vger.kernel.org" <netdev@vger.kernel.org>
Cc:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [PATCH net-next v1] sch_cake: drop unused variable tin_quantum_prio
In-Reply-To: <87tv5x4sj2.fsf@toke.dk>
References: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk> <87tv5x4sj2.fsf@toke.dk>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 18 Dec 2019 15:31:09 +0100
Message-ID: <87o8w54seq.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com> writes:

> Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> writes:
>
>> Turns out tin_quantum_prio isn't used anymore and is a leftover from a
>> previous implementation of diffserv tins.  Since the variable isn't used
>> in any calculations it can be eliminated.
>>
>> Drop variable and places where it was set.
>>
>> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
>
> Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

And that last ACK was supposed to be for the v2... sorry for the noise :/

-Toke

