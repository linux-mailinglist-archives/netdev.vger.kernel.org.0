Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540A32B9C2
	for <lists+netdev@lfdr.de>; Mon, 27 May 2019 20:05:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727128AbfE0SEW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 May 2019 14:04:22 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42960 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726484AbfE0SEV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 May 2019 14:04:21 -0400
Received: by mail-ot1-f67.google.com with SMTP id i2so15471195otr.9;
        Mon, 27 May 2019 11:04:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qc5bwgG1nJlpiXW7qOpXYd6aZ6dtl7PwtbbKYJAwtlk=;
        b=QT+oR2PzBjtJAJ4Q9xeAgE/GB4/+a9hDfoejIBw07ZAUJYbrWe12KnBXyT6Q5/iLMx
         Ydgqpnjzkoq0HKSc3sdBbcj592NHjQe33H1nmmu3r2AaqZuH9kSEfW4X1IjSYDJ9MXCs
         KbWJxL8Yq3sTHtuZ/d8J0BUr3hat6BR4JI1NDD11dQrfaHGgkmjqml3BwckU8DYQfO9n
         NNh3Daph4Uerkcl1CE1+09Xt7BLTuLkxJBL/6jYBXCOXI9PjnH7J+ihDWH8uCDFjUnT5
         YkqoQY84Fl86gGlQtIxjqbqRWGwMcDNTQyFQcKnD4RXyGWWCskBQpIqLW0rWVIAxk6jB
         w55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qc5bwgG1nJlpiXW7qOpXYd6aZ6dtl7PwtbbKYJAwtlk=;
        b=mp0XdHJL60CrZCx94RmVKKjAZXHG/m02fJrdR9zJTsnVvEBO7/ZqChGJp1vZYQXuS1
         XHKa6AiWqWPcH0W2lv3BjXqSaicjk0pwlveS+5RQbCbRmiRxrVd+grlq2lJRaQbqobGy
         f5dvmGS8pT9ODsB+F11hYgRNzA0XI50ywmIKrQkaCAE5Lus9D/17McPG1zVwsaiUwsKy
         FkijvmSYwBhkwbGvqfkvs5yPoowYXvQIrhd71FFcTGJ3dSmcovxIp12MJtJ3Zob7UGHq
         N9G5yC6goo3k5i4ACqrWVXgKViLX1ivBgl+0u81z2XY51AcThWHe4PduEGugz3Y7NlMO
         1zcw==
X-Gm-Message-State: APjAAAX99x0CM6aOxQdcP2BU+arNPgEhGyPxroXeIK5gMZxJSN86IqZx
        4aJqwnEQlqGfqPHJYFHfL2cuuH2iDdGguhzqVcAPL68U
X-Google-Smtp-Source: APXvYqyG/5Xo+qXItm0oFZccwmyw4v4GWKwCndcRrcwlFCngOkzbwFAFOT2+r1bf4fzOZCZjIfstm/Kj4oTQvjej1Yc=
X-Received: by 2002:a9d:744d:: with SMTP id p13mr50944036otk.96.1558980261008;
 Mon, 27 May 2019 11:04:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190527134623.5673-1-narmstrong@baylibre.com> <20190527134623.5673-3-narmstrong@baylibre.com>
In-Reply-To: <20190527134623.5673-3-narmstrong@baylibre.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 27 May 2019 20:04:10 +0200
Message-ID: <CAFBinCCD93XzMp8gbUUc_Q0pHt84=zyn3_TuPCVUpnB8LK48Fw@mail.gmail.com>
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

On Mon, May 27, 2019 at 3:47 PM Neil Armstrong <narmstrong@baylibre.com> wrote:
>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
