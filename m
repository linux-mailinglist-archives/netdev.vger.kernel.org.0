Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92F394AD05C
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241316AbiBHE3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:29:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234088AbiBHE3i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:29:38 -0500
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BF48C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:29:37 -0800 (PST)
Received: by mail-pf1-x429.google.com with SMTP id i30so16736447pfk.8
        for <netdev@vger.kernel.org>; Mon, 07 Feb 2022 20:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KFy0VFK8kUwnINSIg5P5ODLFMqdHWEM7U09ysXDvakA=;
        b=q1RWHtzzdh7ColxUMz5qZ+pbDpAWiEFojK9xC8J5mkAE3dUuR9Ri5ourJjxS5FQCEt
         gnEX4BS5OruPR06c6SEWAKBLL3iQ11TConhiIqlnWMZjKAuUNFSrUwZQvGVWlC5mgNMo
         /WatYpZJj7m687ORr7vPtH6zaqNgSteUmECuwO8t5SkoN9As/sHbKaE+1ibmv5Ydh0v7
         2Y3fmMJnTXd/4508owLgeZtVkZbBcohA8mzhNWt3wqpHRE9gDDmluofS8V1bUQsMfvzx
         2Kn0zaVk/tygyw18JOUhvvWLZhITMxK0ahgmfxQLe2hmPFJ13hkdg46y79ZQ4nzS018j
         UqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KFy0VFK8kUwnINSIg5P5ODLFMqdHWEM7U09ysXDvakA=;
        b=BLG3EYOysuw36OZ3ewpMriRj2OnLJoElBDiwO6BnZs09Kv8W+vwDpdIzDFjzSTkR35
         uJh64IWwgUPzDTxEa8uZtd/VUnnIclJZcbRLpn58hO3SWSXLJGw4+I6F03qiFWMahV60
         0HYpLjnJJf42IEaOF3KlB6uVNMea7ekIN64g3Ti5nJQdH5ZyWxvqpy40Ef/M/tH9dmfA
         4jhbxUDNxTu42cNL/qMOGZjh6RQAynT7raBirTAPUNp3s/J6ot3aWKMZrg689aojtIlG
         OGWrv9RiLTN0EhP5FJ04nDgVxGGnv4c82j4D/eNc2C1HaMjQ4E2+E6rhQrCKnfh6GJwm
         QluQ==
X-Gm-Message-State: AOAM532EgvCff6KdpcVaVIGUYIy3j9te4KrZ2fRplv7JFIoLVD64PEox
        EmAl4Vd6dBD7Xwv07fRu8Bg=
X-Google-Smtp-Source: ABdhPJyJlP3/qsCLVBWlj35nGZQPrVkehXDbka6ZfOG2VQXGc1ehSNOHp0PjYlsm6yFMthm9CcJACQ==
X-Received: by 2002:a05:6a00:1c96:: with SMTP id y22mr2630885pfw.8.1644294577188;
        Mon, 07 Feb 2022 20:29:37 -0800 (PST)
Received: from [10.0.2.64] ([209.37.97.194])
        by smtp.googlemail.com with ESMTPSA id x1sm14566908pfh.167.2022.02.07.20.29.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 20:29:36 -0800 (PST)
Message-ID: <2815a75c-b474-34f0-f0c9-7566f0f9e87e@gmail.com>
Date:   Mon, 7 Feb 2022 20:29:35 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.5.1
Subject: Re: [PATCH net-next 11/11] net: remove default_device_exit()
Content-Language: en-US
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>,
        Eric Dumazet <edumazet@google.com>
References: <20220207171756.1304544-1-eric.dumazet@gmail.com>
 <20220207171756.1304544-12-eric.dumazet@gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220207171756.1304544-12-eric.dumazet@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/7/22 9:17 AM, Eric Dumazet wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> For some reason default_device_ops kept two exit method:
> 
> 1) default_device_exit() is called for each netns being dismantled in
> a cleanup_net() round. This acquires rtnl for each invocation.
> 
> 2) default_device_exit_batch() is called once with the list of all netns
> int the batch, allowing for a single rtnl invocation.
> 
> Get rid of the .exit() method to handle the logic from
> default_device_exit_batch(), to decrease the number of rtnl acquisition
> to one.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> ---
>  net/core/dev.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>


