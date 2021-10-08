Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A48A4262AE
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 05:01:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbhJHDDY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 23:03:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhJHDDW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Oct 2021 23:03:22 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B45C7C061570;
        Thu,  7 Oct 2021 20:01:27 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id i189so1338903ioa.1;
        Thu, 07 Oct 2021 20:01:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=+fkNQoyl7/G1Nnp9gBXkyA8zVSQ0T+pMI2DlTvcxdJ0=;
        b=eVfJGv//wsqA1LQ0R0YFWDRrIIhEWpxrQw24kEWUx7a+wfAvVrqRBD+OaXWQPrZd09
         jjWT0PUkPK4HW92jpmatwGZAcY1gLSRmmVswaLuYYG9yZOaKAvLacwDz4/MDWtpGjf3s
         yD196w92FBT9SQf1cU4fSCfNlEv+LyziPj9HAmKMxzy46Zagqa7lvkQCI/Z5OPRNjEPM
         LJ0mktcvJQN9fTB7y0dCboIoyUbJae66pTvCSgA/5X/qWQOyBM8x1zmNlZCF35oKX6N2
         eQsN6OH/uoi2BjRu/a9sqQZ9JOQRi6f+IXtCk9BfSPKzDkzHOr7EeIpXCKPCZg6hwY1F
         7E2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+fkNQoyl7/G1Nnp9gBXkyA8zVSQ0T+pMI2DlTvcxdJ0=;
        b=bpcT5oaJOgJV1/A3DtjraxPt7wA1wQG5rXU9xqXg0zxq6HnroRLPWk3T6biWqtSjju
         GeJn4QHLoL7LnNWpBjyi5zEHGoh9yXX+zwceDlXI20aUZnkvor0eajbi3xYKfVnzzfts
         rA/31omhiIVR9/cXzeaEhuGPh9NF6azYALgxQD4iq8xfz+ss9iMGooHZbudVs8TQjG4L
         kGqEV5UHVs0Y7zi1ivBsUirAVtxzEYIXrM6fVVGZEhB3944JARrkuu9SHUwf6F2EUZRq
         Onvzsqot04ajGwkjLUCP8L3/7eL3g9q5U3qs+5dq7EptcQY4L+VwPBwZcI4206Tl+ja6
         3pag==
X-Gm-Message-State: AOAM532CUzWvoOI+7WN4nY+KYw5iLEqsNAqgXIBcV0dgr/HCu5bB1O6F
        VhgB0sOD58+AYd01ACsGDOzSQ2HHGnrwwg==
X-Google-Smtp-Source: ABdhPJy7xYb7ZZlXqk05zv002T3/APASk+2gMDILIK5EmQmfrW8yeLoeMuxCNZ5wNCL7esX/fcFZdg==
X-Received: by 2002:a6b:b204:: with SMTP id b4mr5632349iof.66.1633662086655;
        Thu, 07 Oct 2021 20:01:26 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id b13sm389561ioq.26.2021.10.07.20.01.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Oct 2021 20:01:25 -0700 (PDT)
Subject: Re: [PATCH 11/11] selftests: net/fcnal: Reduce client timeout
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <516043441bd13bc1e6ba7f507a04362e04c06da5.1633520807.git.cdleonard@gmail.com>
 <3ed2262e-fce2-c587-5112-e4583cd042ed@gmail.com>
 <c48ea9e2-acdc-eb11-a4b0-35474003fcf3@gmail.com>
 <65ae97e3-73c1-3221-96fe-6096a8aacfa1@gmail.com>
 <d7ac5d58-1e59-a657-a51b-4d757f7552ca@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <9f78b5f9-997f-fbc5-0831-c66c3d1c2654@gmail.com>
Date:   Thu, 7 Oct 2021 21:01:24 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <d7ac5d58-1e59-a657-a51b-4d757f7552ca@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/7/21 2:52 PM, Leonard Crestez wrote:
> Would you agree with adding an option to fcnal-test.sh which decreases
> timeouts passed to nettest client calls?

sure
