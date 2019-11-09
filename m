Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F0B8F6105
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 20:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbfKITDi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Nov 2019 14:03:38 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:34719 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfKITDi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Nov 2019 14:03:38 -0500
Received: by mail-il1-f194.google.com with SMTP id p6so8153479ilp.1;
        Sat, 09 Nov 2019 11:03:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=m3uHaDtX3ciBcivMZkabAXv4IXjFfi/2JONmJEnyS4M=;
        b=RCAYa6kDMEf/AeTD8Nl6PkaEchhfOa75CoD+JNUUk5NFr32qGnt/60EF2p4d0qfHXc
         7J2h3624bHpfa8ny+/zFhT4UDKyJ9Ns0r33h0ihLOUDd1/g2aLQjR2Ikl5NfzEV5rs9M
         YaJtV0PnLlnNq9aM8Njk8+o5e81nr4js8o1XTRfoY22U5PagUjym+3iabkGkIhgWhlCx
         OsiFHtAriIEsVOKZuEPDPKg5gUbq6jFRA4yqU/w1fmyVAKczKo6bPkGI4gYdmXPiUrMH
         25QfbLt8XKOnCzXaliR0vOVPeRRQ7LzsOEg+MQ3ks1T5UmD0HCAxCtbPdGS6xinHocxa
         n5PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=m3uHaDtX3ciBcivMZkabAXv4IXjFfi/2JONmJEnyS4M=;
        b=ce6UfIY0WIcQSDie3LRTfLLPzY9EvjgOLtTWb4Xk+w3QxzQVwpJ5fH+Mmz/nX82w1m
         /WztH/Guz5xpQT12ZXv591K7dE5DzqOGlipyTc70yYBCY0OJvgceCkCvcY54Johw/U8c
         q3MZ6xOz9lx3OZWBZPybPX0ED5/HqGxNEH7FxSnVLGr2ivdNG6CwSLtQPdDYxMrzgVtP
         497XR36/tFOJKX87AFEBrQF/wNd4UIXO//jCFKG/tuvWtJfZ8NiO90ED5E8PLAA/57XK
         oaTZAHC0RiG3CNjVnU2VbL9WVG+craAvDIxJHREVeGPeytBH3Bw8pv2sNaF1lxqgBbwb
         BcRw==
X-Gm-Message-State: APjAAAWscmzdovbgniHKgEV6A3E4TbwIgYrsbtEcnwUCAmnzawm/kqiA
        Yd/4Wdv0+D25NMoW9Mzzg+OYupV/mWg8kwScL5s=
X-Google-Smtp-Source: APXvYqwLdQBgG/eiU+syj+zmlngIAnifD4FCbVu6rau6qyJbKLCYEZtAQ3RATTBj6ml3CSIhCOohWn5rvOvE/NAdcJI=
X-Received: by 2002:a92:c888:: with SMTP id w8mr20267021ilo.153.1573326217272;
 Sat, 09 Nov 2019 11:03:37 -0800 (PST)
MIME-Version: 1.0
References: <20191108210236.1296047-1-arnd@arndb.de> <20191108211323.1806194-4-arnd@arndb.de>
In-Reply-To: <20191108211323.1806194-4-arnd@arndb.de>
From:   Deepa Dinamani <deepa.kernel@gmail.com>
Date:   Sat, 9 Nov 2019 11:03:25 -0800
Message-ID: <CABeXuvpgQA8SgW-r+jB70=yuV5hes0r0q7idX5wYzjEL=jTjfA@mail.gmail.com>
Subject: Re: [PATCH 13/23] y2038: socket: remove timespec reference in timestamping
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     y2038 Mailman List <y2038@lists.linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Network Devel Mailing List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Acked-by: Deepa Dinamani <deepa.kernel@gmail.com>
