Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19A0070A40
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 22:02:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732457AbfGVUCK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 16:02:10 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:44242 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729858AbfGVUCJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 16:02:09 -0400
Received: by mail-io1-f65.google.com with SMTP id s7so76637415iob.11
        for <netdev@vger.kernel.org>; Mon, 22 Jul 2019 13:02:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sifive.com; s=google;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=7KHxh1QD/oXTDWc3Ol8Je8VksYYJh9G9PLns3mcwbuo=;
        b=bTR8i8zUllpMoZ40e03tB7gNhfdJCmmPPAe3V3S37KemxLp2Pfxvdg6aqvRR3nOCMy
         HJUD6xok/NPrliUcSvpBk5vw9NErK3Sgck4dkOw5uYesjEvb0gHvhsbP2cK1sr4pp5Cz
         oVd9jSLisJxIT7CfnmqtAdZwZDq2f6Swd2q3xGrPkPfYRkIoWaPJ5i28Klj54ARyZFTH
         ciWWyOR6+9PFVmVxngR1A312ewaEpkO9R7ubfD1Y6Ulr6DiDalliFyWtv1Ab1hlVpOWK
         zZCh82ajNKWjL+YqFRpoPFhpfupq2020UWCY+v9nviowDi4pL+x/sHuOQdmywjW+ViEY
         zz2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=7KHxh1QD/oXTDWc3Ol8Je8VksYYJh9G9PLns3mcwbuo=;
        b=JPvtIrm2TcrBAPd6RoqUNyIh4UrmDB/EaeaTVj8RjulqGNiLBjAn4TkOVSe81Jyb4S
         LC1F0iEbrHpOOKpvHLNDhRGgOFV+Q4vuwh4f/7xOz0n6nB+UjvUmP45MgPMrNVR4D7HD
         vJp/rGr8mCBv1qH/EsWZw5GsroAlY68chmqqCUmMR9gdtEKJnOF8re3BYXZI9Tmc1Pq3
         VRh+tdw32TTdoynrdQ5GjLO5GDaTstBJkdtDnfJ+Xh2oz7Q4UsAgxQKnQSMikwpM/MLV
         9kW4uQ5C1aQoVcr1WgnlyFOkDOzUaaDxda9SsW6SzqY2z0Vpk7AmY7zvpn4EJ+B2EX3h
         eaLg==
X-Gm-Message-State: APjAAAUL6WKqvPdBLHd5nqRRcr79RR8cr8tH5NZlZ3fxcTM5xd89PrOb
        NzKyttQkexN23dJFn+DucudC0Q==
X-Google-Smtp-Source: APXvYqxyOswcj7g0LDvyDOV3fbWCFcNrYA4iTJciHHWKaqUGvlZ1qgSVQwNjOcAJl5e0SpvoVdMXaQ==
X-Received: by 2002:a02:bca:: with SMTP id 193mr35203345jad.46.1563825729108;
        Mon, 22 Jul 2019 13:02:09 -0700 (PDT)
Received: from localhost (67-0-62-24.albq.qwest.net. [67.0.62.24])
        by smtp.gmail.com with ESMTPSA id b8sm33365705ioj.16.2019.07.22.13.02.08
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 22 Jul 2019 13:02:08 -0700 (PDT)
Date:   Mon, 22 Jul 2019 13:02:07 -0700 (PDT)
From:   Paul Walmsley <paul.walmsley@sifive.com>
X-X-Sender: paulw@viisi.sifive.com
To:     Yash Shah <yash.shah@sifive.com>
cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org, mark.rutland@arm.com,
        palmer@sifive.com, aou@eecs.berkeley.edu,
        nicolas.ferre@microchip.com, ynezz@true.cz, sachin.ghadi@sifive.com
Subject: Re: [PATCH 2/3] macb: Update compatibility string for SiFive
 FU540-C000
In-Reply-To: <1563534631-15897-2-git-send-email-yash.shah@sifive.com>
Message-ID: <alpine.DEB.2.21.9999.1907221301490.5793@viisi.sifive.com>
References: <1563534631-15897-1-git-send-email-yash.shah@sifive.com> <1563534631-15897-2-git-send-email-yash.shah@sifive.com>
User-Agent: Alpine 2.21.9999 (DEB 301 2018-08-15)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 19 Jul 2019, Yash Shah wrote:

> Update the compatibility string for SiFive FU540-C000 as per the new
> string updated in the binding doc.
> Reference: https://lkml.org/lkml/2019/7/17/200
> 
> Signed-off-by: Yash Shah <yash.shah@sifive.com>

Reviewed-by: Paul Walmsley <paul.walmsley@sifive.com>

- Paul
