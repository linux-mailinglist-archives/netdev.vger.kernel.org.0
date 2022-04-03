Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D939E4F0B38
	for <lists+netdev@lfdr.de>; Sun,  3 Apr 2022 18:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiDCQ0f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 12:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239092AbiDCQ0f (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 12:26:35 -0400
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5FD61AF1A
        for <netdev@vger.kernel.org>; Sun,  3 Apr 2022 09:24:40 -0700 (PDT)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-de3ca1efbaso8031936fac.9
        for <netdev@vger.kernel.org>; Sun, 03 Apr 2022 09:24:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tAyqInwpsg1/JMVsnBiyRKeJvStqf2kOGIackf9bZv0=;
        b=aEu6vy0i9swT0ztZK911qaTKVWWy7ObJnWISsr3o0y5f53e1+v4QJvLfzKERW7oDYY
         iS4EuvL66NlyLIMkPcdwjg9X4aYk84i3QtWiw/tJktcOgxDwuNY4/oG/ioUGjWaMZpKj
         B0ZCDPeiWKfw0QYeWm6u/IJ+XsrDYGVMLLOECC5+kX8xK0omQRg+5S/WL36ZCgawAas5
         lDV0SfXeZJvFLxsrMBl7i4Mvzu68ckv24CJSP0y39inrWJg7QSroyzMQZwwY62dmj069
         tgn2zYWO9nMGgGSN5E4uus3Zr7FL499dFFr+r2VvrBT7H6lKQC51Q/e2skQtMG30525i
         BpKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tAyqInwpsg1/JMVsnBiyRKeJvStqf2kOGIackf9bZv0=;
        b=p2Hzrj0MpDwNDgsEUQbJxszFnBLLWys6SPUe4vLBMCkclroKA+u+qAIyBb6nUGh8N+
         LIT5M6uJZoX7V5E+XHPSfB6u3m8+z2lX6B1MODBMO2QBoCGtPgfSBBifsqxDo2mlImT+
         +wEaS+SFWFu7Uzh5RA+a2exbJ8r024WDyP91tu2OnD1N7V4Jh3lGwdIuRWTqd0P8GMPX
         Sz+8qseH6syIM94Q9e5UYtzyRPyqG18TQbNDA6ky2+r9nypKOA5keppEHsvvDgHA2JDG
         O2t7eHF7MhtfJ/lw5GRagNsg9jIX3G1makPlo9neoXJJCTXXH3j+ADjSpVZ+X2pI0k59
         cfog==
X-Gm-Message-State: AOAM530n1FBh+TufFH8S5KT614k5HFBd5fz51wBJwCizAXGhQx6jULzp
        ZahJgMl6WFTSdc2zeWznwRo=
X-Google-Smtp-Source: ABdhPJwYowlPAhXbdQNrfpEq5/3TwQ2LTv9IRnKjckOy67KJfdXUKmpI7SyLkk24w16KJs68HJrImQ==
X-Received: by 2002:a05:6870:9611:b0:df:200f:a6dd with SMTP id d17-20020a056870961100b000df200fa6ddmr8736311oaq.299.1649003080090;
        Sun, 03 Apr 2022 09:24:40 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.58])
        by smtp.googlemail.com with ESMTPSA id m23-20020a4add17000000b0032489ab619esm3090868oou.45.2022.04.03.09.24.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 09:24:39 -0700 (PDT)
Message-ID: <2bbfde7b-7b67-68fd-f62b-f9cd9b89d2ad@gmail.com>
Date:   Sun, 3 Apr 2022 10:24:36 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Subject: Re: Matching unbound sockets for VRF
Content-Language: en-US
To:     Stephen Suryaputra <ssuryaextr@gmail.com>
Cc:     netdev@vger.kernel.org
References: <20220324171930.GA21272@EXT-6P2T573.localdomain>
 <7b5eb495-a3fe-843f-9020-0268fb681c72@gmail.com>
 <YkBfQqz66FxYmGVV@ssuryadesk>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YkBfQqz66FxYmGVV@ssuryadesk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/27/22 6:57 AM, Stephen Suryaputra wrote:
> 
> The reproducer script is attached.
> 

h0 has the mgmt vrf, the l3mdev settings yet is running the client in
*default* vrf. Add 'ip vrf exec mgmt' before the 'nc' and it works.

Are you saying that before Mike and Robert's changes you could get a
client to run in default VRF and work over mgmt VRF? If so it required
some ugly routing tricks (the last fib rule you installed) and is a bug
relative to the VRF design.
