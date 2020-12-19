Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E2242DEC5E
	for <lists+netdev@lfdr.de>; Sat, 19 Dec 2020 01:26:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgLSAZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Dec 2020 19:25:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725914AbgLSAZF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Dec 2020 19:25:05 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39984C0617B0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:24:25 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id b5so2257650pjl.0
        for <netdev@vger.kernel.org>; Fri, 18 Dec 2020 16:24:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=YLHp6XoiAnLdgiBSw3CYGVylQZ3lIJLdYmuZRtM9bSU=;
        b=VUFCbdBKD6uoPSxRqaEoagO63iKB/LbxnA3m3k6qmi51MxODjzFTFWE7j9jNCN3aAH
         0Wviw6M5MP9Ka+bQxtgKL8+XPI/Qy/BvJEj27ED88idASyiJ5UTVpqRA4v0LhqXgInUi
         LhraHHTf3yJKpWHbyyo7djRrLVDV7RGcx86uX8knVLk6DJDY1Vq6ZrpfCURTVJkU1ex9
         hQktAcZBW0Ugj5Hq77m6dCkTAFmFgh/m7NyLdC2tfsnVhE8KOst0ZO2XWNnXG6XU/Urf
         d214Rin2NfwM6g4wWRn4bl2jz2K7rHa/egoPT9oQmPOavve3dBYioTKlhWEmMw4ft8RB
         Ak9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=YLHp6XoiAnLdgiBSw3CYGVylQZ3lIJLdYmuZRtM9bSU=;
        b=dfuG60X//yHdGgozu15dSVryBbDzv+xf6Mtxme5u82sqj0sivIUrOYZ42WIRKowCYO
         MVxAnErAITZ9d4J4p40PO61MH95nHG5YiuCVj1FWV0wLKK+WC+lMsljeogAEV+h+P9TU
         JuEygVBcky94zy/lz7Y4Vt8i6Cbspcj2NTVvitTmI3mvt5197Du2kZtpKyNUtH1RbvZx
         V8YA/l1OOziuCWDXN6zR55Y04iPtef8I6SDOod/JZF0rxjiHZS19jfouJebFU2QWQT8r
         lJ2RBYWeYIam0PpPduDbfgRS2AjdOyt57UpcFVDH3ggu2d6dJ7AOMGiTHxb2nWRiZ4Vs
         Wgmw==
X-Gm-Message-State: AOAM5332sIMCYG9E5GAoOfjUs5S0F2nhw+Ixiwao0LYhhizItnngNkzD
        LB4vWawF9yDCsh/3zyDeaP2PEPC53fk=
X-Google-Smtp-Source: ABdhPJyYQN4T8YIScvlfryIVeBxSjlwHWLeZqJeQMthANe5B7lP3BoKLOip8+e75WC4/zXT1HUHkpQ==
X-Received: by 2002:a17:902:e98c:b029:da:cb88:f11d with SMTP id f12-20020a170902e98cb02900dacb88f11dmr6823390plb.17.1608337463380;
        Fri, 18 Dec 2020 16:24:23 -0800 (PST)
Received: from [10.230.29.166] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id j14sm8497200pjm.10.2020.12.18.16.24.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 18 Dec 2020 16:24:22 -0800 (PST)
Subject: Re: [RFC PATCH net-next 4/4] net: dsa: remove the DSA specific
 notifiers
To:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org
References: <20201218223852.2717102-1-vladimir.oltean@nxp.com>
 <20201218223852.2717102-5-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <3da4edeb-6d12-8166-dc0f-ede5757454cc@gmail.com>
Date:   Fri, 18 Dec 2020 16:24:20 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20201218223852.2717102-5-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/18/2020 2:38 PM, Vladimir Oltean wrote:
> This effectively reverts commit 60724d4bae14 ("net: dsa: Add support for
> DSA specific notifiers"). The reason is that since commit 2f1e8ea726e9
> ("net: dsa: link interfaces with the DSA master to get rid of lockdep
> warnings"), it appears that there is a generic way to achieve the same
> purpose. The only user thus far, the Broadcom SYSTEMPORT driver, was
> converted to use the generic notifiers.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
