Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A57014BA66F
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 17:52:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243440AbiBQQwS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 11:52:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:45994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233980AbiBQQwS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 11:52:18 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE8F512AAF;
        Thu, 17 Feb 2022 08:52:02 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id a8so8712312ejc.8;
        Thu, 17 Feb 2022 08:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=QW98ZAnaTyeOi8FPTz8x8h5/4COyBHutpkvvD0kXcq4=;
        b=PzaFH60CnXlgEaw+MxGzPZX3CggnAQDxzzLHy3lf+PPzdG8ixNd3wuulyE14lhShvP
         zAg4AhZSNQ7FFdr9xKrlMSUuUCCa4alb8k3z6K1W3CbhHAHMLcq53cO5kiLMFlzm4eA2
         0vv2C0dX9OIWTk8uo7ZE01T5ih1gofBVyaD3eiFyahEQqsT3WoOhiu/wI3hUjoF1xQSs
         RPpBon5nT2d9OhQTzE+u9ZyVIDAbOUUfNnSilnLC410GVksT4kThujYO4D11TsQZrkxM
         re1o8jZr/nqZgGHITpKH94voCsERAtRlOxr7uLk7wZTipXP/D53s1kzZKk1HyutE2lqs
         kAGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=QW98ZAnaTyeOi8FPTz8x8h5/4COyBHutpkvvD0kXcq4=;
        b=B7vIZF6SNdKETdiFVsCQVIFVrm6TdHdKqSOSY45MHfYZM10vEJA2r8qcyf++/2/EUu
         0PPTHgot4RK13XuelP/yBbBQPiI/vMNDzVzpamAEDMsp595ebrprnnGTABbVof8BIl+i
         xpjbtCmWE3A631RZrC61v52di1M9nIQeCf82FefIGrRd4YIZLq+yD5G3nXv+xzMDWxe0
         5Sw4dsHBebCoYxwhH0KX6Q+jSJpqPJ24GdBpgQ0sszYHu7gWFKNlUlH4JDcBoFvTaLh2
         FGW9TyKjgQTIi/kauA4pI1wrrZE28uROEWJIjEP0j/qfsVSVOEGlVU808ZkslXyVd6ap
         y/vw==
X-Gm-Message-State: AOAM530OvmftMTzJApWQJrRrZWH9z+9e56/tjhBcv+61m2RtYp/oypyK
        nA3LF+S26iByNkCK3h8VlAo=
X-Google-Smtp-Source: ABdhPJwtEn3D5+cKd8hP6JIr/8eyP8k8OBrxb52ozeiZGn6A/SKZI9bw35zidvnok2uRY4Rfp+w7nA==
X-Received: by 2002:a17:906:1e0c:b0:6cf:d014:e454 with SMTP id g12-20020a1709061e0c00b006cfd014e454mr3080164ejj.583.1645116721507;
        Thu, 17 Feb 2022 08:52:01 -0800 (PST)
Received: from debian64.daheim (pd9e29561.dip0.t-ipconnect.de. [217.226.149.97])
        by smtp.gmail.com with ESMTPSA id eg42sm1594303edb.79.2022.02.17.08.52.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 08:52:01 -0800 (PST)
Received: from localhost.daheim ([127.0.0.1])
        by debian64.daheim with esmtp (Exim 4.95)
        (envelope-from <chunkeey@gmail.com>)
        id 1nKj3j-001iGV-5S;
        Thu, 17 Feb 2022 17:52:00 +0100
Message-ID: <c9bb90ef-86fd-609a-0b55-896350602996@gmail.com>
Date:   Thu, 17 Feb 2022 17:52:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH][next] carl9170: Replace zero-length arrays with
 flexible-array members
Content-Language: de-DE
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org
References: <20220216194955.GA904126@embeddedor>
From:   Christian Lamparter <chunkeey@gmail.com>
In-Reply-To: <20220216194955.GA904126@embeddedor>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 16/02/2022 20:49, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare
> having a dynamically sized set of trailing elements in a structure.
> Kernel code should always use “flexible array members”[1] for these
> cases. The older style of one-element or zero-length arrays should
> no longer be used[2].
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/78
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

Acked-by: Christian Lamparter <chunkeey@gmail.com>

(I've also applied it to the firmware source)

