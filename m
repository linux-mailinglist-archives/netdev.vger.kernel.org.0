Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA261B0C4A
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 15:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726614AbgDTNNc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 09:13:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726050AbgDTNNc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Apr 2020 09:13:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFC50C061A0C;
        Mon, 20 Apr 2020 06:13:30 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ng8so4566134pjb.2;
        Mon, 20 Apr 2020 06:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=1TAgcxIt86/pBZoXVfOkKX7rv0NrEGvRTPnHP44Lt+w=;
        b=WWDlb6SFnnPcrUNjIa1hQgMf2be2Ej55anqWOXEjcohow9GEJAFR8b2vFR/+Z6b3Ay
         ES6An7SYMLfKug3SNa/XyetLtJEmclrWAMjyWRWOP6nkoPcnCBeBl18P8Akes2xDHlYf
         y0vPqjQrRHxOBfxM9QeY5WcBYBnidKhOAlY2mo1DI64fwJK2LAEp9MgulN/oFINeDUTQ
         5M2MmSFQWHC2GMkIBOyf0ULo0o/m9S9qmj+NKeugqEFi3T2nxXWnBsx4RPFCw20cKMaJ
         FJ4Ks0a7HYY4CzGfhQjFwnSbKWA6c98nn0IjRp8aCRkzAlBLj1FH3WfKtL7YgSIwqjQZ
         PBOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=1TAgcxIt86/pBZoXVfOkKX7rv0NrEGvRTPnHP44Lt+w=;
        b=V4mtj8XeFYNc/JADQ9zMYxVhz9YkS7S1ITt7YVMnAgDSLFKXA2ZfcLzSWt7dYugJfX
         SETF7Ej9A2KqIfB6NiXxU5cvUuAZJO+DnQtbEhWRv4ekehjTIhmUzqCPPZbfV+fJYbG0
         tYW+//ghQ4aK1DMC/8eEyPbC8TbR4Fifk/a0pqfnWezZhcZ46f0Zv17dCsgfpke0iQSX
         pePEA+q4Bog86928zvxXPFHhJpm180BfTEdil9YLPiGmx7YVLsFIs6n3d8nmPs3mQGGL
         plzDaGRDkXpp8JSBxLYWPtMWJ08w9AMwwtIF08TXH79Jsas3ePsLhq3NR7SNGxIOgGBX
         CsBQ==
X-Gm-Message-State: AGi0PuZeBysAtgM9bsapfVOoyO1Cx/ge4vqUxhbQGcRWW/AB5gxNDd2i
        P/WFjFaBDicPi6Rl9S3tLN4=
X-Google-Smtp-Source: APiQypJU5VK8wVTpvE19z47A8p3kMYjIqaAA/yNAWadv9cPJFQp+9mZYnwvBoQhFFvunoy0bECEV6w==
X-Received: by 2002:a17:90a:32ea:: with SMTP id l97mr21405427pjb.50.1587388410421;
        Mon, 20 Apr 2020 06:13:30 -0700 (PDT)
Received: from localhost (89.208.244.140.16clouds.com. [89.208.244.140])
        by smtp.gmail.com with ESMTPSA id o187sm1052194pfb.12.2020.04.20.06.13.29
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 20 Apr 2020 06:13:29 -0700 (PDT)
Date:   Mon, 20 Apr 2020 21:13:27 +0800
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Coccinelle <cocci@systeme.lip6.fr>
Subject: Re: [PATCH net-next v1] can: ti_hecc: convert to
 devm_platform_ioremap_resource_byname()
Message-ID: <20200420131327.GA8103@nuc8i5>
References: <08979629-d9b8-6656-222f-4e84667651a1@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <08979629-d9b8-6656-222f-4e84667651a1@web.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 19, 2020 at 06:19:12PM +0200, Markus Elfring wrote:
> > use devm_platform_ioremap_resource_byname() to simplify code,
> > it contains platform_get_resource_byname() and
> > devm_ioremap_resource(), and also remove some duplicate error
> > message.
> 
> How do you think about a wording variant like the following?
> 
>    Use the function “devm_platform_ioremap_resource_byname” to simplify
>    source code which calls the functions “platform_get_resource_byname”
>    and “devm_ioremap_resource”.
>    Remove also a few error messages which became unnecessary with this
>    software refactoring.
>
Markus, Thank you very much！yes, your comments is better. I will send
the patch v2. Thanks again!

> 
> Will any more contributors get into the development mood to achieve
> similar collateral evolution by the means of the semantic patch language?
> Would you like to increase applications of the Coccinelle software?
>
I want, but currently I don't have much free time, sorry！

BR,
Dejin
> Regards,
> Markus
