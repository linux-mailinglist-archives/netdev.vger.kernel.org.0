Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6E534422BB
	for <lists+netdev@lfdr.de>; Mon,  1 Nov 2021 22:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232004AbhKAVgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Nov 2021 17:36:45 -0400
Received: from mail-ot1-f50.google.com ([209.85.210.50]:45746 "EHLO
        mail-ot1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKAVgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Nov 2021 17:36:44 -0400
Received: by mail-ot1-f50.google.com with SMTP id l16-20020a9d6a90000000b0054e7ab56f27so27163750otq.12;
        Mon, 01 Nov 2021 14:34:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Z8yRxOz3s2WTsVm7FQuknGf83woeCl9finIZOSk+7SE=;
        b=lervt4SKIGc5TaCaJxl/a8grxRiwyfw7e8ImIgR84oWywAMBRhlSfTgaIJO9/NWapE
         YEa89Tu1XMwnkXfE0kYt4gEPjsnZVVwIOlexM9zbataKwl5mpEtOIM3mmwoJlVhG+nEI
         teVgXl1uPDAFYhBGSGD8tIQQJwwutu0l9cGMNRckPlFTvj+eBwHVTHgCnyDOhwmVpaC6
         4DnNrmzA2sdsgAUD4MHJ80nY7yz/igDgYbqN0J6nO8uqTL0op+ABnhFVt7OEYacGwd01
         UuuoBDm38uT+r8YZONhqiLl6Pqry0QZ3MNtEynQvMrmQFwQFItGLZY2TLvH/y3MDe5kH
         SBaA==
X-Gm-Message-State: AOAM533xw6zepw0NfehHT5MDfvSIGagTbLw//zYMXrIb3ZIzGXTO6mSp
        IGhtlS+IUwIVYtI3pbC492UpT1EdhQ==
X-Google-Smtp-Source: ABdhPJxNLLoF3dWU4T+Pq+CWqVsnicIHqD56pH0I6Am5juc1pJTriQ+v+d37Rybq9UHIRIC3sR5K5A==
X-Received: by 2002:a9d:1c8f:: with SMTP id l15mr8501691ota.337.1635802450905;
        Mon, 01 Nov 2021 14:34:10 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id m23sm4394890oom.34.2021.11.01.14.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 14:34:10 -0700 (PDT)
Received: (nullmailer pid 1104793 invoked by uid 1000);
        Mon, 01 Nov 2021 21:34:09 -0000
Date:   Mon, 1 Nov 2021 16:34:09 -0500
From:   Rob Herring <robh@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     devicetree@vger.kernel.org, David Lechner <david@lechnology.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH] dt-bindings: net: ti,bluetooth: Document default
 max-speed
Message-ID: <YYBdUWHe0Rkh1TIq@robh.at.kernel.org>
References: <0c6a08c714aeb6dd96b5a54a45b0b5b1cfb49ad1.1635338283.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0c6a08c714aeb6dd96b5a54a45b0b5b1cfb49ad1.1635338283.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Oct 2021 14:38:37 +0200, Geert Uytterhoeven wrote:
> Document the default value of max-speed, as used by
> linux/drivers/bluetooth/hci_ll.c.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
>  Documentation/devicetree/bindings/net/ti,bluetooth.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 

Applied, thanks!
