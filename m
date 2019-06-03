Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3CB33A92
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 00:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726761AbfFCWAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 18:00:48 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33330 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726636AbfFCWAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 18:00:47 -0400
Received: by mail-pf1-f193.google.com with SMTP id x15so1579591pfq.0
        for <netdev@vger.kernel.org>; Mon, 03 Jun 2019 15:00:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R6du/6KKnNDmznz33lKQnArtHrJyOSHRvKP6Z3+6Gug=;
        b=CAeexWrdYYccZQVE3RvyI5Yc3+4LkwqveBPjE9fFipsReUp41O3X9lmdZT5DluuFGG
         fGwF3Mv722F4uswfNbEs7PVHReYDTWyaq7Ltmr9hQF5Y/+nMHmA2Ni+QqvBbyr0qJ+fO
         CNJt23MW8x9ofHhxmVU1qcw10UywUp+msi+kmJozy7O40RV7c+5/5gPNZ/xIPCVCsRnT
         rAVZYCcVEoLCgZX0VJ6CEYjGi/mYzxe/qEcEgaHtHEIkhFLKgLs52/frURFALdJIek91
         yn/aOxR8k3EyNmN9MvfCgzyVAE/uRRKDtDPiqg4P+S17nZMYn6GgG+RlqqClmuJrobPj
         9QEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R6du/6KKnNDmznz33lKQnArtHrJyOSHRvKP6Z3+6Gug=;
        b=cT2eBeJ/CpwptK5qAZv1gU+3rjgDf0Hz6ZzzeSK3bQHCitpG211QHz8U2F6LGu9AaC
         kzZivt5GURgxJdaARIg3DVUu0FlYazv6JIuk+V6pIIwaelSBwc0TxdW71KWeFTAQ41vP
         Oj/QdzrLX0rZqayY3z/8wwUju5xrInY66Juf1RF3VyKiuftEiNz8UQuvwZr+9SzwMq3H
         NJnzcXebw7Y462OgyESBw+yxsfWesdE7IK6JLBKEETx00q7v2fupLlEQey1+G8vW0yjI
         sSHv0dDisHgYMqrkeFyBzfnIXKQgCGztgE/NMhqlSMn8J3grJYdTn3V0ebBOB2RifE7A
         w1xg==
X-Gm-Message-State: APjAAAW28ZCuBJLhEByZGi8MxLT9lhDnyeVb3fD5JJNnBEDlLf9aLB+H
        XHg/sfuhqaGoAeBd0y3JZN52TjraZMLqVA==
X-Google-Smtp-Source: APXvYqzY0dEmdEiuuhkMibuvAxzI6GrqjGqjGE+NKVDzbGNPaLbZD+VVd8yBj2X+2xk/phzD+Jwpkg==
X-Received: by 2002:a62:7641:: with SMTP id r62mr9530270pfc.35.1559595141159;
        Mon, 03 Jun 2019 13:52:21 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x18sm18781016pfo.8.2019.06.03.13.52.20
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Jun 2019 13:52:21 -0700 (PDT)
Date:   Mon, 3 Jun 2019 13:52:19 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Cc:     netdev@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Subject: Re: [PATCH iproute2-next v1] tc: add support for action act_ctinfo
Message-ID: <20190603135219.180df8e6@hermes.lan>
In-Reply-To: <20190603204142.51674-1-ldir@darbyshire-bryant.me.uk>
References: <20190603204142.51674-1-ldir@darbyshire-bryant.me.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  3 Jun 2019 21:41:43 +0100
Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk> wrote:

> ctinfo is an action restoring data stored in conntrack marks to various
> fields.  At present it has two independent modes of operation,
> restoration of DSCP into IPv4/v6 diffserv and restoration of conntrack
> marks into packet skb marks.
>=20
> It understands a number of parameters specific to this action in
> additional to the usual action syntax.  Each operating mode is
> independent of the other so all options are optional, however not
> specifying at least one mode is a bit pointless.
>=20
> Usage: ... ctinfo [dscp mask[/statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
>=20
> DSCP mode
>=20
> dscp enables copying of a DSCP store in the conntrack mark into the
> ipv4/v6 diffserv field.  The mask is a 32bit field and specifies where
> in the conntrack mark the DSCP value is stored.  It must be 6 contiguous
> bits long, e.g. 0xfc000000 would restore the DSCP from the upper 6 bits
> of the conntrack mark.
>=20
> The DSCP copying may be optionally controlled by a statemask.  The
> statemask is a 32bit field, usually with a single bit set and must not
> overlap the dscp mask.  The DSCP restore operation will only take place
> if the corresponding bit/s in conntrack mark yield a non zero result.
>=20
> eg. dscp 0xfc000000/0x01000000 would retrieve the DSCP from the top 6
> bits, whilst using bit 25 as a flag to do so.  Bit 26 is unused in this
> example.
>=20
> CPMARK mode
>=20
> cpmark enables copying of the conntrack mark to the packet skb mark.  In
> this mode it is completely equivalent to the existing act_connmark.
> Additional functionality is provided by the optional mask parameter,
> whereby the stored conntrack mark is logically anded with the cpmark
> mask before being stored into skb mark.  This allows shared usage of the
> conntrack mark between applications.
>=20
> eg. cpmark 0x00ffffff would restore only the lower 24 bits of the
> conntrack mark, thus may be useful in the event that the upper 8 bits
> are used by the DSCP function.
>=20
> Usage: ... ctinfo [dscp mask [statemask]] [cpmark [mask]] [zone ZONE]
> 		  [CONTROL] [index <INDEX>]
> where :
> 	dscp MASK is the bitmask to restore DSCP
> 	     STATEMASK is the bitmask to determine conditional restoring
> 	cpmark MASK mask applied to restored packet mark
> 	ZONE is the conntrack zone
> 	CONTROL :=3D reclassify | pipe | drop | continue | ok |
> 		   goto chain <CHAIN_INDEX>
>=20
> Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
> Reviewed-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>

How about a man page update?
