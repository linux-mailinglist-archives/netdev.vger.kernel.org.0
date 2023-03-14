Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A016B966A
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 14:38:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231561AbjCNNif (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Mar 2023 09:38:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbjCNNiS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Mar 2023 09:38:18 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE401A42D5
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:34:54 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id t15so14361975wrz.7
        for <netdev@vger.kernel.org>; Tue, 14 Mar 2023 06:34:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678800892;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VOzUvlUnmV9Mqpepq0kk5qAxRRaGjzDpT/wREXGyGBA=;
        b=LRF8ykW5F/RmBCTx+vKNgUMi7jDSbV2dxOJVWYD20hn/bZRf2Ywb3GYNJ5GKO62a0w
         yQXr0evCR8pezCK6zdivBP9lNlcsdrOdbPUAjXermc0wyBC6IUP5sU1BeFFBXpUhjV0k
         e4mIJb4YlUZm1+wX5eoL00W8JQcA3/LhVnoycfWhuqdzMip1/xLiZpKyhlsnL1ZmIz9W
         CDeSgWnnEM+ZER7xMjvFNeKYstweM+r+cbQyN86lTyRpHh81C77XtuLuApkV6GZzoZBH
         FEZyzaGRkvuDYU+hXQa3qdyNU71Z6oxqVJdOQYvz2QB9vh17shZ7Vahz1ol5jt2QqFC9
         MhHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678800892;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VOzUvlUnmV9Mqpepq0kk5qAxRRaGjzDpT/wREXGyGBA=;
        b=gd20GoUVzYaM/pMhuaNSc1RWv3tlji/fVZtWeo7PtxTZA5NR/GZ/rhSBG7VxvoUyFc
         s1VN6n/aKjlP2XTuvghnwN680RwKCYByxjC/yjjKtm4+g28aIFZJ2gKHcbAaRa02x0DM
         31DQzH5TXkUhYUMCTGLYGZi4hO8CEINyEr+R5PEk28xNUkfBnH9zgjMtdi4QvK9rxUcO
         xTYrRcWGXGSybt/wTTrX7krDZqRnpuj3OcQmRQ+xXl5rLXO5jF189bF/sJv53myWvmvz
         CXVnJU/JuxHuKqOt/JKkQijb4HfKFVSE1/5apiC+3BjbfasJ6h+EsiWDTpDmxCzcg5a6
         3fjw==
X-Gm-Message-State: AO0yUKWNJmPCuHvKpfc748LPf3qRt7eKVPEKH9QC/oq62Y1oMCPyPrNz
        o/3mEBHiheTN5QcXwTOQCMU=
X-Google-Smtp-Source: AK7set/cTPtGkDp7+BIGV1utQAdQC9rHERqxHXvFApo0nFjE+SjmcybJKEm6GGTGGHgif4/uMdPPTw==
X-Received: by 2002:a5d:4947:0:b0:2ce:a93d:8832 with SMTP id r7-20020a5d4947000000b002cea93d8832mr6544921wrs.35.1678800892601;
        Tue, 14 Mar 2023 06:34:52 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id e18-20020a056000121200b002cf1c435afcsm2132637wrx.11.2023.03.14.06.34.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Mar 2023 06:34:52 -0700 (PDT)
Subject: Re: [PATCH net-next] ethtool: add netlink support for rss set
To:     Jakub Kicinski <kuba@kernel.org>,
        "Mogilappagari, Sudheer" <sudheer.mogilappagari@intel.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "mkubecek@suse.cz" <mkubecek@suse.cz>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>
References: <20230309220544.177248-1-sudheer.mogilappagari@intel.com>
 <20230309232126.7067af28@kernel.org>
 <IA1PR11MB62665336B2FE611635CC61A3E4B99@IA1PR11MB6266.namprd11.prod.outlook.com>
 <20230313155302.73ca491d@kernel.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <1710d769-4f11-22d7-938d-eda0133a2d62@gmail.com>
Date:   Tue, 14 Mar 2023 13:34:51 +0000
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20230313155302.73ca491d@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/03/2023 22:53, Jakub Kicinski wrote:
> Ah, so you do have a feature. Yes, it would be somewhat helpful but my
> larger concern remains. We skipped the dump implementation when
> implementing GET. The admin still has no way of knowing what / how many
> RSS contexts had been created. With the context ID being an unbounded
> integer just going from 0 until ENOENT is not even an option.
> 
> So we need to start tracking the contexts.

Hi Jakub, as the original author of custom RSS contexts I feel like I
 owe this bit of work; I can take a swing at it, unless Sudheer would
 rather do it himself.

> Add a pointer to struct
> netdevice to hold an "ethtool_settings" struct. In the ethtool settings
> struct add a list head. Put an object for each created RSS context on
> that list.
Would an IDR not be appropriate here, rather than a list?
AFAICT every driver that supports contexts either treats the context
 ID as an opaque handle or as an index into a fixed-size array, so as
 long as the driver reports its max context ID to the core somehow,
 the specific ID values chosen are arbitrary and the driver doesn't
 need to do the choosing, it can just take what comes out of the IDR.
