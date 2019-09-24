Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69A72BCA8B
	for <lists+netdev@lfdr.de>; Tue, 24 Sep 2019 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731115AbfIXOrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Sep 2019 10:47:14 -0400
Received: from mail-yw1-f51.google.com ([209.85.161.51]:35656 "EHLO
        mail-yw1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfIXOrO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Sep 2019 10:47:14 -0400
Received: by mail-yw1-f51.google.com with SMTP id r134so723233ywg.2
        for <netdev@vger.kernel.org>; Tue, 24 Sep 2019 07:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gF9uqTgFSz0H2i93NOuIh4qyJMJVsAenxuGEwJQSUoc=;
        b=XwmeGGEbveyH2lFF+Bn8TPI8Z3z9pz+UcRSqomOCfabA7MhMDGY3ob22UnGvh7N5JI
         zqsGGwesqkFkn5kBbsneQnfXBj4BveotjkLL/o+qcY2Us4F47w//rY6Zb/BCyuYGsmrG
         i4HSEryNnt2n5MlK6aT838qfApOKr0mj+jC2lIZ3hFi787xq7ys7Zs72B04CyaDYn0Ov
         aexzAcG1GmQFiDfs2QjpqKBFhCFQyld+S+1vrcBkE3d09/Q+sgpCZM2uXAvs+tV+zO/8
         D038VcyQAZDQNMMEHC8J/Q3UIZ6bPBBRCQt8SIz2XFkaBCvlC1GXdQus6IV7P5QHmgHi
         w5Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gF9uqTgFSz0H2i93NOuIh4qyJMJVsAenxuGEwJQSUoc=;
        b=PBxDioNSgGqQF1Tt7W8GxQHX61K1MT7Z3cWjJsTR8Z/POpFQLU7NzF1B91SRNguDi1
         fvXgHdpm8C4Bbp954sCIHIjLPC0tB1keNPL4LaH9X0qs2ZLZJhJ4SyjvRexOxwvUsnkF
         EvQjdzjAr3/L0mfMPYFnObg3kjW7XUel/DC/aBA17AC3vbG1oqtbwRiUyPOniJZAtRrV
         YF60PQMhc5BuFrRbHT1hc5y98efMPyoAoVZB3MHglcI/6+CA+4qHr6v1jyio1k/XU/Rk
         te5WYAHYU9GtGmwuoVG1jEnBc1vDjO1VGrGJ8D5ePcvRUQlDwDyVgCu85sWv2iyiJLqa
         ofxA==
X-Gm-Message-State: APjAAAUzVC8JWs+y4+vlmWCUCVIlE+rbHomB754oVXiB4w9Vmyp8S9aE
        hXqvHWkApu/6ZQz/FGdori6bUn5/pZz9oHOtyGWVTw==
X-Google-Smtp-Source: APXvYqzyZvx6oSZI7VG83yxLn4mu2nM/pmXB8RWHUUpgIGTJQQsNleg0trRxCcuG0s0eZ0nGEVk3RRy/NB7YzN3I+0Y=
X-Received: by 2002:a81:328e:: with SMTP id y136mr2329710ywy.420.1569336432498;
 Tue, 24 Sep 2019 07:47:12 -0700 (PDT)
MIME-Version: 1.0
References: <20190919103944.129616-1-zenczykowski@gmail.com> <20190924.164016.43204807921728597.davem@davemloft.net>
In-Reply-To: <20190924.164016.43204807921728597.davem@davemloft.net>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 24 Sep 2019 16:47:00 +0200
Message-ID: <CANP3RGeZaGD5JLw4VCLXe_6qmrGRLjROJuUNwbysq_1BhNbKOg@mail.gmail.com>
Subject: Re: [PATCH] net-icmp: remove ping_group_range sysctl
To:     David Miller <davem@davemloft.net>
Cc:     Linux NetDev <netdev@vger.kernel.org>,
        Kees Cook <keescook@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Mahesh Bandewar <maheshb@google.com>,
        Lorenzo Colitti <lorenzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Removing this is going to break things, you can't just remove a sysctl
> because "oh it was a bad idea to add this, sorry."

Yeah, I know... but do you have any other suggestions?

Would you take an alternative to make the default wide opened?

The current sysctl just doesn't work.  It can even print '1 0' meaning
everyone has access.
Perhaps having it as a non-namespace aware global setting (with a
default of on) would be more palatable?
