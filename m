Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83BD11D7C68
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 17:09:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728272AbgERPJY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 11:09:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728231AbgERPJX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 11:09:23 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42E52C05BD09
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:09:22 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id x5so10948687ioh.6
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 08:09:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ieee.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=EoQJxytLsFGCAk3q/7V3Tuf1AW7qKilLYTk5aTLBhcg=;
        b=Xa/mOAvgktEy/edGsiwSknxENTMVnXDZnct8VSHmceVRhW0R+Uu4bbW6j1RucOQwTw
         c/OpVz97Nj5FT8T4Fk2k95gvWEPKRI4PZWst9KGzXmGi2EZjltxsxdne4mW/2I9oQ2hm
         dlzeoMxfi43TLHHihkOEqmFRA4fAoI2pLxfIY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EoQJxytLsFGCAk3q/7V3Tuf1AW7qKilLYTk5aTLBhcg=;
        b=dq5KcUr5WFbkniAZkN61WANNYDGvbMcMBSmz9IKPS2WJLU+f9ICD18js5AKeoS/+lA
         0IggRwAGk+XrGAtkppMvZ0t5F2LWqnEehwImFvenOZw5WAbsDWO51fxr7aFiDyO1R0tf
         nWqGlgUjJY4qOBVxrzJkr3KnAS/MR+bz6npDOokA0PKs5Rwv52w83ztLE0QwkgydITFG
         UAUFy5lLCyN7D45l5Lj3PWVL69MF3Pa6wtJPe3hpfYpQLfKrLYRaWFRRRGI73uXkkzWp
         W2JvLwXLvMoAey3dFmbo/I+Y639nPdBHbdFWFUdgSZCURcQcT9uNFYc/cDzEC+8d6X0m
         XDwg==
X-Gm-Message-State: AOAM530ZyJzWPimmzrWLF+8At9fjFKmeh9dgm6j9auqusz8J6vs+ardm
        UJgK5MJoKo3Z1tmQ8BUdzWdjLSSRb88=
X-Google-Smtp-Source: ABdhPJzxtGE0kyWovKLjj1ZjkpU1Orj0dBN9J7mwhxZPjRoKmSdxPx9HQCZbv39NxP5h40g/AsFqEA==
X-Received: by 2002:a6b:e911:: with SMTP id u17mr14732527iof.29.1589814561599;
        Mon, 18 May 2020 08:09:21 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id w88sm4871104ilk.83.2020.05.18.08.09.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 May 2020 08:09:20 -0700 (PDT)
Subject: Re: [PATCH] drivers: ipa: fix typos for ipa_smp2p structure doc
To:     David Miller <davem@davemloft.net>, wenhu.wang@vivo.com
Cc:     elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@vivo.com
References: <20200514110222.3402-1-wenhu.wang@vivo.com>
 <20200514.130717.1848307407646007455.davem@davemloft.net>
From:   Alex Elder <elder@ieee.org>
Message-ID: <15c868b1-f74a-3267-1e67-702af1938152@ieee.org>
Date:   Mon, 18 May 2020 10:09:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200514.130717.1848307407646007455.davem@davemloft.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/14/20 3:07 PM, David Miller wrote:
> From: Wang Wenhu <wenhu.wang@vivo.com>
> Date: Thu, 14 May 2020 04:02:22 -0700
> 
>> Remove the duplicate "mutex", and change "Motex" to "Mutex". Also I
>> recommend it's easier for understanding to make the "ready-interrupt"
>> a bundle for it is a parallel description as "shutdown" which is appended
>> after the slash.
>>
>> Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
>> Cc: Alex Elder <elder@kernel.org>
> 
> Applied, thanks.

Thank you.	-Alex

