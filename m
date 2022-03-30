Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A0D74EB8CB
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:31:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242296AbiC3Dcc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:32:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241205AbiC3Dcc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:32:32 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 434811C2D9D;
        Tue, 29 Mar 2022 20:30:48 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id w21so16480672pgm.7;
        Tue, 29 Mar 2022 20:30:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=P5ykGU8RvLV1NZyzRceV1JcURHYPOqndhvwAUUI8ONI=;
        b=LroIM0E37j0Z10I+qnQmLPJZ/UaDnMtYLTEuAV9IMfw9e2derL9EbHRpF24orbywoP
         luaJCKYkdAxtUyK6lYxRkFZRU7aHOqTD2vLnMVYRcWQI/eyyEmhvo3KV7P0V64+SALyk
         JQFTuiOUUf2T/3RkOwJaQetzdSC8LsM14tjrnLr/V2jWg/fDnr0GCDYc4g24TWVcVmla
         ZovPux0g2XUESmyB+eI7vOiT91oObxbHugJ6ZCvoTQkTGhrvEKoAgYvwH3mVl6F8vOog
         3LrHUXtv+oPeRv/F9rGcxbvy8EN1u1CW+MU+Ri2AhGmAGFVoJKXcCx1LQIcqgcwfr/Dq
         IVcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=P5ykGU8RvLV1NZyzRceV1JcURHYPOqndhvwAUUI8ONI=;
        b=8EyQKJDCoWRswg3033zDJfO+hmQP/Rsm2kVaNEE34luKBS8clGgDVuyy+P4ZMSSYxL
         a1dAfYSVlY3/orNUq0zWuTEWqZYrB7oaLdepqBt0dUuC9Q3P2fV2qEj2ljL3uAbemdME
         RDOOq+a9PoVzUwTGqTHCMrj+KUOImamdct0fMy5u1GThz8kThT70FlmXGySKQmZ5/leS
         2EYhJYh2jFmRhkPLdpX33ld4QHtutzjL4b8X3uC97gn7538vsDMlr636u0NmLWQfsXOG
         SsP2DPNR6E1VxhxCwSTB0b0ju5kfoXUbr6djbGrn0PgV0oYgCUY1s5jk3T5uiUiBSsmu
         HUqA==
X-Gm-Message-State: AOAM530gqoku0Wx6uRhpyQWkLKeNmMG4KPXfcL7XjmRYvL+02uIPzvMM
        ZOxVlLtsfvSxk+sFKZEHaGA=
X-Google-Smtp-Source: ABdhPJxSBePkAfj4x9eGPi8Zq+dLZwZMzFj6hsL+Lq44SyhR0Y8SJJkXQ4TAG6JrTY9g4pK1Oz3LFQ==
X-Received: by 2002:a65:5a06:0:b0:375:81c9:74b1 with SMTP id y6-20020a655a06000000b0037581c974b1mr4479651pgs.122.1648611047645;
        Tue, 29 Mar 2022 20:30:47 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y4-20020a056a00190400b004fac0896e35sm20711260pfi.42.2022.03.29.20.30.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:30:47 -0700 (PDT)
Message-ID: <8bed0887-c5ab-b1db-a89f-8e4fb51a6294@gmail.com>
Date:   Tue, 29 Mar 2022 20:30:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 04/14] docs: netdev: turn the net-next closed into
 a Warning
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-5-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-5-kuba@kernel.org>
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
> Use the sphinx Warning box to make the net-next being closed
> stand out more.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
