Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D402D96D5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 18:18:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393613AbfJPQSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 12:18:24 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:39029 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727154AbfJPQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Oct 2019 12:18:24 -0400
Received: by mail-lf1-f67.google.com with SMTP id 195so5028907lfj.6;
        Wed, 16 Oct 2019 09:18:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y1u4tBuRnd6ZjEytQ7zg9F82TRiFsD/C7WX2wqbch+8=;
        b=Y7XnxeWv16vJcEIy56IkwtxL2LWSOOIclCzC6NanfV6A6wNIdsg7+3EZdMtgtnNVv7
         xdIrJI/hLsYV97HRn2qp9huBjieN/OP5vRzMRErA11sJbn4U6/CdxhUJgtOMxIIDiElQ
         Q3o+lJ42HjrYPICB6LWJXJSYr7Gt1dymkiTZHYUoowNdz7G2MKmqOtSOzRYOKdHts0Sn
         6ZYcuo60ZcFiPCWA9rD4wKtWOlZs2u0XKR92+SqRdDkYyd6ChC8r4ZD3dXHF3k+BzLPQ
         mD9kUuQ7qTanPS8PDIVPqvyS++w5wJyHLxpepf3r1TOh8chtfJJXsTQ3Tqrs+B0lXyoX
         2rKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y1u4tBuRnd6ZjEytQ7zg9F82TRiFsD/C7WX2wqbch+8=;
        b=WfcuoQNzPv9bk+btBmuqoeGUlPpdXUg3rCVX+dtVuPnHDdLnI9PZ6Kd0peeBQSD5PW
         ih7GOuRC9TvItyjnq98+atJYANsdx1nY7DMzPIc0Nzrag+IQGzO8Tt4cJ32BdsWaL93A
         ZIvj4y4qIfEHInubsYaE/TTAi9UCTrO3na9cSy9FzSgC5gNS1CFGcnhNzpYaMk2b9TnD
         n5egDMqSC9h6lB4/bvC0GoIRjdM4Htv6DgNiNRI2yu0y+EJj5t1V+vzASeaBfACSapXk
         3RGI/3CNvA9GwGBNZWG19S6UAZsqwKyr3DH1CKUb1KkkVuhEsuaM4m1UGZe/DwwFJ63a
         7mUg==
X-Gm-Message-State: APjAAAX/O3x1HaqY1BI0tJMQx+F7bXfRZ8UOERDsDPZEwzaNQkgeQIHo
        y8sk5Ff8JA5KYamGdLfHHK6c61CQ18nh1ahVPo0=
X-Google-Smtp-Source: APXvYqyVZwfMVjw15XoxG0GOxNLuRAAnl9bDYbPMHaNMcwAzDZPkm7NBafCKz09RK7HbPatoJcJIcT8/B0ysUieaPvg=
X-Received: by 2002:ac2:4888:: with SMTP id x8mr25064278lfc.90.1571242700210;
 Wed, 16 Oct 2019 09:18:20 -0700 (PDT)
MIME-Version: 1.0
References: <20191014061549.3669-1-o.rempel@pengutronix.de>
 <20191014061549.3669-5-o.rempel@pengutronix.de> <20191016130057.GF4780@lunn.ch>
In-Reply-To: <20191016130057.GF4780@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 16 Oct 2019 13:20:31 -0300
Message-ID: <CAOMZO5BRfkz+VBR6NRjSY6CymyuXRNqLnF_bOao90j64+sYZtQ@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] net: dsa: add support for Atheros AR9331 build-in switch
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        Chris Snook <chris.snook@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        James Hogan <jhogan@kernel.org>,
        Jay Cliburn <jcliburn@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Rob Herring <robh+dt@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>, linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 1:01 PM Andrew Lunn <andrew@lunn.ch> wrote:

> I think C files should use /*  */, and header files //, for SPDX.

Not really.

From Documentation/process/license-rules.rst:

"C source: // SPDX-License-Identifier: <SPDX License Expression>
 C header: /* SPDX-License-Identifier: <SPDX License Expression> */ "
