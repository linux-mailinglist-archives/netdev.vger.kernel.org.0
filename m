Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D42E624125
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 12:14:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbiKJLOz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 06:14:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiKJLOt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 06:14:49 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81183701A4
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:14:23 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id s18so1901472ybe.10
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 03:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=miraclelinux-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kFOQvtXjwrgfgRl1aCOZt4izhqYAkH+VFOzsIv3BoXw=;
        b=o10kENl357PFnkmHUOmGFFyyRmFjcTRkCpoTqndZ5TdOV1mqtgevzDAEx05ggbFHQO
         ZoSGjMtyWY8DLfPZ5nQo6y6E1k63bUvimfkrQqy+wFgwNlSLbLBrUFHWSZhlUo9f+xyX
         dEIqHoRrdNYOLnyHFt/JwCWtsoUalsCX06xJu7/el529Hviz/wru/MIn+ehGJ+5R25kb
         4Q9Bg4b3+Asm/pLAEYRo6KB9ezEdhYfALDQLEkBq+mV996Wa+HWAduZTaOumvonbYTIS
         BuxctFyf0bRnUvsm0n3aM4NKk/yD5RJ0ZTKRVlTiEB7GL/zeHK430uDVmAPT8XfSzAtc
         YrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kFOQvtXjwrgfgRl1aCOZt4izhqYAkH+VFOzsIv3BoXw=;
        b=nSUeqXfXNPFy2VSYyj5qpe68w1WI5STta4XGMZgs3ETJgFT+pAGFDsy4Rh2hYoS73M
         QmereN732FIzVGjMnkohNk2B99teLv1iKeENOvDam7I93riGcLmAjsskBNT96yLPMag0
         aGHMGZF1apUE5nDOpT/kWdwcNB4h2yMfhQNK9G6iuhZcgAFa71YqdetojiUr2xdDRgGw
         dkeuqCF7XvS05wj10PHBiWD1C3TxAtHlYgBWD7c32eV/CurkMLo4BPH8nsoqpFA+JBNv
         fqnJSZlpNC+xjYhdTUmATK6GUGrdlBytDWqLv1LcixMMISV9IOXbOOKPeOy53387nLDR
         Ho1w==
X-Gm-Message-State: ACrzQf1p4LiJc/AZuyhgOLXe6ywNJAcDZdmm39Bo+C9F9tNls42vMek8
        +Mdsr73Ttnc+cp3G0iA0rb7JzYKOXwPY2F0ysAw6Ww==
X-Google-Smtp-Source: AMsMyM75FJ0LxqM2JtZzGnrtHib/WcbczZLsStoEx/gAO6T4XoD9r0BZ+p1uN+8Mi8SnUL5VaZGLI3gkWHVpfgY37PU=
X-Received: by 2002:a05:6902:110d:b0:670:b10b:d16e with SMTP id
 o13-20020a056902110d00b00670b10bd16emr64699219ybu.259.1668078862561; Thu, 10
 Nov 2022 03:14:22 -0800 (PST)
MIME-Version: 1.0
References: <Y2OmQDjtHmQCHE7x@pevik> <d47c3f41-2977-3ffb-5c99-953088727a4b@gmail.com>
 <Y2wjS/xkCtRrKXhs@pevik>
In-Reply-To: <Y2wjS/xkCtRrKXhs@pevik>
From:   Hideaki Yoshifuji <hideaki.yoshifuji@miraclelinux.com>
Date:   Thu, 10 Nov 2022 20:13:46 +0900
Message-ID: <CAPA1RqATWqQsVjrXMOCFgbYHXvfWdbdgBhQ8Tfz4fqNs8rxVCA@mail.gmail.com>
Subject: Re: ping (iputils) review (call for help)
To:     Petr Vorel <pvorel@suse.cz>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Xin Long <lucien.xin@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Sami Kerola <kerolasa@iki.fi>,
        "Hideaki Yoshifuji (yoshfuji)" <hideaki.yoshifuji@miraclelinux.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

2022=E5=B9=B411=E6=9C=8810=E6=97=A5(=E6=9C=A8) 7:01 Petr Vorel <pvorel@suse=
.cz>:
>
> Hi David,
>
> first, thanks a lot for having a look!

> > > BTW I wonder if it make sense to list Hideaki YOSHIFUJI as NETWORKING
> > > IPv4/IPv6 maintainer. If I'm not mistaken, it has been a decade since=
 he was active.
>
> > > * ping: Call connect() before sending/receiving
> > > https://github.com/iputils/iputils/pull/391
> > > =3D> I did not even knew it's possible to connect to ping socket, but=
 looks like
> > > it works on both raw socket and on ICMP datagram socket.
>
> > no strong opinion on this one. A command line option to use connect
> > might be better than always doing the connect.
> I was thinking about it, as it'd be safer in case of some regression.
> If there is no other opinion I'll probably go this way, although I genera=
lly
> prefer not adding more command line options.

+1: Because ping utility is a basic (or fundamental) tool for
debugging networks,
I do prefer having an option like this to help low-level debugging.

--yoshfuji
