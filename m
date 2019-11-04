Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C51E3EE3B0
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 16:24:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729267AbfKDPYn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 10:24:43 -0500
Received: from mail-qt1-f194.google.com ([209.85.160.194]:33678 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728827AbfKDPYm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Nov 2019 10:24:42 -0500
Received: by mail-qt1-f194.google.com with SMTP id y39so24513770qty.0
        for <netdev@vger.kernel.org>; Mon, 04 Nov 2019 07:24:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N5DTW1ZjhAK25FlV8E786UAoiMrKU1fOCI7teBCp5vs=;
        b=GDpOrs4GHqQQRvNX+oYgVG/YdnTVw/z5OQRau42ZVPsOl0MgantoJmfaojBbrjH2pr
         2d2Vh3Vpp8j7aMWDPbo6+j6JYMAM+QUT0oGswGOl26vOR5JUS4nkDv2bql5j6cudLntq
         ncN0q9em2uGSqoTtoswAFDTwgwvJiIpMOVU35S4D+9j+CtOY/s2pcqBI1WoWMU+xxeQR
         iecV24R+ytGMuNgJYXVRTgvibCK74aeVazoMySAthZAo7L0NwbwgMuDfTY2sQqHS0A40
         PBkI2kPl4ilpwPdpDrzAjm/UNYMm8HyrHKFHXQy1IGLq4+lf1vLOrIvCHAkX9KYMh3Jy
         G2Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N5DTW1ZjhAK25FlV8E786UAoiMrKU1fOCI7teBCp5vs=;
        b=XyHY6Iwsk2/wGF5Ig9Jga8pXsEy/JpHOG7yGfyKyB4xhevLDJzl6drLc+/m4DX+HU8
         BDTqqDCRbiwbnacjeYUoZn6LH1gsl5LJbr10bsZXRmN4kBapz6c9IxiQmpxbNEbS6iVw
         LMyJcRzphPdkzf6mKt5v3NoyhFMX3UCfnfRJda+sTYaN3fOu5VlPbTJm7YMGPQtquhOl
         WTgHnjXGw0JIhEDi96Dk5xZwNvrz1nJNZUW6ttKO6lUfMOywHyKBD3I2TpDwlFd/VYoU
         HnpBrENPqf1ChaqpOlg4Il83yg9RbGUPq/52JsHcKH5sQeIzl8A8yIYhxGJXFCJdMNxR
         zRTw==
X-Gm-Message-State: APjAAAXJpjGAiBq/UifVMVnTsogUPmBpXU6fb1JmvZx1GgSegk3tvj5R
        74KnVKZ+O7d42rxMM5KfRZmOnnN3Wwatvi/gfJ71yQ==
X-Google-Smtp-Source: APXvYqzvXcqSG+UPeRCIxwYwjr2KaBIOYHSIvb1b+PhZun9Gau81ohKyU0SlOmI4keh1P0lls3tz3BBqjzyyRfKkDLc=
X-Received: by 2002:a0c:fba5:: with SMTP id m5mr5784486qvp.139.1572881081333;
 Mon, 04 Nov 2019 07:24:41 -0800 (PST)
MIME-Version: 1.0
References: <20191101173219.18631-1-edumazet@google.com> <20191101.145923.2168876543627475825.davem@davemloft.net>
In-Reply-To: <20191101.145923.2168876543627475825.davem@davemloft.net>
From:   Thiemo Nagel <tnagel@google.com>
Date:   Mon, 4 Nov 2019 16:24:27 +0100
Message-ID: <CAC=O2+SdhuLmsDEUsNQS3hbEH_Puy07gxsN98dQzTNsF0qx2UA@mail.gmail.com>
Subject: Re: [PATCH net] inet: stop leaking jiffies on the wire
To:     David Miller <davem@davemloft.net>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        eric.dumazet@gmail.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks a lot, Eric!

Grepping through the source, it seems to me there are two more
occurrences of jiffies in inet_id:

https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L120
https://github.com/torvalds/linux/blob/v5.3/net/dccp/ipv4.c#L419

Kind regards,
Thiemo
