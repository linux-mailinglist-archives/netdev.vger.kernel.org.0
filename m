Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F0635A4576
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 10:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiH2Ivp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 04:51:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiH2Ivo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 04:51:44 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C79D558512;
        Mon, 29 Aug 2022 01:51:43 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id f4so5535589qkl.7;
        Mon, 29 Aug 2022 01:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=n1RoIBdIPyN20pMev+MpGGOGbH+r3UUo8doQJrELPuk=;
        b=qD5Nh6G+wVQcHlj2sUePl1OdlCmXxx3mhE8Ri4/M405cWanYkXelOsGZFJyNaScz3h
         eNrPR86qfa5mIopQCPUKpt8qS3sq4u/AZzxNB/ESZR8fta9M7Tgu5Efb4ryJL6PFiVk1
         fG6hvY4I6MMsOFt877TkZL1R9epMJt3Wy7jY8K0jNJHq+uSkSdtltv15Er5zJa+q2olX
         IC+uWG9xGFALXAvti9bZQ4AtBjHxJJO/GWUwYjJXtQZBNmJY5ZiF0S5GtMoklt9FdcKB
         1kzZ12hIRgyFaCR6x2gWeMIOF5MNvSSunOJo3rPQ2ma3Qz4Wu/k/fWGISmvjJWVSv0ni
         xRGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=n1RoIBdIPyN20pMev+MpGGOGbH+r3UUo8doQJrELPuk=;
        b=DlG/N+dnQXi13W45qB99iG6k9dylTetjNXBQns7AZ3FAVNdZI8mxVnSCJaeF8tvCIO
         aLhzi5PzkFpAn4wa73eSwNRhw1KbLbZpUjbvM+4BdbEHIedipU6ddTh3vsVGAOvUIMzM
         t2X84wSDjRXV0aklV0Rnislpx1YjNpiOmrEGvapJdeuw1QQ/C0rWvQxW2SWljt6lhAkT
         4xv62z4MESOZ+/uF/Yys0Jcbam9vkelxD5n7G+nD5a1T/fSerseYCAAV5lH/+ttq+AYw
         R5UmoW7wFaT8PSOHMqGAbfLA0BU+P3QB7VY+28MfjvSCBU6fozU11ATyDs5N9DtE+VNi
         qvlA==
X-Gm-Message-State: ACgBeo0AVjU7ptTKO1l0btklcr2+AsOY1Zk7qJp3LpNST9MxwswYOtP6
        2kX6//RSgv8f26nkA/DpjHMapytPW7nmns3kNhE=
X-Google-Smtp-Source: AA6agR40fCruIILl7anmrNlDJvfNeKro7XUHv8CeZeuIbNXLfiWNndTBx4wilKNMi640mX75UJ4eJQ==
X-Received: by 2002:a05:620a:4496:b0:6bb:8db4:6b49 with SMTP id x22-20020a05620a449600b006bb8db46b49mr7684364qkp.703.1661763102970;
        Mon, 29 Aug 2022 01:51:42 -0700 (PDT)
Received: from [10.176.68.61] ([192.19.148.250])
        by smtp.gmail.com with ESMTPSA id br18-20020a05620a461200b006bb0f9b89cfsm5482488qkb.87.2022.08.29.01.51.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Aug 2022 01:51:42 -0700 (PDT)
Message-ID: <a054ffb1-527b-836c-f43e-9f76058cc9ed@gmail.com>
Date:   Mon, 29 Aug 2022 10:51:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH] wifi: cfg80211: add error code in
 brcmf_notify_sched_scan_results()
Content-Language: en-US
To:     Li Qiong <liqiong@nfschina.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>
References: <20220829065831.14023-1-liqiong@nfschina.com>
From:   Arend Van Spriel <aspriel@gmail.com>
In-Reply-To: <20220829065831.14023-1-liqiong@nfschina.com>
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

On 8/29/2022 8:58 AM, Li Qiong wrote:
> The err code is 0 at the first two "out_err" paths, add error code
> '-EINVAL' for these error paths.

There is no added value provided in this change. There is an error 
message, but it is otherwise silently ignored as there is no additional 
fault handling required.

Regards,
Arend

> Signed-off-by: Li Qiong <liqiong@nfschina.com>
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 2 ++
>   1 file changed, 2 insertions(+)
