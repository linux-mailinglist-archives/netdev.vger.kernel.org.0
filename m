Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDCCC1A282C
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 19:59:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbgDHR74 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 13:59:56 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28906 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726780AbgDHR7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 13:59:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586368794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=QhR8/4nwZR3vI75Ff0gRFEnCsK4KP4VWpldugKNK1tM=;
        b=SQ69xQ2HssKiVkcrezx7BGQn+ccVBZn8gyv4UZVU5vSxazMcgN3Et1fnX4eRAtLO9adWWd
        0nrBbvc9qUOiOOEK06BpznTy3xHXxsVeDI50269gLDla3S8tlwkADPsZN4Ko8ghPLvvr1A
        Z7a4U5TkB3tNblBIvjBUll0RC0Gyifw=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-142-AasDFkSROoaOESI37MPeTg-1; Wed, 08 Apr 2020 13:59:50 -0400
X-MC-Unique: AasDFkSROoaOESI37MPeTg-1
Received: by mail-lf1-f71.google.com with SMTP id u13so1662212lfo.10
        for <netdev@vger.kernel.org>; Wed, 08 Apr 2020 10:59:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version;
        bh=QhR8/4nwZR3vI75Ff0gRFEnCsK4KP4VWpldugKNK1tM=;
        b=YTzDmfpQWmOcSA917gHNmjWB1jT3uoXf3MKMeTVKT79pFI+PV7G8D7gYZOw+jiaJEQ
         sCrfyrropO/1eweXZx9F5Ajsjgns4tswXCzqs3asX1a17Owza64MvzkApqywJGxWc7GH
         7ySDkiHuC7w+ZLJqXL3NnNe5rKYXzxn5YIK3Nm9ylCvIXIIUbDG2AyeryWiANkeQYgi0
         4gx61toKImZ/ALG4F6QBuWKiJngC+IbsdZNTobZ/i2K1uefiyFX39MiezVgbLyu/8ZSq
         4y/TavP/rXbi5fR3KSwDKPLNTCFBWn3q/BzF7bqGmQ6kVbfGW+EIsoTcLgKLHVdHA53a
         VlhQ==
X-Gm-Message-State: AGi0PuanFQSTuZmvC+QA/BRSiri7B/CnOwwnL9bfNyVnUdiUUGo9g16L
        +7cFjjLZ/LGgEOp9uD91gJooJ+lMqhZqRQtliyI18qExw26/1K6Iw15VfA/QOYS6KyQIb9KNUIK
        TnZuv9y/uCrWd+J9M
X-Received: by 2002:a2e:9588:: with SMTP id w8mr5482277ljh.262.1586368789139;
        Wed, 08 Apr 2020 10:59:49 -0700 (PDT)
X-Google-Smtp-Source: APiQypKf2YsDNtmqeI+9AaCI5zrRLD+5i5vVW6uP6R3VGlXLttLLJtzSjuAu7eO2NfN5NRTn1MfsXQ==
X-Received: by 2002:a2e:9588:: with SMTP id w8mr5482267ljh.262.1586368788957;
        Wed, 08 Apr 2020 10:59:48 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([45.145.92.2])
        by smtp.gmail.com with ESMTPSA id o17sm2860424lff.70.2020.04.08.10.59.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2020 10:59:48 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 753041804E7; Wed,  8 Apr 2020 19:59:47 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Introducing xdp-project.net - an HTML-rendered version of the xdp-project planning docs
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Wed, 08 Apr 2020 19:59:47 +0200
Message-ID: <878sj57t9o.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi everyone

Just wanted to make you all aware of this web site:

https://xdp-project.net

This is the HTML-rendered version of our existing planning docs located
at https://github.com/xdp-project/xdp-project. Jesper and I are trying
to keep a rough list of all current and planned development work related
to XDP. It can be a bit difficult to just browse the github repository,
though, so we've been wanting to present the information a bit better
for a while.

Well, the above web site is just this - an automatically exported
version of the repository in an easier-to-consume format. Hopefully some
of you will find it useful. We will be updating it on an ongoing basis,
and now that we have a more-accessible version that will be an incentive
for us to work a bit more on the presentation side of this.

Feedback welcome, of course; either here or as issues or pull requests
on the github repository.

-Toke

