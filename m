Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B048523102
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 12:52:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236261AbiEKKwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 06:52:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229819AbiEKKwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 06:52:41 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B21C6FD3E;
        Wed, 11 May 2022 03:52:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id a191so1474856pge.2;
        Wed, 11 May 2022 03:52:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=D69fYPxCw8BUOIfDJnOY3FdNP+e1YOgJF/XqPjbFoNo=;
        b=dXKO8FRy1Gx9Bi+ilR6bwSQQKTQD1+W+fYClXKMXcZFbRCqU19eBjOL+zMisq48KHQ
         p/3UmgbEy9anVL+cuX+/tcSzt9K8kR/wKnpsCqTC1cpLgubJUzRci7ub6xOZmzCnJbxW
         oN8vabwCdI/1z6HNsxW015J8kNcdPzdnwtHmft2RyuezRS0b9HXVR/lMsYfDHge7ptEZ
         DuZPiRHq0Ame6ledlaatKVyZ2BX5cut0fVvzrCNuazazV5p9LaNiDwFsVbd7Z8qEFk/x
         W80BKDKKxfACVsPZ7iE7/Ihsi/AhtAp0cxDQieV/K2NTiMZWuqU22+GlZaLe2+6IcV+/
         25Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=D69fYPxCw8BUOIfDJnOY3FdNP+e1YOgJF/XqPjbFoNo=;
        b=VmmZ3+8g/tSHMsPc5ZD7H+LiDOz4iydZPc4mFRCjKGLfuPMb16o0q6XPj0JgMUDCIi
         UoB4L9Kvt5VhsD+v6xLLtfoNheTR82nV+jsM0Ja85A92zxXpS4al5TLWN2tmCB/Wx44O
         EjfwWxo2qcHDAAlJWo3fS+6sW1LMXnrq+qeX8QhZQWzUYiayffmqROcl8ti7eRMMG/I3
         NEDelzfdD6WouQA4Ot1T5iGZXNb6Igd9eF9eBqh/vdeXmpgBK0UPl4Wh00fpKcWi0t7E
         wnG92ZJ53Dw9QZWRbz1loSK+leWU/hHNcAlKOipikzJ6AnPcEAdJx9bwetAP4G0OvgfF
         JrQw==
X-Gm-Message-State: AOAM530hqm8hcIlsEi+gdj9dc3vhkGPbWRSK0W+eTClJC1fQi/vm09ga
        lHc7kAPp++uavPT3VC//VuE=
X-Google-Smtp-Source: ABdhPJz/1MRji99fbx2kQ84bnyYlvpn5iJ9qHzZyPRhLDMiNAH4pha7e5uayS0kg5Cyw349r6OQFcw==
X-Received: by 2002:a05:6a00:1a49:b0:510:a1d9:7d73 with SMTP id h9-20020a056a001a4900b00510a1d97d73mr15057408pfv.53.1652266359838;
        Wed, 11 May 2022 03:52:39 -0700 (PDT)
Received: from [192.168.11.5] (KD106167171201.ppp-bb.dion.ne.jp. [106.167.171.201])
        by smtp.gmail.com with ESMTPSA id d5-20020a170902c18500b0015e8d4eb1d2sm1487774pld.28.2022.05.11.03.52.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 May 2022 03:52:39 -0700 (PDT)
Message-ID: <ec431b19-520f-b202-33f6-4ba336743ee3@gmail.com>
Date:   Wed, 11 May 2022 19:52:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
From:   Akira Yokosawa <akiyks@gmail.com>
Subject: Re: [PATCH net-next] docs: ctucanfd: Use 'kernel-figure' directive
 instead of 'figure'
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Martin Jerabek <martin.jerabek01@gmail.com>,
        Ondrej Ille <ondrej.ille@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
References: <05d491d4-c498-9bab-7085-9c892b636d68@gmail.com>
 <YntZqxuLSci6f8Z+@debian.me>
Content-Language: en-US
In-Reply-To: <YntZqxuLSci6f8Z+@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 May 2022 13:37:31 +0700,
Bagas Sanjaya wrote:
> On Tue, May 10, 2022 at 06:34:37PM +0900, Akira Yokosawa wrote:
>> Two issues were observed in the ReST doc added by commit c3a0addefbde
>> ("docs: ctucanfd: CTU CAN FD open-source IP core documentation.").
>>
>> The plain "figure" directive broke "make pdfdocs" due to a missing
>> PDF figure.  For conversion of SVG -> PDF to work, the "kernel-figure"
>> directive, which is an extension for kernel documentations, should
>> be used instead.
>>
>
> Does plain "figure" directive not currently support SVG file argument?
> Because when I see reST documentation ([1]), it doesn't explicitly
> mentioned supported image formats.
>
> [1]: https://docutils.sourceforge.io/docs/ref/rst/directives.html#figure
>

Close!

See:
    https://docutils.sourceforge.io/docs/ref/rst/directives.html#images

There you see the compatibility table of image format vs
output format/user agent.  The argument (URI) can be in any
format a consumer of generated document can render.
It's user's (read: kernel-documentation tool's) responsibility
to prepare images in suitable formats.

For kernel documentation, the "kernel-figure" directive triggers
the conversion of images depending on the output format, so that
compatible images can be used in the generated documents.

Those conversions are independent of what you write in .rst files.
If there emerges another output target which prefers a different
image format, you can always modify the extension code in
kfigure.py.

        Thanks, Akira

