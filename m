Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A7855197F
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 19:27:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732417AbfFXR07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 13:26:59 -0400
Received: from mail-yb1-f196.google.com ([209.85.219.196]:34433 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728709AbfFXR07 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 13:26:59 -0400
Received: by mail-yb1-f196.google.com with SMTP id x32so6048248ybh.1
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yXmuDDswJwasFysM5xAe3iWKG6lQgSipjb+VoaydZpo=;
        b=ZEzIcJAE76hfGZSdojtnNCDq8KnZa8QzLX4gcsB7N0ETY6ORcgQdkor67xpQexSWWo
         fnprlr44zWbGI7KMkoUFtAlcXBvv5h8VZTTFA5WYfT7tmNiBdpnUEvMjWV1eespYOnxk
         Fl+PI+e3gWgPAAA77uCNH9dQDpxVjW9vD+haq9JfuhF09FQJyTdun0ZPUHYjjtY0KurC
         v+0o1Wo/EOBSSgiNa8QwBP/x7zBnjsu9+huHIxK7XbalT0GWYGrUmiI2uEkTzkEN6Djk
         nC9qkPQYSsytaWz/1g2lwHRxrOvwJWFj6RibszIU/C+giXx6xQLf/9D3PHoZAG1pkMQh
         vRHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yXmuDDswJwasFysM5xAe3iWKG6lQgSipjb+VoaydZpo=;
        b=YUH7B6FcWakpwFLtFyNmdsrGNZvU+BvVKyEqi1YeUc2UJR8T1RZ21p/jXKafc29rsG
         4vtMNN2sCP+VQmvaN2dKCVPiZzxCcu9/DtSD9QTPgZRI8Wz+lxYjForf2+XcprBHcxfw
         BhV+30HDQ6eOtTIOUnfeEIpaTMdPV29963ycJCYDbHfhb7Ym7WR3IN1m9/Hp2KtNOznp
         4Rzh0/XI1ee5l9FDDVAIhEfs1kmGNeUUaUmxVYyxaPhlbKT8PetVkfY+PAn4V43T5pPU
         MEZQ74NLAUyq8cQaqNl5ARce7j2jTgqyO6GLQ5Z0KncPKcdwIFGyhZxuMxmkL7MWK1+w
         Ra5g==
X-Gm-Message-State: APjAAAVCMaTKJHjY5dU7jVE23hYA95kTiNXheJQ8rU6lty9xJnJfIl9q
        +Qqrfslt4WRqbMTMN6ecYSVj4DTG
X-Google-Smtp-Source: APXvYqxqDEAs9OH4VUAsrUiZlMSy0bLlxhO8cs1u4JGanormu652Bj/YMmu/bexa0NGnsWQ7ZkidYQ==
X-Received: by 2002:a5b:48a:: with SMTP id n10mr2276272ybp.188.1561397217902;
        Mon, 24 Jun 2019 10:26:57 -0700 (PDT)
Received: from mail-yb1-f180.google.com (mail-yb1-f180.google.com. [209.85.219.180])
        by smtp.gmail.com with ESMTPSA id j67sm3084956ywa.39.2019.06.24.10.26.56
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 10:26:56 -0700 (PDT)
Received: by mail-yb1-f180.google.com with SMTP id 5so2427896ybj.10
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 10:26:56 -0700 (PDT)
X-Received: by 2002:a25:21c2:: with SMTP id h185mr14071216ybh.125.1561397215686;
 Mon, 24 Jun 2019 10:26:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
In-Reply-To: <20190624083352.29257-1-rasmus.villemoes@prevas.dk>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Mon, 24 Jun 2019 13:26:18 -0400
X-Gmail-Original-Message-ID: <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
Message-ID: <CA+FuTSeHhz1kntLyeUfAB4ZbtYjO1=Ornwse-yQbPwo5c-_2=g@mail.gmail.com>
Subject: Re: [PATCH net-next] can: dev: call netif_carrier_off() in register_candev()
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 4:34 AM Rasmus Villemoes
<rasmus.villemoes@prevas.dk> wrote:
>
> CONFIG_CAN_LEDS is deprecated. When trying to use the generic netdev
> trigger as suggested, there's a small inconsistency with the link
> property: The LED is on initially, stays on when the device is brought
> up, and then turns off (as expected) when the device is brought down.
>
> Make sure the LED always reflects the state of the CAN device.
>
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Should this target net? Regardless of CONFIG_CAN_LEDS deprecation,
this is already not initialized properly if that CONFIG is disabled
and a can_led_event call at device probe is a noop.
