Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874084EB8DA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242311AbiC3DfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:35:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242335AbiC3DfK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:35:10 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BD0BCB7;
        Tue, 29 Mar 2022 20:33:24 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id mr5-20020a17090b238500b001c67366ae93so832315pjb.4;
        Tue, 29 Mar 2022 20:33:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=oER1Tf3MT3ofLTA2Yz8o+UIKt8JbrEw8BHGuCWnZXy8=;
        b=ITDF4vrkjjDQ7faswCmkq91H2c2gnLtLPvhiAi37aJNUUk+URDEHbE/Kqhh/iw6DVH
         LQCeGVr4Tue5S8OBIsoJWkexmtCBTnDbe6iT+B5xN2expB3DYgYr9wxX9FGsEfvvJk2g
         u+QA93gi17ULXDuu/sf6pKBpVeFAjb8uu4fRxS8/CQLKW3eXMFVWUzmX0u/xowsOc0IE
         if6XaBaKZ3gxxBJhSKKFcc1y1Q46nldzo2TSbvNR6vpaTR9+FP67WPUvi75xIHKBLhNy
         dhJ9DUPqsSHMgWg3ifmpBHxUkboSEzpDRTczQFwMDV6v6k4l3sbl1gPCumpv9+zsF5Cc
         x+SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=oER1Tf3MT3ofLTA2Yz8o+UIKt8JbrEw8BHGuCWnZXy8=;
        b=NUIvAdg7nMiWSt4j4+58blOAQy94fltV6olcWkzvJgudFHTC1glQGoMiQO3Wh3h5Pu
         HCQ/ReJ8kBp9vwvG13NTwrwnwB9sfXVPWK0C8cgg89bScTdrOM64BJ9e0QgnJ5Qu0K95
         zFUTaI1RiIiRdmxrMiBojW1wIUIwX0Si8khBYqHpkcYHnPp+iW8fOGuIaWxninjccfWC
         iEPF1Y2YD7LMAwJHMBM5nZBvkawvlvLlA8Q3kybSTvD4i8dsgrxj9Pai/kZ0J4pJvPOT
         z/Jac75sjOSPj+uFyfvhQWTdiLRT3HHcH8WaDE9ihu4RuC9aBjP2g6FYeobCAIXQPzmv
         YP4Q==
X-Gm-Message-State: AOAM533szHzq8ViHh9CyKMcusX6UtPQOJIPKURVqFhWRxLyzrXMjEPTw
        bkuBcAy2runQrnJKer4CfHA=
X-Google-Smtp-Source: ABdhPJzXRIRVhQsfshMibbJwas/8aykmKlGgc6y0vAe+NVpriIC/ZwfDMZJ/wAA0w4vkQwOjtwjkPg==
X-Received: by 2002:a17:903:40c4:b0:154:a24b:d1e7 with SMTP id t4-20020a17090340c400b00154a24bd1e7mr33526637pld.27.1648611204476;
        Tue, 29 Mar 2022 20:33:24 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id g70-20020a636b49000000b003823dd39d41sm17171948pgc.64.2022.03.29.20.33.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:33:23 -0700 (PDT)
Message-ID: <dc0185c1-7239-b57f-8f03-f34ab20d0369@gmail.com>
Date:   Tue, 29 Mar 2022 20:33:21 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 09/14] docs: netdev: add a question about
 re-posting frequency
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-10-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-10-kuba@kernel.org>
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
> We have to tell people to stop reposting to often lately,
> or not to repost while the discussion is ongoing.
> Document this.
> 
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
