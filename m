Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B49C35F3212
	for <lists+netdev@lfdr.de>; Mon,  3 Oct 2022 16:40:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229698AbiJCOkw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 10:40:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229507AbiJCOku (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 10:40:50 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8754624F3D
        for <netdev@vger.kernel.org>; Mon,  3 Oct 2022 07:40:49 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id p202so8228768iod.6
        for <netdev@vger.kernel.org>; Mon, 03 Oct 2022 07:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=3ATwN/R4sLKE0rBIuoc0I59cS8qmfRx9bRJl8D57Smg=;
        b=b0n3iH2RFlvyBheTuYQ0nUVf+HpGNdlmS2O5bSizTsO9sRPs1F5XsNvUgvmoYNLxaH
         MFb+/nYVRyg/cHeRd4EaB0foYRJdy1bZnj8AO2ahtDbL6Ncp6PNqU/WYX1+Q6rMySidL
         OZwpFQsV0+3j+Dvw98DHvvBI0elUpv4A1cy3S775ty3fP7TBiuS4EmDYCvrZf8WbnmHt
         JIonXFSLLWL+lNU5oNRhmJmIEguXeQ5hRU577fvZtR8cYvF8JTnCTWVRdTvnHSQIzwWe
         IRh6OXLVhi4UITJdwFENprM1G3MTuI1aTOW6mUUNp2aTn4gpJiJx5o+3222v7tFh4ipQ
         NdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=3ATwN/R4sLKE0rBIuoc0I59cS8qmfRx9bRJl8D57Smg=;
        b=Rk+DmBitfxcTF4/vpr/H41YWP2TbgkpWHijih827rU4MK9sEREcwFG2g15uosqP0xl
         r/xp2rksacwtV56VuURDfMip5SHjGO5QyBSHNNyG3D7oQh/DbopE/21b6q4r/GYN0jIO
         LN8eAXBrlgwHq1P7a6RJHGQ5/y6yxb4IcUhm03NGM08dZB418vL+PYdTGCyzxzjSO0GP
         T1AkVrDkCI3ILTbAiZKlMlRvQ0lQeMJkeV2noLQ8b7VmU8T38awqNVZeUega+xp9sXmZ
         vsziGLk+mgtn8SeRqbupKv6fCImmXttLTindvvjzn0GkSHHLlC4SAodcYHSNPMmb9doR
         b7iQ==
X-Gm-Message-State: ACrzQf1p52dtQC+eR1ssZ20ilPBgrXA8DDSDB0CbJfCDHMcVashsCETm
        3SBI36xWis/TJh7umphkqY4=
X-Google-Smtp-Source: AMsMyM7GtzP8sNKZYtJOBD/a3O+0D14YcXQW/jufgP1y1WAjrMe0DU66UT8/0y9S+/iotwDT2tgw3g==
X-Received: by 2002:a05:6638:2686:b0:35a:413a:b7a0 with SMTP id o6-20020a056638268600b0035a413ab7a0mr10351341jat.224.1664808048944;
        Mon, 03 Oct 2022 07:40:48 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:38e6:13c8:49a3:2476? ([2601:282:800:dc80:38e6:13c8:49a3:2476])
        by smtp.googlemail.com with ESMTPSA id y4-20020a056e02118400b002eacd14e68esm3897548ili.71.2022.10.03.07.40.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Oct 2022 07:40:48 -0700 (PDT)
Message-ID: <f7251b13-dbf2-f86c-6c2a-2c037b208017@gmail.com>
Date:   Mon, 3 Oct 2022 08:40:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.0
Subject: Re: [PATCH iproute2-next] iplink_bridge: Add no_linklocal_learn
 option support
Content-Language: en-US
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, razor@blackwall.org,
        netdev@kapio-technology.com, mlxsw@nvidia.com
References: <20221001143551.1291987-1-idosch@nvidia.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221001143551.1291987-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/1/22 8:35 AM, Ido Schimmel wrote:
> @@ -159,6 +160,18 @@ static int bridge_parse_opt(struct link_util *lu, int argc, char **argv,
>  			if (len < 0)
>  				return -1;
>  			addattr_l(n, 1024, IFLA_BR_GROUP_ADDR, llabuf, len);
> +		} else if (matches(*argv, "no_linklocal_learn") == 0) {

changed matches to strcmp and applied to iproute2-next


> +			__u32 no_ll_learn_bit = 1 << BR_BOOLOPT_NO_LL_LEARN;
> +			__u8 no_ll_learn;
> +
> +			NEXT_ARG();
> +			if (get_u8(&no_ll_learn, *argv, 0))
> +				invarg("invalid no_linklocal_learn", *argv);
> +			bm.optmask |= 1 << BR_BOOLOPT_NO_LL_LEARN;
> +			if (no_ll_learn)
> +				bm.optval |= no_ll_learn_bit;
> +			else
> +				bm.optval &= ~no_ll_learn_bit;
>  		} else if (matches(*argv, "fdb_flush") == 0) {
>  			addattr(n, 1024, IFLA_BR_FDB_FLUSH);
>  		} else if (matches(*argv, "vlan_default_pvid") == 0) {

