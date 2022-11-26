Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 450C56398EC
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 00:26:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiKZX0z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Nov 2022 18:26:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229536AbiKZX0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Nov 2022 18:26:53 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CEBA1837E;
        Sat, 26 Nov 2022 15:26:52 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id cl5so11522265wrb.9;
        Sat, 26 Nov 2022 15:26:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rY0qFZwY0/BCIrgdPn0szxAbcTH1ebNL5IsnvxFbdB0=;
        b=LWAfhGClWdJxi5v2iwQVrstS3BHDFNh+XMK7I5BOpu3XKMNgGvnUxjtumQPXPOeiJr
         7dQGMV9jpN/O3lKr08+kTQGl/qlXgWR3ZfVa7lNz0cW+sqE7KGkMZkxXjXt+fC6ytnRN
         rXdSozgwd5VXMAdNFy+FC1UyELRNzIpyUChFdll/4flG2Te2Kyd4rXIpQYqIzgyqjPq/
         GW+fWd107oP5DYuZDJS/Ilex6i/FbnudjtWumtFLI9ej1v1YXfgRYhLZXFCGOKfZ1a9B
         xma+qsR+a7stT4uNihblUbdlnINX5/s67WWxmWad/c8Ks2Bo/ZON8Cljfs26t8qfomlP
         cbiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rY0qFZwY0/BCIrgdPn0szxAbcTH1ebNL5IsnvxFbdB0=;
        b=3uefKyEfP0OdC9hGTjZ2Rai09shxILpyeRKeLTY4TKpRyQqDlCZd/ZnnM1fwP6/4He
         khSgbdFQPIouP/5JShmAjdetLIJGjJ4N63ULUgPu8+t50ol1EHei2ua+rL+sJWdM6/3i
         kRxRw+51A+a4QyQHL8CMRXBDimvGxWVPRZFf7KQhQH4+sV1eZ1FW/VLkNaB53MCYpgNj
         ZJ5jq1hdbC7q8RHDRdbkeJR5EHb3KUW14A29eu/M9EQw2uj7MYOG8Fw7tPqNJHXrL6YE
         lwsj+zOLuMXof9QCzzCa973OFhfRe7JNv2dWXjJ8UjTtd9DPtBeoAIW6OKOV8ZA+p59j
         jOWQ==
X-Gm-Message-State: ANoB5pkRfIQI4zt1/mXemDhmRvji4RCtLlIQuCGo+iglscw27d5Wqa5R
        fDKsZF73fW6Xz+k+ed70hRQ=
X-Google-Smtp-Source: AA0mqf6JbskAQOr1oPN2nM/EB+HNoBRrCRXirpwflyqpP9Mp/9DqRIVq+03CCFvvgR9CuuQQSz6+/w==
X-Received: by 2002:adf:ed08:0:b0:241:cd8b:46eb with SMTP id a8-20020adfed08000000b00241cd8b46ebmr21101137wro.503.1669505210790;
        Sat, 26 Nov 2022 15:26:50 -0800 (PST)
Received: from 168.52.45.77 (201.ip-51-68-45.eu. [51.68.45.201])
        by smtp.gmail.com with ESMTPSA id 21-20020a05600c26d500b003c6c3fb3cf6sm9451900wmv.18.2022.11.26.15.26.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Nov 2022 15:26:50 -0800 (PST)
Message-ID: <c38fe636-f3c3-5465-ebc4-70decca84675@gmail.com>
Date:   Sun, 27 Nov 2022 00:26:46 +0100
MIME-Version: 1.0
User-Agent: nano 6.4
Subject: Re: [PATCH 3/3] Bluetooth: btusb: Add a parameter to let users
 disable the fake CSR force-suspend hack
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     marcel@holtmann.org, johan.hedberg@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, luiz.von.dentz@intel.com,
        quic_zijuhu@quicinc.com, hdegoede@redhat.com,
        linux-kernel@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org, Jack <ostroffjh@users.sourceforge.net>,
        Paul Menzel <pmenzel@molgen.mpg.de>, swyterzone@gmail.com
References: <20221029202454.25651-1-swyterzone@gmail.com>
 <20221029202454.25651-3-swyterzone@gmail.com>
 <CABBYNZKnw+b+KE2=M=gGV+rR_KBJLvrxRrtEc8x12W6PY=LKMw@mail.gmail.com>
 <ac1d556f-fe51-1644-0e49-f7b8cf628969@gmail.com>
 <CABBYNZJytVc8=A0_33EFRS_pMG6aUKnfFPsGii_2uKu7_zENtQ@mail.gmail.com>
Content-Language: en-US
From:   Ismael Ferreras Morezuelas <swyterzone@gmail.com>
In-Reply-To: <CABBYNZJytVc8=A0_33EFRS_pMG6aUKnfFPsGii_2uKu7_zENtQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=0.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_HELO_IP_MISMATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 09/11/2022 23:39, Luiz Augusto von Dentz wrote:
> I see, but for suspend in particular, can't we actually handle it
> somehow? I mean if we can detect the controller is getting stuck and
> print some information and flip the quirk? Otherwise Im afraid this
> parameter will end up always being set by distros to avoid suspend
> problems.

Hi, Luiz. I haven't seen any movement about the [3/3] patch since a few weeks ago.

Given what Hans clarified in his reply, I wondered if you or any of the other
Bluetooth maintainers have changed opinions about including this in some form.

I'm a kernel development newbie, so I'm not good at this. I don't know if I should
do anything else, wait a bit more, or just drop this. Thanks in advance. :)
