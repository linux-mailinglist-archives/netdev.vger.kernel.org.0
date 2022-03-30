Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914CF4EB8C9
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242293AbiC3DcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:32:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiC3DcT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:32:19 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9521BBE13;
        Tue, 29 Mar 2022 20:30:35 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id u22so17622322pfg.6;
        Tue, 29 Mar 2022 20:30:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=24j1sKF1bW73Ii+4kMGeUZn1o9CVyRns3JPUQmW1NTw=;
        b=PIw799Gq2gh0QQh4eutoIUAn4rA32aVp7LPLDnipp7F/A/TukgiwC/gJAOczZiBju5
         NrUpPTZPqDTt4IuCs8vAo3v1wH/lDw/oMqOJZoz34ajMgWzl8rzcoic9EO+MfS72DdWi
         RbRyicJ6qbX/BgFWi6+DRh9kQpipMGSVhuQJFKUWea5Gh9iWrMecKANwqucCe7zN7Q/i
         luUxX/uV94xvJ1xmkBrY/hWFwdytYv2cFLG62wbfHxqpoKBTgsNi+siWZdF+A45OUI36
         k0esp6pjN8Nq8+hx370glfXoc/8QY3IWFMJ2FoiGwgcXQWmYXpJq48NP4E70Cxw4yBKg
         SUqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=24j1sKF1bW73Ii+4kMGeUZn1o9CVyRns3JPUQmW1NTw=;
        b=eAdvCH2S8ZiZl4fGYnb+yZDn0rJp9e/4rdgCuOG6aghTgstGJyFBBDv0oyEXwVmTeG
         7lOc0CQ7gdOI2Nf4N++nXoAlhOuAcrlGZsYIwO9hzxmy5TU2IfORk0Qq08en5aqhUhQ8
         wwqFqOEhkUWOhsVosSZiXUf2EVvJF6PPZeryi53nfQPNl3Dp/m/k4qNrbVq+ozkSlLiT
         0PVrbq9cML61x6+7CBIdEG6txVObfkvvBl4XNQGMsbBo8E+hu8wiMjBtN7nkI31y7AD7
         ArjLNpBMzAV+7RLpu32ycYmTzFVLSBDWzmunH8B5aSmYpEIj9eBhbIgviPyE6fybwU8T
         OuEA==
X-Gm-Message-State: AOAM530ouXvi4uzNeDmbXy27EaME/bAayeDJc30C8ffemZ89ilt4NKOV
        8TLRltz+sbLq5SxnG38zPV8=
X-Google-Smtp-Source: ABdhPJz9gGnJ3o3JCDzzRrT0XMrJo75mVezqwPQQwPNQpHTpPZF09nClisOrZpal7aitxdLu341OvQ==
X-Received: by 2002:a65:424a:0:b0:375:6d8b:8d44 with SMTP id d10-20020a65424a000000b003756d8b8d44mr4571014pgq.170.1648611034914;
        Tue, 29 Mar 2022 20:30:34 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 22-20020a17090a019600b001c6457e1760sm4313043pjc.21.2022.03.29.20.30.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:30:34 -0700 (PDT)
Message-ID: <5441ae13-0b35-774b-c5b0-4c3349b0f88b@gmail.com>
Date:   Tue, 29 Mar 2022 20:30:32 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 03/14] docs: netdev: move the patch marking section
 up
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-4-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-4-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
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



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> We want people to mark their patches with net and net-next in the subject.
> Many miss doing that. Move the FAQ section which points that out up, and
> place it after the section which enumerates the trees, that seems like
> a pretty logical place for it. Since the two sections are together we
> can remove a little bit (not too much) of the repetition.
> 
> v2: also remove the text for non-git setups, we want people to use git.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
