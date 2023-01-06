Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5E966010C
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 14:16:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233783AbjAFNQn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 08:16:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231289AbjAFNQl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 08:16:41 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 929A86C289
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 05:16:40 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id i16so456365ilq.9
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 05:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s1LywjUroOs2NrgqtOKf4lPkuoCqOIhLUrwwnpXq1Ks=;
        b=g71f0MKyl7a4tKOomdOmTJosMPOmmoETipJ3XedVA0ZPudtpAMibVUAveJ+s/XnOIh
         wSLX93JPFrBPG1M/fGfXuNGBOohMyB/AtCZHJjU2NrqHQjHprIXtrX+/6t+njlpZDoBi
         PwUaMstLzXPCeTofwqJz4Gg9dCsKkx7wUrVEXcuhoaZHb8nPdplPBFNlyqL7molaMA3L
         d8kAMsQIOD0BQmOWqL6DWDT1dKZbjr2tYyZOv73eI6YZz9QDOJgHRZ4yTxId2vvGvZeP
         fEUg+b3cT4saYg2VCgIUD2H2FlkOizKlnX9hbNcqgEbW9G0WiwT3GnoBTOHL/L/8pOsi
         jx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s1LywjUroOs2NrgqtOKf4lPkuoCqOIhLUrwwnpXq1Ks=;
        b=jthyYERWQpTrJX1QPafE5R93TxCemfJV1cjsjYEB2sByPXPn2nySnZM153hgpYRQVb
         UKruIi5MJPS90q4BPISGYHmhUiwRi7pG3qMjfFQc9pr7mb0cNkbSAUzIxZsLerb7MGzh
         N9Gv+zXx93zZOty7NFTRa0sLhjoLIFSsVygflvYuNXLhD+vKLUkuShPmPES3BhaAwVXW
         uAd2lHhJ//qd/1xVS2gB9EqSTlQlH4Jk8UPpz0P5Y8jSuJBH7iFMImCnaSsc+Rd8gbQ2
         XIPsbAD8gu+PuXPL1m+dyLJP36iV7qAlrB1bFvkSvWAChykziQOro0/+E7YM391j8cUJ
         oiAA==
X-Gm-Message-State: AFqh2kqKkAKtX4ttW0jGqJV4UHsqnBvAitnENNU8ByDM4IopkEjzMuvu
        bl0OVUBNY94I7CtHjc5hfsaj+g==
X-Google-Smtp-Source: AMrXdXsOg9ULNlsfpIyZ479J8TePmgEgGfziF3VIkTGzJr4CTw24cyLNhgMwW3ul6hcuQZ1AVUKm0g==
X-Received: by 2002:a92:6e10:0:b0:30c:44bb:8d23 with SMTP id j16-20020a926e10000000b0030c44bb8d23mr13007747ilc.2.1673010999918;
        Fri, 06 Jan 2023 05:16:39 -0800 (PST)
Received: from [172.22.22.4] ([98.61.227.136])
        by smtp.googlemail.com with ESMTPSA id a17-20020a92d591000000b0030be6c79645sm362853iln.68.2023.01.06.05.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Jan 2023 05:16:39 -0800 (PST)
Message-ID: <04bf6bd1-1150-ac57-5a8d-a9971148bd40@linaro.org>
Date:   Fri, 6 Jan 2023 07:16:38 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next] net: ipa: correct IPA v4.7 IMEM offset
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        luca.weiss@fairphone.com, konrad.dybcio@linaro.org,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230104181017.2880916-1-elder@linaro.org>
 <20230105215806.4c192dad@kernel.org>
From:   Alex Elder <elder@linaro.org>
In-Reply-To: <20230105215806.4c192dad@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/5/23 11:58 PM, Jakub Kicinski wrote:
> On Wed,  4 Jan 2023 12:10:17 -0600 Alex Elder wrote:
>> Note:  This fixes a commit that first landed in v6.2-rc1.
> 
> Why is it tagged for net-next then? 🤔️
> Let's treat it as a normal fix with a Fixes tag and for net.
> I reckon the commit message makes is sufficiently clear that
> I'm to blame :)

Sorry about that, I was confused, thinking it is only
needed in 6.2-rc--the current release cycle.  But that's
not the way it works.  I guess I wasn't fully recovered
from the holiday break.

I'll re-send and base it on net/master.  Thanks.

					-Alex
