Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6C24EB8E5
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:35:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242330AbiC3DgX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:36:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242329AbiC3DgW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:36:22 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2313BFA6;
        Tue, 29 Mar 2022 20:34:38 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id c2so16480400pga.10;
        Tue, 29 Mar 2022 20:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=UHgD0JHZmslBcFVsPNWHKGMLOss4PCLOfcgxAxs39Y0=;
        b=KXj0/lOlFIXgaAFhwzu6K3xnBI9IPxJalH6MKsJX8HYtpnc3gbzCZZexmtpOXnL2bx
         vZJJhLv8SBGq0jXYrXtTnumUusjLdECg5pyy4dcGit0XzXLc+sLulF7XHg9J0l8NKI5b
         SBYiQ7tp9I5qpGADirI/GQV9iMb/r9S9CAlqqjWs4n1SLSnTvBFXj6T46ORwXkqK0Ruc
         l5/TRXByRbR8BZZtxSm7nfdtX8XCQUUzea8u2Lh8j2fofSnpFLx4jSUFtojgpA1Xl7yH
         kZwzGn3w7PM7SExBkClXwMJ+mbJiA/KmvXeaZ4bZwsIWQeQ0ZBupor6VYeYw4l8CbbLr
         weUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=UHgD0JHZmslBcFVsPNWHKGMLOss4PCLOfcgxAxs39Y0=;
        b=6NjFVrkW1dLdvHsTCuWTHeo3qJ+ALJihzCtS/LNCPaS/FT1pvEi4McjnTfJAgdydop
         fgomBn9dQtHEr/qMRapJkw/6Z51KoiAzsloFL3ua2kDjx/IU52Fc+rGVfglC2faoMdjf
         IMDLAaXnMf500y7j4SsbgByWmaDgs/HeKOzHNi6wUke0qNPB8Lv85DTyHeN350zNWiJb
         D0b2QFlf/XxrtirfiYH8fmEMcE5L9PebBANFfOflC0qOhPg6QdKlORbB7Bp2d88dxIEI
         4OtMi9ALPFVkgufvfFMD+UYmh/a89cHj8eMFdAMEAkNKnImlfgeSEPXHyccAXbQjJ1IV
         dtmQ==
X-Gm-Message-State: AOAM531tfpiTf6cqSb7tWK59DAT4HYuTgnUoKTiRzCOFbp7luPtAc+CM
        Goq2+AG545soRrLg0rf+eDs=
X-Google-Smtp-Source: ABdhPJz8Y9JBINzIYzixdoFQsJa502b+hAte046OR7XLYJ4XZPKolh34c5/Ad5YKdr5rcINE4mEFow==
X-Received: by 2002:aa7:8211:0:b0:4f7:8b7:239b with SMTP id k17-20020aa78211000000b004f708b7239bmr30712554pfi.64.1648611277908;
        Tue, 29 Mar 2022 20:34:37 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id b17-20020a056a000a9100b004e1b7cdb8fdsm23042483pfl.70.2022.03.29.20.34.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:34:36 -0700 (PDT)
Message-ID: <2c2062ff-8e62-ab30-63f5-9a208b064c9e@gmail.com>
Date:   Tue, 29 Mar 2022 20:34:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 12/14] docs: netdev: call out the merge window in
 tag checking
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-13-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-13-kuba@kernel.org>
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
> Add the most important case to the question about "where are we
> in the cycle" - the case of net-next being closed.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
