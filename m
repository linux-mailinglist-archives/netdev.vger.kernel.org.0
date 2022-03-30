Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C6B54EB8D5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241413AbiC3Dcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242300AbiC3Dcs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:32:48 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47ADD1C886B;
        Tue, 29 Mar 2022 20:31:04 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id bx24-20020a17090af49800b001c6872a9e4eso4895753pjb.5;
        Tue, 29 Mar 2022 20:31:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=J60X8o3FgXRr7b4mi+XHG9wg1MGxGL8UH5FAKs7Qhw0=;
        b=EJL309vqer1j8k4a64kkTvRjni4ZARETsVsULzbATWJQl8V88npzY9tP6ODJVjqNnT
         s9flj43JGsGkz07VGsWEieK7jnorVdZdspMkB08GUU9ROHWoRYi2I5H5B1LoOn+R9pOx
         J8hYERQDq9BUmYnHDVxfUKc5m8YGlWpUPLd3zEmmf6ACpmvmdbhBVFmwZi2QqQvZmtA5
         1XR6T+AX+P0MR9tUXlgmY3eAnJVq9NmgmlwxQB3t2Sawi/5b3q4P8joR8uXWbzcJYqtn
         If61ga9XPE+sMhB/5d0coFDjIOHMQyiTfO/MTbAAggCZCzaEbD9j4aUosHN7z14vPt/W
         aLhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=J60X8o3FgXRr7b4mi+XHG9wg1MGxGL8UH5FAKs7Qhw0=;
        b=krj1qIGUhEmtUIza0wru7QVa5FTES7ykPd6zPk6YUiOXF9aYrFeljlGI82/fuHzMzi
         UOIBsNia7OAOeU+xxfsCcEtXj742ACrVdRVRY5MdGc5dJaoLYoF7Mc2S/+27+VbfGWju
         SmXijXiB4m9bNibeG5BXBXllIshxpUjFMDF7ePiX/EpbLCs9wJQOXSIXH6XMKLhMf46h
         cCpJe/hLf6Qexe+BO8h0f5GWWuzzODF8ESbzx8zgF0qkJDltKxJGdP9yIK3Xh/SSqxBR
         jie6dlyZGw9NAASUCdZwhHk14svcz8HzN0/o/XiLCePc27ZAbEPxpPx7vF6XHBtBpTN3
         g17g==
X-Gm-Message-State: AOAM530zxjOTrqjwgg4AWQoO4Tkxfq/al3x4UkfEySPTXRxrLAbhtaN8
        Z+1GkdQP3FWSxuOsgwXmQxs=
X-Google-Smtp-Source: ABdhPJwIBmFKSHHhdIGtossTCAL7CCn3TrGG9phc7fofPj47ZEYCebXHB1+z+IOu8K93zUwQvwbfuw==
X-Received: by 2002:a17:902:f08a:b0:153:9f11:5f8b with SMTP id p10-20020a170902f08a00b001539f115f8bmr33365750pla.95.1648611063728;
        Tue, 29 Mar 2022 20:31:03 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id z16-20020aa78890000000b004fad8469f88sm21282142pfe.38.2022.03.29.20.31.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:31:02 -0700 (PDT)
Message-ID: <9dd270be-78cf-2562-7766-bef8c53fe1fd@gmail.com>
Date:   Tue, 29 Mar 2022 20:31:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 05/14] docs: netdev: note that RFC postings are
 allowed any time
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-6-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-6-kuba@kernel.org>
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
> Document that RFCs are allowed during the merge window.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
