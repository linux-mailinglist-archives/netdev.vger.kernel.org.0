Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91BC323F87
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 19:54:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbfETRyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 13:54:11 -0400
Received: from mail-oi1-f195.google.com ([209.85.167.195]:43459 "EHLO
        mail-oi1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725962AbfETRyL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 13:54:11 -0400
Received: by mail-oi1-f195.google.com with SMTP id t187so10651857oie.10;
        Mon, 20 May 2019 10:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+TT7VxpiGJ92MYdiwp3Ymg21i+ktD/aUk1T7VpGbYWU=;
        b=o6/ke7DkM42v4VU2Pc/qn1wtld8P7VZklPINruRFPm4Jj+fd3QtQ+yvHwYsMa2i3MZ
         dDKmeFB+vNlbzV6m8jVMGITMpO4p/rz2HsIHTRMLeGbkp4yUJmIhxJiGFO+sfq5k7WSp
         IzsIMYmJkh/rP3rzAeUdl9iEzWmz/+gbjcM1HLg0oqusbu2oCqpHk0uYAZr99ivCjsdy
         2jUefsQbU1jfABN1ThxdBfjmmlXesNHha3EoVam/CnW876hedtfx0mNepGOrdWstUIWY
         sfF/I0yWNUF1F8VNSAxMq+RKsrlOYTSojkdo3gVicMuqvLcfY4ypKj8RoClEDKs81syJ
         gjCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+TT7VxpiGJ92MYdiwp3Ymg21i+ktD/aUk1T7VpGbYWU=;
        b=X2m/32yPLzC/KX4RHNFNWEL7gnHi2AVEi80caQpQDAvR3ouSCKnYbHdS7hY778NOI7
         ILp6HqpGUpkgr/qro9up6QV8FxmnihzxyqcJlqW7KcbV5SkB4jZmq6uoa97Vve3+iILs
         gPVr7RFFFTHqFmIwn5CNQyenfD/Qtfd34DqEbmWShtowh7VN4WAM3fL+VsRz5Xy8n1Qo
         zhv8hlQaRj+VHU8SD2vzll/4fDkz7Bzp6PeEVWoqN1fm0OI8peGhzlSVbVmU97CXrKv7
         VeCSC5ccOkaSe/KumfQpnuNFyUwiEpNFGKzjxrm0OVG3woi9Ci8lsmtKpcpEzH4qW11a
         OOHw==
X-Gm-Message-State: APjAAAX84o3GScvXFLUJjH2UTLbs/Saiung5eSDGckNrpURTcIxOXj88
        R4WjtCM4Cs/4b/tu1NZY5sB1HO7rlyjoGO0CwOU=
X-Google-Smtp-Source: APXvYqxTveKpT4B4VuQk3T31UTuVi5i9NCYogPnEhi5gmvdQ9hdPvMLDCpVuSmJVfLt4VV/et7aCi+C62sNpPoI70Zs=
X-Received: by 2002:aca:ab04:: with SMTP id u4mr271445oie.15.1558374850489;
 Mon, 20 May 2019 10:54:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190520143450.2143-1-narmstrong@baylibre.com> <20190520143450.2143-3-narmstrong@baylibre.com>
In-Reply-To: <20190520143450.2143-3-narmstrong@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 20 May 2019 19:53:59 +0200
Message-ID: <CAFBinCADC4ZxHGpyUEiN-VvNph-CN82rgWCLu6qGVjYbwjrn1g@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: stmmac: dwmac-meson8b: update with SPDX
 Licence identifier
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 20, 2019 at 4:35 PM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
