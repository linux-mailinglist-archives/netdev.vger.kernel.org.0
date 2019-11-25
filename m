Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1BF6109585
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 23:35:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725945AbfKYWfY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 17:35:24 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:42527 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfKYWfX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 17:35:23 -0500
Received: by mail-ed1-f66.google.com with SMTP id m13so14381571edv.9
        for <netdev@vger.kernel.org>; Mon, 25 Nov 2019 14:35:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gGKM8WgxdPecFqK7JEzYQACAH/Wy7XYqXKr8OU3l77Q=;
        b=ddW8WVEsukWGAbHNNBYSOW1iOCGrS6fz7cEXTv8DnvEoLFY1VoB7qREXuYS6SjkyZ8
         1QZFNjjv8YG/MMXsqZXoiwNzGKVGVWC1hxsIELwLQiZjC4F7VpCMPM5JKbEQBPWlM0qX
         kdrgm8rUFF8i9127nJ+Zv1CQhIglo/eAUAgdjSMTVlC59wzGzk8yYn9psx2GNibl5qtK
         E6lYgTsacuHak0iosTsFw9uqYc0CXEuCL43K+9Qr9LQsiLKeJgq70i4glT6537LxD5PU
         3gqLA9lX2HLcomIPzrByi+9289bW7itFd1lWe+uhMiyn+D1rPYhNXlMW3JIBIVCdgiZo
         B7cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gGKM8WgxdPecFqK7JEzYQACAH/Wy7XYqXKr8OU3l77Q=;
        b=qHm0lenTTX9WdJuDOIsrsPWBb/NELO5phUlvnEIzAGgvoZxlca9btlpaIkCTQoh7Ah
         hSGf/OooDCjReS2lUmYCGxhYPAHenyJ/puGSgrQljX9QCWoulYqcQKJilBVZld9kwFSi
         pprGqnLja5mHQ57D4Z9vh1eB55ZSuK3i0IZ0Wm1X8TXYs3n2ofxmOl1NCF3a8dr7hcxJ
         hGRaixb/xIbkg48kOxWIwcoiIbIfO9UloeulyADxwjwsHDkaLu6jz38zHSBkyB5W0Q/e
         Lds8ksyEWLBqVZxpSpkDrQmp/Lmu/ZgSeiJR666OPPiqmfgi+K1ozMwvnd/fS3tIR13j
         qqwA==
X-Gm-Message-State: APjAAAURXhJQLiyqO+an3Az1/7uRbVRVQYQclQEFvp8vABB80Y3p918o
        hxSdegfwNkeTdm7g1InuDXUZIGMQP+S7n1FTGnGEpCpx
X-Google-Smtp-Source: APXvYqyhlC1iOx36/esGpSo9g3MJRzq54KNjUjKw7nzHx4QBZHP08WGk/FLhPVQiwjjzG8LRmmms0mBIP1LbcJWz80w=
X-Received: by 2002:a17:906:f10:: with SMTP id z16mr40497764eji.211.1574721322103;
 Mon, 25 Nov 2019 14:35:22 -0800 (PST)
MIME-Version: 1.0
References: <20191122221204.160964-1-zenczykowski@gmail.com>
 <20191123181749.0125e5e5@cakuba.netronome.com> <CANP3RGcWkz+oR3qW4FAsijPSMrAGtUpcdfSbXvpcR9rT-=qQpA@mail.gmail.com>
 <20191124160955.3cf26f53@cakuba.netronome.com>
In-Reply-To: <20191124160955.3cf26f53@cakuba.netronome.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 25 Nov 2019 14:35:11 -0800
Message-ID: <CAHo-OozSDsE843nAgwmLsN7M6otXGpUT5Y5LRkYUqLOvZ+7rHw@mail.gmail.com>
Subject: Re: [PATCH] net: Fix a documentation bug wrt. ip_unprivileged_port_start
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I'm not entirely certain what would be better.
It does seem sensible to me... but perhaps, it would be better if
'may' was 'must' and 'it' was 'they',
since it's referring to the 'privileged ports' which is plural.
