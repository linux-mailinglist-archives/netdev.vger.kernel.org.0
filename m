Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0E6D1CDF43
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 17:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730392AbgEKPlA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 11:41:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1730385AbgEKPk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 May 2020 11:40:59 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E43CCC061A0C
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:40:58 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id f4so3796485iov.11
        for <netdev@vger.kernel.org>; Mon, 11 May 2020 08:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=9CCSGXafHVSnIXhbAh+LGQBsCZa4Z8BhGBIa+lgcjmo=;
        b=BYLl8csgC5nReFg7N3q4ELadcsyXiDNkVzsG4HvR9AqlK+JUqlzeuT2lX0FSRXGkHj
         lGza0Xp6BmHZ109hvF/K5T/zuPL3tgMem8fX//QTHI31ZmvEv0tVh3eLMr5IP7/giAHd
         q3FKxbViL0k/V9OMs7iwNW4c6JlV7NT4hNHIz04avooKeHpjQ3dRjuhSa3s01Nh0EM8C
         FI7qLwJsGbyf81xUpliQyRmsZKPYjco0xcS8JhHV3jFmgnNsXP68YD6B2ysclU1Ucyfd
         jvVns+k9LNNv+Isq5lGJvZpAL+n+eGjotP9w0ku9IEMl63MMWLfYpkIc4h24TnSz3Q/3
         ilsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9CCSGXafHVSnIXhbAh+LGQBsCZa4Z8BhGBIa+lgcjmo=;
        b=GtkyVD+hFQZhdq4yVe9ZIhB8MzYrUiBafSDYJUjaBUCPUpU3JnVc3y/pR/N4gqx4bE
         DJAt+BoAKaXCWcy+C63VojJkw56Z21OmoBrycD4XmDL5C37zs4fMDKpv1508Itn/8JY8
         LXfcwiQ7jtdM1s9hG8zFd9jFiSF2TPQxkJiyIWIysQ8jA1hvW2jbgrdi4tju2fOd7qDC
         a+4EEyPd3d7e61uwpuid4nRd2AsWKPu2c6xlxJIaK7Pci2QXEQtU2gPod5ULUG/wkRVX
         ruLS2SMcoOrAxAZ0jTlPMdpuR+8ZzRnfPF3ErxHsIJJjKPSulBBDaBUoH1t73jMNQsO2
         2hQw==
X-Gm-Message-State: AGi0PuarXa+3VZIakRecWWTbubQnwWpTGqKVKaWrBe9Ci913leINTpSA
        P26U0QQyHD3C5oChhtUArGRVNMvySq94phyNKF7iCyT/
X-Google-Smtp-Source: APiQypLw4pFm0gM+89b/L4vgjIctDDr+fTS97FGEkMZEn+FZUe6C/Xtd+WzATfGPrjkNruF1SibKdj3ZMQqc/ssM+UM=
X-Received: by 2002:a6b:d219:: with SMTP id q25mr15850901iob.202.1589211658061;
 Mon, 11 May 2020 08:40:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200421081542.108296-1-zenczykowski@gmail.com> <20200511121053.GA22168@salvia>
In-Reply-To: <20200511121053.GA22168@salvia>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Mon, 11 May 2020 08:40:46 -0700
Message-ID: <CANP3RGeEK7j_6LH5e2czMcDRR4xo79rnGh4euSLPvojrLE8d4g@mail.gmail.com>
Subject: Re: [PATCH] iptables: flush stdout after every verbose log.
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Netfilter Development Mailing List 
        <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Applied, thanks for explaning.

You're welcome!
