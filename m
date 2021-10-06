Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42A76424062
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 16:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239086AbhJFOuN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 10:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239075AbhJFOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Oct 2021 10:50:12 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A850C061753;
        Wed,  6 Oct 2021 07:48:20 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id y207so1161494oia.11;
        Wed, 06 Oct 2021 07:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XewLXbV0fAQkfACZ0ivzGkAxnAOatRqilHKzFIJtiSs=;
        b=eaA+LZSl9AW8MmZzbCJUc7FStyD0+qd6gmORfpg4PzeLUMX4p0H15dxUoLESK8nn/q
         ivUuiJ/bKCAqEfOl/tz/ukTGTPkB5yxqhBegwCBdR9sTPZmS6+KO+HBDlRlpvHTp35H2
         Gvp2kZUcV7TjHBdGVal3CvR2u1wGSUqY55NTgo6GFZJPRUY4u6bCXOZKOOAl3C5n6pis
         DG3enOJHeY9e4MjDW2Mq3IxiWgof7X1mD2RarUp2lp7d9GOtfX3t7le5aiyejn4MRr8R
         QcJw4f01gVWqulnU3YO+i1/4uM9gvAMrpkZT4dgIh9/yu8N+Wm/8QEEqduhUpaAjnA3S
         OaUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XewLXbV0fAQkfACZ0ivzGkAxnAOatRqilHKzFIJtiSs=;
        b=EqSs2NlFomA0nRXzEM3NiZDPYbecUH97brQCMUwpS64sF6ZZNEQbV7DwnZsJ5MF7UO
         dnzj4KaJa5//pUlzbeLwa2z3uJjJlnlkecqgoghK9GABXtJzVuq+cZbEWfHWKMeDpx0Q
         ZAjo7N/0BRK9k4kKIm0YNEQcCwM/MqOSXIAMeoeIh2qms1ifB114qvkXM4PBiNt1uizk
         g2JwUySpCrVWnuRwS2vDVwPCZl+JnIcaF/Q9AL3QvMGCJ8nEf2g0cT/JFKuVvtJx4Aul
         cjWezeA+U5+Ru/ZDmlYfcnckpnzf9zt8e/N6qOL6dayHfC7totFIpQKE7fTc3VGunRTn
         2tig==
X-Gm-Message-State: AOAM5310u2EXOwx0jQeePqbiY3qrtmdpVuzqgn411gNAsHpdHgYHXbPS
        VOe4kfuLbYpge2MGar6mIB2G9fpBJQRQhw==
X-Google-Smtp-Source: ABdhPJwZR7gD+cfvXEQnaHAtlW7krJO1KYObe5mXqBSnJiDhMeLGUe7m8FbiWNdqZGFqm3O2uSr62Q==
X-Received: by 2002:a05:6808:1525:: with SMTP id u37mr7402733oiw.12.1633531699254;
        Wed, 06 Oct 2021 07:48:19 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id h91sm4148196otb.38.2021.10.06.07.48.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Oct 2021 07:48:19 -0700 (PDT)
Subject: Re: [PATCH 06/11] selftests: net/fcnal: Do not capture do_run_cmd in
 verbose mode
To:     Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Shuah Khan <shuah@kernel.org>, David Ahern <dsahern@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Ido Schimmel <idosch@nvidia.com>,
        Seth David Schoen <schoen@loyalty.org>,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <cover.1633520807.git.cdleonard@gmail.com>
 <b989bb17303518eb149064a6aaaa1c37d2b703c4.1633520807.git.cdleonard@gmail.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <fcb7be3e-f965-438d-2d5a-b9ce433338ce@gmail.com>
Date:   Wed, 6 Oct 2021 08:48:17 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <b989bb17303518eb149064a6aaaa1c37d2b703c4.1633520807.git.cdleonard@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/6/21 5:47 AM, Leonard Crestez wrote:
> This way running with -v will show interspersed output from both nettest
> client and server. This helps to identify the order of events.
> 
> It is also required in order to make nettest fork in the background by
> itself because shell capturing does not stop if the target forks.
> 
> This also fixes SC2166 warning:
> Prefer [ p ] && [ q ] as [ p -a q ] is not well defined.
> 
> Signed-off-by: Leonard Crestez <cdleonard@gmail.com>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 16 +++++++---------
>  1 file changed, 7 insertions(+), 9 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


