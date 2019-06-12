Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E372B42D42
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 19:16:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392145AbfFLRP4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 13:15:56 -0400
Received: from mail-yw1-f65.google.com ([209.85.161.65]:36797 "EHLO
        mail-yw1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726696AbfFLRPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 13:15:55 -0400
Received: by mail-yw1-f65.google.com with SMTP id t126so7117633ywf.3
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Vsnm8qzm4rbFX0yVEWnxn2y7bxIoF5GVXEpaPLgkskk=;
        b=A5AbOaGgb9j5AajMxTZCKjxNvABA4xWsYubGnIEznUXJVoRpXIlc9qMnOdIn2/BQ0v
         pwjP1BvKhnSvjxn1fC06yVjISnAzvvtzZFnjjonFee6gGWW9HtJoIUOSOxtQQnVXNWkU
         kOQFTgWYJwztrXPPNOpoH1CTFjqeIbilAgdOcK/snZ6WvvzvTPyaPkLtD42UR5AMz0h3
         xAw07UAioBb4GzKsnk75xtJNj4q4r4i2T7hJaE0rEpSbXvypgx8zQgn2kvMr2cywjtPy
         oZynD5bqiEfWIHorvudieDVK69C4NjzMyLPXfjcuCJDWSgIFN7kc51/9s71g471c4hE5
         HXzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Vsnm8qzm4rbFX0yVEWnxn2y7bxIoF5GVXEpaPLgkskk=;
        b=and9yxSPKMeb0R9gPO85nyTuckS/ICL7GBvtcrbsOFEChiz2C8Ju2VtDopuCFs0ezp
         KCzk4nVIONFyL0SIYvIqnta3ariDki9NUUdaHpG3ZK+z01iLkVkvlbOLOqE3AF6KKWew
         GXMvUIjqVSWvidhlgBFQmP2Zzo7W6svMKiXMQIWic5hB3Duu7ifD1uP82bvt3pnWiu43
         L2yfCAXLWqEioiYg54lD3OiU9zTkUOIQOgl+WpD6JbJJqYuJfcv9TXGfVfL6RMn9K8Lu
         6JI3iFi+YAx7/MhthSct7ordx1wUb9ON3ngQbBbAPkEXAjTZVySbro7iTkRqzn/Uvzu3
         Dhtg==
X-Gm-Message-State: APjAAAUDQhYMTmxPMNB9SCxtaE2J9UarM0/H/IsQjM79tgGg8f4hf0Cb
        VY+pO/B3COu6uniGuTX8r9cUlWwm
X-Google-Smtp-Source: APXvYqyo/q6RodPNZbZblNd0y0GV4P5aStWAlCfyB8hfmRV9SYF2hDRRLazzers13/1rpjyJ3Rv/TQ==
X-Received: by 2002:a81:5944:: with SMTP id n65mr24465895ywb.182.1560359754235;
        Wed, 12 Jun 2019 10:15:54 -0700 (PDT)
Received: from mail-yw1-f45.google.com (mail-yw1-f45.google.com. [209.85.161.45])
        by smtp.gmail.com with ESMTPSA id e77sm116901ywe.23.2019.06.12.10.15.53
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Wed, 12 Jun 2019 10:15:53 -0700 (PDT)
Received: by mail-yw1-f45.google.com with SMTP id v188so7099312ywb.13
        for <netdev@vger.kernel.org>; Wed, 12 Jun 2019 10:15:53 -0700 (PDT)
X-Received: by 2002:a0d:c0c4:: with SMTP id b187mr21512192ywd.389.1560359752726;
 Wed, 12 Jun 2019 10:15:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190612165233.109749-1-edumazet@google.com>
In-Reply-To: <20190612165233.109749-1-edumazet@google.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 12 Jun 2019 13:15:16 -0400
X-Gmail-Original-Message-ID: <CA+FuTScKx9wagxn-ano=Zj+KTzDpGsSQi6Uwv1CHr7AMg_+eCQ@mail.gmail.com>
Message-ID: <CA+FuTScKx9wagxn-ano=Zj+KTzDpGsSQi6Uwv1CHr7AMg_+eCQ@mail.gmail.com>
Subject: Re: [PATCH net-next 0/8] net/packet: better behavior under DDOS
To:     Eric Dumazet <edumazet@google.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Mahesh Bandewar <maheshb@google.com>,
        netdev <netdev@vger.kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 12, 2019 at 12:52 PM Eric Dumazet <edumazet@google.com> wrote:
>
> Using tcpdump (or other af_packet user) on a busy host can lead to
> catastrophic consequences, because suddenly, potentially all cpus
> are spinning on a contended spinlock.
>
> Both packet_rcv() and tpacket_rcv() grab the spinlock
> to eventually find there is no room for an additional packet.
>
> This patch series align packet_rcv() and tpacket_rcv() to both
> check if the queue is full before grabbing the spinlock.
>
> If the queue is full, they both increment a new atomic counter
> placed on a separate cache line to let readers drain the queue faster.
>
> There is still false sharing on this new atomic counter,
> we might in the future make it per cpu if there is interest.
>
> Eric Dumazet (8):
>   net/packet: constify __packet_get_status() argument
>   net/packet: constify packet_lookup_frame() and __tpacket_has_room()
>   net/packet: constify prb_lookup_block() and __tpacket_v3_has_room()
>   net/packet: constify __packet_rcv_has_room()
>   net/packet: make tp_drops atomic
>   net/packet: implement shortcut in tpacket_rcv()
>   net/packet: remove locking from packet_rcv_has_room()
>   net/packet: introduce packet_rcv_try_clear_pressure() helper
>
>  net/packet/af_packet.c | 96 ++++++++++++++++++++++++-----------

For the series:

Acked-by: Willem de Bruijn <willemb@google.com>

Thanks Eric
