Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08D971CC59B
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 01:48:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728356AbgEIXsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 19:48:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726356AbgEIXsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 May 2020 19:48:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAB68C061A0C;
        Sat,  9 May 2020 16:48:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id l11so404240wru.0;
        Sat, 09 May 2020 16:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=oyJ9nfaDUEIZnN/e+zHAsZdUiuqhaxkOPWRplLzcQ6A=;
        b=DRsTwl19t8xopKLHr4iQyjD9C55iK0dQu5wGE1q8OXbZn8Vavxhh63x4uHsQUC4u5g
         691Z1aQwodveE+ZggjmizUuz6Vbd9BQIWZABDgiFenzDusgF7/pXUDvvvmnAqr4wrgC6
         nIJI8sPc4LqYAU28SYgrddY045jR5W6/DbsNK1dn40Gkw5uUK6+wRp8OKn7XmUanv3zv
         toQEfxYHusp3pjfKjv/jjssXDev7FbfhKck9Pzg7lVFERm4Z88UPhdqbu3XC+bKyilTA
         yJj+B/Etk+TYiFPKPQBn5PKIemHdWd+BwAPc5XGGUZKT0Tsf3LzdXiWg+8ejtHbOA1P2
         ZdUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=oyJ9nfaDUEIZnN/e+zHAsZdUiuqhaxkOPWRplLzcQ6A=;
        b=JzYL6w7NFZxmIDMRBLCZkXBtkeKUHKcozE6r77EE4quUvHKBjTPBxbQUrmaYl/XDx7
         T76ZRlILGH1lIT93QccW27+PItzpxkPBft/ZfVYLHV29fZLCLD5vY0j1nPJ/x0shcA2Z
         G2oNFw+FRAsgLfQfiEHmma7lo3mgrYGJAizBTxEoK/uyP13g5oPBU2rk56z6LC/Cbcx5
         NtrKvtit5Nux4ar8XIe1ufq41wL1KzTf2g8xciSagreFG2JGLo2cVz+vxZGQbuIUfTZ0
         ESSv9SRjjaPKIN3HQ+9UJXurM9HoSoBkJz5mmXmV9evUikwYTOjsX9ENDq1FJ2S6saAS
         vwvA==
X-Gm-Message-State: AGi0PuYC6YZMRa3RzObAPP2mkcP1rrYRtmwJ0Ec9nR8dS7SDgfgpfNfk
        qkR3W84J0Ay3L6Ii6GbbJDHYiT5O
X-Google-Smtp-Source: APiQypLfRH2IA7FwUpetdHnkDTclvm0ULXVykfuZQ5fCY9fImeAN9W1pRuJabPXAfeSuS06Yzlq4UA==
X-Received: by 2002:a5d:6a85:: with SMTP id s5mr10521210wru.122.1589068091217;
        Sat, 09 May 2020 16:48:11 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g25sm19330846wmh.24.2020.05.09.16.48.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 May 2020 16:48:10 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: phy: broadcom: add bcm_phy_modify_exp()
To:     Michael Walle <michael@walle.cc>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>
References: <20200509223714.30855-1-michael@walle.cc>
 <20200509223714.30855-3-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3f1028e3-7cd8-6159-bfca-2718c4e22a16@gmail.com>
Date:   Sat, 9 May 2020 16:48:08 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200509223714.30855-3-michael@walle.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/9/2020 3:37 PM, Michael Walle wrote:
> Add the convenience function to do a read-modify-write. This has the
> additional benefit of saving one write to the selection register.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
