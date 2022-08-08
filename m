Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7D858CF61
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 22:48:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244142AbiHHUss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 16:48:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236712AbiHHUsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 16:48:47 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10ABF63A7;
        Mon,  8 Aug 2022 13:48:45 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id i14so18744928ejg.6;
        Mon, 08 Aug 2022 13:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=aMa8ybms4DKHEHWfzHWmIDW7vZz8sp4m4Xhax705u54=;
        b=o6BAEcY3jCb4GKTNzkURHE2/YyeSCBuKD10W+WptJikeFY1PmbDUt9Flxrh5lMsnOj
         6JcO2PmBDN2HARTuxcddMNXs2Y46oc3Or0qZquH01jmJAYG1y8ffe3KaDIe7LBe8pqKr
         luRqaoNQWN/cvGStsVhOkXJkgvwZmnf3F2H2D73KKcuARVn3BpxaWz2p7tusZr185gk+
         sBkGuvNM8wtrjUmXJWEvBRVSlFa+t+woeFRN3ooyGRVwHPOe68362KTRS3/LIszJOTaw
         D2gc83J6cFXYcfRCLEk3PSIBFpvrwQ3k83yyqMEWS0xYwhqs1MQxhpBI3HnPyFVyKZvY
         M7sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=aMa8ybms4DKHEHWfzHWmIDW7vZz8sp4m4Xhax705u54=;
        b=q30mUYOQ2NecOTMm1rS8bseX2aWQU6pa9KOESVsq+cdkkWsmaCNs8Sdh0xgiFdWN0/
         uF+4dw7RwGeZ6585GPrKLVGFrGGb+fQxu1DJuzRPxlaLTOJfwV5/pzuyzxXsi55GxbVW
         MbR1TbSDt7RTYrUVU4tbDlCwYetNqCc8U0aAW6ktxIxhGmloAjAN17b6ddD6SK1m3Aj/
         zYTCJERcDaBYBFtkwCzXCiPhFW8msynS0gHMYM+t8YiZCdJ+r9HH6Gjnih6ERsIzsifI
         OTsekKMoimV5cCilv76Bw0LWrd3NBrMPM3/wn8qvKBx5jyTVgMEkRwcmHEC0ZPb7q0DB
         2i9A==
X-Gm-Message-State: ACgBeo3XO/fHd5xW3UoutCUiw1lJ0qAGDJgzxbcEIx4MhIvWCPyT89bg
        bAEA1hw5kwOTY2FxJLUuXFo=
X-Google-Smtp-Source: AA6agR5+zZbiYpwWES8+S+DGSCABYSlwYrpvaTvcJdaoTznf6nES6CY+ySi6PmHsyCpqdwFDexYvfA==
X-Received: by 2002:a17:906:6a28:b0:731:48a0:71d with SMTP id qw40-20020a1709066a2800b0073148a0071dmr6229075ejc.249.1659991723717;
        Mon, 08 Aug 2022 13:48:43 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id r25-20020a056402019900b0043d7923af6esm4983363edv.95.2022.08.08.13.48.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Aug 2022 13:48:43 -0700 (PDT)
Subject: Re: [RFC PATCH net-next] docs: net: add an explanation of VF (and
 other) Representors
To:     Randy Dunlap <rdunlap@infradead.org>, ecree@xilinx.com,
        netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-net-drivers@amd.com
References: <20220805165850.50160-1-ecree@xilinx.com>
 <c389fb10-6eaf-7a86-6d50-f195eb29dd38@infradead.org>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <fc280c2e-0024-4af2-ed6f-920f36245eb6@gmail.com>
Date:   Mon, 8 Aug 2022 21:48:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <c389fb10-6eaf-7a86-6d50-f195eb29dd38@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
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

On 05/08/2022 20:15, Randy Dunlap wrote:
> On 8/5/22 09:58, ecree@xilinx.com wrote:
>> +A representor has three main rôles.
> 
> Just use "roles". dict.org and m-w.com are happy with that.
> m-w.com says for "role":
>   variants: or less commonly rôle

Okay, will do.
-ed
