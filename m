Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC17D4240A7
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 17:01:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbhJFPDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 11:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238436AbhJFPDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 11:03:02 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8201DC061746;
        Wed,  6 Oct 2021 08:01:10 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id p80so3121276iod.10;
        Wed, 06 Oct 2021 08:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=zmQVBnLuuHm9wz/qDU61XUER4/3YeXffUriok7CGmrQ=;
        b=N0MC7STt5a6sAPzVxDw6eIsL2hmmuLBac9kAvUel8adWiokU59Hnc1mj/r/yeqAv4p
         v4lMglM+W551qOaZxtLmuP4zhLh8Xt9VBXVK1TBzIZbUiIBe7w1PG/pAYXnS+Gl6QlgY
         E260NMlkLNUrqlGEuxgPUYcLOiXsULuE/OKhQH2XfmwdS3KMK5HpwBKXIeenJycxr9YC
         PhTtlAAr64MUULUlo9nzIGQoRZdmJDEVfXe0axUsCykYp2VM8epbTFdXDapSyjAaSi75
         HV2ssovfVoiZbYSDLNQs9bV1/nc5ou1xjTNR6+b7WURar+NDMe9YTZHMXNRkABaDSQym
         7hHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zmQVBnLuuHm9wz/qDU61XUER4/3YeXffUriok7CGmrQ=;
        b=Cpgrw9GvnhkUKvpWwKJEfQM9y13vAXouxu/4IXxHNlnkRwnc+Q+e7SmMsews1RpGeE
         lwSWMVO75wBtUOTcLWaeZVXHSHutdx94a+V0FCC3X4XL6HxzAhD8N1V3YMXaTObDKSeN
         XZi+sf7tXUhvEoChzzA7P+pef5IVmd9IK0gydfXQoVb2Fa5mfAmUGDvQUHxyZmLOL8gu
         LQIlmXhzRbsBEu6DWpAzJ7r/AOIUq4KcJRkucH8IRCoVdXb5gM2O1ami+it/UsAJz525
         pA41fo0csU7xezHZ6zbKnxcp4gnd7XY2JbB+rN8sMAL/isdTxaUi0efOhfnCex6jD+iN
         llJw==
X-Gm-Message-State: AOAM533ftvHhcQYdOfSytGPZ18rkJcohyqtO+mMcVymSAsgJ+3bVneJy
        rCP7NhLLgBxW+B948O6HfyzTHKGVI7colA==
X-Google-Smtp-Source: ABdhPJypqGEuNCB1EtGjteQ830u3Tun58j4yvf8K/TeIcnO8I/Tfa0ErUjWHuf2okMFZDbY4KZhLWA==
X-Received: by 2002:a02:6a0d:: with SMTP id l13mr7757883jac.92.1633532469379;
        Wed, 06 Oct 2021 08:01:09 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id z187sm12262817iof.49.2021.10.06.08.01.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 08:01:09 -0700 (PDT)
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
From:   David Ahern <dsahern@gmail.com>
Message-ID: <3ed2262e-fce2-c587-5112-e4583cd042ed@gmail.com>
Date:   Wed, 6 Oct 2021 09:01:08 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <516043441bd13bc1e6ba7f507a04362e04c06da5.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> Reduce default client timeout from 5 seconds to 500 miliseconds.
> Can be overridden from environment by exporting NETTEST_CLIENT_TIMEOUT=5
> 
> Some tests need ICMP timeouts so pass an explicit -t5 for those.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 17 +++++++++++------
>  1 file changed, 11 insertions(+), 6 deletions(-)
> 

The problem with blindly reducing the timeouts is running the script on
a loaded server. Some tests are expected to timeout while for tests a
timeout is a failure.
