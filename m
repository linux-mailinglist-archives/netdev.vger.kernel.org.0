Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C38DE2E8
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 06:08:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725827AbfJUEIg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Oct 2019 00:08:36 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:43776 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfJUEIg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Oct 2019 00:08:36 -0400
Received: by mail-pl1-f193.google.com with SMTP id v5so1233541ply.10
        for <netdev@vger.kernel.org>; Sun, 20 Oct 2019 21:08:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=encNu5/Y7nZuPIF5BnSSDFgPQoXnK58k6n1ao+O1nfQ=;
        b=hUtREW1MZ4K2PyAvkn04H9sJCkZOJGPrU6UHIjjkauHDX8ZD4yfoAc3MkODSy8NIdj
         fVbF2xTaic3FVu6TLr9hbMQ9kFQ5JGwnGRNRBuXU2MBlfHXzNR2JzUzhnfb6BDP/8cCe
         zRR2Q3odHkLSl7yEraZa7fE7TNaKZoEczFikFbBxMCl56y1LIfn7x9Zz0duTWcD/URHP
         F7nhqOgssoLybq/Pok4n5rdxp10LC0q3ZPWmw9/bg0xKlUaYQrXVCY9rij6B558Q+MX/
         WEkMhCD5XWtJK37b+N8C5NFQnSEZKdYm0mvslRaQVUnv0E87kr2vPiW1Y1Q9+lBafTVf
         TV+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=encNu5/Y7nZuPIF5BnSSDFgPQoXnK58k6n1ao+O1nfQ=;
        b=kI9U78JpoR/HZICo0spH+9HR0LWw5EPrAmCX+zplYi3/h/ZslMMJpiwA6rm3r0U79r
         t49Knh0UY38SjUSGvAdLjBMnZNDFssdoid5WWPyyfZr97zzJTn8V9YNb0fF34hQaFGOE
         wVZ3K8oQ/ZmOgH4KtUmJ7gwmuaLaIzmyfczozvL+bQKS7mXP8ZCNGqRYPrHlMxRsSM5J
         xpYDgHYbO67LXaXM7DTbsA7LCNCf+rVAKtf0SnI7wnqjl8Q3LulvCjXNRrL5SviGvfsh
         gxWlvkRfXu2a9PCsNF+dqVWePgQIgUxwwz4jlwMR7/JqScLbsroB8NzkxTLPYaUvHptX
         E3CA==
X-Gm-Message-State: APjAAAXfns7Uz7KtQ6fff6iFfYSolI3vRhnWa6L7CCmEq6X1R55NfV5B
        N633IpeZDGWKF/fWCVuUvHTuGq+z
X-Google-Smtp-Source: APXvYqwtEwpPB1Ml6gyuNpncGb/3Ijy/VdlgApsQnf+B1MU3WlVyOyVQjKgYwQacjG44dl6EwP10ZQ==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr22231813plp.223.1571630916015;
        Sun, 20 Oct 2019 21:08:36 -0700 (PDT)
Received: from martin-VirtualBox ([1.39.141.104])
        by smtp.gmail.com with ESMTPSA id r185sm14316667pfr.68.2019.10.20.21.08.34
        (version=TLS1 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 20 Oct 2019 21:08:35 -0700 (PDT)
Date:   Mon, 21 Oct 2019 09:38:29 +0530
From:   Martin Varghese <martinvarghesenokia@gmail.com>
To:     Ben Pfaff <blp@ovn.org>
Cc:     dev@openvswitch.org, netdev@vger.kernel.org, pshelar@ovn.org,
        Martin Varghese <martin.varghese@nokia.com>
Subject: Re: [ovs-dev] [PATCH] Change in openvswitch kernel module to support
 MPLS label depth of 3 in ingress direction.
Message-ID: <20191021040829.GA19653@martin-VirtualBox>
References: <1571581532-18581-1-git-send-email-martinvarghesenokia@gmail.com>
 <20191020190706.GC25323@ovn.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191020190706.GC25323@ovn.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 12:07:06PM -0700, Ben Pfaff wrote:
> On Sun, Oct 20, 2019 at 07:55:32PM +0530, Martin Varghese wrote:
> > From: Martin Varghese <martin.varghese@nokia.com>
> > 
> > The openvswitch kernel module was supporting a MPLS label depth of 1
> > in the ingress direction though the userspace OVS supports a max depth
> > of 3 labels. This change enables openvswitch module to support a max
> > depth of 3 labels in the ingress.
> > 
> > Signed-off-by: Martin Varghese <martin.varghese@nokia.com>
> 
> Thanks for the patch!
> 
> Usually, for kernel module changes, the workflow is to submit the change
> upstream to the Linux kernel first ("upstream first").  Then, afterward,
> we backport the upstream changes into the OVS repository.
> 
> I see that you have CCed this to the Linux kernel networking list
> (netdev) but the patch itself is against the OVS repo.  Probably, if you
> want to get reviews from netdev, you should instead post a patch against
> the net-next repository.
> 
> Thanks again for working to improve Open vSwitch.

Thankyou for your mail.
The same changes are being discussed in netdev@vger.kernel.org.
Along with this patch, V2 of kernel patch for net-next repo is also submitted.
