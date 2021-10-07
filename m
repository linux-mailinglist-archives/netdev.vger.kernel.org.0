Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9D96424B98
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 03:22:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhJGBYm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 21:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230300AbhJGBYl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 21:24:41 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 771E5C061746;
        Wed,  6 Oct 2021 18:22:48 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id h189so2063399iof.1;
        Wed, 06 Oct 2021 18:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ll0oa75vwhrd/jX569DuLEC0YhlCdGYCCf3ViMztJWY=;
        b=XI9c895b2ORswndS2kO8/54RqxOi4N4Y/aDaXGGuPcUzXKv509ghzLFNCLwZQEzu+C
         6o8cl1x14ANfLLWcEEYzyIp3DHpvnRFY+OAaNJy4VlGrPecgrwwgbg/qBu+IABIa5/XE
         MB6VR3rDdODDoBj9Qb7I+F3aaUGuv6P2LUqW8PiZxDMj6b13g9CRJL3qsiY6emhRYODD
         J6tGEWH30YnenomVB4vh9OM4q5E764cKtZM8nyjH9sbuJBp9KOE7NaL8pwYnE03/BBq8
         41+RrUArdcvUBU/sO42N971kvkeZFDvcDtDhSAxCvZOW7HAQyYYplfNA/WQ0dBmKTW+5
         wbaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ll0oa75vwhrd/jX569DuLEC0YhlCdGYCCf3ViMztJWY=;
        b=LfYy213qG1l6NSyNGHDjTpUrzhbtoDmPA8K57M+4dpU5K4RZ84UDlDEtcJC9pzZMax
         TEE+Kzi6Vf2mhF16cPY0jXQx05KYVEmtWrMQAmgBlayI/QUQrMnJb2BAm2633xW7UG61
         f+8YE6dQRy3rs2QUB4UI9EOnRSze+OfHQhk3YAj/qkpDgfuqqoBdg/rfJxl8h2EWKhxF
         TR265Dk77KlPdBL6xtmxTofZVGChtajOINuRi9l8oeFYVZzhOTsodOYSPV1VDh1nESJD
         ojmcAJU2czhMmcpYccQySEHw0zA+WiAjfeGN0gteQSOUmxIiIvusOHnwcYDBOIUZpjaj
         1piQ==
X-Gm-Message-State: AOAM530aXGs46P+gYOFqavFXbS8jWmWEYFSaeJ8pflylkyepQqRcxiPH
        jHQNaUaBbddxtCySLnebCuyI7waFsQpyqA==
X-Google-Smtp-Source: ABdhPJyUBKkqYtLhwhfFhyTmGHceMBGSgF4rJ3DHDWyO1q38N5zNLE2m3V1mkvbYuFMuaXGYoBTDRw==
X-Received: by 2002:a05:6602:1644:: with SMTP id y4mr1123006iow.82.1633569767459;
        Wed, 06 Oct 2021 18:22:47 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id q6sm1549712ile.23.2021.10.06.18.22.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 18:22:47 -0700 (PDT)
Subject: Re: [PATCH 08/11] selftests: net/fcnal: Replace sleep after server
 start with -k
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <ec40bd7128a30e93b90ba888f3468f394617a010.1633520807.git.cdleonard@gmail.com>
 <43210038-b04b-3726-1355-d5f132f6c64e@gmail.com>
 <d6882c3f-4ecf-4b4e-c20e-09b88da4fbd6@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <888962dc-8d55-4875-cf44-c0b8ebaa1978@gmail.com>
Date:   Wed, 6 Oct 2021 19:22:45 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d6882c3f-4ecf-4b4e-c20e-09b88da4fbd6@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 3:35 PM, Leonard Crestez wrote:
> 
> I counted the [FAIL] or [ OK ] markers but not the output of nettest
> itself. I don't know what to look for, I guess I could diff the outputs?
> 
> Shouldn't it be sufficient to compare the exit codes of the nettest client?

mistakes happen. The 700+ tests that exist were verified by me when I
submitted the script - that each test passes when it should and fails
when it should. "FAIL" has many reasons. I tried to have separate exit
codes for nettest.c to capture the timeouts vs ECONNREFUSED, etc., but I
could easily have made a mistake. scanning the output is the best way.
Most of the 'supposed to fail' tests have a HINT saying why it should fail.

> 
> The output is also modified by a previous change to not capture server
> output separately and instead let it be combined with that of the
> client. That change is required for this one, doing out=$(nettest -k)
> does not return on fork unless the pipe is also closed.
> 
> I did not look at your change, mine is relatively minimal because it
> only changes who decide when the server goes into the background: the
> shell script or the server itself. This makes it work very easily even
> for tests with multiple server instances.

The logging issue is why I went with 1 binary do both server and client
after nettest.c got support for changing namespaces.

