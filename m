Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C843FE43A
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 22:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231506AbhIAUrn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 16:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231373AbhIAUrn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 16:47:43 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1A4C061575
        for <netdev@vger.kernel.org>; Wed,  1 Sep 2021 13:46:45 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id n18so416699plp.7
        for <netdev@vger.kernel.org>; Wed, 01 Sep 2021 13:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=+e3t1QO8rBHZ3DmbXetxlF4TSoQ6ZSKNnDh2xeJZLJY=;
        b=aEes/O2Qi4a1c/SxHjEPsM+jn5cjZMuqlYrCiArtLGPxsx4c2v1SFRwuP+kJHSRrd/
         uLD6cd5oDGBjQqli/U2uZHAebxMRmHJ45Hm2k4noKl+PAEgSUOzExfOUY6uBUaP+32oN
         x8hvesSxx7V0ui6E3sQg3rJ2e2DZPIXnITAN+aCTBMzsq3ba7boxWuLquzvN9JEYNH1G
         gTrTPRCTfV8l42pTtcfmEnyf6T/gY1aHLIBiMORxDFgnV/Ur/ygUm21luNxJ80i4TCBo
         IOJrJFnqJnWrDFoTRbzM3bkTRTMz+9xOOq6RV2DXxCzPL9cvlQ2Q4gY+UTrEvHyEU76f
         vRyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=+e3t1QO8rBHZ3DmbXetxlF4TSoQ6ZSKNnDh2xeJZLJY=;
        b=CJa9Zu2PBMfEK+4vcl3AtQrAKJ5i3Z7JBLgvPbi6ygsueEL8vUivmeOdzsSvuskkDw
         znJYNpeUOYF6HNxIuCohNUBuIDm7xXnnK5UYZZtGoNNWsY0k/Ell8WJRuGBsZF6gumY3
         OtOlUKbnh+NWXaupmuStD+Lkf0mlenFsGdQZAX652fU5tf/cMf+bLtPGrXQS/oiIvPY9
         6QsHPH47q0aOahl0y/0GwI0BonF7PfPsv19AKyHuUWBE+7qf0/Ie2QIeS3CP27LBRuBp
         kkt3XULy6bxeNWYoqoXWfe+WHwg6AWWhXOvKuJWU0ENoWtTjRtTe0bX0aZFuInDUGwxx
         Dwig==
X-Gm-Message-State: AOAM531iMGTNlDkZHwXhgfjEAPF7lmdHvnM31VrfR03CCzWvURnuQizm
        c1ZJqugs8E9GBNbwrxyhjW00uAIQSps=
X-Google-Smtp-Source: ABdhPJzJPI6F8tV9696mvwsvAeV3kzUbPnUG9tza/Py5s3Gl7yi1dGH4z7jUVBS28zg2iFQJ/A5u/A==
X-Received: by 2002:a17:90a:808b:: with SMTP id c11mr1334528pjn.33.1630529205335;
        Wed, 01 Sep 2021 13:46:45 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id n8sm322037pjo.45.2021.09.01.13.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Sep 2021 13:46:44 -0700 (PDT)
Message-ID: <9c0c1b99-d3ec-231c-112d-4e279ed0a7c7@gmail.com>
Date:   Wed, 1 Sep 2021 13:46:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH net] bnxt_en: fix kernel doc warnings in bnxt_hwrm.c
Content-Language: en-US
To:     Edwin Peer <edwin.peer@broadcom.com>, netdev@vger.kernel.org
Cc:     michael.chan@broadcom.com, andrew.gospodarek@broadcom.com,
        davem@davemloft.net, kuba@kernel.org
References: <20210901185315.57137-1-edwin.peer@broadcom.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210901185315.57137-1-edwin.peer@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 9/1/2021 11:53 AM, Edwin Peer wrote:
> Parameter names in the comments did not match the function arguments.
> 
> Fixes: 213808170840 ("bnxt_en: add support for HWRM request slices")
> Signed-off-by: Edwin Peer <edwin.peer@broadcom.com>
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Michael Chan <michael.chan@broadcom.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

# Just because you copied me internally ;)
-- 
Florian
