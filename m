Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29C93560F0
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 03:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343581AbhDGBss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 21:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241481AbhDGBsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Apr 2021 21:48:47 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87810C06174A
        for <netdev@vger.kernel.org>; Tue,  6 Apr 2021 18:48:37 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id ep1-20020a17090ae641b029014d48811e37so452078pjb.4
        for <netdev@vger.kernel.org>; Tue, 06 Apr 2021 18:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2gtVZVJp8iFTB70QEA6e3+WXi/38mOeiALLsNtUI0+s=;
        b=K3yj+nX7lz4TuimRslkSJH7odpClI9oFgZ3wOJilOH9LtQW2RTkwACiYRpjOyAtZJ2
         sHMz/YAZYQUgJwKKEly6pKhZgeO8UsV4FJ16MS/f2jc5XW7STi/2KEDfVfysevMIopJV
         VzNycE1zoMhvOguS8iL5lomP4nBjjek+C7C8RZDUKdGaxE7mCS3wnwobJuzQvNEjl3D0
         z7AFuJXyXeeMcSo4vdPvQBu07azX1m/b/BRB3rqrc6AOa626T81f3JRonsTSGyD0jQpK
         Y3QusdNN4/OiSpMo8BN8HjYYvaA81BpigWu1afRpAFgs/6s5lE6zNNfdpy/5L4nWWEZr
         oxwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2gtVZVJp8iFTB70QEA6e3+WXi/38mOeiALLsNtUI0+s=;
        b=AdFrQXZR3l/fiS3AAlGK3Yu1oojVWQInt8x3OA6Ssl6QcPB18EKGCmy1Y5Jg1MIA3H
         RqliVZJ7WxoSB5/IEa6Euv7tR55DMPr8nvVVyeDCxbsjTLE82VaS+oV21FpJhrxOQjSI
         oCH4I7df6cMkWId4rszDHtyfXdlJGEvAPUTALq3tLIuMlHdog0JMnPiiV/G6MfZ4oHK1
         P7BDSXUgiKHXdcCy5KDMW5XkoXX9w8ynzXVCqdCor6SR+Uy1sH2Y6trnup0dzcTSmUve
         OEdKMwCuAGUnJXO5R5s/k02u9RjN7QnuCyLiRm/r6CH/OISQT21RDS/y+XGN2KSONb+E
         MZtg==
X-Gm-Message-State: AOAM530R6qj462SRJUpEkW5omectRN73DwUWdjkVeT/mzedj3TZCmWtA
        lF+DRo9fMW6V/1XK5h4MsoJUpMsbyV8=
X-Google-Smtp-Source: ABdhPJwWZJF3Ca9dHkM66YknDe+zuPrW724F494CuvB3XKPiPCRnoZtmGKm7mUOfF92Ihe30tucYRA==
X-Received: by 2002:a17:90b:4b0e:: with SMTP id lx14mr920277pjb.147.1617760116585;
        Tue, 06 Apr 2021 18:48:36 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b7sm6003583pgs.62.2021.04.06.18.48.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Apr 2021 18:48:36 -0700 (PDT)
Subject: Re: [PATCH net-next] ethtool: document PHY tunable callbacks
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz
References: <20210407002359.1860770-1-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fbb63ed5-697b-87b5-e4f7-67914b1958a4@gmail.com>
Date:   Tue, 6 Apr 2021 18:48:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210407002359.1860770-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/6/2021 5:23 PM, Jakub Kicinski wrote:
> Add missing kdoc for phy tunable callbacks.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
