Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E787108170
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 03:18:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbfKXCR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 21:17:56 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:41121 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXCRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 21:17:55 -0500
Received: by mail-pg1-f195.google.com with SMTP id 207so5313139pge.8
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 18:17:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Ese2cxtf8gOf46gE0gkiWtejh4dLp+uFMMfvmA2fghk=;
        b=AOzv2ZonH1ErdNad6HBFiDS/mqwTu31KW8OFVAwxWxIDh3dVtlRE0fRY8oWzWMTdSa
         1VXrCFvzXrCLKtHKCnEh4EYCcwKDokOn7SQw67QvWU+dwfb+J7H5AdMZkpmwEZH0MznP
         88pzizFn7OLAunaGVE40VjdgcOesDriIL2dUg7u6IMHEHIcmYWS1NnmjLetYDNOJFSCG
         Wu1B6MceCrtpnovnFUV9AzuQsqmc/WERarBx3Dj9AoxD4vby0IyfVszwSkUnmb1/ZG3s
         twz6uvX4IR2iB5OIZID5Q7KAgVDXz8EpwnVhXgYibznN4rXRQi1A0U5Qdc2Lfm4s9wgy
         hYnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Ese2cxtf8gOf46gE0gkiWtejh4dLp+uFMMfvmA2fghk=;
        b=j1VSvru1tVjIlNtBWbqRCVDIP2DMIfH7gbhS1b3/faHR4v7zkg1lxjiJHCvYygD85s
         3sshrX1I/8VttpMQKX8liKN3wh/Xh09eeUbYqM6HcRWgAtfvosaws9wKHHViE7RjvQeM
         tfWIBCQ6cG+pWIg/VkEf0cVIJIbVaXMk2nFufEnWXV0NuQTKTS9sIu4wmhoAeogjeY1a
         P6rgG34Wu4g4T8KnVg3SumCvzqpWsFY1H3Z1CX6lMHdh9dCdvbPJdOorndetjC4Tm/YC
         O+rRbTtyS0hw7SX/wXnTgtjN43bpWe0Q6Y0YA1vncJ8zYUjqm3uZkKhulxjEi+yolDB1
         Hj4Q==
X-Gm-Message-State: APjAAAWtMf7v0VUybyBsOs3XMnOPjw+VxD2+LOATUZOHI7zKOSPLgDDX
        Vbd6s2WliYsm7tprV6hcV/ae0A==
X-Google-Smtp-Source: APXvYqzp/cdERuuReWVKNbF4o927AHDQGiKuhttfYW5LxyMkljCSbVaRD2oCi6q8xmNPin6Km1UcoA==
X-Received: by 2002:aa7:8517:: with SMTP id v23mr26544994pfn.75.1574561875148;
        Sat, 23 Nov 2019 18:17:55 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id p3sm2936615pfb.163.2019.11.23.18.17.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Nov 2019 18:17:55 -0800 (PST)
Date:   Sat, 23 Nov 2019 18:17:49 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <zenczykowski@gmail.com>
Cc:     Maciej =?UTF-8?B?xbtlbmN6eWtvd3NraQ==?= <maze@google.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <edumazet@google.com>
Subject: Re: [PATCH] net: Fix a documentation bug wrt.
 ip_unprivileged_port_start
Message-ID: <20191123181749.0125e5e5@cakuba.netronome.com>
In-Reply-To: <20191122221204.160964-1-zenczykowski@gmail.com>
References: <20191122221204.160964-1-zenczykowski@gmail.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Nov 2019 14:12:04 -0800, Maciej =C5=BBenczykowski wrote:
> From: Maciej =C5=BBenczykowski <maze@google.com>
>=20
> It cannot overlap with the local port range - ie. with autobind selectable
> ports - and not with reserved ports.
>=20
> Indeed 'ip_local_reserved_ports' isn't even a range, it's a (by default
> empty) set.
>=20
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>

Since this is a documentation _bug_ :) we probably need a Fixes tag.
The mistake is almost 3 years old, could be worth giving the backport
bots^W folks a chance to pick it up.

Is this all the way from 4548b683b781 ("Introduce a sysctl that
modifies the value of PROT_SOCK.") ?
