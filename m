Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3E865A7995
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 10:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbiHaI4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 04:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231734AbiHaI4S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 04:56:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43A097820D;
        Wed, 31 Aug 2022 01:55:18 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id u9-20020a17090a1f0900b001fde6477464so7320784pja.4;
        Wed, 31 Aug 2022 01:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=MuINGSAvN8dmwGydRR1Dg0xBbQjT1kSTnxINwZg/HxY=;
        b=U1xCiaa2OCFaMU2//b4N0n7SCpxYz6Bcwyubm/QiFWMnWh8vmWenktp7jUbxmj7r2D
         RTxOwFA6Agwjnaq1tuPcflPUfJkH3WQMrlK6TaSbER7Ysm8pRhdG5f470ffY1AZAVg3W
         05Gk9q4pqg0qmOaqF5o2oHjf96CveHxWGyFUzk/oSk5n/biBPi44DplZc5VdW8Rayeuj
         LOvkY4r2/pdmfynaXHec8i+5xM3Sf4fZK0ZAcxihYnAbxqZTsR8KAzDqXMHWuu4dd44F
         JxpgMDcB5WhywW6IyOzH2QpOm0vSSq9xacKbuq8/c0jJDUOkP4V0Xs9qe3YQoo2Brllm
         K4BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=MuINGSAvN8dmwGydRR1Dg0xBbQjT1kSTnxINwZg/HxY=;
        b=ejCYyYMTjFMze/SNFNX4PjMpEv4di716c7ZsZ6oAQvGl5TEVX3p+X44AJypiY21sAp
         U761dGqQmBQahXlzpQBWoJkZmwmcAJNYYzVVo+9IrkhcxrAHnQvTwZ1BeJqOUikgbCDY
         Xalk5Ksg4mE/aaDnyNOilD21oOokAyo8W1V0fbrT1Pk6QZrZ02Ds3yHsn3CplvY9vFlx
         KL3CyTBDl5rYABEZEYfLK2+5G6xEVTSbojP8Ci6rKReMeOydLjZ/GPKAGKN9iYV5xLW3
         h0cagD7IxYYw8h7tzTaiMn67LtDm9wQVLh0EKBMmrPrUL4fXHg05vN3HFb+zDyDq0clC
         iZbg==
X-Gm-Message-State: ACgBeo1IwkS4CzrercFE4yXcWyhRRPRSyxWWEyWoS+e90+fvjoqKzbz6
        Pp9yM9tmxB4jfT+1vLpLPLSO47hSnkUeySG8LMl+oTLF1Ed7v4rm
X-Google-Smtp-Source: AA6agR5pobNE1EM3kS0q3Rf5cqsvpOMlTx8WA7oaEmiXAPHjAC5DfPpdDdeknL545QFZpkhpTwFEPLZGWSoUK21QNWI=
X-Received: by 2002:a17:90b:350f:b0:1fb:479b:8e51 with SMTP id
 ls15-20020a17090b350f00b001fb479b8e51mr2258071pjb.46.1661936116860; Wed, 31
 Aug 2022 01:55:16 -0700 (PDT)
MIME-Version: 1.0
References: <20220830135604.10173-1-maciej.fijalkowski@intel.com> <20220830135604.10173-4-maciej.fijalkowski@intel.com>
In-Reply-To: <20220830135604.10173-4-maciej.fijalkowski@intel.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Wed, 31 Aug 2022 10:55:05 +0200
Message-ID: <CAJ8uoz1sbkE+_-5B3BZQZ-8MqbXVkSi-YkoGEfvBsJa0n_oq9g@mail.gmail.com>
Subject: Re: [PATCH v5 bpf-next 3/6] selftests: xsk: increase chars for
 interface name
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, netdev@vger.kernel.org,
        magnus.karlsson@intel.com, bjorn@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 30, 2022 at 4:00 PM Maciej Fijalkowski
<maciej.fijalkowski@intel.com> wrote:
>
> So that "enp240s0f0" or such name can be used against xskxceiver.

Why not bump them up to 16 why you are at it, including
MAX_INTERFACES_NAMESPACE_CHARS? In any case:

Acked-by: Magnus Karlsson <magnus.karlsson@intel.com>

> Signed-off-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> ---
>  tools/testing/selftests/bpf/xskxceiver.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/xskxceiver.h b/tools/testing/selftests/bpf/xskxceiver.h
> index 8d1c31f127e7..12bfa6e463d3 100644
> --- a/tools/testing/selftests/bpf/xskxceiver.h
> +++ b/tools/testing/selftests/bpf/xskxceiver.h
> @@ -29,7 +29,7 @@
>  #define TEST_FAILURE -1
>  #define TEST_CONTINUE 1
>  #define MAX_INTERFACES 2
> -#define MAX_INTERFACE_NAME_CHARS 7
> +#define MAX_INTERFACE_NAME_CHARS 10
>  #define MAX_INTERFACES_NAMESPACE_CHARS 10
>  #define MAX_SOCKETS 2
>  #define MAX_TEST_NAME_SIZE 32
> --
> 2.34.1
>
