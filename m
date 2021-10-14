Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE29042DC0A
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 16:51:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231784AbhJNOxX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230359AbhJNOxW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 10:53:22 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ABFBC061570
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:51:17 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id p4so5677625qki.3
        for <netdev@vger.kernel.org>; Thu, 14 Oct 2021 07:51:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=diK8PBp7L4HKaNbGhqd3oIAcnAIb2ei041ZLdURss7c=;
        b=kLB9zUFFsaPayIabV4Qg5Ng/xNjZUGDUDM2uLKxr16sl7F8uB8JDPMC8qNf3v340gz
         1wycmiP+eNW6g7CKBY0zfFzTX9P+W1leyULZxTSqUZn7RMqKGw5rOFIVxkg1xUk55CFJ
         jcTwsnyhtr/AtKufhRaa27rYQHxuJq4sUc/cV1WpuMJzde0YEjCNjPb/2Up+ygDeDTVL
         /Ao+u47lNaJ5ZhlWOeiU9fjOfZ6nyHtXp17Df9/ko5Vtmes4TV3aJ2HyZCl95abi+l1U
         koLw3gJLc2OhgfLOCGCicSahXh6VNreanXuxcjfU5LhfRdgPTkyY2F4u+EH4a7rANPOi
         +40g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=diK8PBp7L4HKaNbGhqd3oIAcnAIb2ei041ZLdURss7c=;
        b=BrO+xrWjwaJPITJbSl+dxjRCH1qmred4Co6WlrEee6nc8JLy/OO0AlTkhn9iZcyrt+
         I4snPNbKDr8SpxndZKCOda8+RtTZTvJEJMmt9W/nNFku0CQesPdS8cOEYfn27cThIJ01
         B9vv88GPW2OMbO97PSTIbUs0YpLdcTC3CBwbpG/xXcPXD6Jo1QPn0YW4sjNorGS4Nh5d
         bAQFYZOwMRA77VvvUUxICbzMr3Qf8xsONPm1k7hY38thRrnyVKPkBfn3OLGsMkppmzTl
         hZ7wUuH/iv0EfjICncCMSE5lBqOCYu4/9WcQ95ie0IwK9QFx/Bjp47+xT4Pu+FxGtiG6
         lYmw==
X-Gm-Message-State: AOAM5319akW0SMo/7RI84cY76snEM/K6OXdboAFwT5gLSt8u1m6a7HeF
        FeczDKzlL/bqwTW0ud6C7wFY/w==
X-Google-Smtp-Source: ABdhPJyMIdsvYIe4JXN1PpWdezLngY26BzRy8Yy8rFeDD5E3VJbpsCuaXxri2ajOShfO5tJajpgXYw==
X-Received: by 2002:a37:9a83:: with SMTP id c125mr5121958qke.186.1634223076522;
        Thu, 14 Oct 2021 07:51:16 -0700 (PDT)
Received: from [192.168.1.173] (bras-base-kntaon1617w-grc-33-142-112-185-132.dsl.bell.ca. [142.112.185.132])
        by smtp.googlemail.com with ESMTPSA id i5sm1463387qtq.28.2021.10.14.07.51.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Oct 2021 07:51:16 -0700 (PDT)
Message-ID: <ce98b6b2-1251-556d-e6c8-461467c3c604@mojatatu.com>
Date:   Thu, 14 Oct 2021 10:51:15 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: Anybody else getting unsubscribed from the list?
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <1fd8d0ac-ba8a-4836-59ab-0ed3b0321775@mojatatu.com>
 <20211014144337.GB11651@ICIPI.localdomain>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
In-Reply-To: <20211014144337.GB11651@ICIPI.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-10-14 10:43, Stephen Suryaputra wrote:
> +1. Had to re-subscribe.
> 

Thanks for confirming. Would be nice to be able maybe
to check somewhere when you suspect you are unsubscribed.
The mailing list is incredibly solid otherwise (amazing
spam filtering for one).

cheers,
jamal
