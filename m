Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 58B3851A12E
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 15:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350741AbiEDNq5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 09:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238169AbiEDNq4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 09:46:56 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B23615700;
        Wed,  4 May 2022 06:43:19 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so5231018pju.2;
        Wed, 04 May 2022 06:43:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:to:cc:references:subject
         :content-language:from:in-reply-to:content-transfer-encoding;
        bh=x9+OqVHzvgZAzmQ7FhCUwnOZ5RMklI3ZHl/WECgRlrA=;
        b=h5GX2Ek2ssMRmIgfObUfXUBvms99jKkg2ji/NF1OP6hQtSdoRpqAKUrAqmOlgoOk1o
         ef/TFOZXNPcm7g/tCjG9aSyV1a1PBTXnSwODFbuVHc5hPRdCF4OM9iQ2AW/GVGkae8F0
         nkS80WsCTtNfsAh1qWSQkvPXYb6VcHR+9yiGrExNglUQdK5CiDVnQsfCQHTOZzBaIxto
         75KQA6/VLNu3SESd3LCjiAzMMxWYRjZWjqE72zt4vP5Ze/HlHqzFUW59ROX4BhRyhns9
         LWUXmT2ISG8LWT05rTHJ59jXMqVvxf9E2lP9QGnSG3KmulPoSqAd9owS2DWSMowZvZhg
         s16Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:to:cc
         :references:subject:content-language:from:in-reply-to
         :content-transfer-encoding;
        bh=x9+OqVHzvgZAzmQ7FhCUwnOZ5RMklI3ZHl/WECgRlrA=;
        b=ePY6617dv/PPiZ87IK5v9K+GdOpGaNlLX+c0lmTVp3m+9Crl+cLRXZVRruLcpkAloD
         XTj4o6DPtd49JOnJesNzi/f+tnff+awpOo4ubPUi4KPddqRREf9SZ7N5eavtiDGzRmhX
         fU+ztjf6jfm67lm6Fput1cwNBdUWxPP+//JhRBiANuBQgjPpjmBbtC7oeS5Etny0k0lX
         qVQUHAG89Xzmxou+rqSJAXFgM00pYXtSchOBsm17977KYwvwJEO1gsZOtJaYtkyquqbC
         pI6g7vKmdweChdBa1zJ5JnGNMtpXettVoiO+acvcqBkVYfDAzmWPj/TDi/bSHz3WnLG/
         YsPw==
X-Gm-Message-State: AOAM531EAjbGmX8T5V3S1N7WHqyVHx/0/MidrOPuaCp002GrfKcuDDde
        HOHSVJsfoVXkNNNPwtDtcTY=
X-Google-Smtp-Source: ABdhPJxjFZqQSVkYuA4ff5UwMHa7xUqA2/GDpd9Wy9e+15M7E6oXY0uMd2Is9JGRFZMUQ6uNx7DyeA==
X-Received: by 2002:a17:90a:c402:b0:1d9:a003:3f8a with SMTP id i2-20020a17090ac40200b001d9a0033f8amr10381617pjt.18.1651671799067;
        Wed, 04 May 2022 06:43:19 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id k129-20020a632487000000b003c14af5060dsm14679659pgk.37.2022.05.04.06.43.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 May 2022 06:43:18 -0700 (PDT)
Message-ID: <c578c9e6-b2a5-3294-d291-2abfda7d1aed@gmail.com>
Date:   Wed, 4 May 2022 22:43:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Dave Jones <davej@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
References: <9d8b436a-5d8d-2a53-a2a1-5fbab987e41b@gmail.com>
Subject: Re: [PATCH net-next] net/core: Remove comment quote for
 __dev_queue_xmit()
Content-Language: en-US
From:   Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <9d8b436a-5d8d-2a53-a2a1-5fbab987e41b@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Wed, 4 May 2022 11:28:51 +0700,
Bagas Sanjaya wrote:
> On 5/4/22 08:03, Jakub Kicinski wrote:
[...]
>> Why drop almost half of the comment if the problem is just the ----
>> banner?
> 
> I can't think of preserving delineation between actual documentation
> and the quote without messing up kernel-doc.
Actually, it is possible.

See "Block Quotes" in ReST documentation at:
https://docutils.sourceforge.io/docs/ref/rst/restructuredtext.html#block-quotes

kernel-doc is basically ReST within comment blocks with several kernel-doc
specific implicit/explicit markers.

        Thanks, Akira

> 
> Actually the "--BLG" signature is the culprit.

