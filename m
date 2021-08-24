Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46ABD3F56D9
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 05:52:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhHXDwu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Aug 2021 23:52:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234052AbhHXDwq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Aug 2021 23:52:46 -0400
Received: from mail-qt1-x836.google.com (mail-qt1-x836.google.com [IPv6:2607:f8b0:4864:20::836])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35B8C061575;
        Mon, 23 Aug 2021 20:52:02 -0700 (PDT)
Received: by mail-qt1-x836.google.com with SMTP id u21so12741426qtw.8;
        Mon, 23 Aug 2021 20:52:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=jms.id.au; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b/Xe9BrdtCP5Xgn+FmLnep/WdGNC7xAM2yhlmxtBW00=;
        b=OgMcuX96vDlm/KLkFpuE2LJqhdB41RIhIR13T7PyJyUr2EoVQWco3MqWAbAIF2mc48
         W6iS2NZ0Wl4lNUaeMUh1SQ0nUnvhsBRLE5u60M5+ilGEGcZFx0sujD5ymozVY8BHPxP+
         b14Qm+Vzn7I4J3XNmzZDFJKBzXThrMuKejz14=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b/Xe9BrdtCP5Xgn+FmLnep/WdGNC7xAM2yhlmxtBW00=;
        b=n3CjfA7bYrpOgqw1/gymInmZRSSDQ7eEVpavXUJYuZ13w7chWg4665ckFh/4jvbfCO
         YkAF7b/ftAwzxH/QZG3HwJ3oQQq3t4GDYMDpAcNQgW5aTYbCulnEdDlQSM7wB+yr+YjU
         89V77vHvqyDDLZvzsToX+onsASgZ2jVt0Isft0tokfJGmdCR+4tarBnOS2aw4p3UPABm
         l3n6u4cKTCzJQM1Erv44eU+W80uXUf71MFNYyAF7h+sDOtePOjgxIR/rbCv3TWNUU5Sj
         sycheKGUbVqssNfWObXlYqSyc6AB+hN7JiFyalFOxTVac3WAMnf8BMWwMdyvi6UJ8Bn6
         qiag==
X-Gm-Message-State: AOAM531/goN4RgGpCO8Bwv5LCOEh0jsW0vr24s5Jafl7/9KefX2LSrxq
        B3MlJ/sAxPGPY6uL3jAT2LxsSQtsMIA/zWVh7CM=
X-Google-Smtp-Source: ABdhPJxPQ1whYJqyb+DVQIpoaOvkiKBee48TTPF/5PSSM8eQqBDcXZORp0+1x1AS5ivbcJPAoLfmf3ZN3XQB9N62GPY=
X-Received: by 2002:ac8:7dd2:: with SMTP id c18mr5376801qte.363.1629777121912;
 Mon, 23 Aug 2021 20:52:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210820074726.2860425-1-joel@jms.id.au> <20210820074726.2860425-2-joel@jms.id.au>
 <YSPseMd1nDHnF/Db@robh.at.kernel.org>
In-Reply-To: <YSPseMd1nDHnF/Db@robh.at.kernel.org>
From:   Joel Stanley <joel@jms.id.au>
Date:   Tue, 24 Aug 2021 03:51:49 +0000
Message-ID: <CACPK8XcU+i6hQeTWpYmt=w7A=1EzwgYcMucz7y6oLxwTFTJsiQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] dt-bindings: net: Add bindings for LiteETH
To:     Rob Herring <robh@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Karol Gugala <kgugala@antmicro.com>,
        Mateusz Holenko <mholenko@antmicro.com>,
        devicetree <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 23 Aug 2021 at 18:44, Rob Herring <robh@kernel.org> wrote:
>
> On Fri, Aug 20, 2021 at 05:17:25PM +0930, Joel Stanley wrote:

> > +
> > +  interrupts:
> > +    maxItems: 1
> > +
>
> > +  rx-fifo-depth: true
> > +  tx-fifo-depth: true
>
> Needs a vendor prefix, type, description and constraints.

These are the standard properties from the ethernet-controller.yaml. I
switched the driver to using those once I discovered they existed (v1
defined these in terms of slots, whereas the ethernet-controller
bindings use bytes).

Cheers,

Joel
