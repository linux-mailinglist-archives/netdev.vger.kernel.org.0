Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11B941689D2
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729055AbgBUWLY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 17:11:24 -0500
Received: from mail-ed1-f45.google.com ([209.85.208.45]:43350 "EHLO
        mail-ed1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726725AbgBUWLY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Feb 2020 17:11:24 -0500
Received: by mail-ed1-f45.google.com with SMTP id dc19so4184694edb.10;
        Fri, 21 Feb 2020 14:11:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6cdf8MxCPSbwySV/dQd+Gx1+0hE9oO2fF0yfSMCUfW8=;
        b=np1qz/bSoS5HGnqI9USyTzsxjCZx8HlX9Vs6HFuzhgacMY87xRlaM4EUbwlwY3ctF2
         QNXE38jfLRXVsMQZYg3+ENyX1OOZLPvUyELeB8i4Un/fk5slVf1mV1a1efc3JTjV2fVk
         Kn2bHk0UAF5QRCzqG06wxeqikLPlnWAK79y9ap+alx5JXNyTViN55aBPnBnGm9Zwzyuy
         EEM5rUbWfEN+NUEOv39hheJx534FCJpbRx9iMnoAQP7f+1hOYXNZh6AGqfN/u9UcTAfg
         /icfKrU87gZTIwHDdL7Q7fvJ4ywaqv7jBesa1mZ7P+wjwAYbMz4LWQv/NueU7IhUiztz
         jjnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6cdf8MxCPSbwySV/dQd+Gx1+0hE9oO2fF0yfSMCUfW8=;
        b=AJ0+sD3uPv/Nydq5z+wjR+0q6jRZWwag8f0JdbBYOcx5zF7TE3pk8WCmgSg0/u35c6
         WDE5QviJCK5DUAz4E6DgOduaSrUR4jAGaz8h/9IVuLNYDgcnZBVN75Waz9xIKEbprQ3w
         /W5sE+zUGBQ0PYOKNGVgMjx7aKOlaNkl8LeOsghxcJcuaA8VgBmq3OxQc9xIc+Wp6+if
         kGZ8mzdIi5aZRnjF/HsoUaBfAcgOL8R42xTJUy2otYB2cvsRNlGItm/CIxCV8YyyP2Rk
         V9HH/ZbJIDNKGw68al6YHNUz5gr3U+hILpeSCd/UjWZFCsw+bAEMaFO6MFLsuc5W+S40
         U5Dg==
X-Gm-Message-State: APjAAAXRDFJ5ozSvya73N1VqXEyFw3v8ut1iBRKmcCDqgQlNFRHobedV
        ga0xEzXL6mt+Fe9X/shmbahOMDwG2fSLn6n58Wc=
X-Google-Smtp-Source: APXvYqz+ZLoDSjm7YkztodnQv9v6LWUZoPcWfWmqVJQS8ww1NWyzFQRyJhZ69DPBwlun6HTmY7rvt1/BLnKYgVHGSfY=
X-Received: by 2002:aa7:c4da:: with SMTP id p26mr35953411edr.4.1582323082266;
 Fri, 21 Feb 2020 14:11:22 -0800 (PST)
MIME-Version: 1.0
References: <CABLYT9ixWZu2NckMg689NdCTO08=-+UOHbALYrQFHCY26Bw91Q@mail.gmail.com>
 <CADVnQyn8t7EiorqHjGQe7wqH6jQy_sgK=M=gieb7JMjWqvbBHw@mail.gmail.com> <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com>
In-Reply-To: <b390a9ed-84a7-d6ef-0647-107259fbd787@gmail.com>
From:   Vieri Di Paola <vieridipaola@gmail.com>
Date:   Fri, 21 Feb 2020 23:11:08 +0100
Message-ID: <CABLYT9jCD-FPZkJwsKP4gtgGaA8=P5DVtJkzUhuX9YoA5LLdww@mail.gmail.com>
Subject: Re: warning messages for net/ipv4/tcp_output.c
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Neal Cardwell <ncardwell@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 12, 2020 at 4:47 AM Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> >> I get a lot of messages regarding net/ipv4/tcp_output.c in syslog.

Hi,

These warning messages were triggered by the Suricata IDS/IPS software
when used in NFQUEUE "repeat mode".
I've found a workaround, so I don't know if this issue needs to be addressed.

Regards,

Vieri
