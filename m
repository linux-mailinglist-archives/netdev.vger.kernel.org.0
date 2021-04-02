Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC1BD352DB9
	for <lists+netdev@lfdr.de>; Fri,  2 Apr 2021 18:28:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhDBQ2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Apr 2021 12:28:10 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:43424 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234275AbhDBQ2H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Apr 2021 12:28:07 -0400
Received: from mail-ed1-f70.google.com ([209.85.208.70])
        by youngberry.canonical.com with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lSMeT-00023m-A8
        for netdev@vger.kernel.org; Fri, 02 Apr 2021 16:28:05 +0000
Received: by mail-ed1-f70.google.com with SMTP id w16so4775876edc.22
        for <netdev@vger.kernel.org>; Fri, 02 Apr 2021 09:28:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=l5pH59VX/ksTw6Nw5DlDio0coKgCovudT1I3TQsyeWk=;
        b=BNd3ft5Cit0bHiZlyn45whYgvggjqquNV8q9zmYrosqDyRUny3zeCOp0ZsVzF3IGXc
         LmMUGIE8Vwt3VuqhQC+gYPTfAf2gkDI+pxzZpFP5UWKl6VBeZ9Q8g0oSxQBzt7rUmIYG
         ChIxT7HjDJlwI8FCBugsMn2/1k3a9q4isEwl8uK7ljR7mIjGxzd9vE6kjASqrrqo9xJ2
         J48EtILq7dl131tCLJhd1IhbYwewNTHWjXOJXCe5hMfqHK9k+Fj4zL7fF40FS/kWSm0W
         PoeNUtHUstJQ8nTKXQ8Rx/Wz6kiq1O2k/yC+zPHy92gYlyqRzdmpkwhjByXapygSYVST
         IYUw==
X-Gm-Message-State: AOAM530dZ6K6jtpseZImQAPjHX07jmyHtAEEh2Twy+QahYYDpAz8r02F
        Prwv9j0liobLNpXj2h+UjCbaL2rWhVmNTayooaCxnJ6w8a8hjo+Gti3CGCgJ7BdrAaGCR/CgMRg
        rKNzFy+2QTNI1CZk9Vf3K8X8BfZTDde4+BQ==
X-Received: by 2002:a05:6402:5255:: with SMTP id t21mr16441020edd.91.1617380885038;
        Fri, 02 Apr 2021 09:28:05 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw9g2d4llc2lwvaUsr9cW/SpPKLMYQ3D0UiMnrkeKAcbMQ7aKl9IfvLpIbgjyCTD6YjNjFkaA==
X-Received: by 2002:a05:6402:5255:: with SMTP id t21mr16441002edd.91.1617380884934;
        Fri, 02 Apr 2021 09:28:04 -0700 (PDT)
Received: from [192.168.1.115] (xdsl-188-155-192-147.adslplus.ch. [188.155.192.147])
        by smtp.gmail.com with ESMTPSA id hd8sm4311138ejc.92.2021.04.02.09.28.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Apr 2021 09:28:04 -0700 (PDT)
Subject: Re: [PATCH] nfc: s3fwrn5: remove unnecessary label
To:     samirweng1979 <samirweng1979@163.com>, k.opasiak@samsung.com
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        wengjianfeng <wengjianfeng@yulong.com>
References: <20210402121548.3260-1-samirweng1979@163.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Message-ID: <0dc19abe-28e6-69a6-40e6-ba03a09aa3ae@canonical.com>
Date:   Fri, 2 Apr 2021 18:28:03 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210402121548.3260-1-samirweng1979@163.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 02/04/2021 14:15, samirweng1979 wrote:
> From: wengjianfeng <wengjianfeng@yulong.com>
> 
> In function s3fwrn5_nci_post_setup, The variable ret is assigned to 0,
> then goto out label, but just return ret in out label, so we use
> return 0 to replace it. and other goto sentences are similar, we use
> return sentences to replace it and delete out label.

The message is difficult to understand - you created one long sentence
with mixing tenses and subjects. "The" starts capital in the middle of
sentence but "and" starts after full stop.

Please rephrase it.

The code itself looks ok.

Best regards,
Krzysztof
