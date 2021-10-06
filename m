Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437AE424098
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239075AbhJFPA4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238226AbhJFPAz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:00:55 -0400
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75B9AC061746;
        Wed,  6 Oct 2021 07:59:03 -0700 (PDT)
Received: by mail-il1-x135.google.com with SMTP id l13so3182538ilo.3;
        Wed, 06 Oct 2021 07:59:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=y4NHrs6aiIo9S6C3VYytFyJQ06OGzDVc4A1DLXf52DQ=;
        b=agyU9edfIBs1azn06hdEatGC9aSL5Y9XzOvT/AZ+xIGfuQAIREDhQjPup5AINBD2Ru
         ngvNm++eTACkBebmwrItxwN2zuErWuQAVnGbyfs/iX/LQcUbLmUTR3YCtrNuOzSVK1BG
         NtW1nAoCVQUHMCGJIW7wkt5gevXW7hWRG6sLwVUPTdHYxpcgxesvNGjMAbp3jsPr/5gR
         WmhnZrvoIV2zbZbggKlo8xTSKAuXA9FSStAJY/EitkeRtXLR/+E75mM6cLfx3lTEcML5
         K2ER9MNsobtwdgVPmISmhcLdyZq2xuJgmCF9Kvyl6rE5d4k0ZGakDZDspYcUZ/VnpXYZ
         qtEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=y4NHrs6aiIo9S6C3VYytFyJQ06OGzDVc4A1DLXf52DQ=;
        b=SG04qoMOmSMfmjrhsVlKIfqiBT7aasCJIX6Uz96QbZq6kmvyZK3uEDLL80+CasUrQN
         7Gi1KhcNTn/ctJnVjg3idB1u3BtIGnpXlXzmrN4REk1mejHZu/RYWshMnBeU/y6J3rkB
         78pqjdlogqlanxJxphloYs2QoWyELLzKDPJK5tYiUcLGiqQ7C21m8l37Jd/AfKdp5O97
         dt5qVy9MK/jj2IYKruldJZwT3qc5J7+tebL6KiB9QyDEZY5Zk7qv1v+lLIINtRzVt5Em
         ZYSXmUHDV9JkfXGlSeHrpyGbMzm3DkVIPr6naPhPZNDH0RoChFrY29Z4vqye2GUseeZ8
         wd+Q==
X-Gm-Message-State: AOAM531bkb2sAhfR+y85XuKjsoh4K04uEJ/2moIDLkk0AqyQttU/Dizo
        ERiD31O0RRqhamQCVs3zK74r1LNvg7MY+A==
X-Google-Smtp-Source: ABdhPJzSUawLqoZ0VEQhl9mAjLFzz5hIq7NeFM8nVHRKGEWkE1iARW9g3boDDjq51AJs/a9bmObo3w==
X-Received: by 2002:a05:6e02:1a6d:: with SMTP id w13mr7485179ilv.304.1633532342877;
        Wed, 06 Oct 2021 07:59:02 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q13sm1184612iop.43.2021.10.06.07.59.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:59:02 -0700 (PDT)
Subject: Re: [PATCH 10/11] selftests: nettest: Add
 NETTEST_CLIENT,SERVER}_TIMEOUT envvars
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ffb237e32f2d725eb782f541681b05a0319b591b.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <f3c0cccd-e543-f2ad-fc45-8784f4c3f5db@gmail.com>
Date:   Wed, 6 Oct 2021 08:59:01 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <ffb237e32f2d725eb782f541681b05a0319b591b.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Move the single "prog_timeout_ms" into sock_args and split into client
> and server timeouts.
> 
> Add NETTEST_CLIENT_TIMEOUT and NETTEST_SERVER_TIMEOUT which can set a
> default value different than the default of 5 seconds.
> 
> This allows exporting NETTEST_CLIENT_TIMEOUT=0.1 and running all of
> fcnal-test.sh quickly.

The command takes command line arguments; no need to make 2 special
environment variables.

> 
> A reduced server timeout is less useful, most tests would work fine with
> an infinite timeout because nettest is launched in the background and
> killed explicitly.

The server timeout was only for cleanup (the tests have a very long
history); given the kill on processes launched the server could just
wait forever.

> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/nettest.c | 66 ++++++++++++++++++++++-----
>  1 file changed, 54 insertions(+), 12 deletions(-)
> 
