Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A39309C8AD
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 07:27:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729262AbfHZF1g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 01:27:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36588 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbfHZF1f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 01:27:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id g67so14502936wme.1;
        Sun, 25 Aug 2019 22:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zhSMjbP0Wu5ZMMWkC9ESobPUe2Y7GCnZAY38J4ap/Fg=;
        b=Wrtgv+P5j+JqrzX4i5a2m0Hf6aY2gVCrX4H2C7/CzDNLSAFsq/LoIOtFetZ7PAh0YC
         Unvv85fAEzk9ao6NSQoXBEMhJ6i0f3m9/sHauFJ17Y3B6xSemwsNGUtKuchuraU+9DAn
         GqGXQEv5AptLkXbzdnWa3Nzwp+4LDv3d7SKmYRb8i0gosMezsJZRZmc0HcN7fVgL9kk6
         5ldBeWlWEF+Y9PcKOwqWfCt+F7Uw0O+zs0r9OAgb8kxggcSGEFGmzb8AUcK1xtbL02lr
         QCIf7CoaEC6xLB+/AKoZzCy1aoSTV3P0GlJoTHjn+zR97eahAoxn3Cxuo7Ocdw3+2IIT
         2nuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zhSMjbP0Wu5ZMMWkC9ESobPUe2Y7GCnZAY38J4ap/Fg=;
        b=pHF8vzw0Yfv6P/JsOPyN+DKtwWsPmSmQMGKJvf1drOIAAr+GDGNXYnXvXsXdOK+xKk
         o6Hwy/9sZpoD+ZrzQy6cRYU9+B4KVnzdRDP/GEnPx3enQdAxWIvVJJy5u6oLQKHLYaOU
         q11gOrwo7Q2o7OHdksWGkgqCyUMS+lfGI9RjVel0BGupkP11xtrMCKRKUlMmV7jcEXf4
         ubpHgR+t8ZY82jM5PFAP9H53X41tvVNTZU3uSHXUG3I3deJALsi838E+JHXTMhkQHGXs
         MrH/u7stONWuCx8xArG2pM9ao74BdTCSOZ40qEHsc4r9/1tWvaBtS8DGgJc4r1iReSng
         JHTw==
X-Gm-Message-State: APjAAAXrA5qTZQRr6QJDbmEcVCcWJs8H5B3PW+Nr/deDYy60etAvSfwI
        QkcEU52fNg7bP9GxrS+XSQfUgtHw
X-Google-Smtp-Source: APXvYqwt/FP7G949MiCl/9GTtZTkNxG2IhYcOlnbipyXfe2PL/fH+6H0ruKcHMUQPWqNlmK9CWHpaQ==
X-Received: by 2002:a7b:cd0f:: with SMTP id f15mr19733964wmj.86.1566797253000;
        Sun, 25 Aug 2019 22:27:33 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f04:7c00:711f:ea9c:2f8:2101? (p200300EA8F047C00711FEA9C02F82101.dip0.t-ipconnect.de. [2003:ea:8f04:7c00:711f:ea9c:2f8:2101])
        by smtp.googlemail.com with ESMTPSA id l15sm9029859wru.56.2019.08.25.22.27.32
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 25 Aug 2019 22:27:32 -0700 (PDT)
Subject: Re: linux-next: manual merge of the net-next tree with the net tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>
Cc:     Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20190826122726.145f538d@canb.auug.org.au>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <6994fc11-51da-3dc2-c213-09496b657abb@gmail.com>
Date:   Mon, 26 Aug 2019 07:27:26 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190826122726.145f538d@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 26.08.2019 04:27, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in:
> 
>   drivers/net/ethernet/realtek/r8169_main.c
> 
> between commit:
> 
>   345b93265b3a ("Revert "r8169: remove not needed call to dma_sync_single_for_device"")
> 
> from the net tree and commit:
> 
>   fcd4e60885af ("r8169: improve rtl_rx")
>   d4ed7463d02a ("r8169: fix DMA issue on MIPS platform")
> 
> from the net-next tree.
> 
> I fixed it up (the latter seems to do the same as the net tree patch) and
> can carry the fix as necessary. This is now fixed as far as linux-next
> is concerned, but any non trivial conflicts should be mentioned to your
> upstream maintainer when your tree is submitted for merging.  You may
> also want to consider cooperating with the maintainer of the conflicting
> tree to minimise any particularly complex conflicts.
> 
Due to other changes there have been two versions of the fix, one for net
and one for net-next. Therefore ignoring the one from net when merging into
net-next was correct. Thanks!
