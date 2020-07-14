Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1A3F21EA16
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 09:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgGNHeI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 03:34:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgGNHeH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 03:34:07 -0400
Received: from mail-lf1-x142.google.com (mail-lf1-x142.google.com [IPv6:2a00:1450:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60C67C061755;
        Tue, 14 Jul 2020 00:34:07 -0700 (PDT)
Received: by mail-lf1-x142.google.com with SMTP id t74so10809584lff.2;
        Tue, 14 Jul 2020 00:34:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vSZCdTeq5IZuIT/5K6A9iU6I7B62mfuU1w1ZeNdxwsA=;
        b=IaeiwFlo8/BnwFbIg9V+kT/A3MGOXKWrL8aFqD7RmTg7SL/L0Ik13tc0GNKZ+nqBr2
         n6F22egPYYSTnoei5lFzP64BmWd0JJUHEc7ShDJoqOV3hqZ+5S46F0Q6UWfsyW3oCbWR
         II4204xpQRJckdYQnNR5iH5fKM8TrMWfCUI9r9unii/uFJIgewAX57yEQnRWe2Nyig1V
         K3fhA8dFPJoDcAKjTEgfTrlTQTafus7qfE+HvYl8EAzwF2Zd9/T+TFq7NexCd5riqzry
         aFclxGUkc8bCLkIWlVKylGLHnyGT62Q5XJ/1uH5hsjLSwD0qXzLWrnGYLX3HaTMI7PRJ
         BmEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:organization
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=vSZCdTeq5IZuIT/5K6A9iU6I7B62mfuU1w1ZeNdxwsA=;
        b=Bj3vvvymTk1igm1eEfY5r/uiBTvbAU3e5L6WTZkAT0cJ6tI9LZE3TZ/ikD2WOqZvG8
         Rk1xvBM8Uv+h+rAJZau6s450J2dO3O8ROrJs5cj7n2y5GLPTOrkl6zQWQrXZkdgcq7eh
         TGnM7ETTz2uI6onks/WkxAbETqUJ7r/Pp4vS5TR+8VB92F6goueZDnS7g461nrZb1JcV
         gM4TM6UbPB4bP4+6nfSjIHhRz4rqjQp36/d4RJuMgrGTPeZyY3IBgqTfIFW72/E1RXi+
         jrDIxZG5bFL1ZL772pY0SMc+xsvlnQ5lNoRu3ztKnGyr3Yzgr+ijOaji0t1LEuP3E+Yv
         HX2A==
X-Gm-Message-State: AOAM531GwPFG9sQzmOHxwXUOTSRG/wo/F+cj6vP6y5syVVolIy2ywtbL
        2Uwtclaq2x2dKZ3y+ELYoXbtQf+mK1U=
X-Google-Smtp-Source: ABdhPJwKAOzh6OpUd3ef4QZMtDjWIvyqfzukJI4zVQgp0Iw73r7ql8TL8LKN16oTjdOmjeR1GQGBJg==
X-Received: by 2002:a19:6a02:: with SMTP id u2mr1568163lfu.9.1594712045894;
        Tue, 14 Jul 2020 00:34:05 -0700 (PDT)
Received: from ?IPv6:2a00:1fa0:809:9719:3978:b690:7798:aa4b? ([2a00:1fa0:809:9719:3978:b690:7798:aa4b])
        by smtp.gmail.com with ESMTPSA id u9sm4468057ljk.44.2020.07.14.00.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jul 2020 00:34:05 -0700 (PDT)
Subject: Re: [PATCH 8/9] dt-bindings: net: renesas,ravb: Add support for
 r8a774e1 SoC
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Vinod Koul <vkoul@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Joerg Roedel <joro@8bytes.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Magnus Damm <magnus.damm@gmail.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        dmaengine@vger.kernel.org, devicetree@vger.kernel.org,
        linux-gpio@vger.kernel.org, iommu@lists.linux-foundation.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
References: <1594676120-5862-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Sergei Shtylyov <sergei.shtylyov@gmail.com>
Organization: Brain-dead Software
Message-ID: <db415d4f-e563-81f4-2202-5eea57f91a6d@gmail.com>
Date:   Tue, 14 Jul 2020 10:34:01 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.3; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1594676120-5862-9-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello!

On 14.07.2020 0:35, Lad Prabhakar wrote:

> From: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> 
> Document RZ/G2H (R8A774E1) SoC bindings.
> 
> Signed-off-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renesas.com>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

[...]

MBR, Sergei
