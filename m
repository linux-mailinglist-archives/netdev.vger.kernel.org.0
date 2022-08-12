Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8847A591334
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 17:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238244AbiHLPnX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 11:43:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237402AbiHLPm6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 11:42:58 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 554B214033;
        Fri, 12 Aug 2022 08:42:56 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id t5so1796389edc.11;
        Fri, 12 Aug 2022 08:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=Y+pMZ4IFihbyH+aGK2yCBcwVMXs5BhIuRXwyoT40/Ws=;
        b=SqylgTmI4x7IkSNw+NJEwtDzShsqwDp7edFbbovAmSnMxN+U74deSItlwVCEBPgIEB
         iE3YwDMykBJfVPsrCEYG6hKliWGJSE74da2jTX6WktLp+wt8PbhKhH06Oq0n80qsDVQW
         xEso4fqstaQJZ99yMnrMRUGVJ0g2hLp5acFbhTmuMzuQxFxRyQy+jH7F9pqkXeaEb89/
         mxUc5a+SKgnqATDL2OXXQU9Q88lisoQnNp83gmDDPzEhjFDSr/bKcRx03RorJh0DV1cT
         BH98NNPtySuvlszH52P3piIJ7FWXSRLuwKonwrESvtGn8h3n/R+khMk8V6LOVK2r3Nfy
         xHKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=Y+pMZ4IFihbyH+aGK2yCBcwVMXs5BhIuRXwyoT40/Ws=;
        b=0h4wF5W6f3PM8rbMnhNjSHvwR9dvpzq2vxTFkLtrpjpsFCMB4+VCVULoU2e8Ce3tLR
         RDdKSrsvkcbFnVIm2ut3KRGx/C0/13JGktk7R015HFG5qxxEKih3dmAaTr0DiqOGOvS6
         8W3yetAOri7XTMGQJisGouGHro8mlVE7FMRRWklzmuqBrR7lCyNlQYlIr8wQfJ0x3XyG
         TDDFclqJSMwpwueOezhvC5NdZZoG8vrwpr07dlrhHSLsDddGl+6ReYqBit9Ql8EFCMMN
         1/3tYdggk6QmX64jLFnxmPz2l/o1yy1v7zM6/isSncFxs5TVXzakuede/TH07ezRXqwy
         ARpw==
X-Gm-Message-State: ACgBeo2EC8ZV4E+m7gw5NXJ6Z60ydsh89UslEsDXIHivko2/JPZp4yVC
        YfM25IqoKyRhx6egZtkndfpWaRMzVWU=
X-Google-Smtp-Source: AA6agR5ziyfKjNdCBzn4uFcV3xLTPgmhJjTpBOp3jDS1Ejecf6T8q6IaLPDzDDmnc1MGwzbUljeoKA==
X-Received: by 2002:a05:6402:50cb:b0:440:87d4:3ad2 with SMTP id h11-20020a05640250cb00b0044087d43ad2mr4105405edb.219.1660318974852;
        Fri, 12 Aug 2022 08:42:54 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id d20-20020aa7d5d4000000b0043c92c44c53sm1494007eds.93.2022.08.12.08.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 08:42:54 -0700 (PDT)
Subject: Re: [RFC net-next 3/4] ynl: add a sample python library
To:     Stephen Hemminger <stephen@networkplumber.org>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, sdf@google.com, jacob.e.keller@intel.com,
        vadfed@fb.com, johannes@sipsolutions.net, jiri@resnulli.us,
        dsahern@kernel.org, fw@strlen.de, linux-doc@vger.kernel.org
References: <20220811022304.583300-1-kuba@kernel.org>
 <20220811022304.583300-4-kuba@kernel.org>
 <20220811180452.13f06623@hermes.local>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <0e27c04a-f17c-7491-7482-46dc9a5dd151@gmail.com>
Date:   Fri, 12 Aug 2022 16:42:53 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220811180452.13f06623@hermes.local>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 12/08/2022 02:04, Stephen Hemminger wrote:
> On Wed, 10 Aug 2022 19:23:03 -0700
> Jakub Kicinski <kuba@kernel.org> wrote:
> 
>> A very short and very incomplete generic python library.
>>
>> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> It would be great if python had standard module for netlink.
> Then your code could just (re)use that.
> Something like mnl but for python.

There's pyroute2, that seemed alright when I used it for something
 a few years back, and I think it has the pieces you need.
https://pyroute2.org/

-ed
