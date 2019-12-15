Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A003511F579
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 04:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbfLOD5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Dec 2019 22:57:13 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:39698 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbfLOD5N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Dec 2019 22:57:13 -0500
Received: by mail-pg1-f193.google.com with SMTP id b137so1669111pga.6
        for <netdev@vger.kernel.org>; Sat, 14 Dec 2019 19:57:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=mD0Q7oQYjKwsMg2M4wabWtadHwqClbEf7Ae0x/K5NMQ=;
        b=y8KYw7nx/0imlHvkK8hcfnQhZoBnj7jpKV5qC1x6NGQC8eB6n7vZakzNmuQ1Le2rT8
         agP7oca0AxBdWDhYoxNvY2OReccDjAirKrxfSQe1ea23vsV+UQPVtVWpipKNC/dRAHRi
         CkJNBil5RyOEiEHC+hCZxmFIPWvmqoUxgPPEGH7DvA2sW9+jN5yIafikJvTjBwQ19zoy
         8gHmrVTo9uFx2nuIBH+IA2pFGIxOKK/czJux9fkqNLWH/p11Fo4wMGjAnN2Oyi9Nx6pS
         dy1WWvUZVAMkG2vqw1mDgzzhTveYPjVy2PeYEe4GV3BxfbiPQNtCU0jE3dciKcuq1NYK
         reFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=mD0Q7oQYjKwsMg2M4wabWtadHwqClbEf7Ae0x/K5NMQ=;
        b=BAbT0imBqMvNk7iHpU4RWCMBZNFb/ahb6sGA2AcUQZWKZ5irBL9g8qBqeCp5QG/eRo
         7EsrcSAHI4rU20nJuoBKA6bJoJ6BuXPHwFpzvSvCSOSUFzScvHC3H1X8+NlSSEsmXVsG
         FelzlC+Lu1PKObHAOXqRnAofSmfbGoyLC7ySOMTIEHDD1THavHf4qmkSJErUm/U4NV0Y
         2Kx9KbpQRDibQeu1mkqYLkuKz4s7xtdPfaCn3BsDPsE2IlKuYxaQDBE1U4uDbJtK+3Qi
         PfN88rG13PEc8G5sD17S438dWzJP8ho31wmSW50GxosPquNqzlXNFfWsQSjONbPqddim
         KZLw==
X-Gm-Message-State: APjAAAWu6s/Wi5pRVYtFarUUfWAJcbaPZ2seGUsLcsxaU6qtG7UaR0yW
        uIfETmpwIvwM6wRlQWErC6cbCQ==
X-Google-Smtp-Source: APXvYqz6bI5msW42zqMqJa8ChbziLHm3II8lGoaSQd+3pIZ6B3/oPn44cKmVhrQtb357WidS/Q2wLQ==
X-Received: by 2002:a63:fc01:: with SMTP id j1mr10175899pgi.220.1576382232363;
        Sat, 14 Dec 2019 19:57:12 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id y144sm17828042pfb.188.2019.12.14.19.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Dec 2019 19:57:12 -0800 (PST)
Date:   Sat, 14 Dec 2019 19:57:08 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Shuah Khan <shuah@kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Paolo Pisati <paolo.pisati@canonical.com>
Subject: Re: [PATCH] selftests: net: tls: remove recv_rcvbuf test
Message-ID: <20191214195708.0f69a0a9@cakuba.netronome.com>
In-Reply-To: <20191213103903.29777-1-cascardo@canonical.com>
References: <20191213103903.29777-1-cascardo@canonical.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Dec 2019 07:39:02 -0300, Thadeu Lima de Souza Cascardo wrote:
> This test only works when [1] is applied, which was rejected.
> 
> Basically, the errors are reported and cleared. In this particular case of
> tls sockets, following reads will block.
> 
> The test case was originally submitted with the rejected patch, but, then,
> was included as part of a different patchset, possibly by mistake.
> 
> [1] https://lore.kernel.org/netdev/20191007035323.4360-2-jakub.kicinski@netronome.com/#t
> 
> Thanks Paolo Pisati for pointing out the original patchset where this
> appeared.
> 
> Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
> Fixes: 65190f77424d (selftests/tls: add a test for fragmented messages)
> Reported-by: Paolo Pisati <paolo.pisati@canonical.com>
> Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>

Applied to net and queued for stable, thank you!
