Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E8FC291606
	for <lists+netdev@lfdr.de>; Sun, 18 Oct 2020 07:26:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726037AbgJRF0V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Oct 2020 01:26:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725308AbgJRF0V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 18 Oct 2020 01:26:21 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10EB2C061755;
        Sat, 17 Oct 2020 22:26:21 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id p16so7148789ilq.5;
        Sat, 17 Oct 2020 22:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=vBVshD4XKNQWVAfYaxqObW20dee4eDOGnAubSKZwmbA=;
        b=vSyi/sLhcd7rm5+z1h6UxSpNTSDGRuzzBPXSlbC2+WAw/SZiy9lIuitif6pPpTIZ+K
         T2+bq/4EzaUwhaat/6dbnuZbdNQe8/I3hAP4T5WdoCfBNNj76I1z2vyTRVPeB+vUTOyz
         qFz6Ez/n0vl6qXpt+zwiBk9N5l/Am7VKfpShA746V3AsuRlqjmcw9QUGaGWtQwuqPiXh
         ctDIh9dxI/OQtlyfiQaNOmbRWnkHzzUQ3rkeAlPsDrETs6ECkOd4ABQC23IbD8cRci4E
         BrKu6Fr9VI0BDE6B/adQIYXUQJ3mqctYBpcHjF21e9sjCJMF0Q3zKoIdzQZ/gZiY0fvQ
         KY6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=vBVshD4XKNQWVAfYaxqObW20dee4eDOGnAubSKZwmbA=;
        b=Hczs2e4nEHCkhNlRVq3YSEeTmUG6LeW9Q4a6GNxJavvjN7lhq8B29QPsApq9ehyvo+
         bvMNaCxScFLy5SsFZ0LaIAASROMUOC7KilIzYxdpG6u40TVchRVl6JF9pwAtmN0c/Xso
         nq8erqJtJVrRo3+UaSBWrjYA11816k0yXyCNiIyyiujOUMpoiT1WRqEEUFAc4XBaUxVY
         1DQqnMYYUI7DefajLhQ3f6OhQ1RYLUd8vu6Ry/7t6LkJl5GRP/5e01x0jo2mRiHubcCv
         R1ahUp4mymGrblDIkZ/ZsTiU0b7r53frscpDaFa5fX0qh2uEWL1MDSGrzaLm6hqW8jFV
         sz6w==
X-Gm-Message-State: AOAM531OeryFDatb87DqtkjlZhqVwGNId+I5RF8L9PYAEH/FUAjiCzP4
        5vllZrRabxfDgiZAijyPAxXXG5D285DxLDn+mss9+3Nq
X-Google-Smtp-Source: ABdhPJyqNdFhHB04BLaKh3XyqXy9mM036KbJ1keST+ef5Zo7I4Z3sjOTCNXgurSc+uvjRBx18j7UJQUnT1jRzI/8dIY=
X-Received: by 2002:a92:1943:: with SMTP id e3mr7435521ilm.140.1602998780373;
 Sat, 17 Oct 2020 22:26:20 -0700 (PDT)
MIME-Version: 1.0
From:   Alexandr D <alexandrdorosh@gmail.com>
Date:   Sun, 18 Oct 2020 08:26:09 +0300
Message-ID: <CAGxHY54m+8vYCfaB-3nnnye_NdrSF1fNoaYMEv6ChiguvBTXtQ@mail.gmail.com>
Subject: Qualcomm Atheros QCA9377 802.11ac firmware
To:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello.
I found some kind of "degradation" in a driver for adapter
Qualcomm Atheros QCA9377 802.11ac Wireless Network Adapter
Generally, "airodump-ng" utility works with firmware-5.bin but doesn't
work with the latest firmware-6.bin.
https://forum.aircrack-ng.org/index.php/topic,2545.msg13665.html#msg13665

Can you have a look?
B.R., Alex
