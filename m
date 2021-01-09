Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB0D2F0442
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 00:16:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726301AbhAIXNG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 18:13:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726062AbhAIXNG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jan 2021 18:13:06 -0500
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC23BC0617A2
        for <netdev@vger.kernel.org>; Sat,  9 Jan 2021 15:12:25 -0800 (PST)
Received: by mail-ot1-x333.google.com with SMTP id w3so13396004otp.13
        for <netdev@vger.kernel.org>; Sat, 09 Jan 2021 15:12:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=xJD1FVrHknw4UCHuN+7RUSGf3Rk44pQ3yW1yznGPrOg=;
        b=Pp9ABwb2Igj/KU6QJ6+18l0e8LSSOBs3xGVTrjPeLX6iJS+34KCMUJkSTJEFrBJEuN
         eUBxIORm91juNvfxlvq1Krg3D+Sk3rjlRtDqYk2JdA7NzeobRYK2IIiUT2KXB2BsmwKz
         trwCLxTCfaZlJmOW7YC60iOCNdkabubkh9UuS+F4zcTUzjX7EJb9N+iCBil8ZClAAxhZ
         zFm14bjLMGs6Gz49UQtHvPzM6qLdIyqisCwHa8diQhTj5jjVfRqR4gihE1DetS1lIevF
         N0udGUnTYB8azF8+momuUTZgEf70eGZR1cvMQXRAjShQogtt9LehDnL8Jql0Xg32IAfr
         CN/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xJD1FVrHknw4UCHuN+7RUSGf3Rk44pQ3yW1yznGPrOg=;
        b=Z7+6zvaZ1gnDQRupQ38TlEJaRB5d3bvehjtJ25B1UP5/MpX0GnQ2v+uJnBpwBp/JQW
         ef2RszlVLkvCgSGGg1uYP1OXtbwT+rQDSd0bK+PqNJqaD/y9yFHP3r+JT6IOJU/dpL/o
         1/BYldv0rakIETeGTDgxMDqNyv3pf9jiEuy5z14INOQYg+U4JmZcqwg+fS0TGOUEDSoI
         nVaj5yHvL8XkFwzbuHtJnYRa3O2NX/gMGazvQZkbcGCl5qbAeSB5vFXfLXxfT/qJLCQk
         bqBJI/gkeWaprk713lhWe/Lp8FabP/sYjumDtyK2091N1MLiO3FyWTJm+JIYL0gFOGwr
         Jb5A==
X-Gm-Message-State: AOAM532X8Kp2mxWA4r2A048m42SD9Piz4SMunUDLYs+Nh3JBTMpgZruR
        7tMhBdAnp4wd2w7cEgFxtJV12tnLLCE=
X-Google-Smtp-Source: ABdhPJxwfZCw8dcAS4FehvKKRAU7RrJpmcXhLjqEP/ldD1E8tSdsAa7wkBymFvmcyvhSg1XJOaXAGA==
X-Received: by 2002:a9d:3e2:: with SMTP id f89mr6873362otf.278.1610233944807;
        Sat, 09 Jan 2021 15:12:24 -0800 (PST)
Received: from Davids-MacBook-Pro.local ([8.48.134.51])
        by smtp.googlemail.com with ESMTPSA id l5sm2639821otj.57.2021.01.09.15.12.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 09 Jan 2021 15:12:23 -0800 (PST)
Subject: Re: [PATCH 00/11] selftests: Updates to allow single instance of
 nettest for client and server
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, schoen@loyalty.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20210109185358.34616-1-dsahern@kernel.org>
 <036b819f-57ad-972e-6728-b1ef87a31efe@gmail.com>
 <20210109110202.13d04aeb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20210109150440.33b7ffe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9bb81496-25a8-42cf-0dee-1be4625a515e@gmail.com>
Date:   Sat, 9 Jan 2021 16:12:22 -0700
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.16; rv:78.0)
 Gecko/20100101 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <20210109150440.33b7ffe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/9/21 4:04 PM, Jakub Kicinski wrote:
> Do you want to address the checkpatch issues, tho?

Yes, I thought I had fixed those. Evidently missed a few.
