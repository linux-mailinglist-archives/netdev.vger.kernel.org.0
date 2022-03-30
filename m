Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98EFF4EB8E6
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242326AbiC3DgM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:36:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242312AbiC3DgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:36:10 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 543033BF8F;
        Tue, 29 Mar 2022 20:34:24 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id t4so13428510pgc.1;
        Tue, 29 Mar 2022 20:34:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=F6QNF4qiHGhmDPpVYtU5PDsAkxIQAsK6JPHtJrp3e4A=;
        b=Aj/vuHp53lF+mL+Lv9jWR6+XQGfsfWxT1Lwc2SkacE0YzpHPco/8oSvDwRxNVXypA/
         Mj0AjiPHLuGMhb7Tm9DGD4YiXTa62iodx440nnOT6No8vXJPfzP+TyaMtNoBpCR/Js6z
         VFDXhZ8FldaNo6vtezqFOEDuIkTrquUrfwVxNLMyVJIEpbg9WQ4yo4LXDQyN9Oitrtob
         LyfOr7Sz84VHCLHCNO9HLH/H9dEa3rAmPX524lrrD4Lo6bF7+8in1Y8XwwyqOOtagJe7
         jL3soJaoxYGOzLh4Rwiv4PMD3/zLaELQLilqlwdETcjzoYxXS2h/Jj/apsBG3DC/HpHs
         f+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=F6QNF4qiHGhmDPpVYtU5PDsAkxIQAsK6JPHtJrp3e4A=;
        b=Ne8aXIRPVWYEWgM7bDPXOURQxFNeDECirNrsuDYrNBB5leZrJcN9m7By2Zom8xjSNh
         95lpVno/y5rM1PaRxfvlq2yUkCey7Z4oxloXq5lzKc++v77KDhpN3Z6c0W5iyxa6KKJL
         CUnpEbVhOVqbfKFyp5/DqaLSBsbNc0Q4/3Q+VnFUGjdBti7W1WoVONbATZ/CUidxHZVj
         9gamNcTiLlT4WnySUBtlf5qevHDTSJxZiSDXJjIQheF8tKPWvp6wOTnNocfrIIXWhTVn
         IoprZ4c7j4LxpJZzJKG1u9QEy8hDxUN10OLFXrW9i38T1H3hcYE8MhAa2/tvxoIsi/Yu
         oaXg==
X-Gm-Message-State: AOAM530Zcnog6x3bWLEzWxUQLg/VvEjJgiLSB91WPG22OtvET8HFtnvW
        ZrXFCxGPSfjXq/+VTqAakewwdIHmTSo=
X-Google-Smtp-Source: ABdhPJyV8sgeDZVpTVIMe0udSjx9SFCSjS8ROrtgONAkov9gai7FzuPwPINqpm1HAA8IyGL+yfilEQ==
X-Received: by 2002:a05:6a00:1490:b0:4fb:1544:bc60 with SMTP id v16-20020a056a00149000b004fb1544bc60mr23578042pfu.73.1648611263846;
        Tue, 29 Mar 2022 20:34:23 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b10-20020a056a00114a00b004f784ba5e6asm22418032pfm.17.2022.03.29.20.34.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:34:23 -0700 (PDT)
Message-ID: <17d26edf-a646-fc7d-28e8-3976ce1386df@gmail.com>
Date:   Tue, 29 Mar 2022 20:34:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 11/14] docs: netdev: add missing back ticks
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-12-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-12-kuba@kernel.org>
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
> I think double back ticks are more correct. Add where they are missing.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
