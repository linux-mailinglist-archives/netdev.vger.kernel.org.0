Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6E333AD120
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 19:25:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236001AbhFRR14 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 13:27:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233617AbhFRR1z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 13:27:55 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB221C061574;
        Fri, 18 Jun 2021 10:25:45 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id D7E7D9A2;
        Fri, 18 Jun 2021 17:25:44 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net D7E7D9A2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1624037145; bh=VWmAA0YzzpNvxcoFBtGHf43nmNUWhu3CK8g3vdxbsRE=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=b01VgQRUzhEO5ndT69988RRG7Ev9fbKU5L28nWrpKNKt5OdisyW4eyn2ulpFyGIOv
         gXXfDjDvkvsOt9eDIWtOXhJQKLUGsiKa05hhZPMYF44dVJxwT4IvUHh6Kynh+kkHDU
         D9UUQ4ALmlVEJGt0Dq2t12XkhF0slNOjEUejb8ZjPAWObLs6SYTtHJOQ9qENWcPNji
         KxLmlcO17k83mlWjiWRFP8DtbWCoW8ZoGib0arLJ09yxiXArzwyd4AOyzb+yc8xvBQ
         9iCRsurkJwvXKAR+ENbp0XeIhB1uFMrMSJ0DavligyWb2Wpm4S3jgddzduwIyLLjWU
         mdenQMhW1oK0Q==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>
Subject: Re: linux-next: manual merge of the net-next tree with the jc_docs
 tree
In-Reply-To: <20210618115533.0b48bf39@canb.auug.org.au>
References: <20210618115533.0b48bf39@canb.auug.org.au>
Date:   Fri, 18 Jun 2021 11:25:44 -0600
Message-ID: <871r8zrso7.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Today's linux-next merge of the net-next tree got a conflict in:
>
>   Documentation/networking/devlink/devlink-trap.rst
>
> between commit:
>
>   8d4a0adc9cab ("docs: networking: devlink: avoid using ReST :doc:`foo` markup")
>
> from the jc_docs tree and commit:
>
>   01f1b6ed2b84 ("documentation: networking: devlink: fix prestera.rst formatting that causes build warnings")
>
> from the net-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.
>
> -- 
> Cheers,
> Stephen Rothwell
>
> diff --cc Documentation/networking/devlink/devlink-trap.rst
> index efa5f7f42c88,ef8928c355df..000000000000
> --- a/Documentation/networking/devlink/devlink-trap.rst
> +++ b/Documentation/networking/devlink/devlink-trap.rst
> @@@ -495,8 -495,9 +495,9 @@@ help debug packet drops caused by thes
>   links to the description of driver-specific traps registered by various device
>   drivers:
>   
>  -  * :doc:`netdevsim`
>  -  * :doc:`mlxsw`
>  -  * :doc:`prestera`
>  +  * Documentation/networking/devlink/netdevsim.rst
>  +  * Documentation/networking/devlink/mlxsw.rst
> ++  * Documentation/networking/devlink/prestera.rst

This is the right fix, thanks.  I got that :doc: directive taken out
even if everybody chose to ignore my request to that end...:)

jon
