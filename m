Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD2984EB8CA
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:31:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242283AbiC3Db5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:31:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241623AbiC3Dby (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:31:54 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02032ED7A;
        Tue, 29 Mar 2022 20:30:09 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id k14so16516430pga.0;
        Tue, 29 Mar 2022 20:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=KyLEzyexPbDl5BWe+SmA6ACVCLgWcxJwt+jWXe3UNZ4=;
        b=o1f4h8amr2jabr3Ow5xTMK9m0VYiWSxFOAkHRMxyBxc/elj/QpggPa4+20ViubyZQI
         CyhGIjEEJOyXFbtKlvlvAlpiA2l9XsOe9mzOsUKyHgVhFWUwK2yJFotP9qr/q8G0Z2kc
         kXTRsbgoRBkOfD+8+uBoXLmN5sCfym/62Phvgpl1X+777GKnTZ/P5T3cEGCFKMg7wP1D
         GLDj1v8AS13Ge4jHJYcqSZ4UAeX5a1qc2e+g6agW0crBNpyrLVVtLWgEuXDF3+Ioysyg
         7I/+BIrAu9LBsivkYmnl6sC7VnsiF+KhWbNBq8MmnhpThB2LQMhjtJApEv+wwWQItryd
         NeLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=KyLEzyexPbDl5BWe+SmA6ACVCLgWcxJwt+jWXe3UNZ4=;
        b=FPVe1f3oCAbplYrNX5cWAe9FQXQBMASKDOTTQ/HozFBP10oU2TJeiWgQpokN78p3S1
         oq8E6sWjQk5sr2gUBuFaQZdaef7c7S+a83zHl5kww+MFXebNPhdD5nlkqH3Qny0ck+FK
         6aQvzmYki3/ZBjrTOgnN+tus/HVf6L8Aufn5FFlI0VMz5xv3Ap427eT/HE0H7qWX+Er+
         9gDLW4MuoPmMpc9ki43/BjJ8H+QL3+TXM3WsIc/TiD3cSEvlemfQTSVOjlVuw4qn1U9f
         Hdt02bm1BsKeN/FyGCXkoRy54M1jAoq7u8aaU3GHQ7LgaGVWJsZsuwiOOCBzS2lrpjy/
         BGPQ==
X-Gm-Message-State: AOAM532uEbm5QPYXeMnN81yfssUlzpk1k9zU4+5B8QdBBhgbwV78jd75
        msZ2wiWs1/UAL9FtLyQU+i8=
X-Google-Smtp-Source: ABdhPJzPJUEigKr4H07JF3PbiaHx87PHx+NQymTvCiVO7N9xGr5hab/efSQmxAUI9vn9+QVGx5qVhw==
X-Received: by 2002:a62:1d09:0:b0:4fd:8b00:d28 with SMTP id d9-20020a621d09000000b004fd8b000d28mr4807333pfd.81.1648611009204;
        Tue, 29 Mar 2022 20:30:09 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id t10-20020a056a00138a00b004fa9c9fda44sm21513832pfg.89.2022.03.29.20.30.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:30:08 -0700 (PDT)
Message-ID: <39544cd2-f111-0441-82a7-ad552c1fe170@gmail.com>
Date:   Tue, 29 Mar 2022 20:30:06 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 01/14] docs: netdev: replace references to old
 archives
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-2-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-2-kuba@kernel.org>
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
> Most people use (or should use) lore at this point.
> Replace the pointers to older archiving systems.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
