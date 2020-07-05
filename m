Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FDF214F76
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728341AbgGEUlv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:41:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728158AbgGEUlv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:41:51 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DBFBC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:41:51 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id j20so442523pfe.5
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:41:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hA8cZ7kKOHppRjIw/fNtKFv2jf/xVUSjnR130duDW4g=;
        b=veK6jGjkTilVtk+X11sfUiy692Oq0juH71PpqF9mDPKJiU0AR3DClC90i94zGQYPEM
         d+9GCv/3A5nH3KHhYvZz5T+lP9sxn70zi+5wvQWlAJ6foQ4u8PhyKmU3YUXDjn32hifE
         29+ABYm1nvTP/yPe9fRy9a61xEs9ZTwZUguCt7Hv3o+/9XKR0HVytSZoVRZljjAbG1q9
         41vzdd/p+Z7dmuSnMp24340zIW6FHC1CWxMC2UYjl+lgaDN+cyH+FevwY33ydki8XlSO
         II7UHj0iitQSUV7TACod6aAuyMOTbKRI5w4AFBzNvugHUR0UxZZc6EOCWCQl13WlhSbb
         VlZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hA8cZ7kKOHppRjIw/fNtKFv2jf/xVUSjnR130duDW4g=;
        b=uRtcil+NXfPu6VOqDHFLOEmQW380almGUrFsMUKQYhsAI7LeGkCkMEfjDwV+uEuCON
         wt/THLZgcel6w/4EwEjbk9xgyvRHQkj5rGykTUIS1Qo/msSG4xnf5T0jZMq1nlnUcBao
         i7CJKpHTBVUQXyra+EjacUAj77tVTM2FnG3tdn3ur+/PDcsLI19VVIfgu1KUqFzjRdA6
         7+XyqQP2UxJTfYwFaJQdKsPFR+d9exTI3dZJOI6RZxZa3qu9xjM4KaQ/Dh7c7FOVneNe
         1ULyvHbkBLxlftsgZgA7kvyhdTsDJaOTNVK82XekrR+km/5DbYUb0Mbqs/y6ekukcj+V
         2LgA==
X-Gm-Message-State: AOAM5329RbWuyZ7JB1TQhNkK+C/3l8vk7lb800swBQ9KZXNr7KkWeaAI
        N0AwaBhsRmfkowoS3Dhsk+0=
X-Google-Smtp-Source: ABdhPJwGDEMUxcKlHIbcxIChvkVHFR+ccPNjMTishrupJ7qS4EjKTx0zELbsH3UCdFi9/0UpVcJuiQ==
X-Received: by 2002:aa7:91cc:: with SMTP id z12mr39547036pfa.239.1593981710820;
        Sun, 05 Jul 2020 13:41:50 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id d4sm16979800pgf.9.2020.07.05.13.41.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:41:50 -0700 (PDT)
Subject: Re: [PATCH net-next 4/5] net: dsa: tag_mtk: Fix warnings for __be16
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705193008.889623-1-andrew@lunn.ch>
 <20200705193008.889623-5-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <074021f8-e5a5-ba78-53f3-aaa2777017e4@gmail.com>
Date:   Sun, 5 Jul 2020 13:41:47 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705193008.889623-5-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 12:30 PM, Andrew Lunn wrote:
> net/dsa/tag_mtk.c:84:13: warning: incorrect type in assignment (different base types)
> net/dsa/tag_mtk.c:84:13:    expected restricted __be16 [usertype] hdr
> net/dsa/tag_mtk.c:84:13:    got int
> net/dsa/tag_mtk.c:94:17: warning: restricted __be16 degrades to integer
> 
> The result of a ntohs() is not __be16, but u16.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
