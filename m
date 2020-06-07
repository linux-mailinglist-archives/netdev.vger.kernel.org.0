Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551631F0DF3
	for <lists+netdev@lfdr.de>; Sun,  7 Jun 2020 20:22:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729917AbgFGSWc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 7 Jun 2020 14:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726850AbgFGSWc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 7 Jun 2020 14:22:32 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31BF6C061A0E;
        Sun,  7 Jun 2020 11:22:31 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id 64so645554pfv.11;
        Sun, 07 Jun 2020 11:22:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vry3kzQSZSZj1GOjJrxz4ScnVqaIH12RaFaPASZek+U=;
        b=iDzebIJHJf7odh4e8QzMcRtoVRsRZtinz4k4LNRZmVdpGdFgXQbz1B5/M8g+8kEY/+
         UVflb0WRTyAPyo+LhE8eXj05VuDbEflwtJ+tTJEpEo5CjJLY9bIlgJ892AM5HVsz85jR
         Goyi7rV/ehudyuPH61Bba4O/QkJGBkn/ayxyl7uNegRqHACuceY9NxV3tbwSFBBbjomW
         u0lB1CxY2OD++3iRSA8gkItw5Aw9gItuFNjjc7X/DNyjceHv0fo4orjaI1JEUTBZtOJ1
         qnN96mZbregCg5TDHehDy9fqxXAZTVDirVquZSeFHVWcW/4p1VZwhp3Fm6hn70/miIoD
         mqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vry3kzQSZSZj1GOjJrxz4ScnVqaIH12RaFaPASZek+U=;
        b=CnPIiOUNjnvz7Mb0gTuH9evgYtVbTOd/Xuvr5lZWTi3jNSqetg2O6y0dqEoLGzk59a
         AffiwkOmJnR9BqdXojy8P6C5Vr4mxynriLQoLosbdy7eYoq/v2qHOuWJAAeCLm49QuL7
         Cvdcm0WI5lhSk25bqQUrtAadMzQBPJs9tzpMvkzf1MXfQ/9c0SZv9VQactOWysthVZwR
         E5ta52A78Y/rHVk62sdW/rQyvuVs1pznXkn48bSKYsbXOj9ikDeuW60k4c2XMgDoOT7x
         NOmLSej/fL2iCw5Ktezy+2iSzxMz8Dri1le5Lg1Nzp+/rnVbj1vA7gFHtv+DsaurkHRv
         +7rQ==
X-Gm-Message-State: AOAM533bJjEXEFC9CUylLfX1PTurGmNzZpJHrlgGdEOGkp4DwoDZ7u0C
        jmh9NM9KKulHeVAkYl+zTlCYzSWi
X-Google-Smtp-Source: ABdhPJy62jH7j/cIfMv/xxnE67SJzE20yiddf/xsFbMbZdC0Xm/vseQLRubcLTYxqOMe+CR53mblLQ==
X-Received: by 2002:a63:f143:: with SMTP id o3mr18292135pgk.453.1591554150235;
        Sun, 07 Jun 2020 11:22:30 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id h3sm4132323pgd.0.2020.06.07.11.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Jun 2020 11:22:29 -0700 (PDT)
Subject: Re: [RFC PATCH net-next 10/10] selftests: forwarding: Add tests for
 ethtool extended state
To:     Amit Cohen <amitc@mellanox.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        jiri@mellanox.com, idosch@mellanox.com, shuah@kernel.org,
        mkubecek@suse.cz, gustavo@embeddedor.com,
        cforno12@linux.vnet.ibm.com, andrew@lunn.ch,
        linux@rempel-privat.de, alexandru.ardelean@analog.com,
        ayal@mellanox.com, petrm@mellanox.com, mlxsw@mellanox.com,
        liuhangbin@gmail.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
References: <20200607145945.30559-1-amitc@mellanox.com>
 <20200607145945.30559-11-amitc@mellanox.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <35598572-df37-75cf-9f58-ad387af2f245@gmail.com>
Date:   Sun, 7 Jun 2020 11:22:27 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200607145945.30559-11-amitc@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 6/7/2020 7:59 AM, Amit Cohen wrote:
> Add tests to check ethtool report about extended state.
> The tests configure several states and verify that the correct extended
> state is reported by ethtool.
> 
> Check extended state with substate (Autoneg) and extended state without
> substate (No cable).
> 
> Signed-off-by: Amit Cohen <amitc@mellanox.com>
> Reviewed-by: Petr Machata <petrm@mellanox.com>

The delays you have chosen make sense, and if we need to change them
later on, we could always do that.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
